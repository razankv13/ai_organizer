import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';
part 'folder.g.dart';

/// Folder model for organizing notes hierarchically
@freezed
abstract class Folder with _$Folder {
  const factory Folder({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? parentId, // null for root folders
    String? color,
    String? icon,
    int? noteCount,
  }) = _Folder;

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  /// Create a new folder
  factory Folder.create({
    required String name,
    String? parentId,
    String? color,
    String? icon,
  }) {
    return Folder(
      id: _generateFolderId(),
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentId: parentId,
      color: color,
      icon: icon,
      noteCount: 0,
    );
  }

  const Folder._();

  /// Check if this is a root folder (no parent)
  bool get isRoot => parentId == null;

  /// Get display name (defaults to name if not empty)
  String get displayName => name.isEmpty ? 'Untitled Folder' : name;
}

/// Generate unique folder ID
String _generateFolderId() {
  return 'folder_${DateTime.now().millisecondsSinceEpoch}';
}
