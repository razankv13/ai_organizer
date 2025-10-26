import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Empty state component for list screens
///
/// Displays an icon, title, message, and optional action button
/// following the UI/UX guidelines for empty states.
class EmptyState extends StatelessWidget {

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Build semantic label for empty state announcement
    final semanticLabel = '$title. $message${actionText != null ? '. $actionText' : ''}';

    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      child: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Large icon with light color
            Icon(
              icon,
              size: 64,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              title,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Message
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional action button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: textTheme.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
