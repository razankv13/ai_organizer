import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Appearance Settings Screen - allows users to customize app theme
class AppearanceSettingsScreen extends ConsumerStatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  ConsumerState<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends ConsumerState<AppearanceSettingsScreen> {
  AdaptiveThemeMode _selectedThemeMode = AdaptiveThemeMode.system;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    setState(() {
      _isLoading = true;
    });

    // Get current theme from AdaptiveTheme
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    setState(() {
      _selectedThemeMode = savedThemeMode ?? AdaptiveThemeMode.system;
      _isLoading = false;
    });
  }

  Future<void> _applyTheme(AdaptiveThemeMode mode) async {
    // Set theme immediately via AdaptiveTheme (no restart needed!)
    final adaptiveTheme = AdaptiveTheme.of(context);

    switch (mode) {
      case AdaptiveThemeMode.light:
        adaptiveTheme.setLight();
        break;
      case AdaptiveThemeMode.dark:
        adaptiveTheme.setDark();
        break;
      case AdaptiveThemeMode.system:
        adaptiveTheme.setSystem();
        break;
    }

    // Update local state
    setState(() {
      _selectedThemeMode = mode;
    });

    // Save to Supabase in background (non-blocking)
    unawaited(_saveThemeToSupabase(mode));

    // Show feedback
    if (mounted) {
      _showSnackBar('Theme changed successfully');
    }
  }

  Future<void> _saveThemeToSupabase(AdaptiveThemeMode mode) async {
    try {
      final authActions = ref.read(authActionsProvider);
      final profileData = await authActions.getUserProfile();
      final existingPreferences = (profileData?['preferences'] as Map<String, dynamic>?) ?? {};

      existingPreferences['theme_mode'] = mode.name;

      await authActions.updateUserProfile({
        'preferences': existingPreferences,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Failed to save theme to Supabase: $e');
      // Non-critical error, theme is already applied locally
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: isError ? colorScheme.onError : colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Appearance',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),

        // No save button needed - changes apply immediately
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Theme Mode Section
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section header
                        Row(
                          children: [
                            Icon(Icons.palette_outlined, color: colorScheme.primary, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Theme Mode',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Light Theme Option
                        _buildThemeOption(
                          title: 'Light',
                          description: 'Always use light theme',
                          icon: Icons.light_mode,
                          value: AdaptiveThemeMode.light,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        // Dark Theme Option
                        _buildThemeOption(
                          title: 'Dark',
                          description: 'Always use dark theme',
                          icon: Icons.dark_mode,
                          value: AdaptiveThemeMode.dark,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        // System Theme Option
                        _buildThemeOption(
                          title: 'System',
                          description: 'Follow system theme',
                          icon: Icons.auto_mode,
                          value: AdaptiveThemeMode.system,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: colorScheme.primary, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Theme changes apply immediately - no restart needed!',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String description,
    required IconData icon,
    required AdaptiveThemeMode value,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isLast = false,
  }) {
    final isSelected = _selectedThemeMode == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _applyTheme(value),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: !isLast
                ? Border(bottom: BorderSide(color: colorScheme.outlineVariant, width: 1))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, size: 20, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
