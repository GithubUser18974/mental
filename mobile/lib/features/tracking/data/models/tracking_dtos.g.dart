// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoodEntryDto _$MoodEntryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MoodEntryDto', json, ($checkedConvert) {
      final val = _MoodEntryDto(
        id: $checkedConvert('id', (v) => v as String),
        mood: $checkedConvert('mood', (v) => v as String),
        recordedAt: $checkedConvert(
          'recorded_at',
          (v) => DateTime.parse(v as String),
        ),
        score: $checkedConvert('score', (v) => (v as num?)?.toInt()),
        anxiety: $checkedConvert('anxiety', (v) => (v as num?)?.toInt()),
        stress: $checkedConvert('stress', (v) => (v as num?)?.toInt()),
        energy: $checkedConvert('energy', (v) => (v as num?)?.toInt()),
        notes: $checkedConvert('notes', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'recordedAt': 'recorded_at'});

Map<String, dynamic> _$MoodEntryDtoToJson(_MoodEntryDto instance) => <String, dynamic>{
  'id': instance.id,
  'mood': instance.mood,
  'recorded_at': instance.recordedAt.toIso8601String(),
  'score': instance.score,
  'anxiety': instance.anxiety,
  'stress': instance.stress,
  'energy': instance.energy,
  'notes': instance.notes,
};

