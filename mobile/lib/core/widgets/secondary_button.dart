import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/pressable_scale.dart';

/// Full-width white pill button (e.g. "Continue →", "Create Post →").
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = onPressed != null;
    final style = context.textStyles.labelLarge?.copyWith(fontSize: 16, color: p.textPrimary);

    return PressableScale(
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: AppRadius.pillAll,
            border: Border.all(color: p.border),
            boxShadow: AppShadows.soft(p, context.brightness),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: AppRadius.pillAll,
              child: SizedBox(
                height: AppSizes.buttonHeight,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(label, style: style, overflow: TextOverflow.ellipsis),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Icon(trailingIcon, size: 20, color: p.textPrimary),
                    ],
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
