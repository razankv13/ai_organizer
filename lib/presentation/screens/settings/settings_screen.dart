import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                title: 'settings.theme'.tr(),
                subtitle: _getThemeText(context),
                onTap: () => _showThemeActionSheet(context),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.language_outlined,
                title: 'settings.language'.tr(),
                subtitle: _getLanguageText(context),
                onTap: () => _showLanguageActionSheet(context),
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
                onTap: () => context.go('/settings/export-import'),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.email_outlined,
                title: 'Email Integration',
                subtitle: 'Email-to-Note and Gmail import',
                showChevron: true,
                onTap: () => context.go('/settings/email-integration'),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.calendar_today,
                title: 'Calendar Integration',
                subtitle: 'Sync with Google Calendar',
                showChevron: true,
                onTap: () => context.go('/settings/calendar-integration'),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.cloud_outlined,
                title: 'Cloud Storage',
                subtitle: 'Dropbox and Google Drive',
                showChevron: true,
                onTap: () => context.go('/settings/cloud-storage'),
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.notifications_outlined,
                title: 'settings.notifications'.tr(),
                showChevron: true,
                onTap: () {},
              ),
              _SettingDivider(),
              _SettingItem(
                icon: Icons.sync_outlined,
                title: 'settings.sync'.tr(),
                showChevron: true,
                onTap: () {},
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

  String _getThemeText(BuildContext context) {
    final themeMode = AdaptiveTheme.of(context).mode;
    switch (themeMode) {
      case AdaptiveThemeMode.light:
        return 'settings.lightTheme'.tr();
      case AdaptiveThemeMode.dark:
        return 'settings.darkTheme'.tr();
      case AdaptiveThemeMode.system:
        return 'settings.systemTheme'.tr();
    }
  }

  String _getLanguageText(BuildContext context) {
    final locale = context.locale;
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  void _showThemeActionSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActionSheet(
        title: 'settings.theme'.tr(),
        items: [
          _ActionSheetItem(
            icon: Icons.light_mode_outlined,
            title: 'settings.lightTheme'.tr(),
            isSelected: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light,
            onTap: () {
              AdaptiveTheme.of(context).setLight();
              Navigator.of(context).pop();
            },
          ),
          _ActionSheetItem(
            icon: Icons.dark_mode_outlined,
            title: 'settings.darkTheme'.tr(),
            isSelected: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
            onTap: () {
              AdaptiveTheme.of(context).setDark();
              Navigator.of(context).pop();
            },
          ),
          _ActionSheetItem(
            icon: Icons.brightness_auto_outlined,
            title: 'settings.systemTheme'.tr(),
            isSelected: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system,
            onTap: () {
              AdaptiveTheme.of(context).setSystem();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageActionSheet(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'locale': const Locale('en', 'US')},
      {'code': 'es', 'name': 'Español', 'locale': const Locale('es', 'ES')},
      {'code': 'fr', 'name': 'Français', 'locale': const Locale('fr', 'FR')},
      {'code': 'de', 'name': 'Deutsch', 'locale': const Locale('de', 'DE')},
      {'code': 'ja', 'name': '日本語', 'locale': const Locale('ja', 'JP')},
      {'code': 'zh', 'name': '中文', 'locale': const Locale('zh', 'CN')},
      {'code': 'ar', 'name': 'العربية', 'locale': const Locale('ar', 'SA')},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActionSheet(
        title: 'settings.language'.tr(),
        items: languages.map((lang) {
          return _ActionSheetItem(
            icon: Icons.language,
            title: lang['name'] as String,
            isSelected: context.locale.languageCode == lang['code'],
            onTap: () {
              context.setLocale(lang['locale'] as Locale);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
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
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
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
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                size: AppSpacing.iconSize,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: AppSpacing.md),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: colorScheme.onSurfaceVariant,
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
      padding: const EdgeInsets.only(left: AppSpacing.md + AppSpacing.iconSize + AppSpacing.md),
      child: Divider(
        height: 1,
        thickness: 1,
        color: colorScheme.outlineVariant,
      ),
    );
  }
}

/// Custom action sheet following UI/UX guidelines (dark modal)
class _ActionSheet extends StatelessWidget {
  final String title;
  final List<_ActionSheetItem> items;

  const _ActionSheet({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF3A3A3A), // Dark gray modal background from guidelines
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000), // 20% black
            blurRadius: 24,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFF6B6B6B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFFFFFFF), // White text on dark modal
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Action items
            ...items,

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

/// Action sheet item widget
class _ActionSheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionSheetItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textColor = isDestructive
        ? const Color(0xFFFF5454)
        : const Color(0xFFFFFFFF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                size: 22,
                color: textColor,
              ),

              const SizedBox(width: AppSpacing.md),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // Check mark for selected item
              if (isSelected)
                const Icon(
                  Icons.check,
                  size: 22,
                  color: Color(0xFF007AFF), // iOS blue
                ),
            ],
          ),
        ),
      ),
    );
  }
}
