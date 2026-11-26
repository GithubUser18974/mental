import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// One option in a row of pill choices with a radio indicator.
/// Selected = primary gradient + white text.
class PillOption extends StatelessWidget {
  const PillOption({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = selected ? p.onPrimary : p.textSecondary;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: AppMotion.normal,
        curve: AppMotion.curve,
        decoration: BoxDecoration(
          gradient: selected ? p.primaryGradient : null,
          color: selected ? null : p.surface,
          borderRadius: AppRadius.pillAll,
          border: selected ? null : Border.all(color: p.border),
          boxShadow: selected
              ? AppShadows.raised(p, context.brightness)
              : AppShadows.soft(p, context.brightness),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: AppRadius.pillAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget - 4),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: context.textStyles.labelLarge?.copyWith(color: fg)),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      size: 16,
                      color: fg,
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
