import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/presentation/screens/home/home_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/notes_list_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/note_detail_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/note_edit_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/voice_note_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/voice_notes_list_screen.dart';
import 'package:ai_organizer/presentation/screens/sharing/share_note_screen.dart';
import 'package:ai_organizer/presentation/screens/search/search_screen.dart';
import 'package:ai_organizer/presentation/screens/organize/organize_screen.dart';
import 'package:ai_organizer/presentation/screens/settings/settings_screen.dart';
import 'package:ai_organizer/presentation/screens/settings/export_import_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/edit_profile_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/appearance_settings_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/notification_settings_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/language_settings_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/storage_sync_settings_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/change_password_screen.dart';
import 'package:ai_organizer/presentation/screens/integrations/email_integration_screen.dart';
import 'package:ai_organizer/presentation/screens/integrations/gmail_import_screen.dart';
import 'package:ai_organizer/presentation/screens/integrations/calendar_integration_screen.dart';
import 'package:ai_organizer/presentation/screens/integrations/cloud_storage_screen.dart';
import 'package:ai_organizer/presentation/screens/calendar/calendar_view_screen.dart';
import 'package:ai_organizer/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:ai_organizer/presentation/widgets/navigation/main_navigation.dart';

/// App router configuration using GoRouter with StatefulShell for proper tab navigation
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  // Navigator keys for each tab
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _notesNavigatorKey = GlobalKey<NavigatorState>();
  static final _searchNavigatorKey = GlobalKey<NavigatorState>();
  static final _organizeNavigatorKey = GlobalKey<NavigatorState>();
  static final _settingsNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Onboarding route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main StatefulShell route with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          return MainNavigation(navigationShell: shell);
        },
        branches: [
          // Home tab branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          
          // Notes tab branch and sub-routes
          StatefulShellBranch(
            navigatorKey: _notesNavigatorKey,
            routes: [
              GoRoute(
                path: '/notes',
                name: 'notes',
                builder: (context, state) {
                  final folderId = state.uri.queryParameters['folderId'];
                  return NotesListScreen(folderId: folderId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'note-create',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NoteEditScreen(),
                  ),
                  GoRoute(
                    path: 'voice',
                    name: 'voice-note',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VoiceNoteScreen(),
                  ),
                  GoRoute(
                    path: 'voice-list',
                    name: 'voice-notes-list',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VoiceNotesListScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'note-detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return NoteDetailScreen(noteId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: 'note-edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return NoteEditScreen(noteId: id);
                        },
                      ),
                      GoRoute(
                        path: 'share',
                        name: 'note-share',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          final title = state.uri.queryParameters['title'] ?? '';
                          return ShareNoteScreen(noteId: id, noteTitle: title);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          // Search tab branch
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          
          // Organize tab branch
          StatefulShellBranch(
            navigatorKey: _organizeNavigatorKey,
            routes: [
              GoRoute(
                path: '/organize',
                name: 'organize',
                builder: (context, state) => const OrganizeScreen(),
              ),
            ],
          ),
          
          // Settings tab branch
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  // Profile management routes
                  GoRoute(
                    path: 'edit-profile',
                    name: 'edit-profile',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'appearance',
                    name: 'appearance-settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AppearanceSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: 'notification-settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    name: 'language-settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const LanguageSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'storage-sync',
                    name: 'storage-sync-settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const StorageSyncSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: 'change-password',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  // Other settings routes
                  GoRoute(
                    path: 'export-import',
                    name: 'export-import',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ExportImportScreen(),
                  ),
                  GoRoute(
                    path: 'email-integration',
                    name: 'email-integration',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const EmailIntegrationScreen(),
                    routes: [
                      GoRoute(
                        path: 'gmail-import',
                        name: 'gmail-import',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => const GmailImportScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'calendar-integration',
                    name: 'calendar-integration',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CalendarIntegrationScreen(),
                  ),
                  GoRoute(
                    path: 'cloud-storage',
                    name: 'cloud-storage',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CloudStorageIntegrationScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Navigation helper extensions
extension AppRouterExtension on BuildContext {
  /// Navigate to home screen
  void goHome() => go('/');
  
  /// Navigate to notes list
  void goNotes() => go('/notes');
  
  /// Navigate to specific note
  void goNote(String noteId) => go('/notes/$noteId');
  
  /// Navigate to note edit
  void goNoteEdit(String? noteId) {
    if (noteId != null) {
      go('/notes/$noteId/edit');
    } else {
      go('/notes/create');
    }
  }

  /// Navigate to note sharing screen
  void goNoteShare(String noteId, String noteTitle) {
    go('/notes/$noteId/share?title=${Uri.encodeComponent(noteTitle)}');
  }

  /// Navigate to voice note recording
  void goVoiceNote() => go('/notes/voice');

  /// Navigate to voice notes list
  void goVoiceNotesList() => go('/notes/voice-list');

  /// Navigate to search
  void goSearch() => go('/search');
  
  /// Navigate to organize
  void goOrganize() => go('/organize');
  
  /// Navigate to settings
  void goSettings() => go('/settings');
  
  /// Navigate to onboarding
  void goOnboarding() => go('/onboarding');

  /// Navigate to email integration settings
  void goEmailIntegration() => go('/settings/email-integration');

  /// Navigate to Gmail import
  void goGmailImport() => go('/settings/email-integration/gmail-import');

  /// Navigate to calendar integration settings
  void goCalendarIntegration() => go('/settings/calendar-integration');

  /// Navigate to cloud storage integration settings
  void goCloudStorage() => go('/settings/cloud-storage');

  /// Navigate to edit profile screen
  void goEditProfile() => go('/settings/edit-profile');

  /// Navigate to appearance settings
  void goAppearanceSettings() => go('/settings/appearance');

  /// Navigate to notification settings
  void goNotificationSettings() => go('/settings/notifications');

  /// Navigate to language settings
  void goLanguageSettings() => go('/settings/language');

  /// Navigate to storage & sync settings
  void goStorageSyncSettings() => go('/settings/storage-sync');

  /// Navigate to change password screen
  void goChangePassword() => go('/settings/change-password');

  /// Navigate back or to home if no history
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      goHome();
    }
  }
} 