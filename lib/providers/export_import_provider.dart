import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/services/export_service.dart';
import 'package:ai_organizer/services/import_service.dart';
import 'package:ai_organizer/services/backup_service.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/presentation/screens/settings/export_import_screen.dart';
import 'package:intl/intl.dart';
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/models/tag.dart' as model;
import 'package:ai_organizer/data/models/attachment.dart' as model;

/// Provider for export service
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

/// Provider for import service
final importServiceProvider = Provider<ImportService>((ref) {
  return ImportService();
});

/// Provider for backup service
final backupServiceProvider = Provider<BackupService>((ref) {
  final database = ref.watch(databaseProvider);
  return BackupService(database);
});

/// Provider for export/import operations
final exportImportProvider =
    StateNotifierProvider<ExportImportNotifier, ExportImportState>((ref) {
  return ExportImportNotifier(ref);
});

/// State for export/import operations
class ExportImportState {
  final bool isLoading;
  final String? error;

  const ExportImportState({
    this.isLoading = false,
    this.error,
  });

  ExportImportState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ExportImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for export/import operations
class ExportImportNotifier extends StateNotifier<ExportImportState> {
  final Ref ref;

  ExportImportNotifier(this.ref) : super(const ExportImportState());

  /// Export notes
  Future<File?> exportNotes({
    required ExportFormat format,
    required bool exportAll,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final exportService = ref.read(exportServiceProvider);
      final database = ref.read(databaseProvider);

      // Get notes to export
      final notes = await database.getAllNotes();

      if (notes.isEmpty) {
        throw Exception('No notes to export');
      }

      // Get tags and attachments for each note
      final noteTags = <String, List<model.Tag>>{};
      final noteAttachments = <String, List<model.Attachment>>{};

      for (final note in notes) {
        final dbTags = await database.getTagsForNote(note.id);
        noteTags[note.id] = dbTags.map((tag) => model.Tag(
          id: tag.id,
          name: tag.name,
          createdAt: tag.createdAt,
          color: tag.color,
          useCount: tag.useCount,
          description: tag.description,
        )).toList();

        noteAttachments[note.id] = await database.getAttachmentsForNote(note.id);
      }

      // Convert to model.Note
      final modelNotes = notes.map((note) {
        final tags = noteTags[note.id] ?? [];
        return note.toModel(tags.map((t) => t.name).toList());
      }).toList();

      // Export based on format
      File result;
      switch (format) {
        case ExportFormat.json:
          result = await exportService.exportNotesToJson(
            modelNotes,
            noteTags,
            noteAttachments,
          );
          break;
        case ExportFormat.markdown:
          final files = await exportService.exportNotesToMarkdown(
            modelNotes,
            noteTags,
            noteAttachments,
          );
          result = files.first; // Return first file for now
          break;
        case ExportFormat.html:
          final files = await exportService.exportNotesToHtml(
            modelNotes,
            noteTags,
            noteAttachments,
          );
          result = files.first;
          break;
        case ExportFormat.pdf:
          final files = await exportService.exportNotesToPdf(
            modelNotes,
            noteTags,
            noteAttachments,
          );
          result = files.first;
          break;
      }

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Import notes
  Future<ImportResult> importNotes({
    required String filePath,
    required ImportFormat format,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final importService = ref.read(importServiceProvider);
      final database = ref.read(databaseProvider);
      final file = File(filePath);

      ImportResult result;

      switch (format) {
        case ImportFormat.json:
          result = await importService.importNotesFromJson(file);
          break;
        case ImportFormat.markdown:
          // For single markdown file
          final importedData = await importService.importNoteFromMarkdown(file);
          if (importedData != null) {
            // Save to database
            await database.insertNote(importedData.note);
            for (final tag in importedData.tags) {
              await database.insertTag(tag);
            }
            result = ImportResult(
              notesImported: 1,
              tagsImported: importedData.tags.length,
              attachmentsImported: 0,
              errors: const [],
            );
          } else {
            result = const ImportResult(
              notesImported: 0,
              tagsImported: 0,
              attachmentsImported: 0,
              errors: ['Failed to import markdown file'],
            );
          }
          break;
      }

      // Refresh notes provider
      ref.invalidate(notesProvider);

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Create backup
  Future<BackupResult> createBackup() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final backupService = ref.read(backupServiceProvider);
      final result = await backupService.createBackup();

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Restore backup
  Future<RestoreResult> restoreBackup(String backupPath) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final backupService = ref.read(backupServiceProvider);
      final file = File(backupPath);
      final result = await backupService.restoreFromBackup(file);

      // Refresh notes provider
      ref.invalidate(notesProvider);

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Delete backup
  Future<void> deleteBackup(String backupPath) async {
    final backupService = ref.read(backupServiceProvider);
    final file = File(backupPath);
    await backupService.deleteBackup(file);
  }
}

/// Provider for backup list
final backupListProvider = FutureProvider<List<BackupInfo>>((ref) async {
  final backupService = ref.watch(backupServiceProvider);
  final backups = await backupService.listBackups();

  final backupInfoList = <BackupInfo>[];

  for (final backup in backups) {
    final metadata = await backupService.getBackupMetadata(backup);
    if (metadata != null) {
      final metadataInfo = metadata['metadata'] as Map<String, dynamic>?;
      backupInfoList.add(
        BackupInfo(
          filename: backup.path.split('/').last,
          filePath: backup.path,
          fileSize: metadata['file_size'] as int,
          backupDate: DateTime.parse(metadata['backup_date'] as String),
          notesCount: metadataInfo?['notes_count'] as int? ?? 0,
          tagsCount: metadataInfo?['tags_count'] as int? ?? 0,
        ),
      );
    }
  }

  return backupInfoList;
});

/// Backup information model
class BackupInfo {
  final String filename;
  final String filePath;
  final int fileSize;
  final DateTime backupDate;
  final int notesCount;
  final int tagsCount;

  const BackupInfo({
    required this.filename,
    required this.filePath,
    required this.fileSize,
    required this.backupDate,
    required this.notesCount,
    required this.tagsCount,
  });

  String get formattedSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy HH:mm').format(backupDate);
  }
}

/// Extension to convert Note table to model.Note
extension NoteToModel on Note {
  model.Note toModel(List<String> tags) {
    return model.Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPinned: isPinned,
      isArchived: isArchived,
      isFavorite: isFavorite,
      folderId: folderId,
      color: color,
      tags: tags,
    );
  }
}
