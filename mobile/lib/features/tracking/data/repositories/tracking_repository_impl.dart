import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/tracking/data/models/tracking_dtos.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';
import 'package:mindful/features/tracking/domain/repositories/tracking_repository.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>(
  (ref) => TrackingRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Remote implementation over `/api/v1/tracking/*`. Nothing is cached on the device.
class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl(this._api);

  final ApiClient _api;

  static final DateFormat _day = DateFormat('yyyy-MM-dd');

  static MoodEntry _mood(Object? d) => MoodEntryDto.fromJson(ApiData.object(d)).toEntity();

  static SymptomEntry _symptom(Object? d) => SymptomEntryDto.fromJson(ApiData.object(d)).toEntity();

  static SleepEntry _sleep(Object? d) => SleepEntryDto.fromJson(ApiData.object(d)).toEntity();

  /// Follows cursors until the range is fully loaded.
  Future<List<T>> _all<T>(
    String path,
    DayRange range,
    T Function(Map<String, dynamic>) parse,
  ) async {
    final items = <T>[];
    String? cursor;
    do {
      final envelope = await _api.get(
        path,
        query: {
          'from': _day.format(range.from),
          'to': _day.format(range.to),
          'per_page': 100,
          'cursor': ?cursor,
        },
        parse: (d) => ApiData.list(d).map(parse).toList(),
      );
      items.addAll(envelope.data);
      cursor = envelope.pagination?.hasMore ?? false ? envelope.pagination?.nextCursor : null;
    } while (cursor != null);
    return items;
  }

  @override
  Future<TrackingOverview> overview() async => (await _api.get(
    '/tracking/overview',
    parse: (d) => OverviewDto.fromJson(ApiData.object(d)).toEntity(),
  )).data;

  @override
  Future<Insights> insights() async => (await _api.get(
    '/tracking/insights',
    parse: (d) => InsightsDto.fromJson(ApiData.object(d)).toEntity(),
  )).data;

  @override
  Future<List<SymptomCategory>> symptomCategories() async => (await _api.get(
    '/tracking/symptom-categories',
    parse: (d) => ApiData.list(d).map((j) => SymptomCategoryDto.fromJson(j).toEntity()).toList(),
  )).data;

  @override
  Future<List<MoodEntry>> moods(DayRange range) =>
      _all('/tracking/moods', range, (j) => MoodEntryDto.fromJson(j).toEntity());

  @override
  Future<List<SymptomEntry>> symptoms(DayRange range) =>
      _all('/tracking/symptoms', range, (j) => SymptomEntryDto.fromJson(j).toEntity());

  @override
  Future<List<SleepEntry>> sleep(DayRange range) =>
      _all('/tracking/sleep', range, (j) => SleepEntryDto.fromJson(j).toEntity());

  @override
  Future<MoodEntry> mood(String id) async =>
      (await _api.get('/tracking/moods/$id', parse: _mood)).data;

  @override
  Future<SymptomEntry> symptom(String id) async =>
      (await _api.get('/tracking/symptoms/$id', parse: _symptom)).data;

  @override
  Future<SleepEntry> sleepEntry(String id) async =>
      (await _api.get('/tracking/sleep/$id', parse: _sleep)).data;

  @override
  Future<MoodEntry> saveMood(MoodDraft draft, {String? id}) async {
    final body = {
      'mood': draft.mood.wire,
      'score': draft.score,
      'anxiety': draft.anxiety,
      'stress': draft.stress,
      'energy': draft.energy,
      'notes': draft.notes,
    };
    return id == null
        ? (await _api.post('/tracking/moods', body: body, parse: _mood)).data
        : (await _api.put('/tracking/moods/$id', body: body, parse: _mood)).data;
  }

  @override
  Future<SymptomEntry> saveSymptom(SymptomDraft draft, {String? id}) async {
    final body = {
      'category': draft.categorySlug,
      'severity': draft.severity,
      'duration_minutes': draft.durationMinutes,
      'notes': draft.notes,
    };
    return id == null
        ? (await _api.post('/tracking/symptoms', body: body, parse: _symptom)).data
        : (await _api.put('/tracking/symptoms/$id', body: body, parse: _symptom)).data;
  }

  @override
  Future<SleepEntry> saveSleep(SleepDraft draft, {String? id}) async {
    final body = {'duration_minutes': draft.durationMinutes, 'quality': draft.quality};
    return id == null
        ? (await _api.post('/tracking/sleep', body: body, parse: _sleep)).data
        : (await _api.put('/tracking/sleep/$id', body: body, parse: _sleep)).data;
  }

  @override
  Future<void> deleteMood(String id) => _api.delete('/tracking/moods/$id');

  @override
  Future<void> deleteSymptom(String id) => _api.delete('/tracking/symptoms/$id');

  @override
  Future<void> deleteSleep(String id) => _api.delete('/tracking/sleep/$id');
}
