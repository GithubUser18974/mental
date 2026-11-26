import 'package:flutter/material.dart';

/// "Soft Lavender" color tokens (see `.claude/rules/design-system.md`).
///
/// Access in widgets via `context.palette` — never hard-code colors.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primarySoft,
    required this.gradientStart,
    required this.gradientEnd,
    required this.background,
    required this.backgroundTint,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.onPrimary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.shadow,
  });

  static const light = AppPalette(
    primary: Color(0xFF7C4DEB),
    primaryDark: Color(0xFF6D3AE0),
    primaryLight: Color(0xFFB79CFA),
    primarySoft: Color(0xFFEDE6FE),
    gradientStart: Color(0xFF8455F0),
    gradientEnd: Color(0xFF6D3AE0),
    background: Color(0xFFF3F0FC),
    backgroundTint: Color(0xFFE9E4FA),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF8F6FE),
    border: Color(0xFFE6E1F5),
    textPrimary: Color(0xFF1E1B3A),
    textSecondary: Color(0xFF6E6A85),
    textTertiary: Color(0xFFA5A1BA),
    onPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF2E9E6A),
    warning: Color(0xFFB7791F),
    danger: Color(0xFFC23B57),
    shadow: Color(0xFF7C4DEB),
  );

  static const dark = AppPalette(
    primary: Color(0xFFA584FA),
    primaryDark: Color(0xFF8B5CF6),
    primaryLight: Color(0xFFC4AEFC),
    primarySoft: Color(0xFF3A2F6B),
    gradientStart: Color(0xFF8455F0),
    gradientEnd: Color(0xFF6D3AE0),
    background: Color(0xFF15122A),
    backgroundTint: Color(0xFF1C1836),
    surface: Color(0xFF221E3D),
    surfaceMuted: Color(0xFF2A2549),
    border: Color(0xFF352F58),
    textPrimary: Color(0xFFF2F0FA),
    textSecondary: Color(0xFFB4AFCC),
    textTertiary: Color(0xFF7D7899),
    onPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF5BD39B),
    warning: Color(0xFFF5B547),
    danger: Color(0xFFF07A90),
    shadow: Color(0xFF000000),
  );

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primarySoft;

  /// Primary-button gradient ends. Both keep white label text ≥ 4.5:1 (WCAG AA).
  final Color gradientStart;
  final Color gradientEnd;

  final Color background;
  final Color backgroundTint;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color onPrimary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color shadow;

  LinearGradient get primaryGradient => LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [gradientStart, gradientEnd],
  );

  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundTint, background],
  );

  @override
  AppPalette copyWith({Color? primary, Color? surface, Color? background}) => AppPalette(
    primary: primary ?? this.primary,
    primaryDark: primaryDark,
    primaryLight: primaryLight,
    primarySoft: primarySoft,
    gradientStart: gradientStart,
    gradientEnd: gradientEnd,
    background: background ?? this.background,
    backgroundTint: backgroundTint,
    surface: surface ?? this.surface,
    surfaceMuted: surfaceMuted,
    border: border,
    textPrimary: textPrimary,
    textSecondary: textSecondary,
    textTertiary: textTertiary,
    onPrimary: onPrimary,
    success: success,
    warning: warning,
    danger: danger,
    shadow: shadow,
  );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      primary: l(primary, other.primary),
      primaryDark: l(primaryDark, other.primaryDark),
      primaryLight: l(primaryLight, other.primaryLight),
      primarySoft: l(primarySoft, other.primarySoft),
      gradientStart: l(gradientStart, other.gradientStart),
      gradientEnd: l(gradientEnd, other.gradientEnd),
      background: l(background, other.background),
      backgroundTint: l(backgroundTint, other.backgroundTint),
      surface: l(surface, other.surface),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
      border: l(border, other.border),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      onPrimary: l(onPrimary, other.onPrimary),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      shadow: l(shadow, other.shadow),
    );
  }
}
