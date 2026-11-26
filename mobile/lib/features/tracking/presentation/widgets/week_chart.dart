import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

/// Seven-day mood strip (FR-TRACK-004 "graphical trends"): a soft bar per day sized by
/// the mood score (or the mood level when no score was given), with the mood icon.
/// Days without a check-in show an empty well — never a judgement.
class WeekChart extends StatelessWidget {
  const WeekChart({required this.days, super.key});

  final List<DaySummary> days;

  static const double _barArea = 96;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final weekday = DateFormat.E(l10n.localeName);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final day in days)
          Expanded(
            child: Semantics(
              label:
                  '${DateFormat.MMMEd(l10n.localeName).format(day.date)}: '
                  '${day.mood?.label(l10n) ?? l10n.noValue}',
              excludeSemantics: true,
              child: Column(
                children: [
                  SizedBox(
                    height: _barArea,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _Bar(fraction: _fraction(day), filled: day.mood != null),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Icon(
                    day.mood?.selectedIcon ?? Icons.remove_rounded,
                    size: 18,
                    color: day.mood == null ? p.textTertiary : p.primary,
                  ),
                  Text(weekday.format(day.date), style: context.textStyles.labelSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static double _fraction(DaySummary day) {
    if (day.score case final score?) return (score / 10).clamp(0.1, 1);
    if (day.mood case final mood?) return mood.level / 5;
    return 0.08;
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.filled});

  final double fraction;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.curve,
      width: 18,
      height: WeekChart._barArea * fraction,
      decoration: BoxDecoration(
        gradient: filled
            ? LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [p.primaryLight, p.primary],
              )
            : null,
        color: filled ? null : p.surfaceMuted,
        borderRadius: AppRadius.pillAll,
      ),
    );
  }
}
