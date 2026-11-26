import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/app/theme/app_typography.dart';
import 'package:mindful/core/widgets/pressable_scale.dart';

/// Full-width pill button with the primary gradient (main call to action).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool isLoading;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      excludeSemantics: true,
      child: PressableScale(
        enabled: _enabled,
        child: AnimatedOpacity(
          opacity: _enabled || isLoading ? 1 : 0.5,
          duration: AppMotion.fast,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: p.primaryGradient,
              borderRadius: AppRadius.pillAll,
              boxShadow: _enabled ? AppShadows.raised(p, context.brightness) : null,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: _enabled ? onPressed : null,
                borderRadius: AppRadius.pillAll,
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  width: double.infinity,
                  child: Center(
                    child: isLoading
                        ? SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: p.onPrimary),
                          )
                        : _Label(label: label, icon: trailingIcon, color: p.onPrimary),
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

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.icon, required this.color});

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.labelLarge
        ?.withWeight(FontWeight.w600)
        .copyWith(color: color, fontSize: 16);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(label, style: style, overflow: TextOverflow.ellipsis),
        ),
        if (icon != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, color: color, size: 20),
        ],
      ],
    );
  }
}
