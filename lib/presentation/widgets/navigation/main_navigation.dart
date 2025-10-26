import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Main navigation widget with bottom navigation bar for StatefulShellRoute
class MainNavigation extends StatelessWidget {
  const MainNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentIndex = navigationShell.currentIndex;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: AppSpacing.bottomNavHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'navigation.home'.tr(),
                isActive: currentIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              _buildNavItem(
                context,
                icon: Icons.note_outlined,
                activeIcon: Icons.note,
                label: 'navigation.notes'.tr(),
                isActive: currentIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              _buildNavItem(
                context,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: 'navigation.search'.tr(),
                isActive: currentIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              _buildNavItem(
                context,
                icon: Icons.folder_outlined,
                activeIcon: Icons.folder,
                label: 'organize.title'.tr(),
                isActive: currentIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
              _buildNavItem(
                context,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'navigation.settings'.tr(),
                isActive: currentIndex == 4,
                onTap: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    navigationShell.goBranch(index);
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isActive 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 