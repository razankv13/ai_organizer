import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/models/tag.dart' as model;
import 'package:ai_organizer/data/models/attachment.dart' as model;

/// Result of a backup operation
class BackupResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;
  final int? notesCount;
  final int? tagsCount;
  final int? attachmentsCount;

  const BackupResult({
    required this.success,
    this.filePath,
    this.errorMessage,
    this.notesCount,
    this.tagsCount,
    this.attachmentsCount,
  });

  BackupResult.success({
    required String filePath,
    required int notesCount,
    required int tagsCount,
    required int attachmentsCount,
  }) : this(
          success: true,
          filePath: filePath,
          notesCount: notesCount,
          tagsCount: tagsCount,
          attachmentsCount: attachmentsCount,
        );

  BackupResult.failure(String errorMessage)
      : this(
          success: false,
          errorMessage: errorMessage,
        );
}

/// Result of a restore operation
class RestoreResult {
  final bool success;
  final String? errorMessage;
  final int? notesRestored;
  final int? tagsRestored;
  final int? attachmentsRestored;

  const RestoreResult({
    required this.success,
    this.errorMessage,
    this.notesRestored,
    this.tagsRestored,
    this.attachmentsRestored,
  });

  RestoreResult.success({
    required int notesRestored,
    required int tagsRestored,
    required int attachmentsRestored,
  }) : this(
          success: true,
          notesRestored: notesRestored,
          tagsRestored: tagsRestored,
          attachmentsRestored: attachmentsRestored,
        );

  RestoreResult.failure(String errorMessage)
      : this(
          success: false,
          errorMessage: errorMessage,
        );
}

/// Service for creating and restoring full app backups
class BackupService {
  final AppDatabase database;

  BackupService(this.database);

  /// Create a full backup of the app data
  Future<BackupResult> createBackup() async {
    try {
      // Get all data from database
      final notes = await database.getAllNotes();
      final tags = await database.getAllTags();

      // Get all attachments and note-tag relationships
      final allAttachments = <Map<String, dynamic>>[];
      final noteTagRelations = <Map<String, dynamic>>[];

      for (final note in notes) {
        // Get attachments for this note
        final attachments = await database.getAttachmentsForNote(note.id);
        allAttachments.addAll(
          attachments.map((att) => att.toJson()).toList(),
        );

        // Get tags for this note
        final noteTags = await database.getTagsForNote(note.id);
        for (final tag in noteTags) {
          noteTagRelations.add({
            'noteId': note.id,
            'tagId': tag.id,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }

      // Create backup data structure
      final backupData = {
        'version': '1.0.0',
        'app_name': 'AI Organizer',
        'backup_date': DateTime.now().toIso8601String(),
        'data': {
          'notes': notes.map((note) => note.toJson()).toList(),
          'tags': tags.map((tag) => tag.toJson()).toList(),
          'attachments': allAttachments,
          'note_tags': noteTagRelations,
        },
        'metadata': {
          'notes_count': notes.length,
          'tags_count': tags.length,
          'attachments_count': allAttachments.length,
        },
      };

      // Save to file
      final backupFile = await _saveBackupToFile(backupData);

      return BackupResult.success(
        filePath: backupFile.path,
        notesCount: notes.length,
        tagsCount: tags.length,
        attachmentsCount: allAttachments.length,
      );
    } catch (e) {
      return BackupResult.failure('Failed to create backup: $e');
    }
  }

  /// Restore app data from a backup file
  Future<RestoreResult> restoreFromBackup(File backupFile) async {
    try {
      // Read and parse backup file
      final jsonString = await backupFile.readAsString();
      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate backup format
      final version = backupData['version'] as String?;
      if (version == null) {
        return RestoreResult.failure('Invalid backup format: missing version');
      }

      final data = backupData['data'] as Map<String, dynamic>?;
      if (data == null) {
        return RestoreResult.failure('Invalid backup format: missing data');
      }

      // Parse notes
      final notesData = data['notes'] as List<dynamic>? ?? [];
      final tagsData = data['tags'] as List<dynamic>? ?? [];
      final attachmentsData = data['attachments'] as List<dynamic>? ?? [];
      final noteTagsData = data['note_tags'] as List<dynamic>? ?? [];

      var notesRestored = 0;
      var tagsRestored = 0;
      var attachmentsRestored = 0;

      // Clear existing data (optional - you might want to merge instead)
      // Uncomment if you want to replace all data
      // await database.deleteAllNotes();
      // await database.deleteAllTags();

      // Restore tags first (to maintain referential integrity)
      for (final tagJson in tagsData) {
        try {
          final tagData = tagJson as Map<String, dynamic>;
          final tag = model.Tag.fromJson(tagData);
          await database.insertTag(tag);
          tagsRestored++;
        } catch (e) {
          // Tag might already exist, skip
        }
      }

      // Restore notes
      for (final noteJson in notesData) {
        try {
          final noteData = noteJson as Map<String, dynamic>;
          final note = model.Note.fromJson(noteData);
          await database.insertNote(note);
          notesRestored++;
        } catch (e) {
          // Note might already exist, skip
        }
      }

      // Restore attachments
      for (final attachmentJson in attachmentsData) {
        try {
          final attachmentData = attachmentJson as Map<String, dynamic>;
          final attachment = model.Attachment.fromJson(attachmentData);
          await database.insertAttachment(attachment);
          attachmentsRestored++;
        } catch (e) {
          // Attachment might already exist, skip
        }
      }

      // Note-tag relationships are handled by the insertNote method
      // via _updateNoteTags, so we don't need to manually restore them

      return RestoreResult.success(
        notesRestored: notesRestored,
        tagsRestored: tagsRestored,
        attachmentsRestored: attachmentsRestored,
      );
    } catch (e) {
      return RestoreResult.failure('Failed to restore backup: $e');
    }
  }

  /// Get list of available backups
  Future<List<File>> listBackups() async {
    try {
      final directory = await _getBackupDirectory();
      final files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.aiorgbackup'))
          .toList();

      // Sort by modification date (newest first)
      files.sort((a, b) {
        final aModified = a.lastModifiedSync();
        final bModified = b.lastModifiedSync();
        return bModified.compareTo(aModified);
      });

      return files;
    } catch (e) {
      return [];
    }
  }

  /// Delete a backup file
  Future<bool> deleteBackup(File backupFile) async {
    try {
      await backupFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get backup metadata without restoring
  Future<Map<String, dynamic>?> getBackupMetadata(File backupFile) async {
    try {
      final jsonString = await backupFile.readAsString();
      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      return {
        'version': backupData['version'],
        'backup_date': backupData['backup_date'],
        'metadata': backupData['metadata'],
        'file_size': await backupFile.length(),
        'file_path': backupFile.path,
      };
    } catch (e) {
      return null;
    }
  }

  // Helper methods

  /// Save backup data to file
  Future<File> _saveBackupToFile(Map<String, dynamic> backupData) async {
    final directory = await _getBackupDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'ai_organizer_backup_$timestamp.aiorgbackup';
    final file = File(path.join(directory.path, filename));

    final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
    await file.writeAsString(jsonString);

    return file;
  }

  /// Get backup directory
  Future<Directory> _getBackupDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(path.join(documentsDir.path, 'backups'));

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    return backupDir;
  }

  /// Schedule automatic backups (optional feature)
  Future<void> scheduleAutomaticBackup({
    required Duration interval,
  }) async {
    // This would integrate with a background task scheduler
    // For now, this is a placeholder for future implementation
    // You could use packages like workmanager or background_fetch
  }
}
