import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

/// Tag model for note organization
@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String name,
    required DateTime createdAt,
    @Default('#FF6B6B') String color,
    @Default(0) int useCount,
    String? description,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  /// Create a new tag with generated ID
  factory Tag.create({
    required String name,
    String? color,
    String? description,
  }) {
    return Tag(
      id: _generateTagId(),
      name: name,
      createdAt: DateTime.now(),
      color: color ?? '#FF6B6B',
      description: description,
    );
  }

  const Tag._();

  /// Increment usage count
  Tag incrementUse() {
    return copyWith(useCount: useCount + 1);
  }

  /// Update tag properties
  Tag update({
    String? name,
    String? color,
    String? description,
  }) {
    return copyWith(
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }

  /// Check if tag matches search query
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final searchLower = query.toLowerCase();
    return name.toLowerCase().contains(searchLower) ||
           (description?.toLowerCase().contains(searchLower) ?? false);
  }
}

/// Generate unique tag ID
String _generateTagId() {
  return 'tag_${DateTime.now().millisecondsSinceEpoch}';
} 