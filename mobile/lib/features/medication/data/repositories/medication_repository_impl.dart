import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/medication/data/models/medication_dtos.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';
import 'package:mindful/features/medication/domain/repositories/medication_repository.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => MedicationRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Remote implementation over `/api/v1/medications/*`. Nothing is cached on the device.
class MedicationRepositoryImpl implements MedicationRepository {
  MedicationRepositoryImpl(this._api);

  final ApiClient _api;

  static final DateFormat _day = DateFormat('yyyy-MM-dd');

  static Medication _med(Object? d) => MedicationDto.fromJson(ApiData.object(d)).toEntity();

  static IntakeLog _log(Object? d) => IntakeLogDto.fromJson(ApiData.object(d)).toEntity();

  static Map<String, dynamic> _body(MedicationDraft d) => {
    'name': d.name,
    'dosage': d.dosage,
    'unit': d.unit.wire,
    'start_date': _day.format(d.startDate),
    'end_date': d.endDate == null ? null : _day.format(d.endDate!),
    'instructions': d.instructions,
    'clinician': d.clinician,
    'notes': d.notes,
    'reminders_enabled': d.remindersEnabled,
    'schedule': {
      'type': d.schedule.type.wire,
      if (d.schedule.type != ScheduleType.asNeeded) 'times': d.schedule.times,
      if (d.schedule.type == ScheduleType.weekly) 'days_of_week': d.schedule.daysOfWeek,
      if (d.schedule.type == ScheduleType.interval) 'interval_days': d.schedule.intervalDays,
    },
  };

  @override
  Future<List<Medication>> medications(String filter) async {
    final items = <Medication>[];
    String? cursor;
    do {
      final envelope = await _api.get(
        '/medications',
        query: {'status': filter, 'per_page': 100, 'cursor': ?cursor},
        parse: (d) => ApiData.list(d).map((j) => MedicationDto.fromJson(j).toEntity()).toList(),
      );
      items.addAll(envelope.data);
      cursor = envelope.pagination?.hasMore ?? false ? envelope.pagination?.nextCursor : null;
    } while (cursor != null);
    // Names are encrypted server-side, so sorting happens here.
    return items..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Future<Medication> medication(String id) async =>
      (await _api.get('/medications/$id', parse: _med)).data;

  @override
  Future<Medication> save(MedicationDraft draft, {String? id}) async => id == null
      ? (await _api.post('/medications', body: _body(draft), parse: _med)).data
      : (await _api.put('/medications/$id', body: _body(draft), parse: _med)).data;

  @override
  Future<Medication> setStatus(String id, MedicationStatus status) async =>
      (await _api.put('/medications/$id', body: {'status': status.wire}, parse: _med)).data;

  @override
  Future<void> delete(String id) => _api.delete('/medications/$id');

  @override
  Future<List<Dose>> doses({required DateTime from, required DateTime to}) async {
    final envelope = await _api.get(
      '/medications/doses',
      query: {'from': _day.format(from), 'to': _day.format(to)},
      parse: (d) => ApiData.list(d).map((j) => DoseDto.fromJson(j).toEntity()).toList(),
    );
    return envelope.data;
  }

  @override
  Future<IntakeLog> logIntake(
    String medicationId, {
    required IntakeStatus status,
    DateTime? scheduledAt,
    DateTime? takenAt,
  }) async {
    final envelope = await _api.post(
      '/medications/$medicationId/logs',
      body: {
        'status': status.wire,
        'scheduled_at': ?scheduledAt?.toUtc().toIso8601String(),
        if (status.hasIntakeTime) 'taken_at': (takenAt ?? DateTime.now()).toUtc().toIso8601String(),
      },
      parse: _log,
    );
    return envelope.data;
  }

  @override
  Future<CursorPage<IntakeLog>> logs(String medicationId, {String? cursor}) async {
    final envelope = await _api.get(
      '/medications/$medicationId/logs',
      query: {'cursor': ?cursor},
      parse: (d) => ApiData.list(d).map((j) => IntakeLogDto.fromJson(j).toEntity()).toList(),
    );
    return CursorPage(
      items: envelope.data,
      nextCursor: envelope.pagination?.nextCursor,
      hasMore: envelope.pagination?.hasMore ?? false,
    );
  }

  @override
  Future<List<MedicationExperience>> experiences(String medicationId) async {
    final envelope = await _api.get(
      '/medications/$medicationId/experiences',
      query: {'per_page': 100},
      parse: (d) => ApiData.list(d).map((j) => ExperienceDto.fromJson(j).toEntity()).toList(),
    );
    return envelope.data;
  }

  @override
  Future<MedicationExperience> addExperience(
    String medicationId, {
    required ExperienceKind kind,
    required String description,
  }) async {
    final envelope = await _api.post(
      '/medications/$medicationId/experiences',
      body: {'kind': kind.wire, 'description': description},
      parse: (d) => ExperienceDto.fromJson(ApiData.object(d)).toEntity(),
    );
    return envelope.data;
  }

  @override
  Future<void> deleteExperience(String medicationId, String experienceId) =>
      _api.delete('/medications/$medicationId/experiences/$experienceId');
}
