// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    _CalendarEvent(
      id: json['id'] as String,
      googleEventId: json['googleEventId'] as String?,
      taskId: json['taskId'] as String?,
      noteId: json['noteId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      isAllDay: json['isAllDay'] as bool?,
      location: json['location'] as String?,
      source: json['source'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
    );

Map<String, dynamic> _$CalendarEventToJson(_CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'googleEventId': instance.googleEventId,
      'taskId': instance.taskId,
      'noteId': instance.noteId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isAllDay': instance.isAllDay,
      'location': instance.location,
      'source': instance.source,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
    };
