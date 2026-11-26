import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';
import 'package:mindful/features/medication/presentation/providers/medication_providers.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_labels.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_tile.dart';

/// Meds tab (FR-MED-006): today's doses with Taken / Skip, current medications, and
/// a link to past ones. Opening it also refreshes the device's local reminders.
class MedsPage extends ConsumerStatefulWidget {
  const MedsPage({super.key});

  @override
  ConsumerState<MedsPage> createState() => _MedsPageState();
}

class _MedsPageState extends ConsumerState<MedsPage> {
  @override
  void initState() {
    super.initState();
    // Best effort: keeps reminders aligned with the server (e.g. after a timezone change).
    ref.read(reminderSyncProvider).sync().ignore();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final medications = ref.watch(medicationsProvider('current'));

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(medicationsProvider)
          ..invalidate(todayDosesProvider);
        await ref.read(medicationsProvider('current').future);
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
            child: Text(l10n.medsTitle, style: context.textStyles.headlineSmall),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: context.palette.textSecondary),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(child: Text(l10n.medsDisclaimer, style: context.textStyles.bodySmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...medications.when(
            skipLoadingOnRefresh: true,
            loading: () => [const SizedBox(height: 200, child: LoadingView())],
            error: (e, _) => [
              ErrorView(error: e, onRetry: () => ref.invalidate(medicationsProvider)),
            ],
            data: (meds) => [
              if (meds.isNotEmpty) ...[
                _TodayCard(medications: meds),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.currentMeds, style: context.textStyles.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                for (final m in meds)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
                    child: MedicationTile(medication: m),
                  ),
              ] else
                EmptyView(icon: Icons.medication_outlined, subtitle: l10n.noMeds),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: l10n.addMedication,
                trailingIcon: Icons.add_rounded,
                onPressed: () => context.push(AppRoutes.medicationNew),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.medicationsPast),
                child: Text(l10n.pastMeds),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard({required this.medications});

  final List<Medication> medications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final doses = ref.watch(todayDosesProvider);
    final byId = {for (final m in medications) m.id: m};

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.todayDoses, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...doses.when(
            skipLoadingOnRefresh: true,
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (e, _) => [
              ErrorView(error: e, onRetry: () => ref.invalidate(todayDosesProvider)),
            ],
            data: (list) => [
              if (list.isEmpty) Text(l10n.noDosesToday, style: context.textStyles.bodyMedium),
              for (final dose in list)
                if (byId[dose.medicationId] case final med?) _DoseRow(dose: dose, medication: med),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoseRow extends ConsumerStatefulWidget {
  const _DoseRow({required this.dose, required this.medication});

  final Dose dose;
  final Medication medication;

  @override
  ConsumerState<_DoseRow> createState() => _DoseRowState();
}

class _DoseRowState extends ConsumerState<_DoseRow> {
  bool _busy = false;

  Future<void> _log(IntakeStatus status) async {
    setState(() => _busy = true);
    try {
      await ref.read(medicationActionsProvider).logDose(widget.dose, status);
    } on Object catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final time = formatTime(context, widget.dose.scheduledAt);
    final log = widget.dose.log;
    final name = widget.medication.name;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(time, style: context.textStyles.labelLarge?.copyWith(color: p.primary)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.textStyles.titleSmall, overflow: TextOverflow.ellipsis),
                Text(doseLabel(l10n, widget.medication), style: context.textStyles.bodySmall),
              ],
            ),
          ),
          if (log != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(log.status.icon, size: 18, color: p.primary),
                const SizedBox(width: AppSpacing.xxs),
                Text(log.status.label(l10n), style: context.textStyles.labelMedium),
              ],
            )
          else if (_busy)
            const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
          else ...[
            IconButton(
              tooltip: l10n.markSkipped(name, time),
              icon: Icon(Icons.close_rounded, color: p.textSecondary),
              onPressed: () => _log(IntakeStatus.skipped),
            ),
            IconButton.filled(
              tooltip: l10n.markTaken(name, time),
              icon: const Icon(Icons.check_rounded),
              onPressed: () => _log(IntakeStatus.taken),
            ),
          ],
        ],
      ),
    );
  }
}
