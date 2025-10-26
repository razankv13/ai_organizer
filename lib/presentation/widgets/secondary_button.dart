import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:flutter/material.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Secondary/text button for less prominent actions
///
/// Styled as a text button with optional custom color.
/// Used for secondary actions like "Skip" or "Cancel".
/// Meets minimum touch target requirements (44x44dp).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: text,
      button: true,
      enabled: onPressed != null,
      child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(
          AppSpacing.minTouchTarget,
          AppSpacing.minTouchTarget,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      child: Text(
        text,
        style: textTheme.labelLarge?.copyWith(
          color: textColor ?? colorScheme.primary,
        ),
      ),
      ),
    );
  }
}
