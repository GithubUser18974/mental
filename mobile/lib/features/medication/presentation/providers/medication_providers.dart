import 'dart:async';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/core/notifications/local_reminders.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';

/// Private medication data lives only in memory (autoDispose, wiped on sign-out).
final FutureProviderFamily<List<Medication>, String> medicationsProvider = FutureProvider
    .autoDispose
    .family<List<Medication>, String>((ref, filter) {
      ref.watch(authSessionProvider);
      return ref.read(medicationRepositoryProvider).medications(filter);
    });

final FutureProviderFamily<Medication, String> medicationProvider = FutureProvider.autoDispose
    .family<Medication, String>((ref, id) {
      ref.watch(authSessionProvider);
      return ref.read(medicationRepositoryProvider).medication(id);
    });

/// Today's doses (local day) with their logs.
final FutureProvider<List<Dose>> todayDosesProvider = FutureProvider.autoDispose((ref) {
  ref.watch(authSessionProvider);
  final today = DateTime.now();
  return ref.read(medicationRepositoryProvider).doses(from: today, to: today);
});

final FutureProviderFamily<CursorPage<IntakeLog>, String> intakeHistoryProvider = FutureProvider
    .autoDispose
    .family<CursorPage<IntakeLog>, String>((ref, id) {
      ref.watch(authSessionProvider);
      return ref.read(medicationRepositoryProvider).logs(id);
    });

final FutureProviderFamily<List<MedicationExperience>, String> experiencesProvider = FutureProvider
    .autoDispose
    .family<List<MedicationExperience>, String>((ref, id) {
      ref.watch(authSessionProvider);
      return ref.read(medicationRepositoryProvider).experiences(id);
    });

/// Rebuilds the device's local reminders from the server's dose list (FR-MED-003):
/// the next `ReminderSync.days` days, active medications with reminders on, doses not
/// yet logged.
/// Text is always generic — never a medication name or dose.
final reminderSyncProvider = Provider<ReminderSync>(ReminderSync.new);

class ReminderSync {
  ReminderSync(this._ref);

  final Ref _ref;

  static const int days = 7;

  /// Same dose → same notification id.
  static int idFor(Dose dose) =>
      Object.hash(dose.medicationId, dose.scheduledAt.millisecondsSinceEpoch) & 0x7fffffff;

  Future<void> sync({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final doses = await _ref
        .read(medicationRepositoryProvider)
        .doses(
          from: current,
          to: current.add(const Duration(days: days - 1)),
        );

    final slots = [
      for (final dose in doses)
        if (dose.reminder && dose.log == null && dose.scheduledAt.isAfter(current))
          ReminderSlot(id: idFor(dose), at: dose.scheduledAt),
    ];

    final locale = _ref.read(localeControllerProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(Locale(effectiveLanguageCode(locale)));
    await _ref
        .read(localRemindersProvider)
        .replaceAll(slots, title: l10n.appName, body: l10n.reminderBody);
  }
}

/// Medication changes, each followed by a refresh of the affected lists and the
/// device's reminders (so a discontinued medication stops reminding at once).
final medicationActionsProvider = Provider<MedicationActions>(MedicationActions.new);

class MedicationActions {
  MedicationActions(this._ref);

  final Ref _ref;

  void _refresh({String? id}) {
    _ref
      ..invalidate(medicationsProvider)
      ..invalidate(todayDosesProvider);
    if (id != null) {
      _ref
        ..invalidate(medicationProvider(id))
        ..invalidate(intakeHistoryProvider(id));
    }
    unawaited(_ref.read(reminderSyncProvider).sync().catchError((Object _) {}));
  }

  Future<Medication> save(MedicationDraft draft, {String? id}) async {
    final saved = await _ref.read(medicationRepositoryProvider).save(draft, id: id);
    if (draft.remindersEnabled && draft.schedule.type != ScheduleType.asNeeded) {
      // Ask once, at the moment reminders become useful. Declining is fine.
      await _ref.read(localRemindersProvider).requestPermission().catchError((Object _) => false);
    }
    _refresh(id: saved.id);
    return saved;
  }

  Future<void> setStatus(String id, MedicationStatus status) async {
    await _ref.read(medicationRepositoryProvider).setStatus(id, status);
    _refresh(id: id);
  }

  Future<void> delete(String id) async {
    await _ref.read(medicationRepositoryProvider).delete(id);
    _refresh();
  }

  Future<void> logDose(Dose dose, IntakeStatus status) async {
    await _ref
        .read(medicationRepositoryProvider)
        .logIntake(dose.medicationId, status: status, scheduledAt: dose.scheduledAt);
    _refresh(id: dose.medicationId);
  }

  Future<void> logAsNeeded(String medicationId) async {
    await _ref
        .read(medicationRepositoryProvider)
        .logIntake(medicationId, status: IntakeStatus.taken, takenAt: DateTime.now());
    _ref.invalidate(intakeHistoryProvider(medicationId));
  }

  Future<void> addExperience(String id, ExperienceKind kind, String description) async {
    await _ref
        .read(medicationRepositoryProvider)
        .addExperience(id, kind: kind, description: description);
    _ref.invalidate(experiencesProvider(id));
  }

  Future<void> deleteExperience(String id, String experienceId) async {
    await _ref.read(medicationRepositoryProvider).deleteExperience(id, experienceId);
    _ref.invalidate(experiencesProvider(id));
  }
}
