import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:mindful/features/tracking/presentation/widgets/entry_form_actions.dart';
import 'package:mindful/features/tracking/presentation/widgets/scale_field.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

/// Log (or edit) last night's sleep: hours in half-hour steps + optional quality.
class SleepLogPage extends ConsumerWidget {
  const SleepLogPage({this.entryId, super.key});

  final String? entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = entryId;
    if (id == null) return const _SleepForm();
    return ref
        .watch(sleepEntryProvider(id))
        .when(
          loading: () => const Scaffold(body: AppBackground(child: LoadingView())),
          error: (e, _) => Scaffold(
            body: AppBackground(
              child: ErrorView(error: e, onRetry: () => ref.invalidate(sleepEntryProvider(id))),
            ),
          ),
          data: (entry) => _SleepForm(editing: entry),
        );
  }
}

class _SleepForm extends ConsumerStatefulWidget {
  const _SleepForm({this.editing});

  final SleepEntry? editing;

  @override
  ConsumerState<_SleepForm> createState() => _SleepFormState();
}

class _SleepFormState extends ConsumerState<_SleepForm> {
  /// Half-hour steps between 30 min and 14 h.
  late int _minutes = (widget.editing?.durationMinutes ?? 420).clamp(30, 840);
  late int? _quality = widget.editing?.quality;
  bool _busy = false;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final ok = await runEntryAction(
      context,
      () => ref
          .read(trackingActionsProvider)
          .saveSleep(
            SleepDraft(durationMinutes: _minutes, quality: _quality),
            id: widget.editing?.id,
          ),
      message: l10n.entrySaved,
    );
    if (!ok && mounted) setState(() => _busy = false);
  }

  Future<void> _delete() async {
    final id = widget.editing?.id;
    if (id == null || !await confirmEntryDelete(context) || !mounted) return;
    setState(() => _busy = true);
    final ok = await runEntryAction(
      context,
      () => ref.read(trackingActionsProvider).deleteSleep(id),
      message: AppLocalizations.of(context).entryDeleted,
    );
    if (!ok && mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return FormPage(
      title: widget.editing == null ? l10n.sleepTitle : l10n.sleepEditTitle,
      subtitle: l10n.trackPrivate,
      badge: l10n.checkInBadge,
      bottom: EntryFormActions(
        busy: _busy,
        onSave: _save,
        onDelete: widget.editing == null ? null : _delete,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.sleepHowLong, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                Icon(Icons.bedtime_outlined, color: p.primary, size: 32),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.sleepHoursValue(hoursOf(_minutes)),
                  style: context.textStyles.headlineSmall,
                ),
                Slider(
                  value: _minutes.toDouble(),
                  min: 30,
                  max: 840,
                  divisions: 27,
                  label: l10n.sleepHoursValue(hoursOf(_minutes)),
                  semanticFormatterCallback: (v) => l10n.sleepHoursValue(hoursOf(v.round())),
                  onChanged: (v) => setState(() => _minutes = v.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ScaleField(
            label: l10n.scaleSleepQuality,
            value: _quality,
            onChanged: (v) => setState(() => _quality = v),
          ),
        ],
      ),
    );
  }
}
