import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/share_permission.dart';
import 'package:ai_organizer/data/models/shared_note.dart';
import 'package:ai_organizer/providers/sharing_provider.dart';

/// Screen for managing note sharing and permissions
class ShareNoteScreen extends ConsumerStatefulWidget {
  const ShareNoteScreen({
    super.key,
    required this.noteId,
    required this.noteTitle,
  });

  final String noteId;
  final String noteTitle;

  @override
  ConsumerState<ShareNoteScreen> createState() => _ShareNoteScreenState();
}

class _ShareNoteScreenState extends ConsumerState<ShareNoteScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SharePermission _selectedPermission = SharePermission.view;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _shareWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(sharingActionsProvider);
      await actions.shareWithEmail(
        noteId: widget.noteId,
        email: _emailController.text.trim(),
        permission: _selectedPermission,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note shared with ${_emailController.text.trim()}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        _emailController.clear();
        _selectedPermission = SharePermission.view;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing note: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createShareLink() async {
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(sharingActionsProvider);
      final shareData = await actions.createShareLink(
        noteId: widget.noteId,
        permission: _selectedPermission,
      );

      final link = shareData['link'] as String;

      if (mounted) {
        // Copy link to clipboard
        await Clipboard.setData(ClipboardData(text: link));

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Share link copied to clipboard!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating share link: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _shareViaSystem() async {
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(sharingActionsProvider);
      await actions.shareViaSystemShare(
        noteId: widget.noteId,
        noteTitle: widget.noteTitle,
        permission: _selectedPermission,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updatePermission(SharedNote share, SharePermission newPermission) async {
    try {
      final actions = ref.read(sharingActionsProvider);
      await actions.updatePermission(
        shareId: share.id,
        noteId: widget.noteId,
        newPermission: newPermission,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permission updated'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating permission: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _revokeShare(SharedNote share) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Revoke Access', style: textTheme.titleLarge),
        content: Text(
          'Remove access for ${share.sharedWithEmail}?',
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
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Revoke',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final actions = ref.read(sharingActionsProvider);
      await actions.revokeShare(
        shareId: share.id,
        noteId: widget.noteId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Access revoked'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error revoking access: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract theme data once
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sharesAsync = ref.watch(sharesForNoteProvider(widget.noteId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Share Note',
          style: textTheme.titleLarge,
        ),
        actions: [
          // Share count badge
          sharesAsync.when(
            data: (shares) => shares.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          '${shares.length} shared',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Share with email section
            Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share with people',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            style: textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Enter email address',
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: colorScheme.onSurfaceVariant,
                                size: AppSpacing.iconSize,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.outline,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.outline,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _shareWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
                            elevation: 0,
                            padding: AppSpacing.buttonPadding,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: AppSpacing.md,
                                  height: AppSpacing.md,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Share',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Permission selector
                  Row(
                    children: [
                      Text(
                        'Permission:',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ChoiceChip(
                        label: Text(
                          'View only',
                          style: textTheme.labelMedium?.copyWith(
                            color: _selectedPermission == SharePermission.view
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                        selected: _selectedPermission == SharePermission.view,
                        onSelected: (_) => setState(() => _selectedPermission = SharePermission.view),
                        selectedColor: colorScheme.secondaryContainer,
                        backgroundColor: colorScheme.surface,
                        side: BorderSide(
                          color: _selectedPermission == SharePermission.view
                              ? colorScheme.secondary
                              : colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ChoiceChip(
                        label: Text(
                          'Can edit',
                          style: textTheme.labelMedium?.copyWith(
                            color: _selectedPermission == SharePermission.edit
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                        selected: _selectedPermission == SharePermission.edit,
                        onSelected: (_) => setState(() => _selectedPermission = SharePermission.edit),
                        selectedColor: colorScheme.secondaryContainer,
                        backgroundColor: colorScheme.surface,
                        side: BorderSide(
                          color: _selectedPermission == SharePermission.edit
                              ? colorScheme.secondary
                              : colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Share link and system share buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _createShareLink,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(color: colorScheme.outline),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          icon: Icon(
                            Icons.link,
                            size: AppSpacing.iconSizeSmall,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            'Copy Link',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _shareViaSystem,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(color: colorScheme.outline),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          icon: Icon(
                            Icons.share,
                            size: AppSpacing.iconSizeSmall,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            'Share',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // List of people with access
            Expanded(
              child: sharesAsync.when(
                data: (shares) {
                  if (shares.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No one has access yet',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Share this note with others',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    itemCount: shares.length,
                    itemBuilder: (context, index) {
                      final share = shares[index];
                      return _ShareListItem(
                        share: share,
                        onPermissionChanged: (newPermission) => _updatePermission(share, newPermission),
                        onRevoke: () => _revokeShare(share),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Error loading shares',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          error.toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying a single share in the list
class _ShareListItem extends StatelessWidget {
  const _ShareListItem({
    required this.share,
    required this.onPermissionChanged,
    required this.onRevoke,
  });

  final SharedNote share;
  final Function(SharePermission) onPermissionChanged;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            share.sharedWithEmail[0].toUpperCase(),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          share.sharedWithEmail,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxs),
            Text(
              share.permission.displayName,
              style: textTheme.labelSmall?.copyWith(
                color: share.permission == SharePermission.edit
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (share.expiresAt != null)
              Text(
                'Expires: ${_formatDate(share.expiresAt!)}',
                style: textTheme.labelSmall?.copyWith(
                  color: share.isExpired
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Permission dropdown
            DropdownButton<SharePermission>(
              value: share.permission,
              underline: const SizedBox.shrink(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              dropdownColor: colorScheme.surface,
              items: SharePermission.values.map((permission) {
                return DropdownMenuItem(
                  value: permission,
                  child: Text(
                    permission.displayName,
                    style: textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (newPermission) {
                if (newPermission != null) {
                  onPermissionChanged(newPermission);
                }
              },
            ),
            // Revoke button
            IconButton(
              icon: Icon(
                Icons.close,
                color: colorScheme.error,
                size: AppSpacing.iconSize,
              ),
              onPressed: onRevoke,
              tooltip: 'Revoke access',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inDays > 365) {
      return 'in ${(difference.inDays / 365).round()} years';
    } else if (difference.inDays > 30) {
      return 'in ${(difference.inDays / 30).round()} months';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hours';
    } else {
      return 'soon';
    }
  }
}
