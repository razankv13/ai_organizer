/// Centralized route paths and names for app navigation
///
/// This file contains all route paths and names as static constants
/// to ensure type-safe navigation throughout the app and prevent typos.
///
/// Usage:
/// ```dart
/// // Navigate using path
/// context.go(AppRoutes.home);
///
/// // Navigate using name
/// context.goNamed(AppRouteNames.home);
///
/// // Parametrized routes
/// context.go(AppRoutes.noteDetail(noteId));
/// ```
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ============================================================================
  // MAIN TAB ROUTES
  // ============================================================================

  /// Home screen route: `/`
  static const String home = '/';

  /// Notes list screen route: `/notes`
  static const String notes = '/notes';

  /// Search screen route: `/search`
  static const String search = '/search';

  /// Organize screen route: `/organize`
  static const String organize = '/organize';

  /// Settings screen route: `/settings`
  static const String settings = '/settings';

  // ============================================================================
  // AUTH ROUTES
  // ============================================================================

  /// Login screen route: `/login`
  static const String login = '/login';

  /// Signup screen route: `/signup`
  static const String signup = '/signup';

  // ============================================================================
  // PROFILE ROUTES
  // ============================================================================

  /// Profile screen route: `/profile`
  static const String profile = '/profile';

  // ============================================================================
  // NOTE ROUTES
  // ============================================================================

  /// Note create route: `/notes/create`
  static const String noteCreate = '/notes/create';

  /// Voice note recording route: `/notes/voice`
  static const String voiceNote = '/notes/voice';

  /// Voice notes list route: `/notes/voice-list`
  static const String voiceNotesList = '/notes/voice-list';

  /// Build note detail path with noteId
  /// Returns: `/notes/{noteId}`
  static String noteDetail(String noteId) => '/notes/$noteId';

  /// Build note edit path with noteId
  /// Returns: `/notes/{noteId}/edit`
  static String noteEdit(String noteId) => '/notes/$noteId/edit';

  /// Build note share path with noteId and optional title
  /// Returns: `/notes/{noteId}/share?title={encodedTitle}`
  static String noteShare(String noteId, [String? title]) {
    final path = '/notes/$noteId/share';
    if (title != null && title.isNotEmpty) {
      return '$path?title=${Uri.encodeComponent(title)}';
    }
    return path;
  }

  /// Build notes list path with optional folderId query parameter
  /// Returns: `/notes?folderId={folderId}`
  static String notesWithFolder(String? folderId) {
    if (folderId != null && folderId.isNotEmpty) {
      return '$notes?folderId=$folderId';
    }
    return notes;
  }

  // ============================================================================
  // SETTINGS & PROFILE ROUTES
  // ============================================================================

  /// Edit profile route: `/settings/edit-profile`
  static const String editProfile = '/settings/edit-profile';

  /// Appearance settings route: `/settings/appearance`
  static const String appearanceSettings = '/settings/appearance';

  /// Notification settings route: `/settings/notifications`
  static const String notificationSettings = '/settings/notifications';

  /// Language settings route: `/settings/language`
  static const String languageSettings = '/settings/language';

  /// Storage & sync settings route: `/settings/storage-sync`
  static const String storageSyncSettings = '/settings/storage-sync';

  /// Change password route: `/settings/change-password`
  static const String changePassword = '/settings/change-password';

  /// Export/Import route: `/settings/export-import`
  static const String exportImport = '/settings/export-import';

  // ============================================================================
  // INTEGRATION ROUTES
  // ============================================================================

  /// Email integration settings route: `/settings/email-integration`
  static const String emailIntegration = '/settings/email-integration';

  /// Gmail import route: `/settings/email-integration/gmail-import`
  static const String gmailImport = '/settings/email-integration/gmail-import';

  /// Calendar integration settings route: `/settings/calendar-integration`
  static const String calendarIntegration = '/settings/calendar-integration';

  /// Cloud storage integration settings route: `/settings/cloud-storage`
  static const String cloudStorage = '/settings/cloud-storage';

  // ============================================================================
  // OTHER ROUTES
  // ============================================================================

  /// Onboarding screen route: `/onboarding`
  static const String onboarding = '/onboarding';
}

/// Centralized route names for GoRouter named navigation
///
/// Route names are used with `context.goNamed()` for type-safe navigation.
/// They correspond to the `name` parameter in GoRoute definitions.
///
/// Usage:
/// ```dart
/// context.goNamed(
///   AppRouteNames.noteDetail,
///   pathParameters: {'id': noteId},
/// );
/// ```
class AppRouteNames {
  // Private constructor to prevent instantiation
  AppRouteNames._();

  // ============================================================================
  // MAIN TAB ROUTE NAMES
  // ============================================================================

  /// Home screen route name
  static const String home = 'home';

  /// Notes list screen route name
  static const String notes = 'notes';

  /// Search screen route name
  static const String search = 'search';

  /// Organize screen route name
  static const String organize = 'organize';

  /// Settings screen route name
  static const String settings = 'settings';

  // ============================================================================
  // AUTH ROUTE NAMES
  // ============================================================================

  /// Login screen route name
  static const String login = 'login';

  /// Signup screen route name
  static const String signup = 'signup';

  // ============================================================================
  // PROFILE ROUTE NAMES
  // ============================================================================

  /// Profile screen route name
  static const String profile = 'profile';

  // ============================================================================
  // NOTE ROUTE NAMES
  // ============================================================================

  /// Note detail screen route name
  static const String noteDetail = 'note-detail';

  /// Note create screen route name
  static const String noteCreate = 'note-create';

  /// Note edit screen route name
  static const String noteEdit = 'note-edit';

  /// Note share screen route name
  static const String noteShare = 'note-share';

  /// Voice note recording screen route name
  static const String voiceNote = 'voice-note';

  /// Voice notes list screen route name
  static const String voiceNotesList = 'voice-notes-list';

  // ============================================================================
  // SETTINGS & PROFILE ROUTE NAMES
  // ============================================================================

  /// Edit profile screen route name
  static const String editProfile = 'edit-profile';

  /// Appearance settings screen route name
  static const String appearanceSettings = 'appearance-settings';

  /// Notification settings screen route name
  static const String notificationSettings = 'notification-settings';

  /// Language settings screen route name
  static const String languageSettings = 'language-settings';

  /// Storage & sync settings screen route name
  static const String storageSyncSettings = 'storage-sync-settings';

  /// Change password screen route name
  static const String changePassword = 'change-password';

  /// Export/Import screen route name
  static const String exportImport = 'export-import';

  // ============================================================================
  // INTEGRATION ROUTE NAMES
  // ============================================================================

  /// Email integration settings screen route name
  static const String emailIntegration = 'email-integration';

  /// Gmail import screen route name
  static const String gmailImport = 'gmail-import';

  /// Calendar integration settings screen route name
  static const String calendarIntegration = 'calendar-integration';

  /// Cloud storage integration settings screen route name
  static const String cloudStorage = 'cloud-storage';

  // ============================================================================
  // OTHER ROUTE NAMES
  // ============================================================================

  /// Onboarding screen route name
  static const String onboarding = 'onboarding';
}
