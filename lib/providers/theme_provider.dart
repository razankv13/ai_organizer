import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._authActions) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final AuthActions _authActions;

  /// Load theme mode from user preferences
  Future<void> _loadThemeMode() async {
    try {
      final profileData = await _authActions.getUserProfile();
      if (profileData != null && profileData['preferences'] != null) {
        final preferences = profileData['preferences'] as Map<String, dynamic>?;
        if (preferences != null) {
          final themeModeStr = preferences['theme_mode'] as String?;
          state = _themeModeFromString(themeModeStr);
        }
      }
    } catch (e) {
      debugPrint('Failed to load theme mode: $e');
      // Keep default (system)
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Set theme mode and save to backend
  Future<void> setThemeMode(ThemeMode mode) async {
    // Optimistically update UI
    state = mode;

    try {
      // Get existing preferences
      final profileData = await _authActions.getUserProfile();
      final existingPreferences = (profileData?['preferences'] as Map<String, dynamic>?) ?? {};

      // Update theme_mode in preferences
      existingPreferences['theme_mode'] = _themeModeToString(mode);

      // Save to backend
      await _authActions.updateUserProfile({
        'preferences': existingPreferences,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
      // UI already updated optimistically, so user sees the change
      // If save fails, it will be reverted on next app launch
    }
  }

  /// Reload theme mode from backend (useful after login)
  Future<void> reload() async {
    await _loadThemeMode();
  }
}

/// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final authActions = ref.watch(authActionsProvider);
  return ThemeModeNotifier(authActions);
});
