import 'package:flutter/material.dart';

/// Minimalist color system for AI Organizer App
/// Based on iOS-inspired light theme with clean, professional aesthetics
class AppColors {
  AppColors._();

  // ===== LIGHT THEME COLORS =====

  /// Background colors for light theme
  static const Color lightBackground = Color(0xFFF5F5F5);  // Light gray background
  static const Color lightCardBackground = Color(0xFFFFFFFF);  // White cards
  static const Color lightSurfaceBackground = Color(0xFFFAFAFA);  // Slightly off-white surface

  /// Primary brand colors for light theme (iOS Blue)
  static const Color lightPrimary = Color(0xFF007AFF);
  static const Color lightPrimaryContainer = Color(0xFFD3E4FD);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnPrimaryContainer = Color(0xFF001B3D);

  /// Secondary colors for light theme (Purple for AI/special features)
  static const Color lightSecondary = Color(0xFF5856D6);
  static const Color lightSecondaryContainer = Color(0xFFE8E7FF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnSecondaryContainer = Color(0xFF1A1A3D);

  /// Tertiary colors (kept for compatibility)
  static const Color lightTertiary = Color(0xFF5856D6);
  static const Color lightTertiaryContainer = Color(0xFFE8E7FF);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnTertiaryContainer = Color(0xFF1A1A3D);

  /// Text colors for light theme (hierarchical)
  static const Color lightPrimaryText = Color(0xFF1A1A1A);  // Near-black for titles
  static const Color lightSecondaryText = Color(0xFF6B6B6B);  // Medium gray for body text
  static const Color lightTertiaryText = Color(0xFF8E8E8E);  // Light gray for metadata
  static const Color lightPlaceholderText = Color(0xFFB0B0B0);  // Very light gray for hints

  /// Surface colors for light theme (simplified)
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF6B6B6B);

  /// Borders & Dividers for light theme
  static const Color lightBorderColor = Color(0xFFE8E8E8);  // Very subtle borders
  static const Color lightDividerColor = Color(0xFFF0F0F0);  // Minimal dividers

  /// Outline colors for light theme
  static const Color lightOutline = Color(0xFFE8E8E8);
  static const Color lightOutlineVariant = Color(0xFFF0F0F0);

  /// Modal/Action Sheet colors for light theme
  static const Color lightModalBackground = Color(0xFF3A3A3A);  // Dark gray for action sheets
  static const Color lightModalText = Color(0xFFFFFFFF);  // White text on dark modals
  static const Color lightModalTextSecondary = Color(0xFFE0E0E0);  // Light gray for modal secondary text

  /// Interactive state colors for light theme
  static const Color lightPressedOverlay = Color(0x10000000);  // 6% black overlay for pressed state
  static const Color lightFocusedBorder = Color(0xFF007AFF);  // Blue border for focused inputs
  static const Color lightSelectedBackground = Color(0xFFF0F0F0);  // Light gray for selected items

  // ===== DARK THEME COLORS =====

  /// Primary brand colors for dark theme
  static const Color darkPrimary = Color(0xFF90CAF9);
  static const Color darkPrimaryContainer = Color(0xFF1565C0);
  static const Color darkOnPrimary = Color(0xFF001B3D);
  static const Color darkOnPrimaryContainer = Color(0xFFD3E4FD);

  /// Secondary colors for dark theme
  static const Color darkSecondary = Color(0xFFBA9AFF);
  static const Color darkSecondaryContainer = Color(0xFF3A2C6B);
  static const Color darkOnSecondary = Color(0xFF1A1A3D);
  static const Color darkOnSecondaryContainer = Color(0xFFE8E7FF);

  /// Tertiary colors for dark theme
  static const Color darkTertiary = Color(0xFFBA9AFF);
  static const Color darkTertiaryContainer = Color(0xFF3A2C6B);
  static const Color darkOnTertiary = Color(0xFF1A1A3D);
  static const Color darkOnTertiaryContainer = Color(0xFFE8E7FF);

  /// Background colors for dark theme
  static const Color darkBackground = Color(0xFF1A1A1A);  // Near-black background
  static const Color darkCardBackground = Color(0xFF2D2D2D);  // Dark gray cards
  static const Color darkSurfaceBackground = Color(0xFF252525);  // Slightly lighter surface

  /// Text colors for dark theme
  static const Color darkPrimaryText = Color(0xFFFFFFFF);  // White text
  static const Color darkSecondaryText = Color(0xFFB0B0B0);  // Light gray text
  static const Color darkTertiaryText = Color(0xFF8E8E8E);  // Medium gray for metadata

