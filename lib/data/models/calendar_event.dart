import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

/// Represents a calendar event from Google Calendar
@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    String? googleEventId,
    String? taskId,
    String? noteId,
    required String title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? location,
    required String source, // 'google_calendar', 'app_task', 'app_note'
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
