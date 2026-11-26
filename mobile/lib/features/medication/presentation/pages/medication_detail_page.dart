import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';
import 'package:mindful/features/medication/presentation/providers/medication_providers.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_labels.dart';

/// Medication details (FR-MED-004/005/006): info and schedule, pause / resume / stop,
/// recent doses, private experience notes, edit and delete.
class MedicationDetailPage extends ConsumerWidget {
  const MedicationDetailPage({required this.medicationId, super.key});

  final String medicationId;

  Future<bool> _confirm(BuildContext context, String message, String action) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(d).pop(false), child: Text(l10n.actionCancel)),
          TextButton(onPressed: () => Navigator.of(d).pop(true), child: Text(action)),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(medicationProvider(medicationId));
    final actions = ref.read(medicationActionsProvider);

    return ListPageScaffold(
      title: loaded.value?.name ?? l10n.medDetailsTitle,
      trailing: loaded.value == null
          ? null
          : IconButton(
              tooltip: l10n.medFormEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(AppRoutes.medicationEditPath(medicationId)),
            ),
      onRefresh: () async => ref
        ..invalidate(medicationProvider(medicationId))
        ..invalidate(intakeHistoryProvider(medicationId))
        ..invalidate(experiencesProvider(medicationId)),
      slivers: [
        loaded.when(
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
          error: (e, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              error: e,
              onRetry: () => ref.invalidate(medicationProvider(medicationId)),
            ),
          ),
          data: (m) => SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.xxl,
            ),
            sliver: SliverList.list(
              children: [
                _InfoCard(medication: m),
                const SizedBox(height: AppSpacing.md),
                if (m.status == MedicationStatus.active &&
                    m.schedule.type == ScheduleType.asNeeded) ...[
                  PrimaryButton(
                    label: l10n.medLogAsNeeded,
                    trailingIcon: Icons.check_rounded,
                    onPressed: () => _run(context, () async {
                      await actions.logAsNeeded(m.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(l10n.entrySaved)));
                      }
                    }),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Row(
                  children: [
                    if (m.status != MedicationStatus.discontinued)
                      Expanded(
                        child: SecondaryButton(
                          label: m.status == MedicationStatus.paused
                              ? l10n.medResume
                              : l10n.medPause,
                          onPressed: () => _run(
                            context,
                            () => actions.setStatus(
                              m.id,
                              m.status == MedicationStatus.paused
                                  ? MedicationStatus.active
                                  : MedicationStatus.paused,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SecondaryButton(
                          label: l10n.medResume,
                          onPressed: () =>
                              _run(context, () => actions.setStatus(m.id, MedicationStatus.active)),
                        ),
                      ),
                  ],
                ),
                if (m.status != MedicationStatus.discontinued)
                  TextButton(
                    onPressed: () async {
                      if (await _confirm(context, l10n.medStopConfirm, l10n.medStop) &&
                          context.mounted) {
                        await _run(
                          context,
                          () => actions.setStatus(m.id, MedicationStatus.discontinued),
                        );
                      }
                    },
                    child: Text(l10n.medStop),
                  ),
                const SizedBox(height: AppSpacing.md),
                _History(medicationId: m.id),
                const SizedBox(height: AppSpacing.md),
                _Experiences(medicationId: m.id),
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: () async {
                    if (await _confirm(context, l10n.medDeleteConfirm, l10n.actionDelete) &&
                        context.mounted) {
                      await _run(context, () async {
                        await actions.delete(m.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(l10n.entryDeleted)));
                          context.pop();
                        }
                      });
                    }
                  },
                  child: Text(
                    l10n.medDelete,
                    style: context.textStyles.labelLarge?.copyWith(color: context.palette.danger),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final m = medication;
    final date = DateFormat.yMMMd(l10n.localeName);
    final status = switch (m.status) {
      MedicationStatus.paused => l10n.medPaused,
      MedicationStatus.discontinued => l10n.medDiscontinued,
      MedicationStatus.active => null,
    };

    Widget line(IconData icon, String text) => Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: p.primary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(text, style: context.textStyles.bodyMedium)),
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(doseLabel(l10n, m), style: context.textStyles.titleLarge),
          if (status != null)
            Text(status, style: context.textStyles.labelMedium?.copyWith(color: p.primary)),
          line(Icons.schedule_rounded, scheduleSummary(context, m.schedule)),
          line(
            Icons.event_outlined,
            [
              l10n.medStarted(date.format(m.startDate)),
              if (m.endDate case final end?) l10n.medUntil(date.format(end)),
            ].join(' · '),
          ),
          if (m.schedule.type != ScheduleType.asNeeded && !m.remindersEnabled)
            line(Icons.notifications_off_outlined, l10n.remindersOff),
          if (m.instructions case final i? when i.isNotEmpty) line(Icons.info_outline_rounded, i),
          if (m.clinician case final c? when c.isNotEmpty) line(Icons.person_outline_rounded, c),
          if (m.notes case final n? when n.isNotEmpty) line(Icons.notes_rounded, n),
        ],
      ),
    );
  }
}

