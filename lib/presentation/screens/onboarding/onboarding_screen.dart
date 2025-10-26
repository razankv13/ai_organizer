import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/presentation/widgets/primary_button.dart';
import 'package:ai_organizer/presentation/widgets/secondary_button.dart';

/// Onboarding screen with swipeable feature pages
///
/// Displays a multi-page carousel showcasing app features:
/// 1. Capture Everything
/// 2. AI Organization
/// 3. Smart Search
/// 4. Welcome & Get Started
///
/// Strictly follows UI/UX guidelines with proper theme usage.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Total number of pages
  static const int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: AppSpacing.animationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: AppSpacing.animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _getStarted() {
    context.go(AppRoutes.home);
  }

  void _skip() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (top-right)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                right: AppSpacing.md,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: SecondaryButton(
                  text: 'onboarding.skip'.tr(),
                  onPressed: _skip,
                  textColor: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // PageView with feature pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildFeaturePage(
                    icon: Icons.note_add,
                    title: 'onboarding.feature1Title'.tr(),
                    description: 'onboarding.feature1Description'.tr(),
                    useSecondaryColor: false,
                  ),
                  _buildFeaturePage(
                    icon: Icons.auto_awesome,
                    title: 'onboarding.feature2Title'.tr(),
                    description: 'onboarding.feature2Description'.tr(),
                    useSecondaryColor: true, // AI feature uses secondary color
                  ),
                  _buildFeaturePage(
                    icon: Icons.search,
                    title: 'onboarding.feature3Title'.tr(),
                    description: 'onboarding.feature3Description'.tr(),
                    useSecondaryColor: false,
                  ),
                  _buildWelcomePage(),
                ],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: _buildPageIndicators(),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenHorizontal,
                right: AppSpacing.screenHorizontal,
                bottom: AppSpacing.xl,
              ),
              child: _buildNavigationButtons(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a feature showcase page
  Widget _buildFeaturePage({
    required IconData icon,
    required String title,
    required String description,
    required bool useSecondaryColor,
  }) {
    // Extract theme data
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature icon with colored background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: useSecondaryColor
                  ? colorScheme.secondaryContainer
                  : colorScheme.primaryContainer,
              shape: BoxShape.circle,
              boxShadow: AppShadows.cardShadow,
            ),
            child: Icon(
              icon,
              size: 64,
              color: useSecondaryColor
                  ? colorScheme.secondary
                  : colorScheme.primary,
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Feature title
          Text(
            title,
            style: textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Feature description
          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the final welcome page
  Widget _buildWelcomePage() {
    // Extract theme data
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon/logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: AppShadows.cardElevatedShadow,
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 56,
              color: colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Welcome title
          Text(
            'onboarding.welcome'.tr(),
            style: textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Subtitle
          Text(
            'onboarding.subtitle'.tr(),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the page indicator dots
  Widget _buildPageIndicators() {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _totalPages,
        (index) => AnimatedContainer(
          duration: AppSpacing.fastAnimation,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          ),
        ),
      ),
    );
  }

  /// Builds the navigation buttons (Next/Get Started)
  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _totalPages - 1;

    return Row(
      children: [
        // Back button (only show if not on first page)
        if (_currentPage > 0)
          Expanded(
            child: SecondaryButton(
              text: 'common.previous'.tr(),
              onPressed: _previousPage,
            ),
          ),

        if (_currentPage > 0) const SizedBox(width: AppSpacing.md),

        // Next/Get Started button
        Expanded(
          flex: _currentPage > 0 ? 1 : 2,
          child: PrimaryButton(
            text: isLastPage
                ? 'onboarding.getStarted'.tr()
                : 'common.next'.tr(),
            onPressed: _nextPage,
            icon: isLastPage ? Icons.arrow_forward : null,
          ),
        ),
      ],
    );
  }
}
