// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarSettings _$CalendarSettingsFromJson(Map<String, dynamic> json) =>
    _CalendarSettings(
      id: json['id'] as String,
      userId: json['userId'] as String,
      isGoogleCalendarConnected: json['isGoogleCalendarConnected'] as bool,
      googleAccountEmail: json['googleAccountEmail'] as String?,
      googleCalendarId: json['googleCalendarId'] as String?,
      syncTasksToCalendar: json['syncTasksToCalendar'] as bool? ?? true,
      syncEventsToNotes: json['syncEventsToNotes'] as bool? ?? true,
      syncIntervalMinutes: (json['syncIntervalMinutes'] as num?)?.toInt() ?? 30,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CalendarSettingsToJson(_CalendarSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'isGoogleCalendarConnected': instance.isGoogleCalendarConnected,
      'googleAccountEmail': instance.googleAccountEmail,
      'googleCalendarId': instance.googleCalendarId,
      'syncTasksToCalendar': instance.syncTasksToCalendar,
      'syncEventsToNotes': instance.syncEventsToNotes,
      'syncIntervalMinutes': instance.syncIntervalMinutes,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
