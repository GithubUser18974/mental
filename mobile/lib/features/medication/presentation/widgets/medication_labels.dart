import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';

/// "08:00" → localized clock time ("8:00 AM" / "٨:٠٠ ص").
String formatClock(BuildContext context, String hhmm) {
  final parts = hhmm.split(':');
  final time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  return MaterialLocalizations.of(context).formatTimeOfDay(time);
}

String formatTime(BuildContext context, DateTime at) =>
    MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(at.toLocal()));

/// Short weekday name for ISO 1 (Mon) … 7 (Sun).
String weekdayName(AppLocalizations l10n, int isoDay) =>
    // 2024-01-01 was a Monday.
    DateFormat.E(l10n.localeName).format(DateTime(2024, 1, isoDay));

/// "50 mg", "1 tablet".
String doseLabel(AppLocalizations l10n, Medication m) =>
    '${m.dosage} ${m.unit == DosageUnit.other ? l10n.unitOther : m.unit.wire}';

/// "Every day at 8:00 AM, 8:00 PM", "Mon, Wed at …", "Every 3 days at …", "As needed".
String scheduleSummary(BuildContext context, MedicationSchedule s) {
  final l10n = AppLocalizations.of(context);
  final times = s.times.map((t) => formatClock(context, t)).join(', ');
  final when = switch (s.type) {
    ScheduleType.daily => l10n.scheduleDaily,
    ScheduleType.weekly => s.daysOfWeek.map((d) => weekdayName(l10n, d)).join(', '),
    ScheduleType.interval => l10n.scheduleEveryNDays(s.intervalDays ?? 2),
    ScheduleType.asNeeded => l10n.scheduleAsNeeded,
  };
  return s.type == ScheduleType.asNeeded || times.isEmpty
      ? when
      : '$when ${l10n.scheduleAt(times)}';
}

extension IntakeStatusUi on IntakeStatus {
  String label(AppLocalizations l10n) => switch (this) {
    IntakeStatus.taken => l10n.doseStatusTaken,
    IntakeStatus.skipped => l10n.doseStatusSkipped,
    IntakeStatus.missed => l10n.doseStatusMissed,
    IntakeStatus.delayed => l10n.doseStatusDelayed,
  };

  IconData get icon => switch (this) {
    IntakeStatus.taken => Icons.check_circle_rounded,
    IntakeStatus.delayed => Icons.schedule_rounded,
    IntakeStatus.skipped => Icons.remove_circle_outline_rounded,
    IntakeStatus.missed => Icons.radio_button_unchecked_rounded,
  };
}

extension ExperienceKindUi on ExperienceKind {
  String label(AppLocalizations l10n) => switch (this) {
    ExperienceKind.benefit => l10n.expBenefit,
    ExperienceKind.sideEffect => l10n.expSideEffect,
    ExperienceKind.change => l10n.expChange,
    ExperienceKind.general => l10n.expGeneral,
  };

  IconData get icon => switch (this) {
    ExperienceKind.benefit => Icons.thumb_up_alt_outlined,
    ExperienceKind.sideEffect => Icons.report_gmailerrorred_outlined,
    ExperienceKind.change => Icons.change_circle_outlined,
    ExperienceKind.general => Icons.notes_rounded,
  };
}
