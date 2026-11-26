import 'package:flutter/widgets.dart';

/// Spacing scale (design-system.md → "Shape & spacing").
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  /// Horizontal screen padding.
  static const double screen = lg;

  static const EdgeInsetsDirectional screenPadding = EdgeInsetsDirectional.symmetric(
    horizontal: screen,
  );
}

/// Corner radii.
abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;

  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Component sizes.
abstract final class AppSizes {
  static const double buttonHeight = 56;
  static const double iconButton = 44;
  static const double minTapTarget = 48;
  static const double roundSelector = 64;
  static const double actionWell = 40;
  static const double tileIcon = 32;
}

/// Motion: calm, short (design-system.md → "Motion").
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Curve curve = Curves.easeOutCubic;
  static const double pressedScale = 0.97;
}
