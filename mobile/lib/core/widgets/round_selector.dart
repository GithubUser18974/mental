import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/pressable_scale.dart';

/// 64px circular icon selector; selected uses the primary gradient + filled icon.
class RoundSelector extends StatelessWidget {
  const RoundSelector({
    required this.icon,
    required this.selectedIcon,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: PressableScale(
        enabled: true,
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.curve,
          width: AppSizes.roundSelector,
          height: AppSizes.roundSelector,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected ? p.primaryGradient : null,
            color: selected ? null : p.surface,
            boxShadow: selected
                ? AppShadows.raised(p, context.brightness)
                : AppShadows.soft(p, context.brightness),
          ),
          child: Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                selected ? selectedIcon : icon,
                size: 26,
                color: selected ? p.onPrimary : p.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
