// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmailSettings _$EmailSettingsFromJson(Map<String, dynamic> json) =>
    _EmailSettings(
      id: json['id'] as String,
      userId: json['userId'] as String,
      uniqueEmail: json['uniqueEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isEnabled: json['isEnabled'] as bool? ?? true,
      gmailConnected: json['gmailConnected'] as bool? ?? false,
      gmailEmail: json['gmailEmail'] as String?,
      gmailRefreshToken: json['gmailRefreshToken'] as String?,
      lastGmailSync: json['lastGmailSync'] == null
          ? null
          : DateTime.parse(json['lastGmailSync'] as String),
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$EmailSettingsToJson(_EmailSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'uniqueEmail': instance.uniqueEmail,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isEnabled': instance.isEnabled,
      'gmailConnected': instance.gmailConnected,
      'gmailEmail': instance.gmailEmail,
      'gmailRefreshToken': instance.gmailRefreshToken,
      'lastGmailSync': instance.lastGmailSync?.toIso8601String(),
      'preferences': instance.preferences,
    };
