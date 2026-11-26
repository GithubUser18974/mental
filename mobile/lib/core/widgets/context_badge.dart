import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// Small pill label marking the screen context (e.g. "Community Post").
class ContextBadge extends StatelessWidget {
  const ContextBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(color: p.primarySoft, borderRadius: AppRadius.pillAll),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs + 2,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.labelMedium?.copyWith(color: p.primary),
        ),
      ),
    );
  }
}
