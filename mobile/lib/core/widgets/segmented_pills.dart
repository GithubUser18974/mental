import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// Equal-width segmented pill control (selected = primary gradient). Always fits the
/// available width, so no option is hidden off-screen.
class SegmentedPills extends StatelessWidget {
  const SegmentedPills({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.pillAll,
        border: Border.all(color: p.border),
        boxShadow: AppShadows.soft(p, context.brightness),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.xxs),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: _Segment(
                  label: labels[i],
                  selected: i == selectedIndex,
                  onTap: () => onChanged(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: AppMotion.normal,
        curve: AppMotion.curve,
        decoration: BoxDecoration(
          gradient: selected ? p.primaryGradient : null,
          borderRadius: AppRadius.pillAll,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: AppRadius.pillAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 40,
              child: Center(
                // Long labels shrink to fit rather than being cut off.
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xxs),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: context.textStyles.labelLarge?.copyWith(
                        color: selected ? p.onPrimary : p.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
