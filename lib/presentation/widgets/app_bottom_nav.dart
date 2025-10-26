import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation bar for the app
class AppBottomNav extends StatelessWidget {
  
  /// Factory constructor to create bottom nav based on current route
  factory AppBottomNav.fromRoute(String route) {
    int index;
    
    if (route.startsWith('/notes')) {
      index = 1;
    } else if (route.startsWith('/profile')) {
      index = 2;
    } else {
      index = 0; // Home by default
    }
    
    return AppBottomNav(currentIndex: index);
  }
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: theme.textTheme.labelSmall,
          items: [
            BottomNavigationBarItem(
              icon: Semantics(
                label: currentIndex == 0
                    ? '${SemanticLabels.homeTab}, selected'
                    : SemanticLabels.homeTab,
                button: true,
                selected: currentIndex == 0,
                child: const Icon(Icons.home_outlined),
              ),
              activeIcon: Semantics(
                label: '${SemanticLabels.homeTab}, selected',
                button: true,
                selected: true,
                child: const Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: currentIndex == 1
                    ? '${SemanticLabels.notesTab}, selected'
                    : SemanticLabels.notesTab,
                button: true,
                selected: currentIndex == 1,
                child: const Icon(Icons.note_outlined),
              ),
              activeIcon: Semantics(
                label: '${SemanticLabels.notesTab}, selected',
                button: true,
                selected: true,
                child: const Icon(Icons.note),
              ),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: currentIndex == 2
                    ? 'Profile tab, selected'
                    : 'Profile tab',
                button: true,
                selected: currentIndex == 2,
                child: const Icon(Icons.person_outline),
              ),
              activeIcon: Semantics(
                label: 'Profile tab, selected',
                button: true,
                selected: true,
                child: const Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    // Skip if already on the tapped page
    if (index == currentIndex) return;
    
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/notes');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
} 