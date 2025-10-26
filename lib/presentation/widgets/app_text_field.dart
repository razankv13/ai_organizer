import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Standard input field for forms following UI/UX guidelines
///
/// Styled with theme colors, proper borders, and consistent sizing.
/// Supports validation, icons, and multi-line input.
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.readOnly = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Build semantic label for screen readers
    final semanticLabel = SemanticLabels.textFieldLabel(
      label: widget.labelText ?? widget.hintText ?? 'Text input',
      isRequired: widget.validator != null,
      errorMessage: _errorMessage,
    );

    return Semantics(
      label: semanticLabel,
      textField: true,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: (value) {
          final error = widget.validator?.call(value);
          setState(() => _errorMessage = error);
          return error;
        },
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        textCapitalization: widget.textCapitalization,
      style: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintText: widget.hintText,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                )
              : null,
          suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        ),
      ),
    );
  }
}
