import 'dart:io';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/cloud_storage_connection.dart' as model;

/// Service for Dropbox integration
/// Handles OAuth authentication and file operations
class DropboxService {
  final SupabaseClient? _supabaseClient;
  final AppDatabase _database;
  final FlutterSecureStorage _secureStorage;

  static const String _dropboxAccessTokenKey = 'dropbox_access_token';
  static const String _dropboxRefreshTokenKey = 'dropbox_refresh_token';

  DropboxService({
    required SupabaseClient? supabaseClient,
    required AppDatabase database,
  })  : _supabaseClient = supabaseClient,
        _database = database,
        _secureStorage = const FlutterSecureStorage();

  /// Get Dropbox client credentials from environment
  String get _dropboxClientId => dotenv.env['DROPBOX_CLIENT_ID'] ?? '';
  String get _dropboxClientSecret => dotenv.env['DROPBOX_CLIENT_SECRET'] ?? '';

  /// Initialize Dropbox SDK
  Future<void> initialize() async {
    // Initialize Dropbox with credentials
    await Dropbox.init(
      _dropboxClientId,
      _dropboxClientSecret,
      _dropboxClientSecret,
    );
  }

  /// Check if user is authenticated with Dropbox
  Future<bool> get isAuthenticated async {
    final accessToken = await _secureStorage.read(key: _dropboxAccessTokenKey);
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Get current authenticated user's email
  Future<String?> get authenticatedUserEmail async {
    if (!await isAuthenticated) return null;

    try {
      final userId = _supabaseClient?.auth.currentUser?.id;
      if (userId == null) return null;

      final connection = await _database.getCloudStorageConnectionByProvider(
        userId,
        'dropbox',
      );

      return connection?.userEmail;
    } catch (e) {
      return null;
    }
  }

  /// Authenticate with Dropbox using OAuth
  Future<bool> signIn() async {
    try {
      // Initialize if not already done
      await initialize();

      // Authorize with Dropbox using PKCE (more secure)
      await Dropbox.authorizePKCE();

      // Get access token
      final accessToken = await Dropbox.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      // Store tokens securely
      await _secureStorage.write(
        key: _dropboxAccessTokenKey,
        value: accessToken,
      );

      // Get user info
      final userInfo = await _getCurrentUser();

      // Save connection to database
      await _saveConnection(
        accessToken: accessToken,
        refreshToken: null,
        userEmail: userInfo != null && userInfo['email'] != null
            ? (userInfo['email']['email_address'] as String?)
            : null,
        userName: userInfo != null && userInfo['name'] != null
            ? (userInfo['name']['display_name'] as String?)
            : null,
      );

      return true;
    } catch (e) {
      print('Error signing in to Dropbox: $e');
      return false;
    }
  }

  /// Sign out from Dropbox
  Future<void> signOut() async {
    try {
      // Unlink account
      await Dropbox.unlink();

      // Clear stored tokens
      await _secureStorage.delete(key: _dropboxAccessTokenKey);
      await _secureStorage.delete(key: _dropboxRefreshTokenKey);

      // Delete connection from database
      final userId = _supabaseClient?.auth.currentUser?.id;
      if (userId != null) {
        await _database.deleteCloudStorageConnectionByProvider(
          userId,
          'dropbox',
        );
      }
    } catch (e) {
      print('Error signing out from Dropbox: $e');
    }
  }

  /// Get current Dropbox user info
  Future<dynamic> _getCurrentUser() async {
    try {
      final accountInfo = await Dropbox.getCurrentAccount();
      return accountInfo;
    } catch (e) {
      print('Error getting Dropbox user info: $e');
      return null;
    }
  }

  /// List files in Dropbox folder
  Future<List<Map<String, dynamic>>> listFiles({
    String path = '',
    bool recursive = false,
  }) async {
    try {
      final accessToken = await _secureStorage.read(key: _dropboxAccessTokenKey);
      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      final response = await Dropbox.listFolder(path);

      if (response == null) {
        return [];
      }

      final files = <Map<String, dynamic>>[];

      if (response['entries'] != null) {
        for (final entry in response['entries']) {
          if (entry['.tag'] == 'file') {
            files.add({
              'name': entry['name'],
              'path': entry['path_display'],
              'size': entry['size'],
              'modified': entry['server_modified'],
              'id': entry['id'],
            });
          }
        }
      }

      return files;
    } catch (e) {
      print('Error listing Dropbox files: $e');
      return [];
    }
  }

  /// Download file from Dropbox
  Future<File?> downloadFile({
    required String dropboxPath,
    required String localPath,
  }) async {
    try {
      final accessToken = await _secureStorage.read(key: _dropboxAccessTokenKey);
      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      await Dropbox.download(dropboxPath, localPath);

      final file = File(localPath);
      if (await file.exists()) {
        return file;
      }

      return null;
    } catch (e) {
      print('Error downloading file from Dropbox: $e');
      return null;
    }
  }

  /// Upload file to Dropbox
  Future<bool> uploadFile({
    required String localPath,
    required String dropboxPath,
  }) async {
    try {
      final accessToken = await _secureStorage.read(key: _dropboxAccessTokenKey);
      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('File not found: $localPath');
      }

      await Dropbox.upload(localPath, dropboxPath);

      return true;
    } catch (e) {
      print('Error uploading file to Dropbox: $e');
      return false;
    }
  }

  /// Get file metadata
  Future<Map<String, dynamic>?> getFileMetadata(String path) async {
    try {
      final accessToken = await _secureStorage.read(key: _dropboxAccessTokenKey);
      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      // Get temporary link which contains metadata
      final response = await Dropbox.getTemporaryLink(path);

      if (response == null) {
        return null;
      }

      return {
        'link': response,
        'path': path,
      };
    } catch (e) {
      print('Error getting file metadata: $e');
      return null;
    }
  }

  /// Save connection to database
  Future<void> _saveConnection({
    required String accessToken,
    String? refreshToken,
    String? userEmail,
    String? userName,
  }) async {
    final userId = _supabaseClient?.auth.currentUser?.id;
    if (userId == null) return;

    final now = DateTime.now();

    // Check if connection already exists
    final existing = await _database.getCloudStorageConnectionByProvider(
      userId,
      'dropbox',
    );

    if (existing != null) {
      // Update existing connection
      await _database.updateCloudStorageConnection(
        existing.id,
        accessToken: accessToken,
        refreshToken: refreshToken,
        userEmail: userEmail,
        userName: userName,
      );
    } else {
      // Insert new connection
      await _database.insertCloudStorageConnection(
        CloudStorageConnectionsCompanion.insert(
          id: const Uuid().v4(),
          userId: userId,
          provider: model.CloudStorageProvider.dropbox,
          accessToken: accessToken,
          refreshToken: drift.Value(refreshToken),
          tokenExpiry: const drift.Value.absent(),
          userEmail: drift.Value(userEmail),
          userName: drift.Value(userName),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  /// Get stored connection from database
  Future<model.CloudStorageConnection?> getConnection() async {
    final userId = _supabaseClient?.auth.currentUser?.id;
    if (userId == null) return null;

    return await _database.getCloudStorageConnectionByProvider(
      userId,
      'dropbox',
    );
  }
}
