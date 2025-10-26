import 'dart:io';

import 'package:ai_organizer/data/models/cloud_storage_connection.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/services/dropbox_service.dart';
import 'package:ai_organizer/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for Dropbox Service
final dropboxServiceProvider = Provider<DropboxService>((ref) {
  final database = ref.watch(databaseProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return DropboxService(
    supabaseClient: supabase!,
    database: database,
  );
});

/// Provider for Google Drive Service
final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  final database = ref.watch(databaseProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return GoogleDriveService(
    supabaseClient: supabase!,
    database: database,
  );
});

/// Provider for cloud storage connections
final cloudStorageConnectionsProvider = FutureProvider<List<CloudStorageConnection>>((ref) async {
  final database = ref.watch(databaseProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return [];
  }

  return await database.getAllCloudStorageConnections(currentUser.id);
});

/// Provider for Dropbox connection
final dropboxConnectionProvider = FutureProvider<CloudStorageConnection?>((ref) async {
  final database = ref.watch(databaseProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return null;
  }

  return await database.getCloudStorageConnectionByProvider(
    currentUser.id,
    'dropbox',
  );
});

/// Provider for Google Drive connection
final googleDriveConnectionProvider = FutureProvider<CloudStorageConnection?>((ref) async {
  final database = ref.watch(databaseProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return null;
  }

  return await database.getCloudStorageConnectionByProvider(
    currentUser.id,
    'google_drive',
  );
});

/// Provider for cloud storage actions
final cloudStorageActionsProvider = Provider<CloudStorageActions>((ref) {
  return CloudStorageActions(ref);
});

/// Cloud storage actions class
class CloudStorageActions {
  CloudStorageActions(this._ref);

  final Ref _ref;

  // ====================
  // DROPBOX ACTIONS
  // ====================

  /// Sign in to Dropbox
  Future<bool> signInToDropbox() async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    final result = await dropboxService.signIn();

    if (result) {
      // Refresh connections
      _ref.invalidate(dropboxConnectionProvider);
      _ref.invalidate(cloudStorageConnectionsProvider);
    }

    return result;
  }

  /// Sign out from Dropbox
  Future<void> signOutFromDropbox() async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    await dropboxService.signOut();

    // Refresh connections
    _ref.invalidate(dropboxConnectionProvider);
    _ref.invalidate(cloudStorageConnectionsProvider);
  }

  /// List files from Dropbox
  Future<List<Map<String, dynamic>>> listDropboxFiles({
    String path = '',
    bool recursive = false,
  }) async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    return await dropboxService.listFiles(path: path, recursive: recursive);
  }

  /// Download file from Dropbox
  Future<File?> downloadDropboxFile({
    required String dropboxPath,
    required String localPath,
  }) async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    return await dropboxService.downloadFile(
      dropboxPath: dropboxPath,
      localPath: localPath,
    );
  }

  /// Upload file to Dropbox
  Future<bool> uploadToDropbox({
    required String localPath,
    required String dropboxPath,
  }) async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    return await dropboxService.uploadFile(
      localPath: localPath,
      dropboxPath: dropboxPath,
    );
  }

  // ====================
  // GOOGLE DRIVE ACTIONS
  // ====================

  /// Sign in to Google Drive
  Future<bool> signInToGoogleDrive() async {
    final driveService = _ref.read(googleDriveServiceProvider);
    final result = await driveService.signIn();

    if (result) {
      // Refresh connections
      _ref.invalidate(googleDriveConnectionProvider);
      _ref.invalidate(cloudStorageConnectionsProvider);
    }

    return result;
  }

  /// Sign out from Google Drive
  Future<void> signOutFromGoogleDrive() async {
    final driveService = _ref.read(googleDriveServiceProvider);
    await driveService.signOut();

    // Refresh connections
    _ref.invalidate(googleDriveConnectionProvider);
    _ref.invalidate(cloudStorageConnectionsProvider);
  }

  /// List files from Google Drive
  Future<List<Map<String, dynamic>>> listGoogleDriveFiles({
    String? folderId,
    String? query,
    int maxResults = 100,
  }) async {
    final driveService = _ref.read(googleDriveServiceProvider);
    return await driveService.listFiles(
      folderId: folderId,
      query: query,
      maxResults: maxResults,
    );
  }

  /// Download file from Google Drive
  Future<File?> downloadGoogleDriveFile({
    required String fileId,
    required String fileName,
  }) async {
    final driveService = _ref.read(googleDriveServiceProvider);
    return await driveService.downloadFile(
      fileId: fileId,
      fileName: fileName,
    );
  }

  /// Upload file to Google Drive
  Future<String?> uploadToGoogleDrive({
    required File file,
    String? folderId,
    String? description,
  }) async {
    final driveService = _ref.read(googleDriveServiceProvider);
    return await driveService.uploadFile(
      file: file,
      folderId: folderId,
      description: description,
    );
  }

  /// Search Google Drive files
  Future<List<Map<String, dynamic>>> searchGoogleDriveFiles(String query) async {
    final driveService = _ref.read(googleDriveServiceProvider);
    return await driveService.searchFiles(query);
  }

  /// Create folder in Google Drive
  Future<String?> createGoogleDriveFolder({
    required String name,
    String? parentFolderId,
  }) async {
    final driveService = _ref.read(googleDriveServiceProvider);
    return await driveService.createFolder(
      name: name,
      parentFolderId: parentFolderId,
    );
  }

  // ====================
  // GENERAL ACTIONS
  // ====================

  /// Check if Dropbox is connected
  Future<bool> get isDropboxConnected async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    return await dropboxService.isAuthenticated;
  }

  /// Check if Google Drive is connected
  bool get isGoogleDriveConnected {
    final driveService = _ref.read(googleDriveServiceProvider);
    return driveService.isSignedIn;
  }

  /// Get Dropbox user email
  Future<String?> get dropboxUserEmail async {
    final dropboxService = _ref.read(dropboxServiceProvider);
    return await dropboxService.authenticatedUserEmail;
  }

  /// Get Google Drive user email
  String? get googleDriveUserEmail {
    final driveService = _ref.read(googleDriveServiceProvider);
    return driveService.currentUserEmail;
  }
}
