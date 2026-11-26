import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';

/// A 1–10 rating (FR-TRACK-001). Optional scales start empty ("Add") and can be cleared,
/// so skipping a field never records a made-up value.
class ScaleField extends StatelessWidget {
  const ScaleField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final current = value;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: AppCard(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(label, style: context.textStyles.titleSmall)),
                if (current == null)
                  TextButton.icon(
                    onPressed: () => onChanged(5),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.scaleAdd),
                  )
                else ...[
                  Text(
                    l10n.scaleValue(current),
                    style: context.textStyles.labelLarge?.copyWith(color: p.primary),
                  ),
                  if (!isRequired)
                    IconButton(
                      tooltip: l10n.scaleClear(label),
                      icon: Icon(Icons.close_rounded, size: 18, color: p.textTertiary),
                      onPressed: () => onChanged(null),
                    )
                  else
                    const SizedBox(width: AppSpacing.sm, height: AppSizes.minTapTarget),
                ],
              ],
            ),
            if (current != null)
              Slider(
                value: current.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$current',
                semanticFormatterCallback: (v) => l10n.scaleValue(v.round()),
                onChanged: (v) => onChanged(v.round()),
              ),
          ],
        ),
      ),
    );
  }
}
