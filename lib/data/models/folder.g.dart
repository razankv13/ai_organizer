// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Folder _$FolderFromJson(Map<String, dynamic> json) => _Folder(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  parentId: json['parentId'] as String?,
  color: json['color'] as String?,
  icon: json['icon'] as String?,
  noteCount: (json['noteCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$FolderToJson(_Folder instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'parentId': instance.parentId,
  'color': instance.color,
  'icon': instance.icon,
  'noteCount': instance.noteCount,
};
