import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Change Password Screen - allows users to update their password
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSaving = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;

      // Update password via Supabase Auth
      final userResponse = await supabase.auth.updateUser(
        UserAttributes(
          password: _newPasswordController.text.trim(),
        ),
      );

      if (userResponse.user != null) {
        if (mounted) {
          _showSnackBar('Password changed successfully');
          context.pop();
        }
      } else {
        throw Exception('Failed to update password');
      }
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
      setState(() {
        _errorMessage = e.message;
        _isSaving = false;
      });
      if (mounted) {
        _showSnackBar(e.message, isError: true);
      }
    } catch (e) {
      debugPrint('Failed to change password: $e');
      setState(() {
        _errorMessage = 'Failed to change password: $e';
        _isSaving = false;
      });
      if (mounted) {
        _showSnackBar('Failed to change password', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: isError ? colorScheme.onError : colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Change Password',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Your new password must be at least 8 characters long',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // New Password
              Text(
                'New Password',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
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
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 4,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Confirm Password
              Text(
                'Confirm New Password',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
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
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 4,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xxxl),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: _isSaving
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
                      : Text(
                          'Change Password',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
