import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Notification Settings Screen - manage notification preferences
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _noteReminders = true;
  bool _syncNotifications = false;
  bool _aiSuggestions = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      final profileData = await authActions.getUserProfile();

      if (profileData != null && profileData['preferences'] != null) {
        final preferences = profileData['preferences'] as Map<String, dynamic>?;
        if (preferences != null) {
          setState(() {
            _pushNotifications = preferences['push_notifications'] as bool? ?? true;
            _noteReminders = preferences['note_reminders'] as bool? ?? true;
            _syncNotifications = preferences['sync_notifications'] as bool? ?? false;
            _aiSuggestions = preferences['ai_suggestions'] as bool? ?? true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load preferences: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final authActions = ref.read(authActionsProvider);

      // Get existing preferences first
      final profileData = await authActions.getUserProfile();
      final existingPreferences = (profileData?['preferences'] as Map<String, dynamic>?) ?? {};

      // Update notification preferences
      existingPreferences['push_notifications'] = _pushNotifications;
      existingPreferences['note_reminders'] = _noteReminders;
      existingPreferences['sync_notifications'] = _syncNotifications;
      existingPreferences['ai_suggestions'] = _aiSuggestions;

      // Save updated preferences
      await authActions.updateUserProfile({
        'preferences': existingPreferences,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showSnackBar('Notification settings saved');
      }
    } catch (e) {
      debugPrint('Failed to save preferences: $e');
      if (mounted) {
        _showSnackBar('Failed to save settings', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Notification Settings Section
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
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Notification Preferences',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        // Push notifications
                        _buildSwitchItem(
                          title: 'Push Notifications',
                          description: 'Receive push notifications',
                          value: _pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                          },
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        const Divider(height: AppSpacing.lg),

                        // Note reminders
                        _buildSwitchItem(
                          title: 'Note Reminders',
                          description: 'Get reminded about your notes',
                          value: _noteReminders,
                          onChanged: (value) {
                            setState(() {
                              _noteReminders = value;
                            });
                          },
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        const Divider(height: AppSpacing.lg),

                        // Sync notifications
                        _buildSwitchItem(
                          title: 'Sync Notifications',
                          description: 'Notify when sync completes',
                          value: _syncNotifications,
                          onChanged: (value) {
                            setState(() {
                              _syncNotifications = value;
                            });
                          },
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        const Divider(height: AppSpacing.lg),

                        // AI suggestions
                        _buildSwitchItem(
                          title: 'AI Suggestions',
                          description: 'Get AI-powered suggestions',
                          value: _aiSuggestions,
                          onChanged: (value) {
                            setState(() {
                              _aiSuggestions = value;
                            });
                          },
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
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'You can manage system notification permissions in your device settings',
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

  Widget _buildSwitchItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }
}
