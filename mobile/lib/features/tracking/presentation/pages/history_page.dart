import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/segmented_pills.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:mindful/features/tracking/presentation/widgets/month_calendar.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

enum _HistoryTab { moods, symptoms, sleep }

/// Month-by-month history (FR-TRACK-004): mood calendar + entries, symptoms, sleep.
/// Tapping an entry opens it for editing or deleting (FR-TRACK-006).
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  _HistoryTab _tab = _HistoryTab.moods;

  DayRange get _range => (from: _month, to: DateTime(_month.year, _month.month + 1, 0));

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  void _shift(int months) => setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(trackingHistoryProvider(_range));

    return ListPageScaffold(
      title: l10n.historyTitle,
      onRefresh: () async => ref.invalidate(trackingHistoryProvider(_range)),
      slivers: [
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SegmentedPills(
                  labels: [l10n.historyMoods, l10n.historySymptoms, l10n.historySleep],
                  selectedIndex: _tab.index,
                  onChanged: (i) => setState(() => _tab = _HistoryTab.values[i]),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    IconButton(
                      tooltip: l10n.previousMonth,
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: () => _shift(-1),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMM(l10n.localeName).format(_month),
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.nextMonth,
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _isCurrentMonth ? null : () => _shift(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        history.when(
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
          error: (e, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              error: e,
              onRetry: () => ref.invalidate(trackingHistoryProvider(_range)),
            ),
          ),
          data: (h) => SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screen,
              AppSpacing.xs,
              AppSpacing.screen,
              AppSpacing.xxl,
            ),
            sliver: SliverList.list(
              children: switch (_tab) {
                _HistoryTab.moods => [
                  AppCard(
                    child: MonthCalendar(month: _month, moods: h.moods),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (h.moods.isEmpty) EmptyView(subtitle: l10n.historyEmpty),
                  for (final m in h.moods) _MoodTile(entry: m),
                ],
                _HistoryTab.symptoms => [
                  if (h.symptoms.isEmpty) EmptyView(subtitle: l10n.historyEmpty),
                  for (final s in h.symptoms) _SymptomTile(entry: s),
                ],
                _HistoryTab.sleep => [
                  if (h.sleep.isEmpty) EmptyView(subtitle: l10n.historyEmpty),
                  for (final s in h.sleep) _SleepTile(entry: s),
                ],
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final DateTime time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final when = DateFormat.MMMEd(l10n.localeName).add_jm().format(time.toLocal());
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: p.primarySoft, borderRadius: AppRadius.smAll),
              child: SizedBox.square(
                dimension: AppSizes.actionWell,
                child: Icon(icon, color: p.primary, size: 22),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleSmall),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium,
                    ),
                  Text(when, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: p.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  const _MoodTile({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final details = [
      if (entry.score case final s?) '${l10n.scaleMood} $s',
      if (entry.stress case final s?) '${l10n.scaleStress} $s',
      ?entry.notes,
    ].join(' · ');
    return _EntryTile(
      icon: entry.mood.selectedIcon,
      title: entry.mood.label(l10n),
      subtitle: details.isEmpty ? null : details,
      time: entry.recordedAt,
      onTap: () => context.push(AppRoutes.trackCheckInPath(entry.id)),
    );
  }
}

class _SymptomTile extends StatelessWidget {
  const _SymptomTile({required this.entry});

  final SymptomEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _EntryTile(
      icon: symptomIcon(entry.category.icon),
      title: entry.category.name,
      subtitle: l10n.severityValue(entry.severity),
      time: entry.recordedAt,
      onTap: () => context.push(AppRoutes.trackSymptomPath(entry.id)),
    );
  }
}

class _SleepTile extends StatelessWidget {
  const _SleepTile({required this.entry});

  final SleepEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _EntryTile(
      icon: Icons.bedtime_outlined,
      title: l10n.sleepHoursValue(hoursOf(entry.durationMinutes)),
      subtitle: entry.quality == null ? null : l10n.qualityValue(entry.quality!), // Checked.
      time: entry.recordedAt,
      onTap: () => context.push(AppRoutes.trackSleepPath(entry.id)),
    );
  }
}
