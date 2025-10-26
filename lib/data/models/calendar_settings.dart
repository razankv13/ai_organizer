import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_settings.freezed.dart';
part 'calendar_settings.g.dart';

@freezed
abstract class CalendarSettings with _$CalendarSettings {
  const factory CalendarSettings({
    required String id,
    required String userId,
    required bool isGoogleCalendarConnected,
    String? googleAccountEmail,
    String? googleCalendarId,
    @Default(true) bool syncTasksToCalendar,
    @Default(true) bool syncEventsToNotes,
    @Default(30) int syncIntervalMinutes,
    DateTime? lastSyncedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CalendarSettings;

  factory CalendarSettings.fromJson(Map<String, dynamic> json) =>
      _$CalendarSettingsFromJson(json);
}
