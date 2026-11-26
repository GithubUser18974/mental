import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/core/widgets/selectable_tile.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:mindful/features/tracking/presentation/widgets/entry_form_actions.dart';
import 'package:mindful/features/tracking/presentation/widgets/scale_field.dart';
import 'package:mindful/features/tracking/presentation/widgets/tracking_labels.dart';

/// Log (or edit) a symptom (FR-TRACK-003): category tile grid, severity, optional
/// duration and private notes.
class SymptomLogPage extends ConsumerWidget {
  const SymptomLogPage({this.entryId, super.key});

  final String? entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = entryId;
    if (id == null) return const _SymptomForm();
    return ref
        .watch(symptomEntryProvider(id))
        .when(
          loading: () => const Scaffold(body: AppBackground(child: LoadingView())),
          error: (e, _) => Scaffold(
            body: AppBackground(
              child: ErrorView(error: e, onRetry: () => ref.invalidate(symptomEntryProvider(id))),
            ),
          ),
          data: (entry) => _SymptomForm(editing: entry),
        );
  }
}

class _SymptomForm extends ConsumerStatefulWidget {
  const _SymptomForm({this.editing});

  final SymptomEntry? editing;

  @override
  ConsumerState<_SymptomForm> createState() => _SymptomFormState();
}

class _SymptomFormState extends ConsumerState<_SymptomForm> {
  static const List<int> _durations = [15, 30, 60, 120, 240];

  late String? _category = widget.editing?.category.slug;
  late int _severity = widget.editing?.severity ?? 5;
  late int? _duration = widget.editing?.durationMinutes;
  late final _notes = TextEditingController(text: widget.editing?.notes);
  bool _categoryMissing = false;
  bool _busy = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final category = _category;
    if (category == null) {
      setState(() => _categoryMissing = true);
      return;
    }
    setState(() => _busy = true);
    final draft = SymptomDraft(
      categorySlug: category,
      severity: _severity,
      durationMinutes: _duration,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    final ok = await runEntryAction(
      context,
      () => ref.read(trackingActionsProvider).saveSymptom(draft, id: widget.editing?.id),
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
      () => ref.read(trackingActionsProvider).deleteSymptom(id),
      message: AppLocalizations.of(context).entryDeleted,
    );
    if (!ok && mounted) setState(() => _busy = false);
  }

  String _durationLabel(AppLocalizations l10n, int minutes) =>
      minutes < 60 ? l10n.durationMinutes(minutes) : l10n.durationHours(minutes ~/ 60);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(symptomCategoriesProvider);

    return FormPage(
      title: widget.editing == null ? l10n.symptomTitle : l10n.symptomEditTitle,
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
          Text(l10n.symptomWhich, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          categories.when(
            loading: () => const SizedBox(height: 120, child: LoadingView()),
            error: (e, _) =>
                ErrorView(error: e, onRetry: () => ref.invalidate(symptomCategoriesProvider)),
            data: (list) => GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.95,
              children: [
                for (final c in list)
                  SelectableTile(
                    icon: symptomIcon(c.icon),
                    label: c.name,
                    selected: _category == c.slug,
                    onTap: () => setState(() {
                      _category = c.slug;
                      _categoryMissing = false;
                    }),
                  ),
              ],
            ),
          ),
          if (_categoryMissing)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
              child: Text(
                l10n.symptomRequired,
                style: context.textStyles.bodySmall?.copyWith(color: context.palette.danger),
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          ScaleField(
            label: l10n.scaleSeverity,
            value: _severity,
            isRequired: true,
            onChanged: (v) => setState(() => _severity = v ?? _severity),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.durationTitle, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              PillOption(
                label: l10n.durationNotSure,
                selected: _duration == null,
                onTap: () => setState(() => _duration = null),
              ),
              for (final minutes in _durations)
                PillOption(
                  label: _durationLabel(l10n, minutes),
                  selected: _duration == minutes,
                  onTap: () => setState(() => _duration = minutes),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: l10n.privateNotes,
            hint: l10n.privateNotesHint,
            controller: _notes,
            maxLength: 2000,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
