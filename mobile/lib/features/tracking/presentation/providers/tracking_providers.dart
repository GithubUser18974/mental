import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/tracking/data/repositories/tracking_repository_impl.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';

/// Private health data lives only in memory (autoDispose, wiped on sign-out) — never
/// cached on the device.
final FutureProvider<TrackingOverview> trackingOverviewProvider = FutureProvider.autoDispose(
  (ref) {
    ref.watch(authSessionProvider);
    return ref.read(trackingRepositoryProvider).overview();
  },
);

final FutureProvider<Insights> insightsProvider = FutureProvider.autoDispose((ref) {
  ref.watch(authSessionProvider);
  return ref.read(trackingRepositoryProvider).insights();
});

final FutureProvider<List<SymptomCategory>> symptomCategoriesProvider = FutureProvider.autoDispose(
  (ref) async {
    ref.watch(authSessionProvider);
    final categories = await ref.read(trackingRepositoryProvider).symptomCategories();
    ref.keepAlive();
    return categories;
  },
);

/// Everything recorded in a range of days (history screens).
class TrackingHistory {
  const TrackingHistory({required this.moods, required this.symptoms, required this.sleep});

  final List<MoodEntry> moods;
  final List<SymptomEntry> symptoms;
  final List<SleepEntry> sleep;
}

final FutureProviderFamily<TrackingHistory, DayRange> trackingHistoryProvider = FutureProvider
    .autoDispose
    .family<TrackingHistory, DayRange>((ref, range) async {
      ref.watch(authSessionProvider);
      final repo = ref.read(trackingRepositoryProvider);
      final (moods, symptoms, sleep) = await (
        repo.moods(range),
        repo.symptoms(range),
        repo.sleep(range),
      ).wait;
      return TrackingHistory(moods: moods, symptoms: symptoms, sleep: sleep);
    });

final FutureProviderFamily<MoodEntry, String> moodEntryProvider = FutureProvider.autoDispose
    .family<MoodEntry, String>((ref, id) => ref.read(trackingRepositoryProvider).mood(id));

final FutureProviderFamily<SymptomEntry, String> symptomEntryProvider = FutureProvider.autoDispose
    .family<SymptomEntry, String>((ref, id) => ref.read(trackingRepositoryProvider).symptom(id));

final FutureProviderFamily<SleepEntry, String> sleepEntryProvider = FutureProvider.autoDispose
    .family<SleepEntry, String>((ref, id) => ref.read(trackingRepositoryProvider).sleepEntry(id));

/// Saves / deletes entries, then refreshes everything that summarizes them. Insights are
/// recomputed in the background on the server, so they're refetched too.
final trackingActionsProvider = Provider<TrackingActions>(TrackingActions.new);

class TrackingActions {
  TrackingActions(this._ref);

  final Ref _ref;

  void _refresh() => _ref
    ..invalidate(trackingOverviewProvider)
    ..invalidate(insightsProvider)
    ..invalidate(trackingHistoryProvider);

  Future<void> saveMood(MoodDraft draft, {String? id}) async {
    await _ref.read(trackingRepositoryProvider).saveMood(draft, id: id);
    if (id != null) _ref.invalidate(moodEntryProvider(id));
    _refresh();
  }

  Future<void> saveSymptom(SymptomDraft draft, {String? id}) async {
    await _ref.read(trackingRepositoryProvider).saveSymptom(draft, id: id);
    if (id != null) _ref.invalidate(symptomEntryProvider(id));
    _refresh();
  }

  Future<void> saveSleep(SleepDraft draft, {String? id}) async {
    await _ref.read(trackingRepositoryProvider).saveSleep(draft, id: id);
    if (id != null) _ref.invalidate(sleepEntryProvider(id));
    _refresh();
  }

  Future<void> deleteMood(String id) async {
    await _ref.read(trackingRepositoryProvider).deleteMood(id);
    _refresh();
  }

  Future<void> deleteSymptom(String id) async {
    await _ref.read(trackingRepositoryProvider).deleteSymptom(id);
    _refresh();
  }

  Future<void> deleteSleep(String id) async {
    await _ref.read(trackingRepositoryProvider).deleteSleep(id);
    _refresh();
  }
}
