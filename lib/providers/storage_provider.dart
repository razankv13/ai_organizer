import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Provider for storage actions
final storageActionsProvider = Provider<StorageActions>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return StorageActions(client);
});

/// Storage actions for Supabase
class StorageActions {

  StorageActions(this._client);
  final SupabaseClient? _client;

  /// Helper to ensure client is initialized
  SupabaseClient get _ensureClient {
    if (_client == null) {
      throw Exception('Supabase is not initialized. Check your .env configuration.');
    }
    return _client!;
  }
  static const String _bucketName = 'attachments';

  /// Upload a file to Supabase storage
  /// Returns the public URL of the uploaded file
  Future<String> uploadFile(File file, String noteId) async {
    final client = _ensureClient;

    // Generate a unique filename
    final extension = path.extension(file.path);
    final uuid = const Uuid().v4();
    final filename = '$uuid$extension';

    // Create a path with user ID and note ID for organization
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final storagePath = '${user.id}/$noteId/$filename';

    // Upload the file
    await client.storage
      .from(_bucketName)
      .upload(storagePath, file);

    // Get the public URL
    final publicUrl = client.storage
      .from(_bucketName)
      .getPublicUrl(storagePath);

    return publicUrl;
  }

  /// Create a thumbnail and upload it to Supabase storage
  Future<String?> uploadThumbnail(File thumbnailFile, String noteId) async {
    try {
      final client = _ensureClient;

      // Generate a unique filename with thumb_ prefix
      final extension = path.extension(thumbnailFile.path);
      final uuid = const Uuid().v4();
      final filename = 'thumb_$uuid$extension';

      // Create a path with user ID and note ID for organization
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final storagePath = '${user.id}/$noteId/thumbnails/$filename';

      // Upload the thumbnail
      await client.storage
        .from(_bucketName)
        .upload(storagePath, thumbnailFile);

      // Get the public URL
      final publicUrl = client.storage
        .from(_bucketName)
        .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  /// Delete a file from Supabase storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      final client = _ensureClient;

      // Extract the file path from the URL
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;

      // The path format in storage is typically /storage/v1/object/public/bucket-name/path/to/file
      // We need to extract just the path/to/file part
      final storagePath = pathSegments.sublist(5).join('/');

      // Delete the file
      await client.storage
        .from(_bucketName)
        .remove([storagePath]);
    } catch (e) {
      // Handle or ignore error
    }
  }

  /// Delete all files for a note
  Future<void> deleteNoteFiles(String noteId) async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) return;

      final dirPath = '${user.id}/$noteId';

      // List all files in the directory
      final files = await client.storage
        .from(_bucketName)
        .list(path: dirPath);

      // Create a list of file paths to delete
      final filePaths = files.map((file) => '$dirPath/${file.name}').toList();

      // Delete the files if any exist
      if (filePaths.isNotEmpty) {
        await client.storage
          .from(_bucketName)
          .remove(filePaths);
      }
    } catch (e) {
      // Handle or ignore error
    }
  }

  /// Create storage bucket if it doesn't exist
  Future<void> ensureBucketExists() async {
    try {
      final client = _ensureClient;

      // Get list of buckets
      final buckets = await client.storage.listBuckets();

      // Check if our bucket exists
      final bucketExists = buckets.any((bucket) => bucket.name == _bucketName);

      // Create bucket if it doesn't exist
      if (!bucketExists) {
        await client.storage.createBucket(_bucketName,
          const BucketOptions(public: true)); // Make it public for easy access
      }
    } catch (e) {
      // Handle error or ignore
    }
  }
} 