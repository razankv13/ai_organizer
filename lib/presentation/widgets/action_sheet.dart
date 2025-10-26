import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Dark modal action sheet for contextual actions
/// Follows UI/UX guidelines for dark bottom sheet design
class ActionSheet extends StatelessWidget {
  const ActionSheet({super.key, this.title, required this.items});
  final String? title;
  final List<ActionSheetItem> items;

  /// Shows the action sheet as a modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required List<ActionSheetItem> items,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ActionSheet(title: title, items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data once at the top for efficiency and consistency
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomSheetTheme = Theme.of(context).bottomSheetTheme;

    // Modal background color from theme (dark gray #3A3A3A for light theme)
    final modalBackground = bottomSheetTheme.modalBackgroundColor ?? colorScheme.surface;

    // Text color for dark modal background (white)
    // Using white directly since this is a special inverse modal design
    const modalTextColor = Colors.white;

    // Handle indicator color (medium gray on dark background)
    final handleColor = Colors.white.withOpacity(0.4);

    // Destructive color from theme
    final destructiveColor = colorScheme.error;

    // Build semantic label for action sheet
    final semanticLabel = title != null
        ? SemanticLabels.bottomSheetLabel(title!)
        : SemanticLabels.bottomSheetLabel('Actions');

    return Semantics(
      label: semanticLabel,
      namesRoute: true,
      scopesRoute: true,
      child: Container(
      decoration: BoxDecoration(
        color: modalBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
        boxShadow: AppShadows.modalShadow,
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
                color: handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title (if provided)
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  title!,
                  style: textTheme.titleMedium?.copyWith(color: modalTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],

            // Action items
            ...items.map((item) => _buildActionItem(context, item, modalTextColor, destructiveColor)),

            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    ActionSheetItem item,
    Color modalTextColor,
    Color destructiveColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: item.title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            item.onTap();
          },
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 22,
                color: item.isDestructive ? destructiveColor : modalTextColor,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  item.title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: item.isDestructive ? destructiveColor : modalTextColor,
                  ),
                ),
              ),
              if (item.trailing != null) item.trailing!,
            ],
          ),
        ),
        ),
      ),
    );
  }
}

/// Action sheet item configuration
class ActionSheetItem {
  const ActionSheetItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;
}
