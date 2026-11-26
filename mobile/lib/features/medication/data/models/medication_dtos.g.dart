// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleDto _$ScheduleDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ScheduleDto',
  json,
  ($checkedConvert) {
    final val = _ScheduleDto(
      type: $checkedConvert('type', (v) => v as String),
      times: $checkedConvert(
        'times',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
      ),
      daysOfWeek: $checkedConvert(
        'days_of_week',
        (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      ),
      intervalDays: $checkedConvert(
        'interval_days',
        (v) => (v as num?)?.toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'daysOfWeek': 'days_of_week',
    'intervalDays': 'interval_days',
  },
);

Map<String, dynamic> _$ScheduleDtoToJson(_ScheduleDto instance) => <String, dynamic>{
  'type': instance.type,
  'times': instance.times,
  'days_of_week': instance.daysOfWeek,
  'interval_days': instance.intervalDays,
};

_MedicationDto _$MedicationDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_MedicationDto',
  json,
  ($checkedConvert) {
    final val = _MedicationDto(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      dosage: $checkedConvert('dosage', (v) => v as String),
      unit: $checkedConvert('unit', (v) => v as String),
      startDate: $checkedConvert('start_date', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      endDate: $checkedConvert('end_date', (v) => v as String?),
      instructions: $checkedConvert('instructions', (v) => v as String?),
      clinician: $checkedConvert('clinician', (v) => v as String?),
      notes: $checkedConvert('notes', (v) => v as String?),
      remindersEnabled: $checkedConvert(
        'reminders_enabled',
        (v) => v as bool? ?? true,
      ),
      isCurrent: $checkedConvert('is_current', (v) => v as bool? ?? true),
      schedule: $checkedConvert(
        'schedule',
        (v) => v == null ? null : ScheduleDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'startDate': 'start_date',
    'endDate': 'end_date',
    'remindersEnabled': 'reminders_enabled',
    'isCurrent': 'is_current',
  },
);

Map<String, dynamic> _$MedicationDtoToJson(_MedicationDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dosage': instance.dosage,
  'unit': instance.unit,
  'start_date': instance.startDate,
  'status': instance.status,
  'end_date': instance.endDate,
  'instructions': instance.instructions,
  'clinician': instance.clinician,
  'notes': instance.notes,
  'reminders_enabled': instance.remindersEnabled,
  'is_current': instance.isCurrent,
  'schedule': instance.schedule?.toJson(),
};

_IntakeLogDto _$IntakeLogDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_IntakeLogDto',
  json,
  ($checkedConvert) {
    final val = _IntakeLogDto(
      id: $checkedConvert('id', (v) => v as String),
      medicationId: $checkedConvert('medication_id', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      scheduledAt: $checkedConvert(
        'scheduled_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      takenAt: $checkedConvert(
        'taken_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      notes: $checkedConvert('notes', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'medicationId': 'medication_id',
    'scheduledAt': 'scheduled_at',
    'takenAt': 'taken_at',
  },
);

Map<String, dynamic> _$IntakeLogDtoToJson(_IntakeLogDto instance) => <String, dynamic>{
  'id': instance.id,
  'medication_id': instance.medicationId,
  'status': instance.status,
  'scheduled_at': instance.scheduledAt?.toIso8601String(),
  'taken_at': instance.takenAt?.toIso8601String(),
  'notes': instance.notes,
};

_DoseDto _$DoseDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_DoseDto',
  json,
  ($checkedConvert) {
    final val = _DoseDto(
      medicationId: $checkedConvert('medication_id', (v) => v as String),
      scheduledAt: $checkedConvert(
        'scheduled_at',
        (v) => DateTime.parse(v as String),
      ),
      reminder: $checkedConvert('reminder', (v) => v as bool? ?? false),
      log: $checkedConvert(
        'log',
        (v) => v == null ? null : IntakeLogDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'medicationId': 'medication_id',
    'scheduledAt': 'scheduled_at',
  },
);

Map<String, dynamic> _$DoseDtoToJson(_DoseDto instance) => <String, dynamic>{
  'medication_id': instance.medicationId,
  'scheduled_at': instance.scheduledAt.toIso8601String(),
  'reminder': instance.reminder,
  'log': instance.log?.toJson(),
};

_ExperienceDto _$ExperienceDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ExperienceDto', json, ($checkedConvert) {
      final val = _ExperienceDto(
        id: $checkedConvert('id', (v) => v as String),
        kind: $checkedConvert('kind', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        observedOn: $checkedConvert('observed_on', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'observedOn': 'observed_on'});

Map<String, dynamic> _$ExperienceDtoToJson(_ExperienceDto instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'description': instance.description,
  'observed_on': instance.observedOn,
};
