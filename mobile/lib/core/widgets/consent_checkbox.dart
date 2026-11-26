import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// A large, tappable checkbox row for explicit consents (age, terms).
/// The whole row toggles; the error appears beneath it.
class ConsentCheckbox extends StatelessWidget {
  const ConsentCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MergeSemantics(
          child: InkWell(
            borderRadius: AppRadius.mdAll,
            onTap: () => onChanged(!value),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
              child: Row(
                children: [
                  Checkbox(
                    value: value,
                    onChanged: (v) => onChanged(v ?? false),
                    activeColor: p.primary,
                    side: BorderSide(
                      color: errorText == null ? p.textTertiary : p.danger,
                      width: 1.5,
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.xsAll),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(child: Text(label, style: context.textStyles.bodyMedium)),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.xxl + AppSpacing.xs),
            child: Text(
              errorText!,
              style: context.textStyles.bodySmall?.copyWith(color: p.danger),
            ),
          ),
      ],
    );
  }
}
