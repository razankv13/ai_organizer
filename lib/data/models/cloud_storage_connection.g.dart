// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_storage_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CloudStorageConnection _$CloudStorageConnectionFromJson(
  Map<String, dynamic> json,
) => _CloudStorageConnection(
  id: json['id'] as String,
  userId: json['userId'] as String,
  provider: $enumDecode(_$CloudStorageProviderEnumMap, json['provider']),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String?,
  tokenExpiry: json['tokenExpiry'] == null
      ? null
      : DateTime.parse(json['tokenExpiry'] as String),
  userEmail: json['userEmail'] as String?,
  userName: json['userName'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CloudStorageConnectionToJson(
  _CloudStorageConnection instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'provider': _$CloudStorageProviderEnumMap[instance.provider]!,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenExpiry': instance.tokenExpiry?.toIso8601String(),
  'userEmail': instance.userEmail,
  'userName': instance.userName,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$CloudStorageProviderEnumMap = {
  CloudStorageProvider.dropbox: 'dropbox',
  CloudStorageProvider.googleDrive: 'google_drive',
};
