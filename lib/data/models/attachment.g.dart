// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  id: json['id'] as String,
  noteId: json['noteId'] as String?,
  fileName: json['fileName'] as String,
  filePath: json['filePath'] as String,
  type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
  fileSize: (json['fileSize'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  mimeType: json['mimeType'] as String?,
  thumbnailPath: json['thumbnailPath'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
      'fileSize': instance.fileSize,
      'createdAt': instance.createdAt.toIso8601String(),
      'mimeType': instance.mimeType,
      'thumbnailPath': instance.thumbnailPath,
      'metadata': instance.metadata,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.document: 'document',
  AttachmentType.audio: 'audio',
  AttachmentType.video: 'video',
  AttachmentType.other: 'other',
};
