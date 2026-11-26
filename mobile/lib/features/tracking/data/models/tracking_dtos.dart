import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';

part 'tracking_dtos.freezed.dart';
part 'tracking_dtos.g.dart';

@freezed
abstract class MoodEntryDto with _$MoodEntryDto {
  const factory MoodEntryDto({
    required String id,
    required String mood,
    required DateTime recordedAt,
    int? score,
    int? anxiety,
    int? stress,
    int? energy,
    String? notes,
  }) = _MoodEntryDto;

  const MoodEntryDto._();

  factory MoodEntryDto.fromJson(Map<String, dynamic> json) => _$MoodEntryDtoFromJson(json);

  MoodEntry toEntity() => MoodEntry(
    id: id,
    mood: Mood.fromWire(mood) ?? Mood.neutral,
    score: score,
    anxiety: anxiety,
    stress: stress,
    energy: energy,
    notes: notes,
    recordedAt: recordedAt.toUtc(),
  );
}

@freezed
abstract class SymptomCategoryDto with _$SymptomCategoryDto {
  const factory SymptomCategoryDto({
    required String slug,
    required String name,
    @Default('') String icon,
  }) = _SymptomCategoryDto;

  const SymptomCategoryDto._();

  factory SymptomCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomCategoryDtoFromJson(json);

  SymptomCategory toEntity() => SymptomCategory(slug: slug, name: name, icon: icon);
}

@freezed
abstract class SymptomEntryDto with _$SymptomEntryDto {
  const factory SymptomEntryDto({
    required String id,
    required SymptomCategoryDto category,
    required int severity,
    required DateTime recordedAt,
    int? durationMinutes,
    String? notes,
  }) = _SymptomEntryDto;

  const SymptomEntryDto._();

  factory SymptomEntryDto.fromJson(Map<String, dynamic> json) => _$SymptomEntryDtoFromJson(json);

  SymptomEntry toEntity() => SymptomEntry(
    id: id,
    category: category.toEntity(),
    severity: severity,
    durationMinutes: durationMinutes,
    notes: notes,
    recordedAt: recordedAt.toUtc(),
  );
}

@freezed
abstract class SleepEntryDto with _$SleepEntryDto {
  const factory SleepEntryDto({
    required String id,
    required int durationMinutes,
    required DateTime recordedAt,
    int? quality,
  }) = _SleepEntryDto;

  const SleepEntryDto._();

  factory SleepEntryDto.fromJson(Map<String, dynamic> json) => _$SleepEntryDtoFromJson(json);

  SleepEntry toEntity() => SleepEntry(
    id: id,
    durationMinutes: durationMinutes,
    quality: quality,
    recordedAt: recordedAt.toUtc(),
  );
}

@freezed
abstract class DaySummaryDto with _$DaySummaryDto {
  const factory DaySummaryDto({required String date, String? mood, double? score}) = _DaySummaryDto;

  const DaySummaryDto._();

  factory DaySummaryDto.fromJson(Map<String, dynamic> json) => _$DaySummaryDtoFromJson(json);

  DaySummary toEntity() =>
      DaySummary(date: DateTime.parse(date), mood: Mood.fromWire(mood), score: score);
}

@freezed
abstract class AveragesDto with _$AveragesDto {
  const factory AveragesDto({
    double? score,
    double? anxiety,
    double? stress,
    double? energy,
    double? sleepHours,
    double? sleepQuality,
  }) = _AveragesDto;

  const AveragesDto._();

  factory AveragesDto.fromJson(Map<String, dynamic> json) => _$AveragesDtoFromJson(json);

  Averages toEntity() => Averages(
    score: score,
    anxiety: anxiety,
    stress: stress,
    energy: energy,
    sleepHours: sleepHours,
    sleepQuality: sleepQuality,
  );
}

@freezed
abstract class TopSymptomDto with _$TopSymptomDto {
  const factory TopSymptomDto({
    required SymptomCategoryDto category,
    required int count,
    required double averageSeverity,
  }) = _TopSymptomDto;

  factory TopSymptomDto.fromJson(Map<String, dynamic> json) => _$TopSymptomDtoFromJson(json);
}

@freezed
abstract class OverviewDto with _$OverviewDto {
  const factory OverviewDto({
    MoodEntryDto? latest,
    @Default(0) int streakDays,
    @Default(0) int totalCheckIns,
    @JsonKey(name: 'last_7_days') @Default(<DaySummaryDto>[]) List<DaySummaryDto> lastSevenDays,
    @Default(<String, AveragesDto>{}) Map<String, AveragesDto> averages,
    @Default(<TopSymptomDto>[]) List<TopSymptomDto> topSymptoms,
  }) = _OverviewDto;

  const OverviewDto._();

  factory OverviewDto.fromJson(Map<String, dynamic> json) => _$OverviewDtoFromJson(json);

  TrackingOverview toEntity() => TrackingOverview(
    latest: latest?.toEntity(),
    streakDays: streakDays,
    totalCheckIns: totalCheckIns,
    lastSevenDays: lastSevenDays.map((d) => d.toEntity()).toList(),
    week: averages['last_7_days']?.toEntity() ?? const Averages(),
    month: averages['last_30_days']?.toEntity() ?? const Averages(),
    topSymptoms: [
      for (final s in topSymptoms)
        TopSymptom(
          category: s.category.toEntity(),
          count: s.count,
          averageSeverity: s.averageSeverity,
        ),
    ],
  );
}

@freezed
abstract class InsightDto with _$InsightDto {
  const factory InsightDto({
    required String key,
    required String text,
    @Default('observation') String kind,
  }) = _InsightDto;

  factory InsightDto.fromJson(Map<String, dynamic> json) => _$InsightDtoFromJson(json);
}

@freezed
abstract class InsightsDto with _$InsightsDto {
  const factory InsightsDto({
    @Default(<InsightDto>[]) List<InsightDto> items,
    @Default('') String disclaimer,
    @Default(false) bool refreshing,
  }) = _InsightsDto;

  const InsightsDto._();

  factory InsightsDto.fromJson(Map<String, dynamic> json) => _$InsightsDtoFromJson(json);

  Insights toEntity() => Insights(
    items: [
      for (final i in items) Insight(key: i.key, text: i.text, isMilestone: i.kind == 'milestone'),
    ],
    disclaimer: disclaimer,
    refreshing: refreshing,
  );
}
