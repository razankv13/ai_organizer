import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/core/navigation/app_router.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/sync_provider.dart';

/// User profile screen - redesigned following UI/UX guidelines
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      final profileData = await authActions.getUserProfile();

      setState(() {
        _profileData = profileData;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Failed to load profile data: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Failed to load profile data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      // If no user is logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: colorScheme.onSurface,
            ),
            onPressed: _loadProfileData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildContent(user, colorScheme, textTheme),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        children: [
          _buildProfileSkeleton(),
          const SizedBox(height: AppSpacing.sm),
          _buildCardSkeleton(height: 180),
          const SizedBox(height: AppSpacing.sm),
          _buildCardSkeleton(height: 240),
        ],
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          // Avatar skeleton
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Name skeleton
          Container(
            width: 180,
            height: 24,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Email skeleton
          Container(
            width: 220,
            height: 16,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Button skeleton
          Container(
            width: 140,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSkeleton({required double height}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, __) => Container(
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
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
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Unable to Load Profile',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage ?? 'An error occurred',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loadProfileData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(User user, ColorScheme colorScheme, TextTheme textTheme) {
    final syncState = ref.watch(syncStateProvider);
    final lastSyncTime = ref.watch(lastSyncTimeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User profile section
          _buildProfileSection(user, colorScheme, textTheme),

          const SizedBox(height: AppSpacing.sm),

          // Sync status section
          _buildSyncSection(colorScheme, textTheme, syncState, lastSyncTime),

          const SizedBox(height: AppSpacing.sm),

          // Settings section
          _buildSettingsSection(colorScheme, textTheme),

          const SizedBox(height: AppSpacing.sm),

          // Account management section
          _buildAccountSection(colorScheme, textTheme),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildProfileSection(User user, ColorScheme colorScheme, TextTheme textTheme) {
    final fullName = _profileData?['full_name'] as String? ?? '';
    final avatarUrl = _profileData?['avatar_url'] as String?;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
              image: avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl == null
                ? Center(
                    child: Text(
                      _getInitials(fullName),
                      style: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : null,
          ),

          const SizedBox(height: AppSpacing.md),

          // User name
          Text(
            fullName.isNotEmpty ? fullName : 'User',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xs),

          // Email
          Text(
            user.email ?? '',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Edit profile button
          SizedBox(
            width: 160,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _editProfile,
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              label: Text(
                'Edit Profile',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection(ColorScheme colorScheme, TextTheme textTheme,
      SyncState syncState, DateTime? lastSyncTime) {
    return Container(
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

          const SizedBox(height: AppSpacing.md),

          // Sync status
          Row(
            children: [
              Icon(
                _getSyncStatusIcon(syncState),
                color: _getSyncStatusColor(syncState, colorScheme),
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Status: ${_getSyncStatusText(syncState)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Last sync time
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Last sync: ${lastSyncTime != null ? _formatDateTime(lastSyncTime) : 'Never'}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Sync buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: syncState == SyncState.syncing ? null : _syncToServer,
                    icon: Icon(
                      Icons.upload,
                      size: 18,
                      color: syncState == SyncState.syncing
                          ? colorScheme.onSurface.withValues(alpha: 0.38)
                          : colorScheme.primary,
                    ),
                    label: Text(
                      'Upload',
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        color: syncState == SyncState.syncing
                            ? colorScheme.onSurface.withValues(alpha: 0.38)
                            : colorScheme.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: syncState == SyncState.syncing
                            ? colorScheme.outline.withValues(alpha: 0.38)
                            : colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: syncState == SyncState.syncing ? null : _syncFromServer,
                    icon: Icon(
                      Icons.download,
                      size: 18,
                      color: syncState == SyncState.syncing
                          ? colorScheme.onSurface.withValues(alpha: 0.38)
                          : colorScheme.primary,
                    ),
                    label: Text(
                      'Download',
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        color: syncState == SyncState.syncing
                            ? colorScheme.onSurface.withValues(alpha: 0.38)
                            : colorScheme.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: syncState == SyncState.syncing
                            ? colorScheme.outline.withValues(alpha: 0.38)
                            : colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
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
              Icon(
                Icons.settings_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Settings',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Settings items
          _buildSettingsItem(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            onTap: _openAppearanceSettings,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),

          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: _openNotificationSettings,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),

          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: 'Language',
            onTap: _openLanguageSettings,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),

          _buildSettingsItem(
            icon: Icons.cloud_outlined,
            title: 'Storage & Sync',
            onTap: _openStorageSettings,
            colorScheme: colorScheme,
            textTheme: textTheme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
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
              Icon(
                Icons.account_circle_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Account',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Account actions
          _buildSettingsItem(
            icon: Icons.lock_outlined,
            title: 'Change Password',
            onTap: _changePassword,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),

          _buildSettingsItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            onTap: _confirmDeleteAccount,
            colorScheme: colorScheme,
            textTheme: textTheme,
            textColor: colorScheme.error,
            iconColor: colorScheme.error,
            isLast: true,
          ),

          const SizedBox(height: AppSpacing.md),

          // Sign out button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, size: 20),
              label: Text(
                'Sign Out',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    Color? textColor,
    Color? iconColor,
    bool isLast = false,
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
                color: iconColor ?? colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: textColor ?? colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
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
        // Success green - could be added to theme, using a predefined success color
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Future<void> _syncToServer() async {
    try {
      final syncActions = ref.read(syncActionsProvider);
      await syncActions.syncToServer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync to server completed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync failed: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _syncFromServer() async {
    try {
      final syncActions = ref.read(syncActionsProvider);
      await syncActions.syncFromServer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync from server completed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync failed: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _editProfile() {
    context.goEditProfile();
  }

  void _openAppearanceSettings() {
    context.goAppearanceSettings();
  }

  void _openNotificationSettings() {
    context.goNotificationSettings();
  }

  void _openLanguageSettings() {
    context.goLanguageSettings();
  }

  void _openStorageSettings() {
    context.goStorageSyncSettings();
  }

  void _changePassword() {
    context.goChangePassword();
  }

  void _confirmDeleteAccount() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final confirmationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Delete Account',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted:',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '• All notes and attachments\n• Tags and folders\n• Profile information\n• Account settings',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Type DELETE to confirm:',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: confirmationController,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'DELETE',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmationController.text.trim().toUpperCase() == 'DELETE') {
                Navigator.of(dialogContext).pop();
                _deleteAccount();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please type DELETE to confirm',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onError,
                      ),
                    ),
                    backgroundColor: colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              'Delete Permanently',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      confirmationController.dispose();
    });
  }

  Future<void> _deleteAccount() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show loading dialog
    unawaited(showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Deleting account...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    ));

    try {
      final authActions = ref.read(authActionsProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Call production-ready delete account function
      // This safely deletes all user data via Supabase function
      final result = await authActions.deleteAccount();

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Account deleted, redirect to login
        context.go('/login');

        // Show success message with statistics
        final deletedCounts = result['deleted_counts'] as Map<String, dynamic>?;
        final notesCount = deletedCounts?['notes'] ?? 0;
        final tagsCount = deletedCounts?['tags'] ?? 0;
        final attachmentsCount = deletedCounts?['attachments'] ?? 0;

        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Account deleted: $notesCount notes, $tagsCount tags, $attachmentsCount attachments',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onInverseSurface,
                  ),
                ),
                backgroundColor: colorScheme.inverseSurface,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting account: $e',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onError,
              ),
            ),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final authActions = ref.read(authActionsProvider);
      await authActions.signOut();

      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error signing out: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
