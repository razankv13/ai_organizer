import 'dart:convert';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/data/models/tag.dart';
import 'package:ai_organizer/data/models/attachment.dart';

/// Service for exporting notes to various formats
class ExportService {
  /// Export a single note to JSON format
  Future<File> exportNoteToJson(Note note, List<Tag> tags, List<Attachment> attachments) async {
    final exportData = {
      'note': note.toJson(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'attachments': attachments.map((att) => att.toJson()).toList(),
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    final file = await _saveToFile(
      'note_${note.id}_${_timestamp()}.json',
      jsonString,
    );

    return file;
  }

  /// Export multiple notes to JSON format
  Future<File> exportNotesToJson(
    List<Note> notes,
    Map<String, List<Tag>> noteTags,
    Map<String, List<Attachment>> noteAttachments,
  ) async {
    final exportData = {
      'notes': notes.map((note) {
        return {
          'note': note.toJson(),
          'tags': (noteTags[note.id] ?? []).map((tag) => tag.toJson()).toList(),
          'attachments': (noteAttachments[note.id] ?? [])
              .map((att) => att.toJson())
              .toList(),
        };
      }).toList(),
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'total_notes': notes.length,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    final file = await _saveToFile(
      'notes_export_${_timestamp()}.json',
      jsonString,
    );

    return file;
  }

  /// Export a single note to Markdown format
  Future<File> exportNoteToMarkdown(
    Note note,
    List<Tag> tags,
    List<Attachment> attachments,
  ) async {
    final buffer = StringBuffer();

    // Title
    buffer.writeln('# ${note.title}');
    buffer.writeln();

    // Metadata
    buffer.writeln('---');
    buffer.writeln('Created: ${_formatDate(note.createdAt)}');
    buffer.writeln('Updated: ${_formatDate(note.updatedAt)}');
    if (tags.isNotEmpty) {
      buffer.writeln('Tags: ${tags.map((t) => t.name).join(', ')}');
    }
    if (note.folderId != null) {
      buffer.writeln('Folder: ${note.folderId}');
    }
    buffer.writeln('---');
    buffer.writeln();

    // Content
    final content = note.content;
    if (content != null && content.isNotEmpty) {
      buffer.writeln(content);
      buffer.writeln();
    }

    // Attachments
    if (attachments.isNotEmpty) {
      buffer.writeln('## Attachments');
      buffer.writeln();
      for (final attachment in attachments) {
        buffer.writeln('- **${attachment.fileName}** (${attachment.fileSizeFormatted})');
        if (attachment.hasExtractedText) {
          buffer.writeln('  - Extracted Text: ${attachment.extractedText}');
        }
      }
      buffer.writeln();
    }

    final file = await _saveToFile(
      'note_${_sanitizeFilename(note.title)}_${_timestamp()}.md',
      buffer.toString(),
    );

    return file;
  }

  /// Export multiple notes to Markdown format (one file per note)
  Future<List<File>> exportNotesToMarkdown(
    List<Note> notes,
    Map<String, List<Tag>> noteTags,
    Map<String, List<Attachment>> noteAttachments,
  ) async {
    final files = <File>[];

    for (final note in notes) {
      final file = await exportNoteToMarkdown(
        note,
        noteTags[note.id] ?? [],
        noteAttachments[note.id] ?? [],
      );
      files.add(file);
    }

    return files;
  }

  /// Export a single note to HTML format
  Future<File> exportNoteToHtml(
    Note note,
    List<Tag> tags,
    List<Attachment> attachments,
  ) async {
    final buffer = StringBuffer();

    // HTML header
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="UTF-8">');
    buffer.writeln('  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('  <title>${_escapeHtml(note.title)}</title>');
    buffer.writeln('  <style>');
    buffer.writeln('    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; max-width: 800px; margin: 40px auto; padding: 20px; line-height: 1.6; }');
    buffer.writeln('    h1 { color: #333; border-bottom: 2px solid #007AFF; padding-bottom: 10px; }');
    buffer.writeln('    .metadata { background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0; }');
    buffer.writeln('    .metadata p { margin: 5px 0; color: #666; }');
    buffer.writeln('    .tags { display: flex; gap: 8px; flex-wrap: wrap; margin: 15px 0; }');
    buffer.writeln('    .tag { background: #007AFF; color: white; padding: 4px 12px; border-radius: 16px; font-size: 14px; }');
    buffer.writeln('    .content { margin: 30px 0; white-space: pre-wrap; }');
    buffer.writeln('    .attachments { margin: 30px 0; }');
    buffer.writeln('    .attachment { background: #f9f9f9; padding: 10px; margin: 8px 0; border-radius: 6px; }');
    buffer.writeln('  </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    // Title
    buffer.writeln('  <h1>${_escapeHtml(note.title)}</h1>');

    // Metadata
    buffer.writeln('  <div class="metadata">');
    buffer.writeln('    <p><strong>Created:</strong> ${_formatDate(note.createdAt)}</p>');
    buffer.writeln('    <p><strong>Updated:</strong> ${_formatDate(note.updatedAt)}</p>');
    if (note.folderId != null) {
      buffer.writeln('    <p><strong>Folder:</strong> ${_escapeHtml(note.folderId!)}</p>');
    }
    buffer.writeln('  </div>');

    // Tags
    if (tags.isNotEmpty) {
      buffer.writeln('  <div class="tags">');
      for (final tag in tags) {
        buffer.writeln('    <span class="tag">${_escapeHtml(tag.name)}</span>');
      }
      buffer.writeln('  </div>');
    }

    // Content
    final content = note.content;
    if (content != null && content.isNotEmpty) {
      buffer.writeln('  <div class="content">');
      buffer.writeln('    ${_escapeHtml(content)}');
      buffer.writeln('  </div>');
    }

    // Attachments
    if (attachments.isNotEmpty) {
      buffer.writeln('  <div class="attachments">');
      buffer.writeln('    <h2>Attachments</h2>');
      for (final attachment in attachments) {
        buffer.writeln('    <div class="attachment">');
        buffer.writeln('      <strong>${_escapeHtml(attachment.fileName)}</strong>');
        buffer.writeln('      <span>(${attachment.fileSizeFormatted})</span>');
        if (attachment.hasExtractedText) {
          buffer.writeln('      <p><em>Extracted Text:</em> ${_escapeHtml(attachment.extractedText!)}</p>');
        }
        buffer.writeln('    </div>');
      }
      buffer.writeln('  </div>');
    }

    buffer.writeln('</body>');
    buffer.writeln('</html>');

    final file = await _saveToFile(
      'note_${_sanitizeFilename(note.title)}_${_timestamp()}.html',
      buffer.toString(),
    );

    return file;
  }

  /// Export multiple notes to HTML format
  Future<List<File>> exportNotesToHtml(
    List<Note> notes,
    Map<String, List<Tag>> noteTags,
    Map<String, List<Attachment>> noteAttachments,
  ) async {
    final files = <File>[];

    for (final note in notes) {
      final file = await exportNoteToHtml(
        note,
        noteTags[note.id] ?? [],
        noteAttachments[note.id] ?? [],
      );
      files.add(file);
    }

    return files;
  }

  /// Export a single note to PDF format
  Future<File> exportNoteToPdf(
    Note note,
    List<Tag> tags,
    List<Attachment> attachments,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Title
            pw.Header(
              level: 0,
              child: pw.Text(
                note.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Metadata
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Created: ${_formatDate(note.createdAt)}'),
                  pw.SizedBox(height: 5),
                  pw.Text('Updated: ${_formatDate(note.updatedAt)}'),
                  if (note.folderId != null) ...[
                    pw.SizedBox(height: 5),
                    pw.Text('Folder: ${note.folderId}'),
                  ],
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Tags
            if (tags.isNotEmpty) ...[
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(16),
                      ),
                    ),
                    child: pw.Text(
                      tag.name,
                      style: const pw.TextStyle(color: PdfColors.white),
                    ),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
            ],

            // Content
            if (note.content.isNotEmpty) ...[
              pw.Text(
                note.content,
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
            ],

            // Attachments
            if (attachments.isNotEmpty) ...[
              pw.Header(
                level: 1,
                child: pw.Text('Attachments'),
              ),
              pw.SizedBox(height: 10),
              ...attachments.map((attachment) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(6),
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${attachment.fileName} (${attachment.fileSizeFormatted})',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      if (attachment.hasExtractedText) ...[
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Extracted Text: ${attachment.extractedText}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/note_${_sanitizeFilename(note.title)}_${_timestamp()}.pdf',
    );

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Export multiple notes to PDF format (one file per note)
  Future<List<File>> exportNotesToPdf(
    List<Note> notes,
    Map<String, List<Tag>> noteTags,
    Map<String, List<Attachment>> noteAttachments,
  ) async {
    final files = <File>[];

    for (final note in notes) {
      final file = await exportNoteToPdf(
        note,
        noteTags[note.id] ?? [],
        noteAttachments[note.id] ?? [],
      );
      files.add(file);
    }

    return files;
  }

  // Helper methods

  /// Save content to a file
  Future<File> _saveToFile(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);
    return file;
  }

  /// Generate timestamp for filenames
  String _timestamp() {
    return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// Sanitize filename by removing special characters
  String _sanitizeFilename(String filename) {
    return filename
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase()
        .substring(0, filename.length > 50 ? 50 : filename.length);
  }

  /// Escape HTML special characters
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
