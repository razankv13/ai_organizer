import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/cloud_storage_provider.dart';

class CloudStorageIntegrationScreen extends ConsumerStatefulWidget {
  const CloudStorageIntegrationScreen({super.key});

  @override
  ConsumerState<CloudStorageIntegrationScreen> createState() =>
      _CloudStorageIntegrationScreenState();
}

class _CloudStorageIntegrationScreenState
    extends ConsumerState<CloudStorageIntegrationScreen> {
  bool _isConnectingDropbox = false;
  bool _isConnectingDrive = false;

  Future<void> _signInToDropbox() async {
    setState(() => _isConnectingDropbox = true);
    try {
      final success =
          await ref.read(cloudStorageActionsProvider).signInToDropbox();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Dropbox connected successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to Dropbox')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to Dropbox: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnectingDropbox = false);
      }
    }
  }

  Future<void> _signOutFromDropbox() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Text(
            'Disconnect Dropbox',
            style: textTheme.titleLarge,
          ),
          content: Text(
            'This will disconnect your Dropbox account. Continue?',
            style: textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text(
                'Disconnect',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(cloudStorageActionsProvider).signOutFromDropbox();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dropbox disconnected')),
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

  Future<void> _signInToGoogleDrive() async {
    setState(() => _isConnectingDrive = true);
    try {
      final success =
          await ref.read(cloudStorageActionsProvider).signInToGoogleDrive();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Google Drive connected successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to connect to Google Drive')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to Google Drive: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnectingDrive = false);
      }
    }
  }

  Future<void> _signOutFromGoogleDrive() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Text(
            'Disconnect Google Drive',
            style: textTheme.titleLarge,
          ),
          content: Text(
            'This will disconnect your Google Drive account. Continue?',
            style: textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text(
                'Disconnect',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(cloudStorageActionsProvider).signOutFromGoogleDrive();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Drive disconnected')),
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

  @override
  Widget build(BuildContext context) {
    // Get theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dropboxConnection = ref.watch(dropboxConnectionProvider);
    final driveConnection = ref.watch(googleDriveConnectionProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Cloud Storage',
          style: textTheme.titleLarge,
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.screenVertical,
        ),
        children: [
          // Header description
          Text(
            'Connect your cloud storage accounts to import files and create notes.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Dropbox Section
          _buildServiceCard(
            context: context,
            icon: Icons.cloud,
            serviceName: 'Dropbox',
            serviceColor: colorScheme.primary,
            connectionAsync: dropboxConnection,
            description: 'Import files from your Dropbox account.',
            isConnecting: _isConnectingDropbox,
            onConnect: _signInToDropbox,
            onDisconnect: _signOutFromDropbox,
          ),

          const SizedBox(height: AppSpacing.md),

          // Google Drive Section
          _buildServiceCard(
            context: context,
            icon: Icons.cloud_circle,
            serviceName: 'Google Drive',
            serviceColor: colorScheme.secondary,
            connectionAsync: driveConnection,
            description: 'Import files from your Google Drive account.',
            isConnecting: _isConnectingDrive,
            onConnect: _signInToGoogleDrive,
            onDisconnect: _signOutFromGoogleDrive,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Information Card
          _buildInformationCard(context),
        ],
      ),
    );
  }

  /// Builds a service card following UI/UX guidelines
  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required String serviceName,
    required Color serviceColor,
    required AsyncValue connectionAsync,
    required String description,
    required bool isConnecting,
    required VoidCallback onConnect,
    required VoidCallback onDisconnect,
  }) {
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
            // Service header (icon + name + status)
            Row(
              children: [
                Icon(
                  icon,
                  size: AppSpacing.iconSizeLarge,
                  color: serviceColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  serviceName,
                  style: textTheme.titleLarge,
                ),
                const Spacer(),
                connectionAsync.when(
                  data: (connection) {
                    if (connection != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: AppSpacing.iconSizeSmall,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              'Connected',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Service content
            connectionAsync.when(
              data: (connection) {
                if (connection != null) {
                  // Connected state
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (connection.userEmail != null) ...[
                        Text(
                          'Account: ${connection.userEmail}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onDisconnect,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(color: colorScheme.error),
                            padding: AppSpacing.buttonPadding,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          child: Text(
                            'Disconnect',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Not connected state
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isConnecting ? null : onConnect,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: AppSpacing.buttonPadding,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                        ),
                        icon: isConnecting
                            ? SizedBox(
                                width: AppSpacing.iconSizeSmall,
                                height: AppSpacing.iconSizeSmall,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.login,
                                size: AppSpacing.iconSizeSmall,
                              ),
                        label: Text(
                          isConnecting
                              ? 'Connecting...'
                              : 'Connect $serviceName',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              error: (error, _) => Text(
                'Error: $error',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the information card following UI/UX guidelines
  Widget _buildInformationCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSize,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'About Cloud Storage',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '• Browse and import files from your cloud storage\n'
              '• Downloaded files will be attached to new notes\n'
              '• Supported file types: documents, images, PDFs, and more\n'
              '• Your cloud storage credentials are stored securely',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
