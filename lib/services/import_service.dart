import 'dart:convert';
import 'dart:io';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/data/models/tag.dart';
import 'package:ai_organizer/data/models/attachment.dart';

/// Result of an import operation
class ImportResult {
  final int notesImported;
  final int tagsImported;
  final int attachmentsImported;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => notesImported > 0;

  const ImportResult({
    required this.notesImported,
    required this.tagsImported,
    required this.attachmentsImported,
    required this.errors,
  });
}

/// Data structure for imported note with its related data
class ImportedNoteData {
  final Note note;
  final List<Tag> tags;
  final List<Attachment> attachments;

  const ImportedNoteData({
    required this.note,
    required this.tags,
    required this.attachments,
  });
}

/// Service for importing notes from various formats
class ImportService {
  /// Import notes from JSON file (single note format)
  Future<ImportedNoteData?> importNoteFromJson(File file) async {
    try {
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate version
      final version = jsonData['version'] as String?;
      if (version == null) {
        throw const FormatException('Invalid JSON format: missing version');
      }

      // Parse note
      final noteData = jsonData['note'] as Map<String, dynamic>?;
      if (noteData == null) {
        throw const FormatException('Invalid JSON format: missing note data');
      }
      final note = Note.fromJson(noteData);

      // Parse tags
      final tagsData = jsonData['tags'] as List<dynamic>? ?? [];
      final tags = tagsData
          .map((tagJson) => Tag.fromJson(tagJson as Map<String, dynamic>))
          .toList();

      // Parse attachments
      final attachmentsData = jsonData['attachments'] as List<dynamic>? ?? [];
      final attachments = attachmentsData
          .map((attJson) =>
              Attachment.fromJson(attJson as Map<String, dynamic>))
          .toList();

      return ImportedNoteData(
        note: note,
        tags: tags,
        attachments: attachments,
      );
    } catch (e) {
      return null;
    }
  }

  /// Import multiple notes from JSON file (bulk export format)
  Future<ImportResult> importNotesFromJson(File file) async {
    final errors = <String>[];
    var notesCount = 0;
    var tagsCount = 0;
    var attachmentsCount = 0;

    try {
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate version
      final version = jsonData['version'] as String?;
      if (version == null) {
        errors.add('Invalid JSON format: missing version');
        return ImportResult(
          notesImported: 0,
          tagsImported: 0,
          attachmentsImported: 0,
          errors: errors,
        );
      }

      // Parse notes array
      final notesData = jsonData['notes'] as List<dynamic>?;
      if (notesData == null) {
        errors.add('Invalid JSON format: missing notes data');
        return ImportResult(
          notesImported: 0,
          tagsImported: 0,
          attachmentsImported: 0,
          errors: errors,
        );
      }

      for (var i = 0; i < notesData.length; i++) {
        try {
          final noteEntry = notesData[i] as Map<String, dynamic>;
          final noteData = noteEntry['note'] as Map<String, dynamic>;

          // Parse note (we parse but don't use it here since we're just counting)
          Note.fromJson(noteData);
          notesCount++;

          // Parse tags
          final tagsData = noteEntry['tags'] as List<dynamic>? ?? [];
          tagsCount += tagsData.length;

          // Parse attachments
          final attachmentsData =
              noteEntry['attachments'] as List<dynamic>? ?? [];
          attachmentsCount += attachmentsData.length;
        } catch (e) {
          errors.add('Error importing note at index $i: $e');
        }
      }

      return ImportResult(
        notesImported: notesCount,
        tagsImported: tagsCount,
        attachmentsImported: attachmentsCount,
        errors: errors,
      );
    } catch (e) {
      errors.add('Failed to parse JSON file: $e');
      return ImportResult(
        notesImported: notesCount,
        tagsImported: tagsCount,
        attachmentsImported: attachmentsCount,
        errors: errors,
      );
    }
  }

  /// Import a note from Markdown file
  Future<ImportedNoteData?> importNoteFromMarkdown(File file) async {
    try {
      final content = await file.readAsString();
      final lines = content.split('\n');

      var title = '';
      var noteContent = '';
      final tags = <Tag>[];
      String? folderId;

      var isMetadata = false;
      var isContent = false;
      final contentBuffer = StringBuffer();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        // Parse title (first H1)
        if (line.startsWith('# ') && title.isEmpty) {
          title = line.substring(2).trim();
          continue;
        }

        // Metadata section
        if (line == '---') {
          if (!isMetadata) {
            isMetadata = true;
          } else {
            isMetadata = false;
            isContent = true;
          }
          continue;
        }

        // Parse metadata
        if (isMetadata) {
          if (line.startsWith('Created:')) {
            // Skip - dates will be auto-generated
          } else if (line.startsWith('Updated:')) {
            // Skip - dates will be auto-generated
          } else if (line.startsWith('Tags:')) {
            final tagNames = line
                .substring('Tags:'.length)
                .trim()
                .split(',')
                .map((t) => t.trim())
                .where((t) => t.isNotEmpty);
            for (final tagName in tagNames) {
              tags.add(Tag.create(name: tagName));
            }
          } else if (line.startsWith('Folder:')) {
            folderId = line.substring('Folder:'.length).trim();
          }
          continue;
        }

        // Parse content (skip attachments section)
        if (isContent && !line.startsWith('## Attachments')) {
          contentBuffer.writeln(line);
        }

        // Stop at attachments section
        if (line.startsWith('## Attachments')) {
          break;
        }
      }

      noteContent = contentBuffer.toString().trim();

      // Create note
      final filename = file.path.split('/').last;
      final noteTitle = title.isNotEmpty ? title : filename;
      final noteContentFinal = noteContent.isNotEmpty ? noteContent : '';

      // Create note with optional folderId
      final note = Note.create(
        title: noteTitle,
        content: noteContentFinal,
        folderId: (folderId != null && folderId.isNotEmpty) ? folderId : null,
      );

      return ImportedNoteData(
        note: note,
        tags: tags,
        attachments: [], // Attachments are not imported from markdown
      );
    } catch (e) {
      return null;
    }
  }

  /// Import multiple Markdown files from a directory
  Future<ImportResult> importNotesFromMarkdownDirectory(Directory directory) async {
    final errors = <String>[];
    var notesCount = 0;
    var tagsCount = 0;

    try {
      final files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.md'))
          .toList();

      for (final file in files) {
        try {
          final importedData = await importNoteFromMarkdown(file);
          if (importedData != null) {
            notesCount++;
            tagsCount += importedData.tags.length;
          } else {
            errors.add('Failed to import: ${file.path}');
          }
        } catch (e) {
          errors.add('Error importing ${file.path}: $e');
        }
      }

      return ImportResult(
        notesImported: notesCount,
        tagsImported: tagsCount,
        attachmentsImported: 0,
        errors: errors,
      );
    } catch (e) {
      errors.add('Failed to read directory: $e');
      return ImportResult(
        notesImported: notesCount,
        tagsImported: tagsCount,
        attachmentsImported: 0,
        errors: errors,
      );
    }
  }

}
