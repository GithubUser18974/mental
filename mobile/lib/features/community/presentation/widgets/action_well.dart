import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// Post action: a 40px rounded-square well with an outlined icon and an optional count
/// (design-system "Action row"). Keeps a 48px tap target.
class ActionWell extends StatelessWidget {
  const ActionWell({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.label,
    this.selected = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final String? label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: selected ? p.primaryGradient : null,
                  color: selected ? null : p.primarySoft,
                  borderRadius: AppRadius.smAll,
                ),
                child: SizedBox.square(
                  dimension: AppSizes.actionWell,
                  child: Icon(icon, size: 20, color: selected ? p.onPrimary : p.primary),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(label!, style: context.textStyles.labelMedium),
                const SizedBox(width: AppSpacing.xxs),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
