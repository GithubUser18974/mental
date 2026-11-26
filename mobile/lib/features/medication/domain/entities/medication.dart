/// Member-maintained medication records (FR-MED-*) — never prescriptions.
library;

enum MedicationStatus {
  active('active'),
  paused('paused'),
  discontinued('discontinued')
  ;

  const MedicationStatus(this.wire);

  final String wire;

  static MedicationStatus fromWire(String? v) =>
      values.firstWhere((s) => s.wire == v, orElse: () => MedicationStatus.active);
}

enum DosageUnit {
  mg('mg'),
  mcg('mcg'),
  g('g'),
  ml('ml'),
  drops('drops'),
  tablet('tablet'),
  capsule('capsule'),
  puff('puff'),
  patch('patch'),
  unit('unit'),
  other('other')
  ;

  const DosageUnit(this.wire);

  final String wire;

  static DosageUnit fromWire(String? v) =>
      values.firstWhere((u) => u.wire == v, orElse: () => DosageUnit.other);
}

enum ScheduleType {
  daily('daily'),
  weekly('weekly'),
  interval('interval'),
  asNeeded('as_needed')
  ;

  const ScheduleType(this.wire);

  final String wire;

  static ScheduleType fromWire(String? v) =>
      values.firstWhere((t) => t.wire == v, orElse: () => ScheduleType.asNeeded);
}

class MedicationSchedule {
  const MedicationSchedule({
    required this.type,
    this.times = const [],
    this.daysOfWeek = const [],
    this.intervalDays,
  });

  final ScheduleType type;

  /// Local wall-clock "HH:MM".
  final List<String> times;

  /// ISO 1 (Mon) … 7 (Sun), for weekly schedules.
  final List<int> daysOfWeek;
  final int? intervalDays;
}

class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.startDate,
    required this.status,
    required this.isCurrent,
    required this.remindersEnabled,
    required this.schedule,
    this.endDate,
    this.instructions,
    this.clinician,
    this.notes,
  });

  final String id;
  final String name;
  final String dosage;
  final DosageUnit unit;
  final DateTime startDate;
  final DateTime? endDate;
  final String? instructions;
  final String? clinician;
  final String? notes;
  final bool remindersEnabled;
  final MedicationStatus status;
  final bool isCurrent;
  final MedicationSchedule schedule;
}

enum IntakeStatus {
  taken('taken'),
  skipped('skipped'),
  missed('missed'),
  delayed('delayed')
  ;

  const IntakeStatus(this.wire);

  final String wire;

  static IntakeStatus fromWire(String? v) =>
      values.firstWhere((s) => s.wire == v, orElse: () => IntakeStatus.taken);

  bool get hasIntakeTime => this == taken || this == delayed;
}

class IntakeLog {
  const IntakeLog({
    required this.id,
    required this.medicationId,
    required this.status,
    this.scheduledAt,
    this.takenAt,
    this.notes,
  });

  final String id;
  final String medicationId;
  final IntakeStatus status;
  final DateTime? scheduledAt;
  final DateTime? takenAt;
  final String? notes;
}

/// A scheduled dose of an active medication (with its log, if recorded).
class Dose {
  const Dose({
    required this.medicationId,
    required this.scheduledAt,
    required this.reminder,
    this.log,
  });

  final String medicationId;
  final DateTime scheduledAt;
  final bool reminder;
  final IntakeLog? log;
}

enum ExperienceKind {
  benefit('benefit'),
  sideEffect('side_effect'),
  change('change'),
  general('general')
  ;

  const ExperienceKind(this.wire);

  final String wire;

  static ExperienceKind fromWire(String? v) =>
      values.firstWhere((k) => k.wire == v, orElse: () => ExperienceKind.general);
}

class MedicationExperience {
  const MedicationExperience({
    required this.id,
    required this.kind,
    required this.description,
    required this.observedOn,
  });

  final String id;
  final ExperienceKind kind;
  final String description;
  final DateTime observedOn;
}

/// What the medication form sends.
class MedicationDraft {
  const MedicationDraft({
    required this.name,
    required this.dosage,
    required this.unit,
    required this.startDate,
    required this.schedule,
    required this.remindersEnabled,
    this.endDate,
    this.instructions,
    this.clinician,
    this.notes,
  });

  final String name;
  final String dosage;
  final DosageUnit unit;
  final DateTime startDate;
  final DateTime? endDate;
  final MedicationSchedule schedule;
  final bool remindersEnabled;
  final String? instructions;
  final String? clinician;
  final String? notes;
}
