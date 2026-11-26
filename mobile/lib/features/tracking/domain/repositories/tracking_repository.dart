import 'package:mindful/features/tracking/domain/entities/tracking.dart';

/// Private tracking API (SRS §8.5). Implementations throw `AppException`s.
abstract interface class TrackingRepository {
  Future<TrackingOverview> overview();

  Future<Insights> insights();

  Future<List<SymptomCategory>> symptomCategories();

  /// All entries in the range (pages followed; ranges are at most a month).
  Future<List<MoodEntry>> moods(DayRange range);

  Future<List<SymptomEntry>> symptoms(DayRange range);

  Future<List<SleepEntry>> sleep(DayRange range);

  Future<MoodEntry> mood(String id);

  Future<SymptomEntry> symptom(String id);

  Future<SleepEntry> sleepEntry(String id);

  Future<MoodEntry> saveMood(MoodDraft draft, {String? id});

  Future<SymptomEntry> saveSymptom(SymptomDraft draft, {String? id});

  Future<SleepEntry> saveSleep(SleepDraft draft, {String? id});

  Future<void> deleteMood(String id);

  Future<void> deleteSymptom(String id);

  Future<void> deleteSleep(String id);
}
