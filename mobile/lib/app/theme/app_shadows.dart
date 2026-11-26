import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_palette.dart';

/// Soft, violet-tinted elevation (never Material `elevation`).
abstract final class AppShadows {
  static List<BoxShadow> soft(AppPalette palette, Brightness brightness) => [
    BoxShadow(
      color: palette.shadow.withValues(alpha: brightness == Brightness.light ? 0.08 : 0.30),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> raised(AppPalette palette, Brightness brightness) => [
    BoxShadow(
      color: (brightness == Brightness.light ? palette.primary : palette.shadow).withValues(
        alpha: brightness == Brightness.light ? 0.25 : 0.35,
      ),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
