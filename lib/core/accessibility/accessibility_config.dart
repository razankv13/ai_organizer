import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension for easier access to math pow
import 'dart:math' as math;

/// Accessibility configuration and feature flags
///
/// Manages accessibility settings including high contrast mode,
/// screen reader detection, and accessibility preferences.
class AccessibilityConfig {
  AccessibilityConfig._();

  // ===== FEATURE FLAGS =====

  /// Enable high contrast mode globally
  static bool _highContrastEnabled = false;

  /// Enable reduced motion for animations
  static bool _reducedMotionEnabled = false;

  /// Enable larger touch targets (increased from 44dp to 48dp)
  static bool _largerTouchTargets = false;

  // ===== GETTERS =====

  static bool get isHighContrastEnabled => _highContrastEnabled;
  static bool get isReducedMotionEnabled => _reducedMotionEnabled;
  static bool get isLargerTouchTargetsEnabled => _largerTouchTargets;

  // ===== SETTERS =====

  static void setHighContrastMode(bool enabled) {
    _highContrastEnabled = enabled;
  }

  static void setReducedMotion(bool enabled) {
    _reducedMotionEnabled = enabled;
  }

  static void setLargerTouchTargets(bool enabled) {
    _largerTouchTargets = enabled;
  }

  // ===== SCREEN READER DETECTION =====

  /// Check if a screen reader is currently active
  /// Returns true if TalkBack (Android) or VoiceOver (iOS) is running
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if bold text is enabled in system settings
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Get current text scale factor for dynamic type
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Check if text scale factor is above normal (accessibility mode)
  static bool isLargeTextEnabled(BuildContext context) {
    return getTextScaleFactor(context) > 1.3;
  }

  // ===== TOUCH TARGET SIZES =====

  /// Minimum touch target size (default: 44dp per iOS HIG)
  static const double minTouchTarget = 44.0;

  /// Larger touch target size for accessibility mode (48dp)
  static const double largeTouchTarget = 48.0;

  /// Get appropriate touch target size based on settings
  static double getTouchTargetSize() {
    return _largerTouchTargets ? largeTouchTarget : minTouchTarget;
  }

  // ===== ANIMATION DURATIONS =====

  /// Get animation duration considering reduced motion setting
  static Duration getAnimationDuration(Duration defaultDuration) {
    if (_reducedMotionEnabled) {
      return Duration.zero;
    }
    return defaultDuration;
  }

  /// Fast animation duration (or zero if reduced motion)
  static Duration get fastAnimation => getAnimationDuration(const Duration(milliseconds: 150));

  /// Normal animation duration (or zero if reduced motion)
  static Duration get normalAnimation => getAnimationDuration(const Duration(milliseconds: 250));

  /// Slow animation duration (or zero if reduced motion)
  static Duration get slowAnimation => getAnimationDuration(const Duration(milliseconds: 350));

  // ===== HAPTIC FEEDBACK =====

  /// Provide haptic feedback for button presses
  static void buttonHaptic() {
    HapticFeedback.lightImpact();
  }

  /// Provide haptic feedback for selections
  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  /// Provide haptic feedback for errors
  static void errorHaptic() {
    HapticFeedback.heavyImpact();
  }

  /// Provide haptic feedback for success
  static void successHaptic() {
    HapticFeedback.mediumImpact();
  }

  // ===== FOCUS MANAGEMENT =====

  /// Request focus on a widget (useful for keyboard navigation)
  static void requestFocus(FocusNode focusNode) {
    focusNode.requestFocus();
  }

  /// Clear focus (dismiss keyboard)
  static void clearFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

/// High contrast color variants for accessibility
///
/// Provides WCAG AAA compliant color combinations
/// for users who need higher contrast ratios.
class HighContrastColors {
  HighContrastColors._();

  // ===== LIGHT THEME HIGH CONTRAST =====

  // Background colors (pure white for maximum contrast)
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  // Text colors (pure black for maximum contrast)
  static const Color lightPrimaryText = Color(0xFF000000);
  static const Color lightSecondaryText = Color(0xFF000000);
  static const Color lightTertiaryText = Color(0xFF3D3D3D);

  // Border colors (strong borders)
  static const Color lightBorder = Color(0xFF000000);
  static const Color lightDivider = Color(0xFF666666);

  // Primary colors (higher contrast blue)
  static const Color lightPrimary = Color(0xFF0051A3); // Darker blue
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD6E4FF);

  // Secondary colors (higher contrast purple)
  static const Color lightSecondary = Color(0xFF4A148C); // Darker purple
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  // Error colors (higher contrast red)
  static const Color lightError = Color(0xFFC62828); // Darker red
  static const Color lightOnError = Color(0xFFFFFFFF);

  // ===== DARK THEME HIGH CONTRAST =====

  // Background colors (pure black for maximum contrast)
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF000000);
  static const Color darkCardBackground = Color(0xFF121212);

  // Text colors (pure white for maximum contrast)
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFFFFFFF);
  static const Color darkTertiaryText = Color(0xFFCCCCCC);

  // Border colors (strong borders)
  static const Color darkBorder = Color(0xFFFFFFFF);
  static const Color darkDivider = Color(0xFFAAAAAA);

  // Primary colors (brighter blue for dark background)
  static const Color darkPrimary = Color(0xFF82B1FF); // Lighter blue
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkPrimaryContainer = Color(0xFF0051A3);

  // Secondary colors (brighter purple for dark background)
  static const Color darkSecondary = Color(0xFFB388FF); // Lighter purple
  static const Color darkOnSecondary = Color(0xFF000000);

  // Error colors (brighter red for dark background)
  static const Color darkError = Color(0xFFFF5252); // Lighter red
  static const Color darkOnError = Color(0xFF000000);

  // ===== CONTRAST RATIO HELPERS =====

  /// Calculate contrast ratio between two colors (WCAG standard)
  /// Returns a value between 1 and 21
  /// - Level AA: minimum 4.5:1 for normal text, 3:1 for large text
  /// - Level AAA: minimum 7:1 for normal text, 4.5:1 for large text
  static double contrastRatio(Color foreground, Color background) {
    final fgLum = _relativeLuminance(foreground);
    final bgLum = _relativeLuminance(background);

    final lighter = fgLum > bgLum ? fgLum : bgLum;
    final darker = fgLum > bgLum ? bgLum : fgLum;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double channel) {
    if (channel <= 0.03928) {
      return channel / 12.92;
    }
    return ((channel + 0.055) / 1.055).pow(2.4);
  }

  /// Check if color combination meets WCAG AA standard
  static bool meetsWCAG_AA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Check if color combination meets WCAG AAA standard
  static bool meetsWCAG_AAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }
}

/// Extension for math operations (pow)
extension on double {
  double pow(num exponent) {
    return (this as num).pow(exponent).toDouble();
  }
}

extension NumPow on num {
  num pow(num exponent) => math.pow(this, exponent);
}