_SymptomCategoryDto _$SymptomCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SymptomCategoryDto', json, ($checkedConvert) {
      final val = _SymptomCategoryDto(
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        icon: $checkedConvert('icon', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$SymptomCategoryDtoToJson(_SymptomCategoryDto instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
  'icon': instance.icon,
};

_SymptomEntryDto _$SymptomEntryDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SymptomEntryDto',
  json,
  ($checkedConvert) {
    final val = _SymptomEntryDto(
      id: $checkedConvert('id', (v) => v as String),
      category: $checkedConvert(
        'category',
        (v) => SymptomCategoryDto.fromJson(v as Map<String, dynamic>),
      ),
      severity: $checkedConvert('severity', (v) => (v as num).toInt()),
      recordedAt: $checkedConvert(
        'recorded_at',
        (v) => DateTime.parse(v as String),
      ),
      durationMinutes: $checkedConvert(
        'duration_minutes',
        (v) => (v as num?)?.toInt(),
      ),
      notes: $checkedConvert('notes', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'recordedAt': 'recorded_at',
    'durationMinutes': 'duration_minutes',
  },
);

Map<String, dynamic> _$SymptomEntryDtoToJson(_SymptomEntryDto instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category.toJson(),
  'severity': instance.severity,
  'recorded_at': instance.recordedAt.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'notes': instance.notes,
};

_SleepEntryDto _$SleepEntryDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SleepEntryDto',
  json,
  ($checkedConvert) {
    final val = _SleepEntryDto(
      id: $checkedConvert('id', (v) => v as String),
      durationMinutes: $checkedConvert(
        'duration_minutes',
        (v) => (v as num).toInt(),
      ),
      recordedAt: $checkedConvert(
        'recorded_at',
        (v) => DateTime.parse(v as String),
      ),
      quality: $checkedConvert('quality', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'durationMinutes': 'duration_minutes',
    'recordedAt': 'recorded_at',
  },
);

Map<String, dynamic> _$SleepEntryDtoToJson(_SleepEntryDto instance) => <String, dynamic>{
  'id': instance.id,
  'duration_minutes': instance.durationMinutes,
  'recorded_at': instance.recordedAt.toIso8601String(),
  'quality': instance.quality,
};

_DaySummaryDto _$DaySummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DaySummaryDto', json, ($checkedConvert) {
      final val = _DaySummaryDto(
        date: $checkedConvert('date', (v) => v as String),
        mood: $checkedConvert('mood', (v) => v as String?),
        score: $checkedConvert('score', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$DaySummaryDtoToJson(_DaySummaryDto instance) => <String, dynamic>{
  'date': instance.date,
  'mood': instance.mood,
  'score': instance.score,
};

_AveragesDto _$AveragesDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_AveragesDto',
  json,
  ($checkedConvert) {
    final val = _AveragesDto(
      score: $checkedConvert('score', (v) => (v as num?)?.toDouble()),
      anxiety: $checkedConvert('anxiety', (v) => (v as num?)?.toDouble()),
      stress: $checkedConvert('stress', (v) => (v as num?)?.toDouble()),
      energy: $checkedConvert('energy', (v) => (v as num?)?.toDouble()),
      sleepHours: $checkedConvert(
        'sleep_hours',
        (v) => (v as num?)?.toDouble(),
      ),
      sleepQuality: $checkedConvert(
        'sleep_quality',
        (v) => (v as num?)?.toDouble(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'sleepHours': 'sleep_hours',
    'sleepQuality': 'sleep_quality',
  },
);

Map<String, dynamic> _$AveragesDtoToJson(_AveragesDto instance) => <String, dynamic>{
  'score': instance.score,
  'anxiety': instance.anxiety,
  'stress': instance.stress,
  'energy': instance.energy,
  'sleep_hours': instance.sleepHours,
  'sleep_quality': instance.sleepQuality,
};

_TopSymptomDto _$TopSymptomDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TopSymptomDto', json, ($checkedConvert) {
      final val = _TopSymptomDto(
        category: $checkedConvert(
          'category',
          (v) => SymptomCategoryDto.fromJson(v as Map<String, dynamic>),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        averageSeverity: $checkedConvert(
          'average_severity',
          (v) => (v as num).toDouble(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'averageSeverity': 'average_severity'});

Map<String, dynamic> _$TopSymptomDtoToJson(_TopSymptomDto instance) => <String, dynamic>{
  'category': instance.category.toJson(),
  'count': instance.count,
  'average_severity': instance.averageSeverity,
};

_OverviewDto _$OverviewDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_OverviewDto',
  json,
  ($checkedConvert) {
    final val = _OverviewDto(
      latest: $checkedConvert(
        'latest',
        (v) => v == null ? null : MoodEntryDto.fromJson(v as Map<String, dynamic>),
      ),
      streakDays: $checkedConvert(
        'streak_days',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      totalCheckIns: $checkedConvert(
        'total_check_ins',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      lastSevenDays: $checkedConvert(
        'last_7_days',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => DaySummaryDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <DaySummaryDto>[],
      ),
      averages: $checkedConvert(
        'averages',
        (v) =>
            (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, AveragesDto.fromJson(e as Map<String, dynamic>)),
            ) ??
            const <String, AveragesDto>{},
      ),
      topSymptoms: $checkedConvert(
        'top_symptoms',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => TopSymptomDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <TopSymptomDto>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'streakDays': 'streak_days',
    'totalCheckIns': 'total_check_ins',
    'lastSevenDays': 'last_7_days',
    'topSymptoms': 'top_symptoms',
  },
);

Map<String, dynamic> _$OverviewDtoToJson(_OverviewDto instance) => <String, dynamic>{
  'latest': instance.latest?.toJson(),
  'streak_days': instance.streakDays,
  'total_check_ins': instance.totalCheckIns,
  'last_7_days': instance.lastSevenDays.map((e) => e.toJson()).toList(),
  'averages': instance.averages.map((k, e) => MapEntry(k, e.toJson())),
  'top_symptoms': instance.topSymptoms.map((e) => e.toJson()).toList(),
};

_InsightDto _$InsightDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_InsightDto', json, ($checkedConvert) {
      final val = _InsightDto(
        key: $checkedConvert('key', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        kind: $checkedConvert('kind', (v) => v as String? ?? 'observation'),
      );
      return val;
    });

Map<String, dynamic> _$InsightDtoToJson(_InsightDto instance) => <String, dynamic>{
  'key': instance.key,
  'text': instance.text,
  'kind': instance.kind,
};

_InsightsDto _$InsightsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_InsightsDto', json, ($checkedConvert) {
      final val = _InsightsDto(
        items: $checkedConvert(
          'items',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => InsightDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <InsightDto>[],
        ),
        disclaimer: $checkedConvert('disclaimer', (v) => v as String? ?? ''),
        refreshing: $checkedConvert('refreshing', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$InsightsDtoToJson(_InsightsDto instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'disclaimer': instance.disclaimer,
  'refreshing': instance.refreshing,
};
