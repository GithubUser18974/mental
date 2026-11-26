import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';
import 'package:mindful/features/tracking/presentation/widgets/week_chart.dart';

/// Track tab (FR-PROGRESS-001 for tracking): check-in call to action, streak, the last
/// 7 days, averages, quick logging, insights preview and history. Private to the member.
class TrackPage extends ConsumerWidget {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final overview = ref.watch(trackingOverviewProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(trackingOverviewProvider)
          ..invalidate(insightsProvider);
        await ref.read(trackingOverviewProvider.future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screen,
          AppSpacing.md,
          AppSpacing.screen,
          AppSpacing.xxl,
        ),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.trackTitle, style: context.textStyles.headlineSmall),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 16, color: context.palette.textSecondary),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(child: Text(l10n.trackPrivate, style: context.textStyles.bodySmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...overview.when(
            skipLoadingOnRefresh: true,
            loading: () => [const SizedBox(height: 240, child: LoadingView())],
            error: (e, _) => [
              ErrorView(error: e, onRetry: () => ref.invalidate(trackingOverviewProvider)),
            ],
            data: (o) => [
              _CheckInCard(overview: o),
              const SizedBox(height: AppSpacing.md),
              _WeekCard(overview: o),
              const SizedBox(height: AppSpacing.md),
              const _QuickLog(),
              if (o.topSymptoms.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _TopSymptoms(symptoms: o.topSymptoms),
              ],
              const SizedBox(height: AppSpacing.md),
              const _InsightsPreview(),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.trackHistory),
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(l10n.seeHistory),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckInCard extends StatelessWidget {
  const _CheckInCard({required this.overview});

  final TrackingOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final latest = overview.latest;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.checkInPrompt, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          if (latest == null)
            Text(l10n.checkInPromptBody, style: context.textStyles.bodyMedium)
          else
            Row(
              children: [
                Icon(latest.mood.selectedIcon, color: p.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.todayYouFelt(latest.mood.label(l10n)),
                    style: context.textStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            children: [
              _Stat(
                icon: Icons.local_fire_department_outlined,
                text: l10n.streakDays(overview.streakDays),
              ),
              _Stat(
                icon: Icons.check_circle_outline_rounded,
                text: l10n.totalCheckIns(overview.totalCheckIns),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: latest == null ? l10n.checkInAction : l10n.checkInAgain,
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: () => context.push(AppRoutes.trackCheckIn),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: context.palette.primary),
        const SizedBox(width: AppSpacing.xxs),
        Text(text, style: context.textStyles.labelMedium),
      ],
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.overview});

  final TrackingOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final week = overview.week;
    String value(double? v) => v == null ? l10n.noValue : formatAverage(v);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.lastSevenDays, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          WeekChart(days: overview.lastSevenDays),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.averagesTitle, style: context.textStyles.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _Average(label: l10n.avgMood, value: value(week.score)),
              _Average(label: l10n.avgStress, value: value(week.stress)),
              _Average(
                label: l10n.avgSleep,
                value: week.sleepHours == null
                    ? l10n.noValue
                    : l10n.hoursShort(formatAverage(week.sleepHours!)), // Checked above.
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Average extends StatelessWidget {
  const _Average({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
        child: DecoratedBox(
          decoration: BoxDecoration(color: p.primarySoft, borderRadius: AppRadius.mdAll),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Text(value, style: context.textStyles.titleMedium?.copyWith(color: p.primary)),
                Text(label, style: context.textStyles.labelMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLog extends StatelessWidget {
  const _QuickLog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _QuickTile(
            icon: Icons.healing_outlined,
            label: l10n.logSymptom,
            onTap: () => context.push(AppRoutes.trackSymptom),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickTile(
            icon: Icons.bedtime_outlined,
            label: l10n.logSleep,
            onTap: () => context.push(AppRoutes.trackSleep),
          ),
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: context.palette.primary, size: AppSizes.tileIcon),
          const SizedBox(height: AppSpacing.xs),
          Text(label, textAlign: TextAlign.center, style: context.textStyles.labelLarge),
        ],
      ),
    );
  }
}

class _TopSymptoms extends StatelessWidget {
  const _TopSymptoms({required this.symptoms});

  final List<TopSymptom> symptoms;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.topSymptomsTitle, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final s in symptoms)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(symptomIcon(s.category.icon), color: p.primary, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(s.category.name, style: context.textStyles.labelLarge)),
                  Text(
                    '× ${s.count} · ${l10n.severityValue(s.averageSeverity.round())}',
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InsightsPreview extends ConsumerWidget {
  const _InsightsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final insights = ref.watch(insightsProvider).value;

    return AppCard(
      onTap: () => context.push(AppRoutes.trackInsights),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_outlined, color: p.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(l10n.insightsTitle, style: context.textStyles.titleMedium)),
              Icon(Icons.chevron_right_rounded, color: p.textTertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            switch (insights) {
              null => l10n.insightsRefreshing,
              Insights(items: [final first, ...]) => first.text,
              Insights(refreshing: true) => l10n.insightsRefreshing,
              _ => l10n.insightsEmpty,
            },
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
