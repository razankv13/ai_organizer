import 'package:ai_organizer/core/theme/app_colors.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/core/theme/app_typography.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Signup screen for user registration with minimalist, iOS-inspired design
/// Following UI/UX guidelines: light theme, clean cards, subtle interactions
/// Uses Theme.of(context) for all color access (proper theming approach)
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  // Button press states for scale animation
  bool _isCreateAccountButtonPressed = false;
  bool _isGoogleButtonPressed = false;

  // Animation controllers for premium entrance effects
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Logo micro-animation controller for premium onboarding effect
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;

  // Sign-in link delayed animation for staggered entrance
  late AnimationController _signInLinkAnimationController;
  late Animation<double> _signInLinkFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppSpacing.animationDuration, // 250ms
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Logo micro-animation with elastic curve for delightful onboarding
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Sign-in link delayed fade for staggered visual hierarchy
    _signInLinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _signInLinkFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _signInLinkAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations with staggered timing for premium visual hierarchy
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _logoAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _signInLinkAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    _signInLinkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  const SizedBox(height: AppSpacing.xl),

                  // App branding
                  _buildBranding(colorScheme),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Signup form card
                  _buildSignupCard(theme, colorScheme),

                  const SizedBox(height: AppSpacing.xl),

                  // Sign in link
                  _buildSignInLink(colorScheme),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(ColorScheme colorScheme) {
    return Column(
      children: [
        // Logo with premium micro-animation and ambient glow
        ScaleTransition(
          scale: _logoScaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              // Multi-layer shadow for premium ambient glow effect
              boxShadow: [
                // Tight shadow
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                // Medium glow
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
                // Wide ambient glow
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.note_alt_outlined, size: 48, color: colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          'Create Your Account',
          style: AppTypography.displayLarge(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Subtitle
        Text(
          'Join AI Organizer to streamline your productivity',
          style: AppTypography.bodyMedium(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignupCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd), // 16dp for premium look
        boxShadow: AppShadows.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name field
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              theme: theme,
              colorScheme: colorScheme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              theme: theme,
              colorScheme: colorScheme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Password field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a password',
              icon: Icons.lock_outline,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.next,
              theme: theme,
              colorScheme: colorScheme,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  size: AppSpacing.iconSize,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Confirm password field
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Confirm your password',
              icon: Icons.lock_outline,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              theme: theme,
              colorScheme: colorScheme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Terms notice
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'By signing up, you agree to our Terms of Service and Privacy Policy',
                      style: AppTypography.bodySmall(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTypography.bodySmall(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Create account button
            _buildPrimaryButton(colorScheme),

            const SizedBox(height: AppSpacing.lg),

            // Divider
            _buildDivider(colorScheme),

            const SizedBox(height: AppSpacing.lg),

            // Google sign in button
            _buildGoogleButton(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required FormFieldValidator<String> validator,
    required ThemeData theme,
    required ColorScheme colorScheme,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium(color: colorScheme.onSurfaceVariant),
        hintText: hint,
        hintStyle: AppTypography.bodyMedium(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant, size: AppSpacing.iconSize),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      style: AppTypography.bodyMedium(color: colorScheme.onSurface),
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      cursorColor: colorScheme.primary,
      validator: validator,
    );
  }

  Widget _buildPrimaryButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTapDown: (_isLoading)
          ? null
          : (_) {
              setState(() => _isCreateAccountButtonPressed = true);
              HapticFeedback.lightImpact();
            },
      onTapUp: (_isLoading)
          ? null
          : (_) => setState(() => _isCreateAccountButtonPressed = false),
      onTapCancel: () => setState(() => _isCreateAccountButtonPressed = false),
      child: AnimatedScale(
        scale: _isCreateAccountButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create Account', style: AppTypography.button(color: colorScheme.onPrimary)),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('OR', style: AppTypography.labelSmall(color: colorScheme.onSurfaceVariant)),
        ),
        Expanded(child: Container(height: 1, color: colorScheme.outlineVariant)),
      ],
    );
  }

  Widget _buildGoogleButton(ColorScheme colorScheme) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : () => _signUpWithProvider(OAuthProvider.google),
        icon: Icon(Icons.g_mobiledata, size: 24, color: colorScheme.onSurface),
        label: Text(
          'Continue with Google',
          style: AppTypography.labelLarge(color: colorScheme.onSurface),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          backgroundColor: colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildSignInLink(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppTypography.bodyMedium(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: _isLoading ? null : _navigateToSignIn,
          child: Text(
            'Sign In',
            style: AppTypography.labelLarge(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);

      // User metadata for profile creation
      final userData = {'full_name': _fullNameController.text.trim()};

      final response = await authActions.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userData: userData,
      );

      if (response.user != null) {
        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Account created successfully! Please check your email to confirm your account.',
                style: AppTypography.bodyMedium(color: colorScheme.onPrimary),
              ),
              backgroundColor: AppColors.lightSuccess, // Success color not in theme, keep AppColors
            ),
          );

          // Navigate back to sign in
          _navigateToSignIn();
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to create account. Please try again.';
        });
      }
    } on AuthException catch (e, stackTrace) {
      debugPrint('AuthException: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUpWithProvider(OAuthProvider provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      await authActions.signInWithOAuth(provider);
      // Navigation will be handled by auth state listener
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred with social login. Please try again.';
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSignIn() {
    context.pop();
  }
}
