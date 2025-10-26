import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ai_organizer/data/models/attachment.dart';

/// Utility class for file management operations
class FileUtils {
  // Private constructor to prevent instantiation
  FileUtils._();

  /// Base directory for app files
  static Future<Directory> get _baseDir async => 
      await getApplicationDocumentsDirectory();

  /// Attachments directory path
  static Future<String> get attachmentsDir async {
    final baseDir = await _baseDir;
    final dir = Directory('${baseDir.path}/attachments');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  /// Thumbnails directory path
  static Future<String> get thumbnailsDir async {
    final baseDir = await _baseDir;
    final dir = Directory('${baseDir.path}/thumbnails');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  /// Generate a unique filename with extension
  static String generateUniqueFilename(String originalFilename) {
    final extension = path.extension(originalFilename);
    final uuid = const Uuid().v4();
    return '$uuid$extension';
  }

  /// Save a file to secure app storage and create thumbnail if it's an image
  /// Returns the saved file path and thumbnail path
  static Future<Map<String, String>> saveAttachmentFile(File file, String noteId) async {
    // Generate unique filename
    final filename = generateUniqueFilename(file.path);
    
    // Create note-specific directory
    final attachDir = await attachmentsDir;
    final noteDir = Directory('$attachDir/$noteId');
    if (!await noteDir.exists()) {
      await noteDir.create(recursive: true);
    }
    
    // Save file to app directory
    final savedFilePath = '${noteDir.path}/$filename';
    await file.copy(savedFilePath);
    
    // Create thumbnail if it's an image
    String? thumbnailPath;
    if (_isImageFile(file.path)) {
      thumbnailPath = await createThumbnail(savedFilePath, noteId);
    }
    
    return {
      'filePath': savedFilePath,
      'thumbnailPath': thumbnailPath ?? '',
    };
  }

  /// Create a thumbnail for an image file
  static Future<String?> createThumbnail(String imagePath, String noteId) async {
    try {
      final thumbnailDir = await thumbnailsDir;
      final noteThumbDir = Directory('$thumbnailDir/$noteId');
      if (!await noteThumbDir.exists()) {
        await noteThumbDir.create(recursive: true);
      }
      
      final filename = path.basename(imagePath);
      final thumbnailPath = '${noteThumbDir.path}/thumb_$filename';
      
      // Compress and resize the image
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        thumbnailPath,
        quality: 70,
        minWidth: 300,
        minHeight: 300,
      );
      
      return result?.path;
    } catch (e) {
      debugPrint('Error creating thumbnail: $e');
      return null;
    }
  }

  /// Delete attachment and its thumbnail
  static Future<bool> deleteAttachment(Attachment attachment) async {
    try {
      // Delete main file
      final file = File(attachment.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Delete thumbnail if exists
      if (attachment.thumbnailPath != null && attachment.thumbnailPath!.isNotEmpty) {
        final thumbnail = File(attachment.thumbnailPath!);
        if (await thumbnail.exists()) {
          await thumbnail.delete();
        }
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting attachment: $e');
      return false;
    }
  }

  /// Delete all attachments for a note
  static Future<bool> deleteNoteAttachments(String noteId) async {
    try {
      // Delete note's attachment directory
      final attachDir = await attachmentsDir;
      final noteDir = Directory('$attachDir/$noteId');
      if (await noteDir.exists()) {
        await noteDir.delete(recursive: true);
      }
      
      // Delete note's thumbnail directory
      final thumbnailDir = await thumbnailsDir;
      final noteThumbDir = Directory('$thumbnailDir/$noteId');
      if (await noteThumbDir.exists()) {
        await noteThumbDir.delete(recursive: true);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting note attachments: $e');
      return false;
    }
  }
  
  /// Check if file is an image
  static bool _isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext);
  }
  
  /// Get MIME type from file extension
  static String? getMimeType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/msword';
      case '.txt':
        return 'text/plain';
      case '.mp3':
        return 'audio/mpeg';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      default:
        return null;
    }
  }
} 