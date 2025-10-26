import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Primary action button following UI/UX guidelines
///
/// Styled with primary color background, white text, and consistent sizing.
/// Includes loading state support and optional icon.
/// Meets minimum touch target requirements (44x44dp).
class PrimaryButton extends StatelessWidget {

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Semantic label for screen readers
    final semanticLabel = isLoading
        ? SemanticLabels.saveButtonWithState(true)
        : text;

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: !isLoading && onPressed != null,
      child: SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          padding: AppSpacing.buttonPadding,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    text,
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
      ),
      ),
    );
  }
}
