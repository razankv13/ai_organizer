import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/cloud_storage_connection.dart' as model;

/// HTTP client for authenticated Google API requests
class GoogleAuthClient extends http.BaseClient {

  GoogleAuthClient(this._headers);
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

/// Service for Google Drive integration
/// Handles OAuth authentication and file operations
class GoogleDriveService {

  GoogleDriveService({
    required SupabaseClient? supabaseClient,
    required AppDatabase database,
  })  : _supabaseClient = supabaseClient,
        _database = database {
    _googleSignIn = GoogleSignIn(
      scopes: [
        drive.DriveApi.driveReadonlyScope,
        drive.DriveApi.driveFileScope,
      ],
    );
  }
  final SupabaseClient? _supabaseClient;
  final AppDatabase _database;
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;

  late final GoogleSignIn _googleSignIn;

  /// Check if user is signed in to Google Drive
  bool get isSignedIn => _currentUser != null;

  /// Get current user's email
  String? get currentUserEmail => _currentUser?.email;

  /// Sign in to Google Drive
  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return false;
      }

      _currentUser = account;

      // Get authentication
      final authentication = await account.authentication;
      final accessToken = authentication.accessToken;

      if (accessToken == null) {
        return false;
      }

      // Create authenticated HTTP client
      final authHeaders = await account.authHeaders;
      final authenticatedClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authenticatedClient);

      // Save connection to database
      await _saveConnection(
        accessToken: accessToken,
        refreshToken: authentication.idToken,
        userEmail: account.email,
        userName: account.displayName,
      );

      return true;
    } catch (e) {
      print('Error signing in to Google Drive: $e');
      return false;
    }
  }

  /// Sign out from Google Drive
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _driveApi = null;

      // Delete connection from database
      final userId = _supabaseClient?.auth.currentUser?.id;
      if (userId != null) {
        await _database.deleteCloudStorageConnectionByProvider(
          userId,
          'google_drive',
        );
      }
    } catch (e) {
      print('Error signing out from Google Drive: $e');
    }
  }

  /// List files in Google Drive
  Future<List<Map<String, dynamic>>> listFiles({
    String? folderId,
    String? query,
    int maxResults = 100,
  }) async {
    if (_driveApi == null) {
      throw Exception('Not authenticated');
    }

    try {
      String queryString = "trashed = false";

      if (folderId != null) {
        queryString += " and '$folderId' in parents";
      }

      if (query != null && query.isNotEmpty) {
        queryString += " and name contains '$query'";
      }

      final fileList = await _driveApi!.files.list(
        q: queryString,
        pageSize: maxResults,
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, mimeType, size, modifiedTime, webViewLink)',
      );

      final files = <Map<String, dynamic>>[];

      for (final file in fileList.files ?? []) {
        files.add({
          'id': file.id,
          'name': file.name,
          'mimeType': file.mimeType,
          'size': file.size != null ? int.parse(file.size!) : 0,
          'modified': file.modifiedTime?.toIso8601String(),
          'webViewLink': file.webViewLink,
        });
      }

      return files;
    } catch (e) {
      print('Error listing Google Drive files: $e');
      return [];
    }
  }

  /// Download file from Google Drive
  Future<File?> downloadFile({
    required String fileId,
    required String fileName,
  }) async {
    if (_driveApi == null) {
      throw Exception('Not authenticated');
    }

    try {
      // Get file metadata first
      final fileMetadata = await _driveApi!.files.get(
        fileId,
        $fields: 'mimeType',
      ) as drive.File;

      // Check if it's a Google Doc that needs export
      final isGoogleDoc = fileMetadata.mimeType?.startsWith('application/vnd.google-apps.') ?? false;

      drive.Media? media;

      if (isGoogleDoc) {
        // Export Google Docs as PDF
        media = await _driveApi!.files.export(
          fileId,
          'application/pdf',
          downloadOptions: drive.DownloadOptions.fullMedia,
        );
      } else {
        // Download regular files
        media = await _driveApi!.files.get(
          fileId,
          downloadOptions: drive.DownloadOptions.fullMedia,
        ) as drive.Media?;
      }

      if (media == null) {
        return null;
      }

      // Save to temp directory
      final tempDir = await getTemporaryDirectory();
      final localPath = '${tempDir.path}/$fileName';
      final localFile = File(localPath);

      // Write stream to file
      final sink = localFile.openWrite();
      await media.stream.pipe(sink);
      await sink.close();

      return localFile;
    } catch (e) {
      print('Error downloading file from Google Drive: $e');
      return null;
    }
  }

  /// Upload file to Google Drive
  Future<String?> uploadFile({
    required File file,
    String? folderId,
    String? description,
  }) async {
    if (_driveApi == null) {
      throw Exception('Not authenticated');
    }

    try {
      final fileName = file.path.split('/').last;

      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.description = description;

      if (folderId != null) {
        driveFile.parents = [folderId];
      }

      final media = drive.Media(file.openRead(), await file.length());

      final response = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      return response.id;
    } catch (e) {
      print('Error uploading file to Google Drive: $e');
      return null;
    }
  }

  /// Get file metadata
  Future<Map<String, dynamic>?> getFileMetadata(String fileId) async {
    if (_driveApi == null) {
      throw Exception('Not authenticated');
    }

    try {
      final file = await _driveApi!.files.get(
        fileId,
        $fields: 'id, name, mimeType, size, modifiedTime, createdTime, webViewLink, thumbnailLink',
      ) as drive.File;

      return {
        'id': file.id,
        'name': file.name,
        'mimeType': file.mimeType,
        'size': file.size != null ? int.parse(file.size!) : 0,
        'modified': file.modifiedTime?.toIso8601String(),
        'created': file.createdTime?.toIso8601String(),
        'webViewLink': file.webViewLink,
        'thumbnailLink': file.thumbnailLink,
      };
    } catch (e) {
      print('Error getting file metadata: $e');
      return null;
    }
  }

  /// Create folder in Google Drive
  Future<String?> createFolder({
    required String name,
    String? parentFolderId,
  }) async {
    if (_driveApi == null) {
      throw Exception('Not authenticated');
    }

    try {
      final folder = drive.File();
      folder.name = name;
      folder.mimeType = 'application/vnd.google-apps.folder';

      if (parentFolderId != null) {
        folder.parents = [parentFolderId];
      }

      final response = await _driveApi!.files.create(folder);
      return response.id;
    } catch (e) {
      print('Error creating folder: $e');
      return null;
    }
  }

  /// Search files by name or content
  Future<List<Map<String, dynamic>>> searchFiles(String searchQuery) async {
    return await listFiles(query: searchQuery);
  }

  /// Get MIME type from file name
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    final mimeTypes = {
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'txt': 'text/plain',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'mp3': 'audio/mpeg',
      'mp4': 'video/mp4',
      'zip': 'application/zip',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
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
      'google_drive',
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
          provider: model.CloudStorageProvider.googleDrive,
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
      'google_drive',
    );
  }
}
