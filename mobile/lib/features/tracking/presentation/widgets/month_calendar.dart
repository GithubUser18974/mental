import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

/// Calendar view of a month (FR-TRACK-004): each day tinted by the last mood recorded
/// that day (lighter = lower), with its icon. Starts on the locale's first weekday.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({required this.month, required this.moods, super.key});

  /// Any day in the month to show.
  final DateTime month;
  final List<MoodEntry> moods;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final locale = l10n.localeName;
    final first = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // intl: 0 = Monday … 6 = Sunday.
    final firstWeekday = DateFormat.EEEE(locale).dateSymbols.FIRSTDAYOFWEEK;
    final leading = (first.weekday - 1 - firstWeekday) % 7;

    // Latest mood per local day (entries arrive newest first).
    final byDay = <int, Mood>{};
    for (final entry in moods) {
      final local = entry.recordedAt.toLocal();
      if (local.year == month.year && local.month == month.month) {
        byDay.putIfAbsent(local.day, () => entry.mood);
      }
    }

    final weekdayNames = DateFormat.E(locale).dateSymbols.NARROWWEEKDAYS;

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    // NARROWWEEKDAYS starts on Sunday.
                    weekdayNames[(firstWeekday + 1 + i) % 7],
                    style: context.textStyles.labelSmall,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.xxs,
          crossAxisSpacing: AppSpacing.xxs,
          children: [
            for (var i = 0; i < leading; i++) const SizedBox.shrink(),
            for (var day = 1; day <= daysInMonth; day++)
              _DayCell(day: day, mood: byDay[day], date: DateTime(month.year, month.month, day)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // Hidden from semantics: each cell already announces its mood.
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final mood in Mood.values)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xxs),
                  child: Icon(mood.selectedIcon, size: 16, color: _tint(p.primary, mood)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static Color _tint(Color primary, Mood mood) =>
      primary.withValues(alpha: 0.25 + 0.15 * mood.level);
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.mood, required this.date});

  final int day;
  final Mood? mood;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final m = mood;
    return Semantics(
      label: '${DateFormat.MMMd(l10n.localeName).format(date)}: ${m?.label(l10n) ?? l10n.noValue}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: m == null ? p.surfaceMuted : p.primary.withValues(alpha: 0.08 + 0.07 * m.level),
          borderRadius: AppRadius.smAll,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day', style: context.textStyles.labelSmall),
            if (m != null) Icon(m.selectedIcon, size: 14, color: MonthCalendar._tint(p.primary, m)),
          ],
        ),
      ),
    );
  }
}
