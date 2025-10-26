// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  noteId: json['noteId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  isCompleted: json['isCompleted'] as bool,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  reminderDate: json['reminderDate'] == null
      ? null
      : DateTime.parse(json['reminderDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  hasNotified: json['hasNotified'] as bool? ?? false,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'noteId': instance.noteId,
  'title': instance.title,
  'description': instance.description,
  'isCompleted': instance.isCompleted,
  'dueDate': instance.dueDate?.toIso8601String(),
  'reminderDate': instance.reminderDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'hasNotified': instance.hasNotified,
};