  /// Surface colors for dark theme
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkSurfaceVariant = Color(0xFF252525);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);

  /// Borders & Dividers for dark theme
  static const Color darkBorderColor = Color(0xFF3A3A3A);  // Subtle dark borders
  static const Color darkDividerColor = Color(0xFF303030);  // Dark dividers

  /// Outline colors for dark theme
  static const Color darkOutline = Color(0xFF3A3A3A);
  static const Color darkOutlineVariant = Color(0xFF303030);

  // ===== SEMANTIC COLORS =====

  /// Success colors
  static const Color lightSuccess = Color(0xFF34C759);
  static const Color lightSuccessContainer = Color(0xFFD1F4DB);
  static const Color darkSuccess = Color(0xFF66BB6A);
  static const Color darkSuccessContainer = Color(0xFF2E7D32);

  /// Warning colors
  static const Color lightWarning = Color(0xFFFFCC00);
  static const Color lightWarningContainer = Color(0xFFFFF9E6);
  static const Color darkWarning = Color(0xFFFFB74D);
  static const Color darkWarningContainer = Color(0xFFE65100);

  /// Error/Destructive colors
  static const Color lightError = Color(0xFFFF5454);
  static const Color lightErrorContainer = Color(0xFFFFE6E6);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkErrorContainer = Color(0xFFD32F2F);

  // ===== AI INTELLIGENCE INDICATORS =====

  /// AI feature colors for light theme
  static const Color lightAiPrimary = Color(0xFF007AFF);  // Use primary blue for AI
  static const Color lightAiContainer = Color(0xFFE8F5FF);  // Light blue background
  static const Color lightAiSurface = Color(0xFFF0F8FF);
  static const Color lightOnAi = Color(0xFF007AFF);

  /// AI feature colors for dark theme
  static const Color darkAiPrimary = Color(0xFF90CAF9);
  static const Color darkAiContainer = Color(0xFF1A3A4A);
  static const Color darkAiSurface = Color(0xFF253544);
  static const Color darkOnAi = Color(0xFF90CAF9);

  // ===== ACCESSIBILITY COLORS =====

  /// High contrast variants for accessibility
  static const Color highContrastLight = Color(0xFFFFFFFF);
  static const Color highContrastDark = Color(0xFF000000);
  static const Color highContrastPrimary = Color(0xFF007AFF);
  static const Color highContrastSecondary = Color(0xFF5856D6);

  // ===== UTILITY METHODS =====

  /// Get appropriate background color based on theme brightness
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  /// Get appropriate card background color based on theme brightness
  static Color getCardBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBackground : darkCardBackground;
  }

  /// Get appropriate surface background color based on theme brightness
  static Color getSurfaceBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSurfaceBackground : darkSurfaceBackground;
  }

  /// Get appropriate primary text color based on theme brightness
  static Color getPrimaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightPrimaryText : darkPrimaryText;
  }

  /// Get appropriate secondary text color based on theme brightness
  static Color getSecondaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryText : darkSecondaryText;
  }

  /// Get appropriate tertiary text color based on theme brightness
  static Color getTertiaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightTertiaryText : darkTertiaryText;
  }

  /// Get appropriate border color based on theme brightness
  static Color getBorderColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBorderColor : darkBorderColor;
  }

  /// Get appropriate divider color based on theme brightness
  static Color getDividerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightDividerColor : darkDividerColor;
  }

  /// Get AI accent color based on theme brightness
  static Color getAiAccentColor(Brightness brightness) {
    return brightness == Brightness.light ? lightAiPrimary : darkAiPrimary;
  }

  /// Get AI container color based on theme brightness
  static Color getAiContainerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightAiContainer : darkAiContainer;
  }

  /// Get semantic success color based on theme brightness
  static Color getSuccessColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSuccess : darkSuccess;
  }

  /// Get semantic warning color based on theme brightness
  static Color getWarningColor(Brightness brightness) {
    return brightness == Brightness.light ? lightWarning : darkWarning;
  }

  /// Get semantic error color based on theme brightness
  static Color getErrorColor(Brightness brightness) {
    return brightness == Brightness.light ? lightError : darkError;
  }
}

/// Material color swatches for theme generation
class AppColorSwatches {
  AppColorSwatches._();

  /// Primary color swatch (iOS Blue)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF007AFF,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF007AFF),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  /// Secondary/AI accent color swatch (Purple)
  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF5856D6,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(0xFF5856D6),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );
}
