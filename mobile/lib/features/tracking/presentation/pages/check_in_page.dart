import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:mindful/features/tracking/presentation/widgets/entry_form_actions.dart';
import 'package:mindful/features/tracking/presentation/widgets/mood_picker.dart';
import 'package:mindful/features/tracking/presentation/widgets/scale_field.dart';

/// Daily check-in (FR-TRACK-001/002): mood required; every scale and the private note are
/// optional. With [entryId] it edits (and can delete) that check-in.
class CheckInPage extends ConsumerWidget {
  const CheckInPage({this.entryId, super.key});

  final String? entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = entryId;
    if (id == null) return const _CheckInForm();
    return ref
        .watch(moodEntryProvider(id))
        .when(
          loading: () => const Scaffold(body: AppBackground(child: LoadingView())),
          error: (e, _) => Scaffold(
            body: AppBackground(
              child: ErrorView(error: e, onRetry: () => ref.invalidate(moodEntryProvider(id))),
            ),
          ),
          data: (entry) => _CheckInForm(editing: entry),
        );
  }
}

class _CheckInForm extends ConsumerStatefulWidget {
  const _CheckInForm({this.editing});

  final MoodEntry? editing;

  @override
  ConsumerState<_CheckInForm> createState() => _CheckInFormState();
}

class _CheckInFormState extends ConsumerState<_CheckInForm> {
  late Mood? _mood = widget.editing?.mood;
  late int? _score = widget.editing?.score;
  late int? _anxiety = widget.editing?.anxiety;
  late int? _stress = widget.editing?.stress;
  late int? _energy = widget.editing?.energy;
  late final _notes = TextEditingController(text: widget.editing?.notes);
  bool _moodMissing = false;
  bool _busy = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final mood = _mood;
    if (mood == null) {
      setState(() => _moodMissing = true);
      return;
    }
    setState(() => _busy = true);
    final draft = MoodDraft(
      mood: mood,
      score: _score,
      anxiety: _anxiety,
      stress: _stress,
      energy: _energy,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    final ok = await runEntryAction(
      context,
      () => ref.read(trackingActionsProvider).saveMood(draft, id: widget.editing?.id),
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
      () => ref.read(trackingActionsProvider).deleteMood(id),
      message: AppLocalizations.of(context).entryDeleted,
    );
    if (!ok && mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormPage(
      title: widget.editing == null ? l10n.checkInPrompt : l10n.checkInEditTitle,
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
          Text(l10n.moodQuestion, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          MoodPicker(
            selected: _mood,
            onChanged: (mood) => setState(() {
              _mood = mood;
              _moodMissing = false;
            }),
          ),
          if (_moodMissing)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
              child: Text(
                l10n.moodRequired,
                style: context.textStyles.bodySmall?.copyWith(color: context.palette.danger),
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.detailsOptional, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ScaleField(
            label: l10n.scaleMood,
            value: _score,
            onChanged: (v) => setState(() => _score = v),
          ),
          ScaleField(
            label: l10n.scaleAnxiety,
            value: _anxiety,
            onChanged: (v) => setState(() => _anxiety = v),
          ),
          ScaleField(
            label: l10n.scaleStress,
            value: _stress,
            onChanged: (v) => setState(() => _stress = v),
          ),
          ScaleField(
            label: l10n.scaleEnergy,
            value: _energy,
            onChanged: (v) => setState(() => _energy = v),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.privateNotes,
            hint: l10n.privateNotesHint,
            controller: _notes,
            maxLength: 2000,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
