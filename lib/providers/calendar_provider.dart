import 'package:ai_organizer/data/models/calendar_event.dart';
import 'package:ai_organizer/data/models/calendar_settings.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/services/calendar_sync_service.dart';
import 'package:ai_organizer/services/google_calendar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Provider for Google Calendar Service
final googleCalendarServiceProvider = Provider<GoogleCalendarService>((ref) {
  return GoogleCalendarService();
});

/// Provider for Calendar Sync Service
final calendarSyncServiceProvider = Provider<CalendarSyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final calendarService = ref.watch(googleCalendarServiceProvider);

  return CalendarSyncService(
    database: database,
    calendarService: calendarService,
  );
});

/// Provider for calendar settings
final calendarSettingsProvider = FutureProvider<CalendarSettings?>((ref) async {
  final database = ref.watch(databaseProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return null;
  }

  // Get settings from database
  final settingsData = await database.getCalendarSettings(currentUser.id);

  if (settingsData == null) {
    return null;
  }

  // Convert to model
  return CalendarSettings(
    id: settingsData.id,
    userId: settingsData.userId,
    isGoogleCalendarConnected: settingsData.isGoogleCalendarConnected,
    googleAccountEmail: settingsData.googleAccountEmail,
    googleCalendarId: settingsData.googleCalendarId,
    syncTasksToCalendar: settingsData.syncTasksToCalendar,
    syncEventsToNotes: settingsData.syncEventsToNotes,
    syncIntervalMinutes: settingsData.syncIntervalMinutes,
    lastSyncedAt: settingsData.lastSyncedAt,
    createdAt: settingsData.createdAt,
    updatedAt: settingsData.updatedAt,
  );
});

/// Provider for calendar events
final calendarEventsProvider = FutureProvider.family<List<CalendarEvent>, DateRange>(
  (ref, dateRange) async {
    final calendarService = ref.watch(googleCalendarServiceProvider);

    if (!calendarService.isSignedIn) {
      return [];
    }

    try {
      return await calendarService.fetchEvents(
        timeMin: dateRange.start,
        timeMax: dateRange.end,
      );
    } catch (e) {
      return [];
    }
  },
);

/// Provider for calendar actions
final calendarActionsProvider = Provider<CalendarActions>((ref) {
  return CalendarActions(ref);
});

/// Calendar actions class
class CalendarActions {
  CalendarActions(this._ref);

  final Ref _ref;
  final _uuid = const Uuid();

  /// Sign in to Google Calendar
  Future<bool> signInToGoogleCalendar() async {
    final calendarService = _ref.read(googleCalendarServiceProvider);
    final result = await calendarService.signInToGoogleCalendar();

    if (result) {
      // Update settings in database
      final currentUser = _ref.read(currentUserProvider);
      if (currentUser != null) {
        final database = _ref.read(databaseProvider);
        final email = calendarService.currentUserEmail;

        // Check if settings exist
        final existingSettings = await database.getCalendarSettings(currentUser.id);

        if (existingSettings == null) {
          // Create new settings
          await database.insertCalendarSettings(_uuid.v4(), currentUser.id);
        }

        // Update connection status
        await database.updateCalendarSettings(
          existingSettings?.id ?? _uuid.v4(),
          isGoogleCalendarConnected: true,
          googleAccountEmail: email,
        );

        // Refresh settings
        _ref.invalidate(calendarSettingsProvider);
      }
    }

    return result;
  }

