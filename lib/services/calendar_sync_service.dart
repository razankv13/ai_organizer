import 'dart:developer' as developer;
import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/task.dart';
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/models/calendar_event.dart';
import 'package:ai_organizer/services/google_calendar_service.dart';
import 'package:uuid/uuid.dart';

/// Service for synchronizing tasks and notes with Google Calendar
class CalendarSyncService {
  CalendarSyncService({
    required this.database,
    required this.calendarService,
  });

  final AppDatabase database;
  final GoogleCalendarService calendarService;
  final _uuid = const Uuid();

  /// Sync all tasks to Google Calendar events
  /// Returns the number of tasks synced
  Future<int> syncTasksToCalendar() async {
    try {
      if (!calendarService.isSignedIn) {
        developer.log('Not signed in to Google Calendar', name: 'CalendarSyncService');
        return 0;
      }

      // Get all incomplete tasks with due dates
      final tasks = await database.getAllTasks();
      final tasksWithDueDates = tasks.where((task) =>
        task.dueDate != null && !task.isCompleted
      ).toList();

      int syncedCount = 0;

      for (final task in tasksWithDueDates) {
        try {
          // Create event in Google Calendar
          final endTime = task.dueDate!.add(const Duration(hours: 1));

          final event = await calendarService.createEvent(
            title: task.title,
            description: task.description ?? '',
            startTime: task.dueDate!,
            endTime: endTime,
          );

          if (event != null) {
            syncedCount++;
            developer.log('Synced task "${task.title}" to Google Calendar', name: 'CalendarSyncService');
          }
        } catch (e) {
          developer.log('Error syncing task "${task.title}": $e', name: 'CalendarSyncService');
        }
      }

      return syncedCount;
    } catch (e) {
      developer.log('Error syncing tasks to calendar: $e', name: 'CalendarSyncService');
      return 0;
    }
  }

  /// Sync Google Calendar events to notes
  /// Returns the number of events synced
  Future<int> syncEventsToNotes({
    DateTime? timeMin,
    DateTime? timeMax,
  }) async {
    try {
      if (!calendarService.isSignedIn) {
        developer.log('Not signed in to Google Calendar', name: 'CalendarSyncService');
        return 0;
      }

      // Fetch events from Google Calendar
      final events = await calendarService.fetchEvents(
        timeMin: timeMin ?? DateTime.now().subtract(const Duration(days: 30)),
        timeMax: timeMax ?? DateTime.now().add(const Duration(days: 90)),
      );

      int syncedCount = 0;

      for (final event in events) {
        try {
          // Create a note for each calendar event
          final note = model.Note(
            id: _uuid.v4(),
            title: '📅 ${event.title}',
            content: _buildNoteContentFromEvent(event),
            createdAt: event.createdAt,
            updatedAt: event.updatedAt,
            isPinned: false,
            isArchived: false,
            isFavorite: false,
          );

          await database.insertNote(note);
          syncedCount++;

          developer.log('Synced event "${event.title}" to note', name: 'CalendarSyncService');
        } catch (e) {
          developer.log('Error syncing event "${event.title}": $e', name: 'CalendarSyncService');
        }
      }

      return syncedCount;
    } catch (e) {
      developer.log('Error syncing events to notes: $e', name: 'CalendarSyncService');
      return 0;
    }
  }

  /// Perform full bidirectional sync
  Future<SyncResult> performFullSync({
    bool syncTasksToCalendar = true,
    bool syncEventsToNotes = true,
  }) async {
    int tasksSynced = 0;
    int eventsSynced = 0;

    if (syncTasksToCalendar) {
      tasksSynced = await this.syncTasksToCalendar();
    }

    if (syncEventsToNotes) {
      eventsSynced = await this.syncEventsToNotes();
    }

    return SyncResult(
      tasksSynced: tasksSynced,
      eventsSynced: eventsSynced,
      syncedAt: DateTime.now(),
    );
  }

  /// Build note content from calendar event
  String _buildNoteContentFromEvent(CalendarEvent event) {
    final buffer = StringBuffer();

    if (event.description != null && event.description!.isNotEmpty) {
      buffer.writeln(event.description);
      buffer.writeln();
    }

    buffer.writeln('**Event Details:**');

    if (event.startTime != null) {
      buffer.writeln('- **Start:** ${_formatDateTime(event.startTime!)}');
    }

    if (event.endTime != null) {
      buffer.writeln('- **End:** ${_formatDateTime(event.endTime!)}');
    }

    if (event.location != null && event.location!.isNotEmpty) {
      buffer.writeln('- **Location:** ${event.location}');
    }

    if (event.isAllDay == true) {
      buffer.writeln('- **All-day event**');
    }

    buffer.writeln();
    buffer.writeln('*Synced from Google Calendar*');

    return buffer.toString();
  }

  /// Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Result of a synchronization operation
class SyncResult {
  const SyncResult({
    required this.tasksSynced,
    required this.eventsSynced,
    required this.syncedAt,
  });

  final int tasksSynced;
  final int eventsSynced;
  final DateTime syncedAt;

  bool get hasChanges => tasksSynced > 0 || eventsSynced > 0;

  int get totalSynced => tasksSynced + eventsSynced;
}
