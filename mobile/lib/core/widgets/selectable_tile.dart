import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/app/theme/app_typography.dart';
import 'package:mindful/core/widgets/pressable_scale.dart';

/// Square grid tile with an outlined icon above a label
/// (categories, moods, symptoms). Use in a 3-column grid.
class SelectableTile extends StatelessWidget {
  const SelectableTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: PressableScale(
        enabled: true,
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            color: selected ? p.primarySoft : p.surfaceMuted,
            borderRadius: AppRadius.lgAll,
            border: Border.all(
              color: selected ? p.primaryLight : p.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? AppShadows.raised(p, context.brightness)
                : AppShadows.soft(p, context.brightness),
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: AppRadius.lgAll,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: AppSizes.tileIcon, color: p.primary),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.labelLarge?.withWeight(
                        selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
