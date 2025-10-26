import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_organizer/core/theme/app_colors.dart';
import 'package:ai_organizer/core/theme/app_typography.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/core/accessibility/accessibility_config.dart';

/// Minimalist theme system for AI Organizer App
/// Based on iOS-inspired clean design with professional aesthetics
///
/// Supports both standard and high contrast themes for accessibility
class AppTheme {
  AppTheme._();

  // ===== THEME DATA GENERATION =====

  /// Generate light theme
  static ThemeData light({String? languageCode}) {
    const brightness = Brightness.light;

    final colorScheme = ColorScheme.light(
      // Primary colors (iOS Blue)
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimary: AppColors.lightOnPrimary,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,

      // Secondary colors (Purple for AI/special features)
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondary: AppColors.lightOnSecondary,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,

      // Tertiary colors
      tertiary: AppColors.lightTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      onTertiary: AppColors.lightOnTertiary,
      onTertiaryContainer: AppColors.lightOnTertiaryContainer,

      // Surface colors (white for cards)
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceBackground,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,

      // Background colors (light gray for screens)
      brightness: brightness,

      // Outline colors (subtle borders)
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,

      // Semantic colors
      error: AppColors.lightError,
      errorContainer: AppColors.lightErrorContainer,
      onError: AppColors.lightOnPrimary,
      onErrorContainer: AppColors.lightPrimaryText,

      shadow: Colors.black,
      scrim: Colors.black.withOpacity(0.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.generateTextTheme(
        brightness: brightness,
        primaryColor: colorScheme.primary,
        languageCode: languageCode,
      ),

      // ===== APP BAR THEME =====
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.lightCardBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.lightPrimaryText,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(
          color: AppColors.lightPrimaryText,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // ===== CARD THEME =====
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        color: AppColors.lightCardBackground,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.cardMargin,
        ),
      ),

      // ===== ELEVATED BUTTON THEME =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          disabledBackgroundColor: AppColors.lightPlaceholderText,
          disabledForegroundColor: AppColors.lightOnPrimary,
        ),
      ),

