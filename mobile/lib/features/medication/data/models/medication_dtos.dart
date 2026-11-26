import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';

part 'medication_dtos.freezed.dart';
part 'medication_dtos.g.dart';

@freezed
abstract class ScheduleDto with _$ScheduleDto {
  const factory ScheduleDto({
    required String type,
    @Default(<String>[]) List<String> times,
    List<int>? daysOfWeek,
    int? intervalDays,
  }) = _ScheduleDto;

  const ScheduleDto._();

  factory ScheduleDto.fromJson(Map<String, dynamic> json) => _$ScheduleDtoFromJson(json);

  MedicationSchedule toEntity() => MedicationSchedule(
    type: ScheduleType.fromWire(type),
    times: times,
    daysOfWeek: daysOfWeek ?? const [],
    intervalDays: intervalDays,
  );
}

@freezed
abstract class MedicationDto with _$MedicationDto {
  const factory MedicationDto({
    required String id,
    required String name,
    required String dosage,
    required String unit,
    required String startDate,
    required String status,
    String? endDate,
    String? instructions,
    String? clinician,
    String? notes,
    @Default(true) bool remindersEnabled,
    @Default(true) bool isCurrent,
    ScheduleDto? schedule,
  }) = _MedicationDto;

  const MedicationDto._();

  factory MedicationDto.fromJson(Map<String, dynamic> json) => _$MedicationDtoFromJson(json);

  Medication toEntity() => Medication(
    id: id,
    name: name,
    dosage: dosage,
    unit: DosageUnit.fromWire(unit),
    startDate: DateTime.parse(startDate),
    endDate: endDate == null ? null : DateTime.parse(endDate!),
    instructions: instructions,
    clinician: clinician,
    notes: notes,
    remindersEnabled: remindersEnabled,
    status: MedicationStatus.fromWire(status),
    isCurrent: isCurrent,
    schedule: schedule?.toEntity() ?? const MedicationSchedule(type: ScheduleType.asNeeded),
  );
}

@freezed
abstract class IntakeLogDto with _$IntakeLogDto {
  const factory IntakeLogDto({
    required String id,
    required String medicationId,
    required String status,
    DateTime? scheduledAt,
    DateTime? takenAt,
    String? notes,
  }) = _IntakeLogDto;

  const IntakeLogDto._();

  factory IntakeLogDto.fromJson(Map<String, dynamic> json) => _$IntakeLogDtoFromJson(json);

  IntakeLog toEntity() => IntakeLog(
    id: id,
    medicationId: medicationId,
    status: IntakeStatus.fromWire(status),
    scheduledAt: scheduledAt?.toUtc(),
    takenAt: takenAt?.toUtc(),
    notes: notes,
  );
}

@freezed
abstract class DoseDto with _$DoseDto {
  const factory DoseDto({
    required String medicationId,
    required DateTime scheduledAt,
    @Default(false) bool reminder,
    IntakeLogDto? log,
  }) = _DoseDto;

  const DoseDto._();

  factory DoseDto.fromJson(Map<String, dynamic> json) => _$DoseDtoFromJson(json);

  Dose toEntity() => Dose(
    medicationId: medicationId,
    scheduledAt: scheduledAt.toUtc(),
    reminder: reminder,
    log: log?.toEntity(),
  );
}

@freezed
abstract class ExperienceDto with _$ExperienceDto {
  const factory ExperienceDto({
    required String id,
    required String kind,
    required String description,
    required String observedOn,
  }) = _ExperienceDto;

  const ExperienceDto._();

  factory ExperienceDto.fromJson(Map<String, dynamic> json) => _$ExperienceDtoFromJson(json);

  MedicationExperience toEntity() => MedicationExperience(
    id: id,
    kind: ExperienceKind.fromWire(kind),
    description: description,
    observedOn: DateTime.parse(observedOn),
  );
}
