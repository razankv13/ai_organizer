import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_colors.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/core/theme/app_typography.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Login screen with clean, minimalist design following UI/UX guidelines
/// Strictly adheres to centralized theme system using Theme.of(context)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  // Button press states for scale animation
  bool _isSignInButtonPressed = false;
  bool _isGoogleButtonPressed = false;

  // Animation controller for subtle entrance animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Logo micro-animation controller for premium onboarding effect
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;

  // Sign up link delayed animation for staggered entrance
  late AnimationController _signUpLinkAnimationController;
  late Animation<double> _signUpLinkFadeAnimation;

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

    // Sign up link delayed fade for staggered visual hierarchy
    _signUpLinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _signUpLinkFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _signUpLinkAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations with staggered timing for premium visual hierarchy
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _logoAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _signUpLinkAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    _signUpLinkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.08),

                    // Logo and branding
                    _buildBranding(theme, colorScheme),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Login card
                    _buildLoginCard(theme, colorScheme),

                    const SizedBox(height: AppSpacing.xl),

                    // Sign up link with delayed fade for staggered entrance
                    FadeTransition(
                      opacity: _signUpLinkFadeAnimation,
                      child: _buildSignUpLink(theme, colorScheme),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Logo with premium micro-animation and ambient glow
        ScaleTransition(
          scale: _logoScaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
            child: Icon(
              Icons.note_alt_outlined,
              size: AppSpacing.iconSizeLarge + AppSpacing.md,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // App name
        Text(
          'AI Organizer',
          style: AppTypography.displayLarge(
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        // Tagline
        Text(
          'Your intelligent note-taking companion',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd), // 16dp for premium look
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome text
              Text(
                'Welcome Back',
                style: AppTypography.displayMedium(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign in to continue to your account',
                style: AppTypography.bodyMedium(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Email field
              _buildTextField(
                theme: theme,
                colorScheme: colorScheme,
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Password field
              _buildTextField(
                theme: theme,
                colorScheme: colorScheme,
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSpacing.iconSizeSmall,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : _forgotPassword,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: EdgeInsets.zero,
                    foregroundColor: colorScheme.primary,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.labelMedium(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),

              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                        size: AppSpacing.iconSizeSmall - 2,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodySmall(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Sign in button
              _buildSignInButton(colorScheme),

              const SizedBox(height: AppSpacing.xl),

              // Premium divider with refined styling
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.outline.withValues(alpha: 0.0),
                            colorScheme.outline.withValues(alpha: 0.3),
                            colorScheme.outline.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'OR',
                      style: AppTypography.labelSmall(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.outline.withValues(alpha: 0.5),
                            colorScheme.outline.withValues(alpha: 0.3),
                            colorScheme.outline.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Google sign in
              _buildGoogleSignInButton(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: AppTypography.bodyLarge(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTypography.bodyMedium(
          color: colorScheme.onSurfaceVariant,
        ),
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: colorScheme.onSurfaceVariant,
          size: AppSpacing.iconSize - 2,
        ),
        suffixIcon: suffixIcon,
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
    );
  }

  Widget _buildSignInButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTapDown: (_isLoading)
          ? null
          : (_) {
              setState(() => _isSignInButtonPressed = true);
              HapticFeedback.lightImpact();
            },
      onTapUp: (_isLoading)
          ? null
          : (_) => setState(() => _isSignInButtonPressed = false),
      onTapCancel: () => setState(() => _isSignInButtonPressed = false),
      child: AnimatedScale(
        scale: _isSignInButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor:
                  colorScheme.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor:
                  colorScheme.onSurface.withValues(alpha: 0.38),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: _isLoading
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
                    'Sign In',
                    style: AppTypography.labelLarge(
                      color: colorScheme.onPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTapDown: (_isLoading)
          ? null
          : (_) {
              setState(() => _isGoogleButtonPressed = true);
              HapticFeedback.lightImpact();
            },
      onTapUp: (_isLoading)
          ? null
          : (_) => setState(() => _isGoogleButtonPressed = false),
      onTapCancel: () => setState(() => _isGoogleButtonPressed = false),
      child: AnimatedScale(
        scale: _isGoogleButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () => _signInWithProvider(OAuthProvider.google),
            icon: SizedBox(
              width: AppSpacing.iconSizeSmall,
              height: AppSpacing.iconSizeSmall,
              child: Image.network(
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                width: AppSpacing.iconSizeSmall,
                height: AppSpacing.iconSizeSmall,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata,
                  size: AppSpacing.iconSizeSmall,
                ),
              ),
            ),
            label: Text(
              'Continue with Google',
              style: AppTypography.labelMedium(
                color: colorScheme.onSurface,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              side: BorderSide(
                color: colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              backgroundColor: colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: AppTypography.bodyMedium(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _navigateToSignUp,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          ),
          child: Text(
            'Sign Up',
            style: AppTypography.labelMedium(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      final response = await authActions.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.user != null) {
        if (mounted) {
          context.go(AppRoutes.home);
        }
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      await authActions.signInWithOAuth(provider);
      // Navigation will be handled by the auth state listener
    } catch (e) {
      setState(() {
        _errorMessage =
            'An error occurred with social login. Please try again.';
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSignUp() {
    context.push(AppRoutes.signup);
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email to reset password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      await authActions.resetPassword(email);

      if (mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password reset email sent'),
            backgroundColor: AppColors.getSuccessColor(colorScheme.brightness),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send reset email. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
