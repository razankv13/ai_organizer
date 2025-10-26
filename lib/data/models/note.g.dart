// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isPinned: json['isPinned'] as bool? ?? false,
  isArchived: json['isArchived'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  folderId: json['folderId'] as String?,
  color: json['color'] as String?,
  isLocal: json['isLocal'] as bool?,
);

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'tags': instance.tags,
  'attachments': instance.attachments,
  'isPinned': instance.isPinned,
  'isArchived': instance.isArchived,
  'isFavorite': instance.isFavorite,
  'folderId': instance.folderId,
  'color': instance.color,
  'isLocal': instance.isLocal,
};
