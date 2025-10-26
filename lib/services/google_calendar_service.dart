import 'dart:developer' as developer;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:ai_organizer/data/models/calendar_event.dart';

/// HTTP client with Google Sign-In authentication
class GoogleAuthClient extends http.BaseClient {
  GoogleAuthClient(this._headers, this._client);

  final Map<String, String> _headers;
  final http.Client _client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

/// Service for Google Calendar OAuth integration and event synchronization
class GoogleCalendarService {
  GoogleCalendarService();

  // Google Sign-In configuration with Calendar scope
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope, calendar.CalendarApi.calendarEventsScope],
  );

  GoogleSignInAccount? _currentUser;
  calendar.CalendarApi? _calendarApi;
  String? _selectedCalendarId;

  /// Check if user is signed in to Google Calendar
  bool get isSignedIn => _currentUser != null;

  /// Get current Google user email
  String? get currentUserEmail => _currentUser?.email;

  /// Get selected calendar ID
  String? get selectedCalendarId => _selectedCalendarId;

  /// Authenticate with Google Calendar using Google Sign-In
  Future<bool> signInToGoogleCalendar() async {
    try {
      // Attempt silent sign-in first
      final account = await _googleSignIn.signInSilently();

      // If silent sign-in fails, show sign-in UI
      _currentUser = account ?? await _googleSignIn.signIn();

      if (_currentUser == null) {
        developer.log('User cancelled Google Calendar sign-in', name: 'GoogleCalendarService');
        return false;
      }

      // Get authentication headers
      final auth = await _currentUser!.authentication;
      if (auth.accessToken == null) {
        developer.log('Failed to get access token', name: 'GoogleCalendarService');
        return false;
      }

      // Create authenticated HTTP client
      final authClient = GoogleAuthClient({
        'Authorization': 'Bearer ${auth.accessToken}',
      }, http.Client());

      // Initialize Calendar API
      _calendarApi = calendar.CalendarApi(authClient);

      developer.log(
        'Successfully signed in to Google Calendar: ${_currentUser!.email}',
        name: 'GoogleCalendarService',
      );

      return true;
    } catch (e) {
      developer.log('Error signing in to Google Calendar: $e', name: 'GoogleCalendarService');
      return false;
    }
  }

  /// Sign out from Google Calendar
  Future<void> signOutFromGoogleCalendar() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _calendarApi = null;
      _selectedCalendarId = null;
      developer.log('Signed out from Google Calendar', name: 'GoogleCalendarService');
    } catch (e) {
      developer.log('Error signing out from Google Calendar: $e', name: 'GoogleCalendarService');
    }
  }

  /// Get list of user's calendars
  Future<List<CalendarInfo>> getCalendars() async {
    if (_calendarApi == null) {
      throw Exception('Not signed in to Google Calendar. Call signInToGoogleCalendar() first.');
    }

    try {
      final calendarList = await _calendarApi!.calendarList.list();

      if (calendarList.items == null) {
        return [];
      }

      return calendarList.items!.map((cal) {
        return CalendarInfo(
          id: cal.id ?? '',
          name: cal.summary ?? 'Unnamed Calendar',
          description: cal.description,
          isPrimary: cal.primary ?? false,
          color: cal.backgroundColor,
        );
      }).toList();
    } catch (e) {
      developer.log('Error fetching calendars: $e', name: 'GoogleCalendarService');
      rethrow;
    }
  }

  /// Set the selected calendar for syncing
  void setSelectedCalendar(String calendarId) {
    _selectedCalendarId = calendarId;
  }

  /// Fetch events from Google Calendar
  Future<List<CalendarEvent>> fetchEvents({
    DateTime? timeMin,
    DateTime? timeMax,
    int maxResults = 100,
  }) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in to Google Calendar');
    }

    if (_selectedCalendarId == null) {
      throw Exception('No calendar selected. Call setSelectedCalendar() first.');
    }

    try {
      final events = await _calendarApi!.events.list(
        _selectedCalendarId!,
        timeMin: timeMin,
        timeMax: timeMax,
        maxResults: maxResults,
        singleEvents: true,
        orderBy: 'startTime',
      );

      if (events.items == null) {
        return [];
      }

      return events.items!.map((event) {
        return _convertGoogleEventToCalendarEvent(event);
      }).toList();
    } catch (e) {
      developer.log('Error fetching events: $e', name: 'GoogleCalendarService');
      rethrow;
    }
  }

  /// Create a new event in Google Calendar
  Future<CalendarEvent?> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    bool isAllDay = false,
  }) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in to Google Calendar');
    }

    if (_selectedCalendarId == null) {
      throw Exception('No calendar selected');
    }

    try {
      final event = calendar.Event();
      event.summary = title;
      event.description = description;
      event.location = location;

      if (isAllDay) {
        // For all-day events, use DateTime at midnight (no time component)
        final startDate = DateTime(startTime.year, startTime.month, startTime.day);
        final endDate = DateTime(endTime.year, endTime.month, endTime.day);

        event.start = calendar.EventDateTime(date: startDate);
        event.end = calendar.EventDateTime(date: endDate);
      } else {
        event.start = calendar.EventDateTime(dateTime: startTime);
        event.end = calendar.EventDateTime(dateTime: endTime);
      }

      final createdEvent = await _calendarApi!.events.insert(event, _selectedCalendarId!);

      return _convertGoogleEventToCalendarEvent(createdEvent);
    } catch (e) {
      developer.log('Error creating event: $e', name: 'GoogleCalendarService');
      return null;
    }
  }

  /// Update an existing event in Google Calendar
  Future<CalendarEvent?> updateEvent({
    required String googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
  }) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in to Google Calendar');
    }

    if (_selectedCalendarId == null) {
      throw Exception('No calendar selected');
    }

    try {
      // First, get the existing event
      final existingEvent = await _calendarApi!.events.get(_selectedCalendarId!, googleEventId);

      // Update fields if provided
      if (title != null) existingEvent.summary = title;
      if (description != null) existingEvent.description = description;
      if (location != null) existingEvent.location = location;

      if (startTime != null) {
        existingEvent.start = calendar.EventDateTime(dateTime: startTime);
      }
      if (endTime != null) {
        existingEvent.end = calendar.EventDateTime(dateTime: endTime);
      }

      final updatedEvent = await _calendarApi!.events.update(
        existingEvent,
        _selectedCalendarId!,
        googleEventId,
      );

      return _convertGoogleEventToCalendarEvent(updatedEvent);
    } catch (e) {
      developer.log('Error updating event: $e', name: 'GoogleCalendarService');
      return null;
    }
  }

  /// Delete an event from Google Calendar
  Future<bool> deleteEvent(String googleEventId) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in to Google Calendar');
    }

    if (_selectedCalendarId == null) {
      throw Exception('No calendar selected');
    }

    try {
      await _calendarApi!.events.delete(_selectedCalendarId!, googleEventId);
      return true;
    } catch (e) {
      developer.log('Error deleting event: $e', name: 'GoogleCalendarService');
      return false;
    }
  }

  /// Convert Google Calendar Event to our CalendarEvent model
  CalendarEvent _convertGoogleEventToCalendarEvent(calendar.Event event) {
    final now = DateTime.now();

    DateTime? startTime;
    DateTime? endTime;
    bool isAllDay = false;

    if (event.start?.dateTime != null) {
      startTime = event.start!.dateTime;
    } else if (event.start?.date != null) {
      final date = event.start!.date!;
      startTime = DateTime(date.year, date.month, date.day);
      isAllDay = true;
    }

    if (event.end?.dateTime != null) {
      endTime = event.end!.dateTime;
    } else if (event.end?.date != null) {
      final date = event.end!.date!;
      endTime = DateTime(date.year, date.month, date.day);
    }

    return CalendarEvent(
      id: event.id ?? '',
      googleEventId: event.id,
      title: event.summary ?? 'Untitled Event',
      description: event.description,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
      location: event.location,
      source: 'google_calendar',
      createdAt: event.created ?? now,
      updatedAt: event.updated ?? now,
      lastSyncedAt: now,
    );
  }
}

/// Information about a Google Calendar
class CalendarInfo {
  const CalendarInfo({
    required this.id,
    required this.name,
    this.description,
    required this.isPrimary,
    this.color,
  });

  final String id;
  final String name;
  final String? description;
  final bool isPrimary;
  final String? color;
}
