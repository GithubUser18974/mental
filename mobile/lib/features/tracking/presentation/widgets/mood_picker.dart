import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/round_selector.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

/// The five moods as round selectors with labels (FR-TRACK-002).
class MoodPicker extends StatelessWidget {
  const MoodPicker({required this.selected, required this.onChanged, super.key});

  final Mood? selected;
  final ValueChanged<Mood> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final mood in Mood.values)
          Flexible(
            child: Column(
              children: [
                RoundSelector(
                  icon: mood.icon,
                  selectedIcon: mood.selectedIcon,
                  semanticLabel: mood.label(l10n),
                  selected: selected == mood,
                  onTap: () => onChanged(mood),
                ),
                const SizedBox(height: AppSpacing.xs),
                ExcludeSemantics(
                  child: Text(
                    mood.label(l10n),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: context.textStyles.labelMedium?.copyWith(
                      color: selected == mood ? context.palette.primary : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
