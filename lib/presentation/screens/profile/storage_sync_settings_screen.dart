import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/sync_provider.dart';

/// Storage & Sync Settings Screen - manage storage and synchronization preferences
class StorageSyncSettingsScreen extends ConsumerStatefulWidget {
  const StorageSyncSettingsScreen({super.key});

  @override
  ConsumerState<StorageSyncSettingsScreen> createState() => _StorageSyncSettingsScreenState();
}

class _StorageSyncSettingsScreenState extends ConsumerState<StorageSyncSettingsScreen> {
  bool _autoSync = true;
  String _syncFrequency = 'hourly';
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isClearingCache = false;

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
            _autoSync = preferences['auto_sync'] as bool? ?? true;
            _syncFrequency = preferences['sync_frequency'] as String? ?? 'hourly';
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

      // Update sync preferences
      existingPreferences['auto_sync'] = _autoSync;
      existingPreferences['sync_frequency'] = _syncFrequency;

      // Save updated preferences
      await authActions.updateUserProfile({
        'preferences': existingPreferences,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showSnackBar('Settings saved');
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

  Future<void> _clearCache() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          title: Text(
            'Clear Cache',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'This will remove cached data. Your notes and attachments will not be affected. Continue?',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Clear',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isClearingCache = true;
    });

    try {
      // Simulate cache clearing (implement actual cache clearing logic here)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        _showSnackBar('Cache cleared successfully');
      }
    } catch (e) {
      debugPrint('Failed to clear cache: $e');
      if (mounted) {
        _showSnackBar('Failed to clear cache', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClearingCache = false;
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
    final syncState = ref.watch(syncStateProvider);

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
          'Storage & Sync',
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
                  // Storage Info Section
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
                              Icons.storage_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Storage Usage',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildStorageInfoItem(
                          'Local Storage',
                          '-- MB',
                          colorScheme,
                          textTheme,
                        ),
                        _buildStorageInfoItem(
                          'Cloud Storage',
                          '-- MB',
                          colorScheme,
                          textTheme,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Sync Settings Section
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
                              Icons.sync,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Synchronization',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        // Auto sync toggle
                        _buildSwitchItem(
                          title: 'Auto Sync',
                          description: 'Automatically sync when online',
                          value: _autoSync,
                          onChanged: (value) {
                            setState(() {
                              _autoSync = value;
                            });
                          },
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),

                        // Sync frequency dropdown
                        if (_autoSync) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Sync Frequency',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          DropdownButtonFormField<String>(
                            value: _syncFrequency,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'manual',
                                child: Text('Manual', style: textTheme.bodyLarge),
                              ),
                              DropdownMenuItem(
                                value: 'hourly',
                                child: Text('Every hour', style: textTheme.bodyLarge),
                              ),
                              DropdownMenuItem(
                                value: 'daily',
                                child: Text('Daily', style: textTheme.bodyLarge),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _syncFrequency = value;
                                });
                              }
                            },
                          ),
                        ],

                        const SizedBox(height: AppSpacing.md),

                        // Sync status
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getSyncStatusIcon(syncState),
                                color: _getSyncStatusColor(syncState, colorScheme),
                                size: 16,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Status: ${_getSyncStatusText(syncState)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Actions Section
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
                              Icons.settings_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Actions',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        // Clear cache button
                        _buildActionButton(
                          title: 'Clear Cache',
                          description: 'Remove temporary files',
                          icon: Icons.delete_sweep_outlined,
                          onTap: _isClearingCache ? null : _clearCache,
                          isLoading: _isClearingCache,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStorageInfoItem(
    String label,
    String value,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

  Widget _buildActionButton({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isLoading,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
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
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSyncStatusIcon(SyncState state) {
    switch (state) {
      case SyncState.idle:
        return Icons.check_circle_outline;
      case SyncState.syncing:
        return Icons.sync;
      case SyncState.error:
        return Icons.error_outline;
    }
  }

  Color _getSyncStatusColor(SyncState state, ColorScheme colorScheme) {
    switch (state) {
      case SyncState.idle:
        return const Color(0xFF34C759);
      case SyncState.syncing:
        return colorScheme.primary;
      case SyncState.error:
        return colorScheme.error;
    }
  }

  String _getSyncStatusText(SyncState state) {
    switch (state) {
      case SyncState.idle:
        return 'Up to date';
      case SyncState.syncing:
        return 'Syncing...';
      case SyncState.error:
        return 'Sync failed';
    }
  }
}