      // ===== OUTLINED BUTTON THEME =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(
            color: AppColors.lightBorderColor,
            width: 1.0,
          ),
        ),
      ),

      // ===== TEXT BUTTON THEME =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          foregroundColor: AppColors.lightPrimary,
        ),
      ),

      // ===== FLOATING ACTION BUTTON THEME =====
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // ===== INPUT DECORATION THEME =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightBorderColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightFocusedBorder,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightError,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightError,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: AppTypography.bodyMedium(
          color: AppColors.lightPlaceholderText,
        ),
        labelStyle: AppTypography.bodyMedium(
          color: AppColors.lightSecondaryText,
        ),
      ),

      // ===== CHIP THEME =====
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSelectedBackground,
        labelStyle: AppTypography.labelSmall(
          color: AppColors.lightSecondaryText,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
      ),

      // ===== BOTTOM NAVIGATION BAR THEME =====
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCardBackground,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTertiaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTypography.labelSmall(),
      ),

      // ===== DIVIDER THEME =====
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDividerColor,
        thickness: 1,
        space: AppSpacing.dividerSpacing,
      ),

      // ===== ICON THEME =====
      iconTheme: const IconThemeData(
        color: AppColors.lightPrimaryText,
        size: AppSpacing.iconSize,
      ),

      primaryIconTheme: const IconThemeData(
        color: AppColors.lightOnPrimary,
        size: AppSpacing.iconSize,
      ),

      // ===== DIALOG THEME =====
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        titleTextStyle: AppTypography.titleLarge(
          color: AppColors.lightPrimaryText,
        ),
        contentTextStyle: AppTypography.bodyMedium(
          color: AppColors.lightSecondaryText,
        ),
      ),

      // ===== BOTTOM SHEET THEME =====
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightModalBackground,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.lightModalBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),

      // ===== CHECKBOX THEME =====
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.lightOnPrimary),
        side: const BorderSide(
          color: AppColors.lightPlaceholderText,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // ===== RADIO THEME =====
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightPlaceholderText;
        }),
      ),

      // ===== SWITCH THEME =====
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightOnPrimary;
          }
          return AppColors.lightPlaceholderText;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightSelectedBackground;
        }),
      ),

      // ===== PROGRESS INDICATOR THEME =====
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lightPrimary,
        linearTrackColor: AppColors.lightSelectedBackground,
        circularTrackColor: AppColors.lightSelectedBackground,
      ),

      // ===== SNACKBAR THEME =====
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightPrimaryText,
        contentTextStyle: AppTypography.bodyMedium(
          color: AppColors.lightOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Generate dark theme
  static ThemeData dark({String? languageCode}) {
    const brightness = Brightness.dark;

    final colorScheme = ColorScheme.dark(
      // Primary colors
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimary: AppColors.darkOnPrimary,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,

      // Secondary colors
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondary: AppColors.darkOnSecondary,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,

      // Tertiary colors
      tertiary: AppColors.darkTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiary: AppColors.darkOnTertiary,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,

      // Surface colors
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceBackground,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,

      // Background colors
      brightness: brightness,

      // Outline colors
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,

      // Semantic colors
      error: AppColors.darkError,
      errorContainer: AppColors.darkErrorContainer,
      onError: AppColors.darkOnPrimary,
      onErrorContainer: AppColors.darkPrimaryText,

      shadow: Colors.black,
      scrim: Colors.black.withOpacity(0.7),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.generateTextTheme(
        brightness: brightness,
        primaryColor: colorScheme.primary,
        languageCode: languageCode,
      ),

      // ===== APP BAR THEME =====
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.darkPrimaryText,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(
          color: AppColors.darkPrimaryText,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // ===== CARD THEME =====
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        color: AppColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.cardMargin,
        ),
      ),

      // Similar component themes as light theme but with dark colors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(
            color: AppColors.darkBorderColor,
            width: 1.0,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(),
          foregroundColor: AppColors.darkPrimary,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.darkBorderColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.darkBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.darkError,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceBackground,
        labelStyle: AppTypography.labelSmall(
          color: AppColors.darkSecondaryText,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardBackground,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTertiaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkDividerColor,
        thickness: 1,
        space: AppSpacing.dividerSpacing,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.darkPrimaryText,
        size: AppSpacing.iconSize,
      ),

      primaryIconTheme: const IconThemeData(
        color: AppColors.darkOnPrimary,
        size: AppSpacing.iconSize,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.darkOnPrimary),
        side: const BorderSide(
          color: AppColors.darkTertiaryText,
          width: 1.5,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTypography.bodyMedium(
          color: AppColors.darkPrimaryText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Generate high contrast light theme for accessibility
  static ThemeData lightHighContrast({String? languageCode}) {
    const brightness = Brightness.light;

    final colorScheme = ColorScheme.light(
      // High contrast primary colors
      primary: HighContrastColors.lightPrimary,
      primaryContainer: HighContrastColors.lightPrimaryContainer,
      onPrimary: HighContrastColors.lightOnPrimary,
      onPrimaryContainer: HighContrastColors.lightPrimaryText,

      // High contrast secondary colors
      secondary: HighContrastColors.lightSecondary,
      secondaryContainer: HighContrastColors.lightPrimaryContainer,
      onSecondary: HighContrastColors.lightOnSecondary,
      onSecondaryContainer: HighContrastColors.lightPrimaryText,

      // High contrast surface colors
      surface: HighContrastColors.lightSurface,
      surfaceContainerHighest: HighContrastColors.lightBackground,
      onSurface: HighContrastColors.lightPrimaryText,
      onSurfaceVariant: HighContrastColors.lightSecondaryText,

      brightness: brightness,

      // High contrast outline colors
      outline: HighContrastColors.lightBorder,
      outlineVariant: HighContrastColors.lightDivider,

      // High contrast semantic colors
      error: HighContrastColors.lightError,
      errorContainer: HighContrastColors.lightPrimaryContainer,
      onError: HighContrastColors.lightOnError,
      onErrorContainer: HighContrastColors.lightPrimaryText,

      shadow: Colors.black,
      scrim: Colors.black.withOpacity(0.8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: HighContrastColors.lightBackground,
      textTheme: AppTypography.generateTextTheme(
        brightness: brightness,
        primaryColor: colorScheme.primary,
        languageCode: languageCode,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: HighContrastColors.lightCardBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: HighContrastColors.lightPrimaryText,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(
          color: HighContrastColors.lightPrimaryText,
          fontWeight: FontWeight.w700, // Bolder for high contrast
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          side: const BorderSide(
            color: HighContrastColors.lightBorder,
            width: 2.0, // Thicker borders for high contrast
          ),
        ),
        color: HighContrastColors.lightCardBackground,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.cardMargin,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: const BorderSide(
              color: HighContrastColors.lightBorder,
              width: 2.0,
            ),
          ),
          textStyle: AppTypography.button(fontWeight: FontWeight.w700),
          backgroundColor: HighContrastColors.lightPrimary,
          foregroundColor: HighContrastColors.lightOnPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(fontWeight: FontWeight.w700),
          foregroundColor: HighContrastColors.lightPrimary,
          side: const BorderSide(
            color: HighContrastColors.lightBorder,
            width: 2.0,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HighContrastColors.lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.lightBorder,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.lightBorder,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.lightPrimary,
            width: 3.0, // Extra thick for focus
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.lightError,
            width: 3.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: HighContrastColors.lightDivider,
        thickness: 2, // Thicker dividers
        space: AppSpacing.dividerSpacing,
      ),

      iconTheme: const IconThemeData(
        color: HighContrastColors.lightPrimaryText,
        size: AppSpacing.iconSize,
      ),
    );
  }

  /// Generate high contrast dark theme for accessibility
  static ThemeData darkHighContrast({String? languageCode}) {
    const brightness = Brightness.dark;

    final colorScheme = ColorScheme.dark(
      // High contrast primary colors
      primary: HighContrastColors.darkPrimary,
      primaryContainer: HighContrastColors.darkPrimaryContainer,
      onPrimary: HighContrastColors.darkOnPrimary,
      onPrimaryContainer: HighContrastColors.darkPrimaryText,

      // High contrast secondary colors
      secondary: HighContrastColors.darkSecondary,
      secondaryContainer: HighContrastColors.darkPrimaryContainer,
      onSecondary: HighContrastColors.darkOnSecondary,
      onSecondaryContainer: HighContrastColors.darkPrimaryText,

      // High contrast surface colors
      surface: HighContrastColors.darkSurface,
      surfaceContainerHighest: HighContrastColors.darkCardBackground,
      onSurface: HighContrastColors.darkPrimaryText,
      onSurfaceVariant: HighContrastColors.darkSecondaryText,

      brightness: brightness,

      // High contrast outline colors
      outline: HighContrastColors.darkBorder,
      outlineVariant: HighContrastColors.darkDivider,

      // High contrast semantic colors
      error: HighContrastColors.darkError,
      errorContainer: HighContrastColors.darkPrimaryContainer,
      onError: HighContrastColors.darkOnError,
      onErrorContainer: HighContrastColors.darkPrimaryText,

      shadow: Colors.black,
      scrim: Colors.black.withOpacity(0.9),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: HighContrastColors.darkBackground,
      textTheme: AppTypography.generateTextTheme(
        brightness: brightness,
        primaryColor: colorScheme.primary,
        languageCode: languageCode,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: HighContrastColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: HighContrastColors.darkPrimaryText,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(
          color: HighContrastColors.darkPrimaryText,
          fontWeight: FontWeight.w700, // Bolder for high contrast
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          side: const BorderSide(
            color: HighContrastColors.darkBorder,
            width: 2.0, // Thicker borders for high contrast
          ),
        ),
        color: HighContrastColors.darkCardBackground,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.cardMargin,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: const BorderSide(
              color: HighContrastColors.darkBorder,
              width: 2.0,
            ),
          ),
          textStyle: AppTypography.button(fontWeight: FontWeight.w700),
          backgroundColor: HighContrastColors.darkPrimary,
          foregroundColor: HighContrastColors.darkOnPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.button(fontWeight: FontWeight.w700),
          foregroundColor: HighContrastColors.darkPrimary,
          side: const BorderSide(
            color: HighContrastColors.darkBorder,
            width: 2.0,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HighContrastColors.darkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.darkBorder,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.darkBorder,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.darkPrimary,
            width: 3.0, // Extra thick for focus
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(
            color: HighContrastColors.darkError,
            width: 3.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: HighContrastColors.darkDivider,
        thickness: 2, // Thicker dividers
        space: AppSpacing.dividerSpacing,
      ),

      iconTheme: const IconThemeData(
        color: HighContrastColors.darkPrimaryText,
        size: AppSpacing.iconSize,
      ),
    );
  }
}
