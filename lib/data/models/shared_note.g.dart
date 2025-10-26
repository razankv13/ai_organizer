// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedNote _$SharedNoteFromJson(Map<String, dynamic> json) => _SharedNote(
  id: json['id'] as String,
  noteId: json['noteId'] as String,
  ownerId: json['ownerId'] as String,
  sharedWithEmail: json['sharedWithEmail'] as String,
  sharedWithUserId: json['sharedWithUserId'] as String?,
  permission: $enumDecode(_$SharePermissionEnumMap, json['permission']),
  shareToken: json['shareToken'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$SharedNoteToJson(_SharedNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'ownerId': instance.ownerId,
      'sharedWithEmail': instance.sharedWithEmail,
      'sharedWithUserId': instance.sharedWithUserId,
      'permission': _$SharePermissionEnumMap[instance.permission]!,
      'shareToken': instance.shareToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$SharePermissionEnumMap = {
  SharePermission.view: 'view',
  SharePermission.edit: 'edit',
};
