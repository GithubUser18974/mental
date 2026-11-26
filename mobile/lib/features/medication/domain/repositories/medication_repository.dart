import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';

/// Private medication API (SRS §8.6). Implementations throw `AppException`s.
abstract interface class MedicationRepository {
  /// [filter]: `current`, `past` or `all`.
  Future<List<Medication>> medications(String filter);

  Future<Medication> medication(String id);

  Future<Medication> save(MedicationDraft draft, {String? id});

  Future<Medication> setStatus(String id, MedicationStatus status);

  Future<void> delete(String id);

  /// Doses of active medications for local days [from]..[to] (inclusive).
  Future<List<Dose>> doses({required DateTime from, required DateTime to});

  Future<IntakeLog> logIntake(
    String medicationId, {
    required IntakeStatus status,
    DateTime? scheduledAt,
    DateTime? takenAt,
  });

  Future<CursorPage<IntakeLog>> logs(String medicationId, {String? cursor});

  Future<List<MedicationExperience>> experiences(String medicationId);

  Future<MedicationExperience> addExperience(
    String medicationId, {
    required ExperienceKind kind,
    required String description,
  });

  Future<void> deleteExperience(String medicationId, String experienceId);
}
