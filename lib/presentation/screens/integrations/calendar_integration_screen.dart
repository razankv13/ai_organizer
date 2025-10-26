import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/providers/calendar_provider.dart';
import 'package:ai_organizer/services/google_calendar_service.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

class CalendarIntegrationScreen extends ConsumerStatefulWidget {
  const CalendarIntegrationScreen({super.key});

  @override
  ConsumerState<CalendarIntegrationScreen> createState() =>
      _CalendarIntegrationScreenState();
}

class _CalendarIntegrationScreenState
    extends ConsumerState<CalendarIntegrationScreen> {
  bool _isConnecting = false;
  bool _isSyncing = false;
  List<CalendarInfo>? _calendars;

  Future<void> _signInToGoogleCalendar() async {
    setState(() => _isConnecting = true);
    try {
      final success =
          await ref.read(calendarActionsProvider).signInToGoogleCalendar();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Google Calendar connected successfully')),
          );
          // Fetch calendars after successful sign-in
          await _fetchCalendars();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to connect to Google Calendar')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to Google Calendar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  Future<void> _signOutFromGoogleCalendar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final textTheme = Theme.of(dialogContext).textTheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          title: Text(
            'Disconnect Google Calendar',
            style: textTheme.titleLarge,
          ),
          content: Text(
            'This will disconnect your Google Calendar. Your existing notes and tasks will not be affected. Continue?',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: const Text('Disconnect'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(calendarActionsProvider).signOutFromGoogleCalendar();
        if (mounted) {
          setState(() => _calendars = null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Calendar disconnected')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error disconnecting: $e')),
          );
        }
      }
    }
  }

  Future<void> _fetchCalendars() async {
    try {
      final calendars =
          await ref.read(calendarActionsProvider).getCalendars();
      if (mounted) {
        setState(() => _calendars = calendars);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching calendars: $e')),
        );
      }
    }
  }

  Future<void> _selectCalendar(CalendarInfo calendar) async {
    try {
      await ref.read(calendarActionsProvider).setSelectedCalendar(calendar.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected calendar: ${calendar.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting calendar: $e')),
        );
      }
    }
  }

  Future<void> _performSync() async {
    setState(() => _isSyncing = true);
    try {
      final result = await ref.read(calendarActionsProvider).performSync();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync complete! ${result.tasksSynced} tasks and ${result.eventsSynced} events synced.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during sync: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarSettings = ref.watch(calendarSettingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Calendar Integration',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: calendarSettings.when(
        data: (settings) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Google Calendar Connection Card
              _buildConnectionCard(settings),

              const SizedBox(height: AppSpacing.md),

              // Calendar Selection (if connected)
              if (settings?.isGoogleCalendarConnected == true) ...[
                _buildCalendarSelectionCard(settings),
                const SizedBox(height: AppSpacing.md),
              ],

              // Sync Settings (if connected)
              if (settings?.isGoogleCalendarConnected == true) ...[
                _buildSyncSettingsCard(settings),
                const SizedBox(height: AppSpacing.md),
              ],

              // Manual Sync Button (if connected)
              if (settings?.isGoogleCalendarConnected == true)
                _buildSyncButton(),
            ],
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: AppSpacing.iconSizeLarge * 2,
                  color: colorScheme.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Error loading settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionCard(settings) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isConnected = settings?.isGoogleCalendarConnected == true;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: AppSpacing.iconSizeLarge,
                  height: AppSpacing.iconSizeLarge,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: AppSpacing.iconSizeSmall,
                    color: isConnected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google Calendar',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xxxs),
                      Text(
                        isConnected
                            ? 'Connected as ${settings?.googleAccountEmail ?? "Unknown"}'
                            : 'Not connected',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Connection Button
            SizedBox(
              width: double.infinity,
              height: AppSpacing.minTouchTarget,
              child: !isConnected
                  ? FilledButton.icon(
                      onPressed: _isConnecting ? null : _signInToGoogleCalendar,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                      ),
                      icon: _isConnecting
                          ? SizedBox(
                              width: AppSpacing.iconSizeSmall,
                              height: AppSpacing.iconSizeSmall,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: Text(
                        _isConnecting ? 'Connecting...' : 'Connect Google Calendar',
                        style: textTheme.labelLarge,
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: _signOutFromGoogleCalendar,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.outline,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(
                        'Disconnect',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSelectionCard(settings) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar Selection',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),

            if (_calendars == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: OutlinedButton.icon(
                    onPressed: _fetchCalendars,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Load Calendars'),
                  ),
                ),
              )
            else if (_calendars!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: AppSpacing.iconSizeLarge * 2,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No calendars found',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: _calendars!.map((calendar) {
                  final isSelected = calendar.id == settings?.googleCalendarId;
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectCalendar(calendar),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Row(
                            children: [
                              Icon(
                                calendar.isPrimary
                                    ? Icons.star
                                    : Icons.calendar_today_outlined,
                                size: AppSpacing.iconSize,
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      calendar.name,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: isSelected
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    if (calendar.description != null) ...[
                                      const SizedBox(height: AppSpacing.xxxs),
                                      Text(
                                        calendar.description!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: colorScheme.primary,
                                  size: AppSpacing.iconSize,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSettingsCard(settings) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Settings',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Sync tasks to calendar
            _buildSettingSwitch(
              title: 'Sync tasks to calendar',
              subtitle: 'Create calendar events for tasks with due dates',
              value: settings?.syncTasksToCalendar ?? true,
              onChanged: (value) {
                ref.read(calendarActionsProvider).updateSyncSettings(
                      syncTasksToCalendar: value,
                    );
              },
            ),

            const SizedBox(height: AppSpacing.xs),

            // Sync events to notes
            _buildSettingSwitch(
              title: 'Sync events to notes',
              subtitle: 'Create notes from calendar events',
              value: settings?.syncEventsToNotes ?? true,
              onChanged: (value) {
                ref.read(calendarActionsProvider).updateSyncSettings(
                      syncEventsToNotes: value,
                    );
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Sync interval
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: AppSpacing.iconSize,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync interval',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          'Every ${settings?.syncIntervalMinutes ?? 30} minutes',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownButton<int>(
                    value: settings?.syncIntervalMinutes ?? 30,
                    underline: const SizedBox.shrink(),
                    dropdownColor: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    items: [
                      DropdownMenuItem(
                        value: 15,
                        child: Text('15 min', style: textTheme.bodyMedium),
                      ),
                      DropdownMenuItem(
                        value: 30,
                        child: Text('30 min', style: textTheme.bodyMedium),
                      ),
                      DropdownMenuItem(
                        value: 60,
                        child: Text('1 hour', style: textTheme.bodyMedium),
                      ),
                      DropdownMenuItem(
                        value: 120,
                        child: Text('2 hours', style: textTheme.bodyMedium),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(calendarActionsProvider).updateSyncSettings(
                              syncIntervalMinutes: value,
                            );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Last sync info
            if (settings?.lastSyncedAt != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: AppSpacing.iconSize,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Last synced: ${_formatDateTime(settings!.lastSyncedAt!)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        title: Text(
          title,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        value: value,
        onChanged: onChanged,
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }

  Widget _buildSyncButton() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.minTouchTarget,
      child: FilledButton.icon(
        onPressed: _isSyncing ? null : _performSync,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        icon: _isSyncing
            ? SizedBox(
                width: AppSpacing.iconSizeSmall,
                height: AppSpacing.iconSizeSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : const Icon(Icons.sync),
        label: Text(
          _isSyncing ? 'Syncing...' : 'Sync Now',
          style: textTheme.labelLarge,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
