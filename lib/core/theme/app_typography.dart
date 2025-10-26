import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Minimalist typography system for AI Organizer App
/// Based on Inter font family with clean, professional hierarchy
class AppTypography {
  AppTypography._();

  // ===== DISPLAY TYPOGRAPHY (for impact) =====

  /// Display Large - 34sp (Screen headers)
  static TextStyle displayLarge({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 34,
        fontWeight: fontWeight ?? FontWeight.w700, // Bold
        letterSpacing: letterSpacing ?? 0.4,
        color: color,
        height: 1.2,
      );

  /// Display Medium - 28sp (Section headers)
  static TextStyle displayMedium({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.35,
        color: color,
        height: 1.3,
      );

  /// Display Small - 22sp (Small headers)
  static TextStyle displaySmall({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.35,
        color: color,
        height: 1.3,
      );

  // ===== HEADLINE TYPOGRAPHY (for structure) =====

  /// Headline Large - 32sp
  static TextStyle headlineLarge({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.25,
      );

  /// Headline Medium - 28sp
  static TextStyle headlineMedium({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.29,
      );

  /// Headline Small - 24sp
  static TextStyle headlineSmall({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.33,
      );

  // ===== TITLE TYPOGRAPHY (for organization) =====

  /// Title Large - 18sp (Note titles / Card titles)
  static TextStyle titleLarge({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.15,
        color: color,
        height: 1.4,
      );

  /// Title Medium - 16sp (Subtitles / Section labels)
  static TextStyle titleMedium({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.15,
        color: color,
        height: 1.4,
      );

  /// Title Small - 14sp (Small titles)
  static TextStyle titleSmall({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.1,
        color: color,
        height: 1.4,
      );

  // ===== BODY TYPOGRAPHY (for content) =====

  /// Body Large - 16sp (Note content)
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400, // Regular
        letterSpacing: letterSpacing ?? 0.15,
        color: color,
        height: 1.5,
      );

  /// Body Medium - 14sp (Standard body text)
  static TextStyle bodyMedium({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400, // Regular
        letterSpacing: letterSpacing ?? 0.25,
        color: color,
        height: 1.5,
      );

  /// Body Small - 12sp (Small body text / Descriptions)
  static TextStyle bodySmall({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400, // Regular
        letterSpacing: letterSpacing ?? 0.4,
        color: color,
        height: 1.5,
      );

  // ===== LABEL TYPOGRAPHY (for UI elements) =====

  /// Label Large - 16sp (Large buttons)
  static TextStyle labelLarge({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.2,
      );

  /// Label Medium - 14sp (Tab labels / Small buttons)
  static TextStyle labelMedium({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500, // Medium
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.2,
      );

  /// Label Small - 11sp (Captions / Metadata)
  static TextStyle labelSmall({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: fontWeight ?? FontWeight.w400, // Regular
        letterSpacing: letterSpacing ?? 0.5,
        color: color,
        height: 1.3,
      );

  // ===== SPECIAL TYPOGRAPHY =====

  /// Code typography - Fira Code
  static TextStyle code({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) =>
      GoogleFonts.firaCode(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        letterSpacing: 0,
        color: color,
        height: 1.5,
      );

  /// Button text
  static TextStyle button({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600, // Semi-bold
        letterSpacing: 0.5,
        color: color,
        height: 1.2,
      );

  /// Caption text
  static TextStyle caption({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        letterSpacing: 0.4,
        color: color,
        height: 1.5,
      );

  /// Overline text
  static TextStyle overline({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: 1.5,
        color: color,
        height: 1.6,
      );

  // ===== LOCALIZED TYPOGRAPHY =====

  /// Get localized body text style based on language
  static TextStyle getLocalizedBodyText(
    String languageCode, {
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    switch (languageCode) {
      case 'ar':
        return GoogleFonts.notoSansArabic(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.8, // Increased line height for Arabic
        );
      case 'zh':
        return GoogleFonts.notoSansSc(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.6,
        );
      case 'ja':
        return GoogleFonts.notoSansJp(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.7,
        );
      case 'hi':
        return GoogleFonts.notoSansDevanagari(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.6,
        );
      case 'th':
        return GoogleFonts.notoSansThai(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.6,
        );
      default:
        return GoogleFonts.inter(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color,
          height: 1.5,
        );
    }
  }

  /// Get localized heading style based on language
  static TextStyle getLocalizedHeading(
    String languageCode, {
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    switch (languageCode) {
      case 'ar':
        return GoogleFonts.notoSansArabic(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color,
          height: 1.4,
        );
      case 'zh':
        return GoogleFonts.notoSansSc(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color,
          height: 1.3,
        );
      case 'ja':
        return GoogleFonts.notoSansJp(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color,
          height: 1.4,
        );
      default:
        return GoogleFonts.inter(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color,
          height: 1.33,
        );
    }
  }

  // ===== COMPLETE TEXT THEME =====

  /// Generate complete TextTheme for the app
  static TextTheme generateTextTheme({
    required Brightness brightness,
    Color? primaryColor,
    String? languageCode,
  }) {
    final baseColor =
        brightness == Brightness.light ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);

    return TextTheme(
      // Display styles
      displayLarge: displayLarge(color: baseColor),
      displayMedium: displayMedium(color: baseColor),
      displaySmall: displaySmall(color: baseColor),

      // Headline styles
      headlineLarge: headlineLarge(color: baseColor),
      headlineMedium: headlineMedium(color: baseColor),
      headlineSmall: headlineSmall(color: baseColor),

      // Title styles
      titleLarge: titleLarge(color: baseColor),
      titleMedium: titleMedium(color: baseColor),
      titleSmall: titleSmall(color: baseColor),

      // Body styles
      bodyLarge: languageCode != null
          ? getLocalizedBodyText(languageCode, color: baseColor)
          : bodyLarge(color: baseColor),
      bodyMedium: languageCode != null
          ? getLocalizedBodyText(languageCode, color: baseColor, fontSize: 14)
          : bodyMedium(color: baseColor),
      bodySmall: bodySmall(color: baseColor),

      // Label styles
      labelLarge: labelLarge(color: baseColor),
      labelMedium: labelMedium(color: baseColor),
      labelSmall: labelSmall(color: baseColor),
    );
  }
}

/// Typography extension for easy access
extension TypographyExtension on BuildContext {
  /// Get display large style
  TextStyle get displayLarge => AppTypography.displayLarge();

  /// Get display medium style
  TextStyle get displayMedium => AppTypography.displayMedium();

  /// Get display small style
  TextStyle get displaySmall => AppTypography.displaySmall();

  /// Get headline large style
  TextStyle get headlineLarge => AppTypography.headlineLarge();

  /// Get headline medium style
  TextStyle get headlineMedium => AppTypography.headlineMedium();

  /// Get headline small style
  TextStyle get headlineSmall => AppTypography.headlineSmall();

  /// Get title large style
  TextStyle get titleLarge => AppTypography.titleLarge();

  /// Get title medium style
  TextStyle get titleMedium => AppTypography.titleMedium();

  /// Get title small style
  TextStyle get titleSmall => AppTypography.titleSmall();

  /// Get body large style
  TextStyle get bodyLarge => AppTypography.bodyLarge();

  /// Get body medium style
  TextStyle get bodyMedium => AppTypography.bodyMedium();

  /// Get body small style
  TextStyle get bodySmall => AppTypography.bodySmall();

  /// Get label large style
  TextStyle get labelLarge => AppTypography.labelLarge();

  /// Get label medium style
  TextStyle get labelMedium => AppTypography.labelMedium();

  /// Get label small style
  TextStyle get labelSmall => AppTypography.labelSmall();

  /// Get button style
  TextStyle get button => AppTypography.button();

  /// Get caption style
  TextStyle get caption => AppTypography.caption();

  /// Get code style
  TextStyle get code => AppTypography.code();
}
