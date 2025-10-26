import 'package:flutter/material.dart';

/// Minimalist spacing system for AI Organizer App
/// Based on 4dp grid system with clean, professional aesthetics
class AppSpacing {
  AppSpacing._();

  // ===== BASE SPACING VALUES =====

  /// Micro spacing - 2dp
  static const double xxxs = 2.0;

  /// Extra extra small spacing - 4dp
  static const double xxs = 4.0;

  /// Extra small spacing - 8dp
  static const double xs = 8.0;

  /// Small spacing - 12dp
  static const double sm = 12.0;

  /// Medium spacing - 16dp (base unit)
  static const double md = 16.0;

  /// Large spacing - 20dp
  static const double lg = 20.0;

  /// Extra large spacing - 24dp
  static const double xl = 24.0;

  /// Extra extra large spacing - 32dp
  static const double xxl = 32.0;

  /// Extra extra extra large spacing - 40dp
  static const double xxxl = 40.0;

  // ===== BORDER RADIUS VALUES =====

  /// Extra small border radius - 8dp
  static const double radiusXs = 8.0;

  /// Small border radius - 12dp (standard for most cards)
  static const double radiusSm = 12.0;

  /// Medium border radius - 16dp
  static const double radiusMd = 16.0;

  /// Large border radius - 20dp
  static const double radiusLg = 20.0;

  /// Extra large border radius - 24dp
  static const double radiusXl = 24.0;

  // ===== COMPONENT SPECIFIC SPACING =====

  /// Card padding
  static const double cardPadding = md;

  /// Card margin
  static const double cardMargin = xs;

  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: sm,
  );

  /// List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.all(md);

  /// Screen horizontal padding
  static const double screenHorizontal = md;

  /// Screen vertical padding
  static const double screenVertical = md;

  /// List item spacing (gap between items)
  static const double listItemSpacing = xs;

  /// App bar height
  static const double appBarHeight = 56.0;

  /// Bottom navigation height
  static const double bottomNavHeight = 80.0;

  /// FAB margin
  static const double fabMargin = md;

  /// Divider spacing
  static const double dividerSpacing = md;

  // ===== LAYOUT CONSTANTS =====

  /// Maximum content width (for large screens)
  static const double maxContentWidth = 800.0;

  /// Minimum touch target size (iOS/Material Design)
  static const double minTouchTarget = 44.0;

  /// Standard icon size
  static const double iconSize = 24.0;

  /// Small icon size
  static const double iconSizeSmall = 20.0;

  /// Large icon size
  static const double iconSizeLarge = 32.0;

  // ===== DEPRECATED (kept for compatibility) =====

  @Deprecated('Use radiusSm instead')
  static const double borderRadius = radiusSm;

  @Deprecated('Use radiusXs instead')
  static const double borderRadiusSmall = radiusXs;

  @Deprecated('Use radiusMd instead')
  static const double borderRadiusLarge = radiusMd;

  @Deprecated('Use radiusXl instead')
  static const double borderRadiusXL = radiusXl;

  @Deprecated('Use AppShadows.cardElevation instead')
  static const double elevation = 2.0;

  @Deprecated('Use AppShadows.cardElevationHigh instead')
  static const double elevationHigh = 8.0;

  @Deprecated('Use AppShadows.none instead')
  static const double elevationLow = 1.0;

  // ===== ANIMATION DURATIONS =====

  /// Fast animation duration - 150ms
  static const Duration fastAnimation = Duration(milliseconds: 150);

  /// Standard animation duration - 250ms
  static const Duration animationDuration = Duration(milliseconds: 250);

  /// Slow animation duration - 350ms
  static const Duration slowAnimation = Duration(milliseconds: 350);

  /// Stagger delay for list animations
  static const Duration staggerDelay = Duration(milliseconds: 50);

  // ===== RESPONSIVE SPACING METHODS =====

  /// Get responsive spacing based on screen width
  ///
  /// [mobile] - spacing for mobile screens (< 600dp)
  /// [tablet] - spacing for tablet screens (600-1200dp)
  /// [desktop] - spacing for desktop screens (> 1200dp)
  static double responsive(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return mobile;
    } else if (width < 1200) {
      return tablet ?? mobile * 1.25;
    } else {
      return desktop ?? mobile * 1.5;
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets responsiveHorizontal(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context,
        mobile: screenHorizontal,
        tablet: lg,
        desktop: xl,
      ),
    );
  }

  /// Get responsive vertical padding
  static EdgeInsets responsiveVertical(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: responsive(
        context,
        mobile: screenVertical,
        tablet: lg,
        desktop: xl,
      ),
    );
  }

  /// Get responsive screen padding
  static EdgeInsets responsiveScreen(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context,
        mobile: screenHorizontal,
        tablet: lg,
        desktop: xl,
      ),
      vertical: responsive(
        context,
        mobile: screenVertical,
        tablet: lg,
        desktop: xl,
      ),
    );
  }

  // ===== SAFE AREA METHODS =====

  /// Get safe area padding
  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get safe area aware top padding
  static double safeTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get safe area aware bottom padding
  static double safeBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get safe area aware horizontal padding
  static EdgeInsets safeHorizontal(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      left: padding.left + screenHorizontal,
      right: padding.right + screenHorizontal,
    );
  }

  /// Get safe area aware screen padding
  static EdgeInsets safeScreen(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      left: padding.left + screenHorizontal,
      right: padding.right + screenHorizontal,
      top: padding.top + screenVertical,
      bottom: padding.bottom + screenVertical,
    );
  }
}

/// Shadow system for minimalist design
class AppShadows {
  AppShadows._();

  /// Subtle card shadow (primary) - 4% black, 8px blur, 2px offset
  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x0A000000), // 4% black
          blurRadius: 8,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Elevated card shadow (on press/focus) - 8% black, 12px blur, 4px offset
  static List<BoxShadow> get cardElevatedShadow => [
        const BoxShadow(
          color: Color(0x14000000), // 8% black
          blurRadius: 12,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Action sheet / modal shadow - 20% black, 24px blur, -4px offset
  static List<BoxShadow> get modalShadow => [
        const BoxShadow(
          color: Color(0x33000000), // 20% black
          blurRadius: 24,
          offset: Offset(0, -4),
          spreadRadius: 0,
        ),
      ];

  /// No shadow (flat)
  static List<BoxShadow> get none => [];

  /// Elevation values for compatibility (use shadows instead)
  static const double cardElevation = 1.0;
  static const double cardElevationHigh = 2.0;
  static const double modalElevation = 4.0;
}

/// Helper extension for responsive spacing
extension ResponsiveSpacing on BuildContext {
  /// Get responsive spacing
  double spacing({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return AppSpacing.responsive(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive horizontal padding
  EdgeInsets get horizontalPadding => AppSpacing.responsiveHorizontal(this);

  /// Get responsive vertical padding
  EdgeInsets get verticalPadding => AppSpacing.responsiveVertical(this);

  /// Get responsive screen padding
  EdgeInsets get screenPadding => AppSpacing.responsiveScreen(this);

  /// Get safe area padding
  EdgeInsets get safePadding => AppSpacing.safeArea(this);

  /// Get safe area aware screen padding
  EdgeInsets get safeScreenPadding => AppSpacing.safeScreen(this);
}
