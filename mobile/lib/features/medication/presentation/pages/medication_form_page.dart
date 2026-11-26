import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/segmented_pills.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';
import 'package:mindful/features/medication/presentation/providers/medication_providers.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_labels.dart';

/// Add or edit a medication (FR-MED-001/002): details, schedule and reminders.
class MedicationFormPage extends ConsumerWidget {
  const MedicationFormPage({this.medicationId, super.key});

  final String? medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = medicationId;
    if (id == null) return const _MedicationForm();
    return ref
        .watch(medicationProvider(id))
        .when(
          loading: () => const Scaffold(body: AppBackground(child: LoadingView())),
          error: (e, _) => Scaffold(
            body: AppBackground(
              child: ErrorView(error: e, onRetry: () => ref.invalidate(medicationProvider(id))),
            ),
          ),
          data: (m) => _MedicationForm(editing: m),
        );
  }
}

class _MedicationForm extends ConsumerStatefulWidget {
  const _MedicationForm({this.editing});

  final Medication? editing;

  @override
  ConsumerState<_MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends ConsumerState<_MedicationForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.editing?.name);
  late final _dosage = TextEditingController(text: widget.editing?.dosage);
  late final _instructions = TextEditingController(text: widget.editing?.instructions);
  late final _clinician = TextEditingController(text: widget.editing?.clinician);
  late final _notes = TextEditingController(text: widget.editing?.notes);
  late DosageUnit _unit = widget.editing?.unit ?? DosageUnit.mg;
  late DateTime _start = widget.editing?.startDate ?? DateUtils.dateOnly(DateTime.now());
  late DateTime? _end = widget.editing?.endDate;
  late ScheduleType _type = widget.editing?.schedule.type ?? ScheduleType.daily;
  late List<String> _times = [...?widget.editing?.schedule.times];
  late Set<int> _days = {...?widget.editing?.schedule.daysOfWeek};
  late int _interval = widget.editing?.schedule.intervalDays ?? 2;
  late bool _reminders = widget.editing?.remindersEnabled ?? true;
  String? _scheduleError;
  bool _busy = false;
  Map<String, List<String>> _serverErrors = const {};

  @override
  void initState() {
    super.initState();
    if (_times.isEmpty && _type != ScheduleType.asNeeded) _times = ['08:00'];
  }

  @override
  void dispose() {
    for (final c in [_name, _dosage, _instructions, _clinician, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _optional(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    final value =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (!_times.contains(value)) _times = ([..._times, value]..sort());
      _scheduleError = null;
    });
  }

  Future<void> _pickDate({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? _start : (_end ?? _start),
      firstDate: start ? DateTime(2000) : _start,
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _start = picked;
        if (_end != null && _end!.isBefore(picked)) _end = null; // Checked non-null.
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final scheduleError = switch (_type) {
      ScheduleType.asNeeded => null,
      _ when _times.isEmpty => l10n.medTimesRequired,
      ScheduleType.weekly when _days.isEmpty => l10n.medDaysRequired,
      _ => null,
    };
    setState(() => _scheduleError = scheduleError);
    if (!(_formKey.currentState?.validate() ?? false) || scheduleError != null) return;

    setState(() {
      _busy = true;
      _serverErrors = const {};
    });
    final draft = MedicationDraft(
      name: _name.text.trim(),
      dosage: _dosage.text.trim(),
      unit: _unit,
      startDate: _start,
      endDate: _end,
      remindersEnabled: _reminders,
      instructions: _optional(_instructions),
      clinician: _optional(_clinician),
      notes: _optional(_notes),
      schedule: MedicationSchedule(
        type: _type,
        times: _type == ScheduleType.asNeeded ? const [] : _times,
        daysOfWeek: (_days.toList()..sort()),
        intervalDays: _interval,
      ),
    );
    try {
      await ref.read(medicationActionsProvider).save(draft, id: widget.editing?.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.entrySaved)));
      context.pop();
    } on ValidationException catch (e) {
      if (mounted) setState(() => _serverErrors = e.fieldErrors);
    } on Object catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final date = DateFormat.yMMMd(l10n.localeName);

    return FormPage(
      title: widget.editing == null ? l10n.medFormNew : l10n.medFormEdit,
      subtitle: l10n.medFormSubtitle,
      badge: l10n.checkInBadge,
      bottom: PrimaryButton(label: l10n.saveEntry, isLoading: _busy, onPressed: _save),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.medName,
              controller: _name,
              textInputAction: TextInputAction.next,
              errorText: _serverErrors['name']?.first,
              validator: (v) => (v ?? '').trim().isEmpty ? l10n.medNameRequired : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.medDosage,
                    controller: _dosage,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    errorText: _serverErrors['dosage']?.first,
                    validator: (v) => RegExp(r'^\d+([.,]\d+)?$').hasMatch((v ?? '').trim())
                        ? null
                        : l10n.medDosageInvalid,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.xxs,
                          bottom: AppSpacing.xs,
                        ),
                        child: Text(l10n.medUnit, style: context.textStyles.titleSmall),
                      ),
                      DropdownButtonFormField<DosageUnit>(
                        initialValue: _unit,
                        items: [
                          for (final u in DosageUnit.values)
                            DropdownMenuItem(
                              value: u,
                              child: Text(u == DosageUnit.other ? l10n.unitOther : u.wire),
                            ),
                        ],
                        onChanged: (u) => setState(() => _unit = u ?? _unit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: l10n.medStartDate,
                    value: date.format(_start),
                    onTap: () => _pickDate(start: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DateField(
                    label: l10n.medEndDate,
                    value: _end == null ? l10n.medNoEndDate : date.format(_end!), // Checked.
                    onTap: () => _pickDate(start: false),
                    onClear: _end == null ? null : () => setState(() => _end = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.medSchedule, style: context.textStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SegmentedPills(
              labels: [
                l10n.scheduleDaily,
                l10n.scheduleWeekly,
                l10n.scheduleInterval,
                l10n.scheduleAsNeeded,
              ],
              selectedIndex: _type.index,
              onChanged: (i) => setState(() {
                _type = ScheduleType.values[i];
                if (_type != ScheduleType.asNeeded && _times.isEmpty) _times = ['08:00'];
                _scheduleError = null;
              }),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_type == ScheduleType.weekly) ...[
              Text(l10n.medDays, style: context.textStyles.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (var d = 1; d <= 7; d++)
                    PillOption(
                      label: weekdayName(l10n, d),
                      selected: _days.contains(d),
                      onTap: () => setState(() {
                        _days = _days.contains(d) ? ({..._days}..remove(d)) : {..._days, d};
                        _scheduleError = null;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (_type == ScheduleType.interval) ...[
              AppCard(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.medIntervalDays(_interval),
                        style: context.textStyles.titleSmall,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: _interval > 2 ? () => setState(() => _interval--) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: _interval < 90 ? () => setState(() => _interval++) : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (_type != ScheduleType.asNeeded) ...[
              Text(l10n.medTimes, style: context.textStyles.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final t in _times)
                    InputChip(
                      label: Text(formatClock(context, t)),
                      deleteButtonTooltipMessage: l10n.medRemoveTime(formatClock(context, t)),
                      onDeleted: () => setState(() => _times = [..._times]..remove(t)),
                    ),
                  ActionChip(
                    avatar: Icon(Icons.add_rounded, color: p.primary),
                    label: Text(l10n.medAddTime),
                    onPressed: _times.length >= 8 ? null : _addTime,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs),
                child: SwitchListTile(
                  contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs),
                  title: Text(l10n.medReminders, style: context.textStyles.titleSmall),
                  subtitle: Text(l10n.medRemindersHelp, style: context.textStyles.bodySmall),
                  value: _reminders,
                  onChanged: (v) => setState(() => _reminders = v),
                ),
              ),
            ],
            if (_scheduleError != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
                child: Text(
                  _scheduleError!, // Checked in the `if`.
                  style: context.textStyles.bodySmall?.copyWith(color: p.danger),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.medInstructions,
              hint: l10n.medInstructionsHint,
              controller: _instructions,
              maxLength: 1000,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: l10n.medClinician, controller: _clinician, maxLength: 120),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: l10n.medNotes, controller: _notes, maxLength: 2000, maxLines: 3),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value, required this.onTap, this.onClear});

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.xxs, bottom: AppSpacing.xs),
          child: Text(label, style: context.textStyles.titleSmall, maxLines: 1),
        ),
        AppCard(
          onTap: onTap,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(Icons.event_outlined, size: 18, color: context.palette.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(value, style: context.textStyles.labelLarge, maxLines: 1),
              ),
              if (onClear != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: onClear,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
