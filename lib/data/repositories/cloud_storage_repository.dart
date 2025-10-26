import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/cloud_storage_connection.dart' as model;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Repository for cloud storage connection operations
class CloudStorageRepository {
  CloudStorageRepository(this._database, this._supabase);

  final AppDatabase _database;
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  /// Convert string to CloudStorageProvider enum
  model.CloudStorageProvider _parseProvider(String providerString) {
    switch (providerString.toLowerCase()) {
      case 'google_drive':
      case 'googledrive':
        return model.CloudStorageProvider.googleDrive;
      case 'dropbox':
        return model.CloudStorageProvider.dropbox;
      default:
        throw ArgumentError('Unknown provider: $providerString');
    }
  }

  /// Convert CloudStorageProvider enum to string
  String _providerToString(model.CloudStorageProvider provider) {
    switch (provider) {
      case model.CloudStorageProvider.googleDrive:
        return 'google_drive';
      case model.CloudStorageProvider.dropbox:
        return 'dropbox';
    }
  }

  // ===== READ OPERATIONS =====

  /// Get all cloud storage connections for the current user
  Future<List<model.CloudStorageConnection>> getAllConnections() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];
    return await _database.getAllCloudStorageConnections(userId);
  }

  /// Get connection by ID
  Future<model.CloudStorageConnection?> getConnectionById(String id) async {
    return await _database.getCloudStorageConnectionById(id);
  }

  /// Get connection by provider for the current user
  Future<model.CloudStorageConnection?> getConnectionByProvider(String providerString) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    return await _database.getCloudStorageConnectionByProvider(userId, providerString);
  }

  /// Check if a provider is connected for the current user
  Future<bool> isProviderConnected(String provider) async {
    final connection = await getConnectionByProvider(provider);
    return connection != null;
  }

  // ===== WRITE OPERATIONS =====

  /// Create a new cloud storage connection
  Future<model.CloudStorageConnection> createConnection({
    required String provider,
    required String accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
    String? userEmail,
    String? userName,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    final companion = CloudStorageConnectionsCompanion.insert(
      id: id,
      userId: userId,
      provider: _parseProvider(provider),
      accessToken: accessToken,
      refreshToken: refreshToken != null ? Value(refreshToken) : const Value.absent(),
      tokenExpiry: tokenExpiry != null ? Value(tokenExpiry) : const Value.absent(),
      userEmail: userEmail != null ? Value(userEmail) : const Value.absent(),
      userName: userName != null ? Value(userName) : const Value.absent(),
      createdAt: now,
      updatedAt: now,
    );

    await _database.insertCloudStorageConnection(companion);

    // Sync to Supabase
    await _syncToSupabase(companion);

    // Return the created connection
    final created = await getConnectionById(id);
    if (created == null) {
      throw Exception('Failed to create connection');
    }
    return created;
  }

  /// Update an existing cloud storage connection
  Future<bool> updateConnection(
    String id, {
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
    String? userEmail,
    String? userName,
  }) async {
    final updated = await _database.updateCloudStorageConnection(
      id,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiry: tokenExpiry,
      userEmail: userEmail,
      userName: userName,
    );

    if (updated) {
      // Sync to Supabase
      final connection = await getConnectionById(id);
      if (connection != null) {
        await _syncConnectionToSupabase(connection);
      }
    }

    return updated;
  }

  /// Refresh access token for a connection
  Future<bool> refreshToken(String id, String newAccessToken, {DateTime? newExpiry}) async {
    return await updateConnection(
      id,
      accessToken: newAccessToken,
      tokenExpiry: newExpiry,
    );
  }

  /// Delete a cloud storage connection
  Future<int> deleteConnection(String id) async {
    final connection = await getConnectionById(id);
    if (connection == null) return 0;

    final deleted = await _database.deleteCloudStorageConnection(id);

    if (deleted > 0) {
      // Delete from Supabase
      await _deleteFromSupabase(id);
    }

    return deleted;
  }

  /// Delete connection by provider for current user
  Future<int> deleteConnectionByProvider(String provider) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0;

    final connection = await getConnectionByProvider(provider);
    if (connection != null) {
      await _deleteFromSupabase(connection.id);
    }

    return await _database.deleteCloudStorageConnectionByProvider(userId, provider);
  }

  // ===== SYNC OPERATIONS =====

  /// Sync a connection to Supabase
  Future<void> _syncToSupabase(CloudStorageConnectionsCompanion companion) async {
    try {
      await _supabase.from('cloud_storage_connections').upsert({
        'id': companion.id.value,
        'user_id': companion.userId.value,
        'provider': _providerToString(companion.provider.value),
        'access_token': companion.accessToken.value,
        'refresh_token': companion.refreshToken.present ? companion.refreshToken.value : null,
        'token_expiry': companion.tokenExpiry.present ? companion.tokenExpiry.value?.toIso8601String() : null,
        'user_email': companion.userEmail.present ? companion.userEmail.value : null,
        'user_name': companion.userName.present ? companion.userName.value : null,
        'created_at': companion.createdAt.value.toIso8601String(),
        'updated_at': companion.updatedAt.value.toIso8601String(),
      });
    } catch (e) {
      // Log error but don't throw - offline-first approach
      debugPrint('Error syncing connection to Supabase: $e');
    }
  }

  /// Sync an existing connection to Supabase
  Future<void> _syncConnectionToSupabase(model.CloudStorageConnection connection) async {
    try {
      await _supabase.from('cloud_storage_connections').upsert({
        'id': connection.id,
        'user_id': connection.userId,
        'provider': _providerToString(connection.provider),
        'access_token': connection.accessToken,
        'refresh_token': connection.refreshToken,
        'token_expiry': connection.tokenExpiry?.toIso8601String(),
        'user_email': connection.userEmail,
        'user_name': connection.userName,
        'created_at': connection.createdAt.toIso8601String(),
        'updated_at': connection.updatedAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error syncing connection to Supabase: $e');
    }
  }

  /// Delete a connection from Supabase
  Future<void> _deleteFromSupabase(String id) async {
    try {
      await _supabase.from('cloud_storage_connections').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting connection from Supabase: $e');
    }
  }

  /// Fetch all connections from Supabase
  Future<void> syncFromSupabase() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('cloud_storage_connections')
          .select()
          .eq('user_id', userId);

      for (final item in response as List<dynamic>) {
        final data = item as Map<String, dynamic>;

        final companion = CloudStorageConnectionsCompanion.insert(
          id: data['id'] as String,
          userId: data['user_id'] as String,
          provider: _parseProvider(data['provider'] as String),
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] != null
              ? Value(data['refresh_token'] as String)
              : const Value.absent(),
          tokenExpiry: data['token_expiry'] != null
              ? Value(DateTime.parse(data['token_expiry'] as String))
              : const Value.absent(),
          userEmail: data['user_email'] != null
              ? Value(data['user_email'] as String)
              : const Value.absent(),
          userName: data['user_name'] != null
              ? Value(data['user_name'] as String)
              : const Value.absent(),
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: DateTime.parse(data['updated_at'] as String),
        );

        await _database.insertCloudStorageConnection(companion);
      }
    } catch (e) {
      debugPrint('Error syncing connections from Supabase: $e');
    }
  }
}
