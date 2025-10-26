import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

/// Core Note model with all essential properties
@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<String> tags,
    @Default([]) List<String> attachments,
    @Default(false) bool isPinned,
    @Default(false) bool isArchived,
    @Default(false) bool isFavorite,
    String? folderId,
    String? color,
    // For offline-first sync - not serialized
    bool? isLocal,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  /// Create a new note with generated ID and timestamps
  factory Note.create({
    required String title,
    required String content,
    List<String>? tags,
    String? folderId,
    String? color,
  }) {
    final now = DateTime.now();
    return Note(
      id: _generateId(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      tags: tags ?? [],
      folderId: folderId,
      color: color,
    );
  }

  /// Update note with new content and timestamp
  const Note._();
  
  Note updateContent({
    String? title,
    String? content,
    List<String>? tags,
    String? folderId,
    String? color,
    bool? isPinned,
    bool? isArchived,
    bool? isFavorite,
  }) {
    return copyWith(
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      folderId: folderId ?? this.folderId,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      updatedAt: DateTime.now(),
    );
  }

  /// Get word count for the note
  int get wordCount {
    if (content.isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Get character count for the note
  int get characterCount => content.length;

  /// Check if note is empty
  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;

  /// Get preview text (first 100 characters)
  String get preview {
    if (content.isEmpty) return title;
    final text = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length > 100 ? '${text.substring(0, 100)}...' : text;
  }

  /// Check if note matches search query
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final searchLower = query.toLowerCase();
    return title.toLowerCase().contains(searchLower) ||
           content.toLowerCase().contains(searchLower) ||
           tags.any((tag) => tag.toLowerCase().contains(searchLower));
  }
}

/// Simple ID generation - could be replaced with UUID package
String _generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
} 