class _History extends ConsumerWidget {
  const _History({required this.medicationId});

  final String medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final history = ref.watch(intakeHistoryProvider(medicationId));
    final format = DateFormat.MMMEd(l10n.localeName).add_jm();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.medHistory, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          ...history.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (e, _) => [
              ErrorView(
                error: e,
                onRetry: () => ref.invalidate(intakeHistoryProvider(medicationId)),
              ),
            ],
            data: (page) => [
              if (page.items.isEmpty)
                Text(l10n.medHistoryEmpty, style: context.textStyles.bodyMedium),
              for (final log in page.items.take(14))
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxs),
                  child: Row(
                    children: [
                      Icon(log.status.icon, size: 18, color: p.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          format.format(
                            (log.scheduledAt ?? log.takenAt ?? DateTime.now()).toLocal(),
                          ),
                          style: context.textStyles.bodyMedium,
                        ),
                      ),
                      Text(log.status.label(l10n), style: context.textStyles.labelMedium),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Experiences extends ConsumerWidget {
  const _Experiences({required this.medicationId});

  final String medicationId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<(ExperienceKind, String)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ExperienceSheet(),
    );
    if (result == null || !context.mounted) return;
    try {
      await ref.read(medicationActionsProvider).addExperience(medicationId, result.$1, result.$2);
    } on Object catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final experiences = ref.watch(experiencesProvider(medicationId));
    final date = DateFormat.yMMMd(l10n.localeName);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.medExperiences, style: context.textStyles.titleMedium)),
              TextButton.icon(
                onPressed: () => _add(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.medAddExperience),
              ),
            ],
          ),
          ...experiences.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (e, _) => [
              ErrorView(error: e, onRetry: () => ref.invalidate(experiencesProvider(medicationId))),
            ],
            data: (list) => [
              if (list.isEmpty) Text(l10n.medExperiencesEmpty, style: context.textStyles.bodySmall),
              for (final e in list)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(e.kind.icon, size: 18, color: p.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${e.kind.label(l10n)} · ${date.format(e.observedOn)}',
                              style: context.textStyles.labelMedium,
                            ),
                            Text(e.description, style: context.textStyles.bodyMedium),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.expDelete,
                        icon: Icon(Icons.delete_outline_rounded, size: 18, color: p.textTertiary),
                        onPressed: () => ref
                            .read(medicationActionsProvider)
                            .deleteExperience(medicationId, e.id)
                            .catchError((Object err) {
                              if (context.mounted) showErrorSnackBar(context, err);
                            }),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExperienceSheet extends StatefulWidget {
  const _ExperienceSheet();

  @override
  State<_ExperienceSheet> createState() => _ExperienceSheetState();
}

class _ExperienceSheetState extends State<_ExperienceSheet> {
  final _text = TextEditingController();
  ExperienceKind _kind = ExperienceKind.general;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.medAddExperience, style: context.textStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final k in ExperienceKind.values)
                  PillOption(
                    label: k.label(l10n),
                    selected: _kind == k,
                    onTap: () => setState(() => _kind = k),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _text,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              maxLength: 2000,
              decoration: InputDecoration(hintText: l10n.expDescription),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: l10n.saveEntry,
              onPressed: _text.text.trim().length < 2
                  ? null
                  : () => Navigator.of(context).pop((_kind, _text.text.trim())),
            ),
          ],
        ),
      ),
    );
  }
}
