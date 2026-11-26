import 'package:flutter/material.dart';

/// Type scale (design-system.md → "Typography").
///
/// Urbanist (variable) for Latin; IBM Plex Sans Arabic is the fallback family, so
/// Arabic glyphs render in Plex automatically in either locale.
abstract final class AppTypography {
  static const String latinFamily = 'Urbanist';
  static const String arabicFamily = 'IBMPlexSansArabic';
  static const List<String> fallback = [arabicFamily];

  static TextStyle _style(double size, FontWeight weight, {double? height}) => TextStyle(
    fontFamily: latinFamily,
    fontFamilyFallback: fallback,
    fontSize: size,
    fontWeight: weight,
    // Urbanist is a variable font: drive the weight axis explicitly.
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
    height: height,
    letterSpacing: 0,
  );

  static final TextStyle display = _style(28, FontWeight.w700, height: 1.2);
  static final TextStyle title = _style(20, FontWeight.w600, height: 1.3);
  static final TextStyle subtitle = _style(16, FontWeight.w600, height: 1.35);
  static final TextStyle body = _style(15, FontWeight.w400, height: 1.45);
  static final TextStyle label = _style(14, FontWeight.w500, height: 1.3);
  static final TextStyle caption = _style(12, FontWeight.w400, height: 1.35);

  /// Maps the scale onto Material's [TextTheme] slots, colored for the given scheme.
  static TextTheme textTheme({required Color primary, required Color secondary}) => TextTheme(
    headlineMedium: display.copyWith(color: primary),
    headlineSmall: display.copyWith(fontSize: 24, color: primary),
    titleLarge: title.copyWith(color: primary),
    titleMedium: subtitle.copyWith(color: primary),
    titleSmall: label.withWeight(FontWeight.w600).copyWith(color: primary),
    bodyLarge: body.copyWith(color: primary),
    bodyMedium: body.copyWith(fontSize: 14, color: primary),
    bodySmall: caption.copyWith(color: secondary),
    labelLarge: label.copyWith(color: primary),
    labelMedium: caption.withWeight(FontWeight.w500).copyWith(color: secondary),
    labelSmall: caption.copyWith(fontSize: 11, color: secondary),
  );
}

/// Changes weight on both `fontWeight` (static fonts, e.g. Arabic) and the variable
/// `wght` axis (Urbanist). Always use this instead of `copyWith(fontWeight: ...)`.
extension TextStyleWeight on TextStyle {
  TextStyle withWeight(FontWeight weight) => copyWith(
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );
}
