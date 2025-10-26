import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text('settings.title'.tr()),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.screenVertical,
        ),
        children: [
          // Appearance Section
          _SettingSection(
            title: 'settings.appearance'.tr(),
            children: [
              _SettingItem(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Theme and display settings',
                showChevron: true,
                onTap: () => context.push(AppRoutes.appearanceSettings),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'App language',
                showChevron: true,
                onTap: () => context.push(AppRoutes.languageSettings),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // General Section
          _SettingSection(
            title: 'settings.general'.tr(),
            children: [
              _SettingItem(
                icon: Icons.import_export_outlined,
                title: 'Export & Import',
                subtitle: 'Backup, export, and import notes',
                showChevron: true,
                onTap: () => context.push(AppRoutes.exportImport),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.email_outlined,
                title: 'Email Integration',
                subtitle: 'Email-to-Note and Gmail import',
                showChevron: true,
                onTap: () => context.push(AppRoutes.emailIntegration),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.calendar_today,
                title: 'Calendar Integration',
                subtitle: 'Sync with Google Calendar',
                showChevron: true,
                onTap: () => context.push(AppRoutes.calendarIntegration),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.cloud_outlined,
                title: 'Cloud Storage',
                subtitle: 'Dropbox and Google Drive',
                showChevron: true,
                onTap: () => context.push(AppRoutes.cloudStorage),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Alerts and reminders',
                showChevron: true,
                onTap: () => context.push(AppRoutes.notificationSettings),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.cloud_outlined,
                title: 'Storage & Sync',
                subtitle: 'Cloud sync and storage',
                showChevron: true,
                onTap: () => context.push(AppRoutes.storageSyncSettings),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // About Section
          _SettingSection(
            title: 'settings.about'.tr(),
            children: [
              _SettingItem(
                icon: Icons.info_outlined,
                title: 'About',
                showChevron: true,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// Custom setting section widget with header and card container
class _SettingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Card container
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Custom setting item widget following UI/UX guidelines
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        splashColor: colorScheme.onSurface.withValues(alpha: 0.06),
        highlightColor: colorScheme.onSurface.withValues(alpha: 0.03),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: AppSpacing.md),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Chevron icon for navigation
              if (showChevron) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Divider between setting items
class _SettingDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md + 24 + AppSpacing.md),
      child: Divider(
        height: 1,
        thickness: 1,
        color: colorScheme.outlineVariant,
      ),
    );
  }
}
