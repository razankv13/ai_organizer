import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:flutter/material.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Search bar used at the top of list screens
/// Follows UI/UX guidelines for minimal design with subtle borders
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search your notes...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.margin,
  });
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: SemanticLabels.searchIcon,
      hint: hintText,
      textField: true,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          autofocus: autofocus,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ),
    );
  }
}
