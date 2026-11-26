import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// Lavender vertical gradient behind every screen.
class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: context.palette.backgroundGradient),
      child: child,
    );
  }
}
