import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
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
import 'package:ai_organizer/presentation/screens/profile/profile_screen.dart';
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
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Profile route
      GoRoute(
        path: AppRoutes.profile,
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
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
                path: AppRoutes.home,
                name: AppRouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          
          // Notes tab branch and sub-routes
          StatefulShellBranch(
            navigatorKey: _notesNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.notes,
                name: AppRouteNames.notes,
                builder: (context, state) {
                  final folderId = state.uri.queryParameters['folderId'];
                  return NotesListScreen(folderId: folderId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    name: AppRouteNames.noteCreate,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NoteEditScreen(),
                  ),
                  GoRoute(
                    path: 'voice',
                    name: AppRouteNames.voiceNote,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VoiceNoteScreen(),
                  ),
                  GoRoute(
                    path: 'voice-list',
                    name: AppRouteNames.voiceNotesList,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VoiceNotesListScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: AppRouteNames.noteDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return NoteDetailScreen(noteId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: AppRouteNames.noteEdit,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return NoteEditScreen(noteId: id);
                        },
                      ),
                      GoRoute(
                        path: 'share',
                        name: AppRouteNames.noteShare,
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
                path: AppRoutes.search,
                name: AppRouteNames.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),

          // Organize tab branch
          StatefulShellBranch(
            navigatorKey: _organizeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.organize,
                name: AppRouteNames.organize,
                builder: (context, state) => const OrganizeScreen(),
              ),
            ],
          ),
          
          // Settings tab branch
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  // Profile management routes
                  GoRoute(
                    path: 'edit-profile',
                    name: AppRouteNames.editProfile,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'appearance',
                    name: AppRouteNames.appearanceSettings,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AppearanceSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: AppRouteNames.notificationSettings,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    name: AppRouteNames.languageSettings,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const LanguageSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'storage-sync',
                    name: AppRouteNames.storageSyncSettings,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const StorageSyncSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: AppRouteNames.changePassword,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  // Other settings routes
                  GoRoute(
                    path: 'export-import',
                    name: AppRouteNames.exportImport,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ExportImportScreen(),
                  ),
                  GoRoute(
                    path: 'email-integration',
                    name: AppRouteNames.emailIntegration,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const EmailIntegrationScreen(),
                    routes: [
                      GoRoute(
                        path: 'gmail-import',
                        name: AppRouteNames.gmailImport,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => const GmailImportScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'calendar-integration',
                    name: AppRouteNames.calendarIntegration,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CalendarIntegrationScreen(),
                  ),
                  GoRoute(
                    path: 'cloud-storage',
                    name: AppRouteNames.cloudStorage,
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
              onPressed: () => context.go(AppRoutes.home),
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
  void goHome() => go(AppRoutes.home);

  /// Navigate to notes list
  void goNotes() => go(AppRoutes.notes);

  /// Navigate to specific note
  void goNote(String noteId) => go(AppRoutes.noteDetail(noteId));

  /// Navigate to note edit
  void goNoteEdit(String? noteId) {
    if (noteId != null) {
      go(AppRoutes.noteEdit(noteId));
    } else {
      go(AppRoutes.noteCreate);
    }
  }

  /// Navigate to note sharing screen
  void goNoteShare(String noteId, String noteTitle) {
    go(AppRoutes.noteShare(noteId, noteTitle));
  }

  /// Navigate to voice note recording
  void goVoiceNote() => go(AppRoutes.voiceNote);

  /// Navigate to voice notes list
  void goVoiceNotesList() => go(AppRoutes.voiceNotesList);

  /// Navigate to search
  void goSearch() => go(AppRoutes.search);

  /// Navigate to organize
  void goOrganize() => go(AppRoutes.organize);

  /// Navigate to settings
  void goSettings() => go(AppRoutes.settings);

  /// Navigate to profile
  void goProfile() => go(AppRoutes.profile);

  /// Navigate to onboarding
  void goOnboarding() => go(AppRoutes.onboarding);

  /// Navigate to email integration settings
  void goEmailIntegration() => go(AppRoutes.emailIntegration);

  /// Navigate to Gmail import
  void goGmailImport() => go(AppRoutes.gmailImport);

  /// Navigate to calendar integration settings
  void goCalendarIntegration() => go(AppRoutes.calendarIntegration);

  /// Navigate to cloud storage integration settings
  void goCloudStorage() => go(AppRoutes.cloudStorage);

  /// Navigate to edit profile screen
  void goEditProfile() => go(AppRoutes.editProfile);

  /// Navigate to appearance settings
  void goAppearanceSettings() => go(AppRoutes.appearanceSettings);

  /// Navigate to notification settings
  void goNotificationSettings() => go(AppRoutes.notificationSettings);

  /// Navigate to language settings
  void goLanguageSettings() => go(AppRoutes.languageSettings);

  /// Navigate to storage & sync settings
  void goStorageSyncSettings() => go(AppRoutes.storageSyncSettings);

  /// Navigate to change password screen
  void goChangePassword() => go(AppRoutes.changePassword);

  /// Navigate to export/import screen
  void goExportImport() => go(AppRoutes.exportImport);

  /// Navigate back or to home if no history
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      goHome();
    }
  }
} 