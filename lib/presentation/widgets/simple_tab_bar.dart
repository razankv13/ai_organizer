import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:flutter/material.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Simple tab bar with underline indicator
/// Follows UI/UX guidelines for minimal tab design
class SimpleTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SimpleTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          final tabLabel = SemanticLabels.toggleButton(
            label: tabs[index],
            isOn: isSelected,
          );

          return Expanded(
            child: Semantics(
              label: tabLabel,
              button: true,
              selected: isSelected,
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? colorScheme.onSurface
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
