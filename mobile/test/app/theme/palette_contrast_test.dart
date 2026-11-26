import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/theme/app_palette.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const aa = 4.5;

  for (final (name, p) in [('light', AppPalette.light), ('dark', AppPalette.dark)]) {
    group('$name palette meets WCAG AA', () {
      test('primary & secondary text on surface and background', () {
        for (final bg in [p.surface, p.background, p.surfaceMuted]) {
          expect(contrast(p.textPrimary, bg), greaterThanOrEqualTo(aa));
          expect(contrast(p.textSecondary, bg), greaterThanOrEqualTo(aa));
        }
      });

      test('white label on both primary-gradient ends', () {
        expect(contrast(p.onPrimary, p.gradientStart), greaterThanOrEqualTo(aa));
        expect(contrast(p.onPrimary, p.gradientEnd), greaterThanOrEqualTo(aa));
      });

      test('primary-colored text (hashtags, links) on surface', () {
        expect(contrast(p.primary, p.surface), greaterThanOrEqualTo(aa));
      });

      test('danger text on surface', () {
        expect(contrast(p.danger, p.surface), greaterThanOrEqualTo(aa));
      });
    });
  }
}
