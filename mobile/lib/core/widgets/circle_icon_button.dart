import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// 44px white circle icon button for app bars (back, more menu).
/// Keeps a 48px tap target for accessibility.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  /// Back button; chevron mirrors automatically in RTL.
  factory CircleIconButton.back({required VoidCallback onPressed, required String semanticLabel}) =>
      CircleIconButton(
        icon: Icons.chevron_left_rounded,
        onPressed: onPressed,
        semanticLabel: semanticLabel,
      );

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: AppSizes.minTapTarget,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: p.surface,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft(p, context.brightness),
            ),
            child: Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                child: SizedBox.square(
                  dimension: AppSizes.iconButton,
                  child: Icon(icon, size: 22, color: p.textPrimary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
