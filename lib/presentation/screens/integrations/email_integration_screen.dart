import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/providers/email_provider.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

class EmailIntegrationScreen extends ConsumerStatefulWidget {
  const EmailIntegrationScreen({super.key});

  @override
  ConsumerState<EmailIntegrationScreen> createState() => _EmailIntegrationScreenState();
}

class _EmailIntegrationScreenState extends ConsumerState<EmailIntegrationScreen> {
  bool _isInitializing = false;
  bool _isConnectingGmail = false;

  @override
  void initState() {
    super.initState();
    _initializeIfNeeded();
  }

  Future<void> _initializeIfNeeded() async {
    final emailSettings = await ref.read(emailSettingsProvider.future);
    if (emailSettings == null && mounted) {
      setState(() => _isInitializing = true);
      try {
        await ref.read(emailActionsProvider).initializeEmailSettings();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error initializing email settings: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isInitializing = false);
        }
      }
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
  }

  Future<void> _regenerateEmail() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regenerate Email Address'),
        content: const Text(
          'This will generate a new unique email address. Your old address will no longer work. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Regenerate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(emailActionsProvider).regenerateUniqueEmail();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email address regenerated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error regenerating email: $e')),
          );
        }
      }
    }
  }

  Future<void> _connectGmail() async {
    setState(() => _isConnectingGmail = true);
    try {
      final success = await ref.read(emailActionsProvider).connectGmail();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gmail connected successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect Gmail')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting Gmail: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnectingGmail = false);
      }
    }
  }

  Future<void> _disconnectGmail() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Gmail'),
        content: const Text('Are you sure you want to disconnect Gmail?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(emailActionsProvider).disconnectGmail();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gmail disconnected')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error disconnecting Gmail: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final emailSettings = ref.watch(emailSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Integration'),
      ),
      body: emailSettings.when(
        data: (settings) {
          if (settings == null && !_isInitializing) {
            return const Center(child: Text('No email settings found'));
          }

          final uniqueEmail = settings?['unique_email'] as String?;
          final isEnabled = settings?['is_enabled'] as bool? ?? true;
          final gmailConnected = settings?['gmail_connected'] as bool? ?? false;
          final gmailEmail = settings?['gmail_email'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email-to-Note Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, color: colorScheme.primary, size: AppSpacing.iconSize),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Email-to-Note',
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Forward emails to your unique address to automatically create notes.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (uniqueEmail != null) ...[
                          Text(
                            'Your unique email address:',
                            style: textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    uniqueEmail,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'monospace',
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: AppSpacing.iconSizeSmall),
                                  color: colorScheme.primary,
                                  onPressed: () => _copyToClipboard(uniqueEmail),
                                  tooltip: 'Copy',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: _regenerateEmail,
                                icon: Icon(Icons.refresh, size: AppSpacing.iconSizeSmall),
                                label: const Text('Regenerate'),
                              ),
                              const Spacer(),
                              Switch(
                                value: isEnabled,
                                onChanged: (value) {
                                  ref.read(emailActionsProvider).toggleEmailToNote(value);
                                },
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text('Enabled', style: textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Gmail Integration Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/gmail_icon.png',
                              width: AppSpacing.iconSize,
                              height: AppSpacing.iconSize,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.mail, color: colorScheme.primary, size: AppSpacing.iconSize),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Gmail Integration',
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Connect your Gmail account to import emails as notes.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (gmailConnected && gmailEmail != null) ...[
                          ListTile(
                            leading: Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                              size: AppSpacing.iconSize,
                            ),
                            title: Text('Connected', style: textTheme.titleMedium),
                            subtitle: Text(
                              gmailEmail,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  context.push('/email-integration/gmail-import');
                                },
                                icon: Icon(Icons.download, size: AppSpacing.iconSizeSmall),
                                label: const Text('Import Emails'),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton(
                                onPressed: _disconnectGmail,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.error,
                                  side: BorderSide(color: colorScheme.error),
                                ),
                                child: const Text('Disconnect'),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: AppSpacing.xs),
                          FilledButton.icon(
                            onPressed: _isConnectingGmail ? null : _connectGmail,
                            icon: _isConnectingGmail
                                ? SizedBox(
                                    width: AppSpacing.iconSizeSmall,
                                    height: AppSpacing.iconSizeSmall,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : Icon(Icons.link, size: AppSpacing.iconSizeSmall),
                            label: Text(_isConnectingGmail ? 'Connecting...' : 'Connect Gmail'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Information Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: AppShadows.cardShadow,
                    ),
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
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'How it works',
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '• Forward any email to your unique address to create a note\n'
                          '• Subject becomes note title, body becomes content\n'
                          '• Email attachments are saved with the note\n'
                          '• Notes are automatically tagged with "email"\n'
                          '• Connect Gmail to import emails directly from your inbox',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
                  'Error loading email settings: $error',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => ref.invalidate(emailSettingsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