  /// Sign out from Google Calendar
  Future<void> signOutFromGoogleCalendar() async {
    final calendarService = _ref.read(googleCalendarServiceProvider);
    await calendarService.signOutFromGoogleCalendar();

    // Update settings in database
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser != null) {
      final database = _ref.read(databaseProvider);
      final settings = await database.getCalendarSettings(currentUser.id);

      if (settings != null) {
        await database.updateCalendarSettings(
          settings.id,
          isGoogleCalendarConnected: false,
          googleAccountEmail: null,
          googleCalendarId: null,
        );

        // Refresh settings
        _ref.invalidate(calendarSettingsProvider);
      }
    }
  }

  /// Get list of calendars
  Future<List<CalendarInfo>> getCalendars() async {
    final calendarService = _ref.read(googleCalendarServiceProvider);
    return await calendarService.getCalendars();
  }

  /// Set selected calendar
  Future<void> setSelectedCalendar(String calendarId) async {
    final calendarService = _ref.read(googleCalendarServiceProvider);
    calendarService.setSelectedCalendar(calendarId);

    // Update in database
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser != null) {
      final database = _ref.read(databaseProvider);
      final settings = await database.getCalendarSettings(currentUser.id);

      if (settings != null) {
        await database.updateCalendarSettings(
          settings.id,
          googleCalendarId: calendarId,
        );

        // Refresh settings
        _ref.invalidate(calendarSettingsProvider);
      }
    }
  }

  /// Update sync settings
  Future<void> updateSyncSettings({
    bool? syncTasksToCalendar,
    bool? syncEventsToNotes,
    int? syncIntervalMinutes,
  }) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) return;

    final database = _ref.read(databaseProvider);
    final settings = await database.getCalendarSettings(currentUser.id);

    if (settings != null) {
      await database.updateCalendarSettings(
        settings.id,
        syncTasksToCalendar: syncTasksToCalendar,
        syncEventsToNotes: syncEventsToNotes,
        syncIntervalMinutes: syncIntervalMinutes,
      );

      // Refresh settings
      _ref.invalidate(calendarSettingsProvider);
    }
  }

  /// Perform manual sync
  Future<SyncResult> performSync({
    bool? syncTasksToCalendar,
    bool? syncEventsToNotes,
  }) async {
    final syncService = _ref.read(calendarSyncServiceProvider);
    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null) {
      return SyncResult(
        tasksSynced: 0,
        eventsSynced: 0,
        syncedAt: DateTime.now(),
      );
    }

    // Get sync settings
    final database = _ref.read(databaseProvider);
    final settings = await database.getCalendarSettings(currentUser.id);

    final shouldSyncTasks = syncTasksToCalendar ?? settings?.syncTasksToCalendar ?? true;
    final shouldSyncEvents = syncEventsToNotes ?? settings?.syncEventsToNotes ?? true;

    // Perform sync
    final result = await syncService.performFullSync(
      syncTasksToCalendar: shouldSyncTasks,
      syncEventsToNotes: shouldSyncEvents,
    );

    // Update last synced time
    if (settings != null) {
      await database.updateCalendarSettings(
        settings.id,
        lastSyncedAt: result.syncedAt,
      );

      // Refresh settings
      _ref.invalidate(calendarSettingsProvider);
    }

    // Refresh calendar events
    _ref.invalidate(calendarEventsProvider);

    return result;
  }

  /// Create calendar event
  Future<CalendarEvent?> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    bool isAllDay = false,
  }) async {
    final calendarService = _ref.read(googleCalendarServiceProvider);

    final event = await calendarService.createEvent(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      isAllDay: isAllDay,
    );

    if (event != null) {
      // Refresh calendar events
      _ref.invalidate(calendarEventsProvider);
    }

    return event;
  }

  /// Update calendar event
  Future<CalendarEvent?> updateEvent({
    required String googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
  }) async {
    final calendarService = _ref.read(googleCalendarServiceProvider);

    final event = await calendarService.updateEvent(
      googleEventId: googleEventId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
    );

    if (event != null) {
      // Refresh calendar events
      _ref.invalidate(calendarEventsProvider);
    }

    return event;
  }

  /// Delete calendar event
  Future<bool> deleteEvent(String googleEventId) async {
    final calendarService = _ref.read(googleCalendarServiceProvider);
    final result = await calendarService.deleteEvent(googleEventId);

    if (result) {
      // Refresh calendar events
      _ref.invalidate(calendarEventsProvider);
    }

    return result;
  }
}

/// Date range for filtering events
class DateRange {
  const DateRange({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}
