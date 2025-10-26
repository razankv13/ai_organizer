import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

/// Attachment model for files, images, and media
@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    String? noteId,
    required String fileName,
    required String filePath,
    required AttachmentType type,
    required int fileSize,
    required DateTime createdAt,
    String? mimeType,
    String? thumbnailPath,
    Map<String, dynamic>? metadata,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  /// Create a new attachment
  factory Attachment.create({
    String? noteId,
    required String fileName,
    required String filePath,
    required AttachmentType type,
    required int fileSize,
    String? mimeType,
    String? thumbnailPath,
    Map<String, dynamic>? metadata,
  }) {
    return Attachment(
      id: _generateAttachmentId(),
      noteId: noteId,
      fileName: fileName,
      filePath: filePath,
      type: type,
      fileSize: fileSize,
      createdAt: DateTime.now(),
      mimeType: mimeType,
      thumbnailPath: thumbnailPath,
      metadata: metadata,
    );
  }

  const Attachment._();

  /// Get file size in human readable format
  String get fileSizeFormatted {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    if (fileSize < 1024 * 1024 * 1024) return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Check if attachment is an image
  bool get isImage => type == AttachmentType.image;

  /// Check if attachment is a document
  bool get isDocument => type == AttachmentType.document;

  /// Check if attachment is audio
  bool get isAudio => type == AttachmentType.audio;

  /// Check if attachment is video
  bool get isVideo => type == AttachmentType.video;

  /// Get file extension
  String get fileExtension {
    final parts = fileName.split('.');
    return parts.isNotEmpty ? parts.last.toLowerCase() : '';
  }

  /// Get extracted text from metadata (OCR result)
  String? get extractedText {
    if (metadata == null) return null;
    return metadata!['extractedText'] as String?;
  }

  /// Check if this attachment has extracted text
  bool get hasExtractedText {
    return extractedText != null && extractedText!.isNotEmpty;
  }

  /// Create a copy with extracted text added to metadata
  Attachment withExtractedText(String text) {
    final updatedMetadata = Map<String, dynamic>.from(metadata ?? {});
    updatedMetadata['extractedText'] = text;
    updatedMetadata['extractedAt'] = DateTime.now().toIso8601String();
    return copyWith(metadata: updatedMetadata);
  }
}

/// Attachment type enumeration
@JsonEnum()
enum AttachmentType {
  image,
  document,
  audio,
  video,
  other;

  /// Get type from file extension
  static AttachmentType fromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
        return AttachmentType.image;
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
        return AttachmentType.document;
      case 'mp3':
      case 'wav':
      case 'm4a':
      case 'aac':
        return AttachmentType.audio;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return AttachmentType.video;
      default:
        return AttachmentType.other;
    }
  }

  /// Convert from string to enum
  static AttachmentType fromString(String typeString) {
    try {
      return AttachmentType.values.firstWhere(
        (e) => e.name == typeString,
        orElse: () => AttachmentType.other,
      );
    } catch (e) {
      return AttachmentType.other;
    }
  }

  /// Get icon for attachment type
  String get icon {
    switch (this) {
      case AttachmentType.image:
        return 'image';
      case AttachmentType.document:
        return 'description';
      case AttachmentType.audio:
        return 'audiotrack';
      case AttachmentType.video:
        return 'videocam';
      case AttachmentType.other:
        return 'attach_file';
    }
  }
}

/// Generate unique attachment ID
String _generateAttachmentId() {
  return 'att_${DateTime.now().millisecondsSinceEpoch}';
} 