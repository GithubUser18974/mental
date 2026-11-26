import 'fake_backend.dart';

/// JSON shaped exactly like the API's tracking resources.
Map<String, dynamic> moodJson({
  String id = 'm1',
  String mood = 'good',
  int? score = 7,
  int? stress,
  String? notes,
  String recordedAt = '2026-11-26T08:00:00Z',
}) => {
  'id': id,
  'mood': mood,
  'score': score,
  'anxiety': null,
  'stress': stress,
  'energy': null,
  'notes': notes,
  'recorded_at': recordedAt,
  'updated_at': recordedAt,
};

Map<String, dynamic> symptomCategoryJson(String slug, String name) => {
  'slug': slug,
  'name': name,
  'icon': 'psychology_alt',
};

Map<String, dynamic> symptomJson({String id = 's1', int severity = 6}) => {
  'id': id,
  'category': symptomCategoryJson('anxiety', 'Anxiety'),
  'severity': severity,
  'duration_minutes': null,
  'notes': null,
  'recorded_at': '2026-11-26T09:00:00Z',
  'updated_at': '2026-11-26T09:00:00Z',
};

Map<String, dynamic> sleepJson({String id = 'z1', int minutes = 450, int? quality = 7}) => {
  'id': id,
  'duration_minutes': minutes,
  'quality': quality,
  'recorded_at': '2026-11-26T06:30:00Z',
  'updated_at': '2026-11-26T06:30:00Z',
};

Map<String, dynamic> overviewJson({Map<String, dynamic>? latest, int streak = 0, int total = 0}) {
  final today = DateTime.now();
  return {
    'latest': latest,
    'streak_days': streak,
    'total_check_ins': total,
    'last_7_days': [
      for (var i = 6; i >= 0; i--)
        {
          'date': today.subtract(Duration(days: i)).toIso8601String().substring(0, 10),
          'mood': i == 0 && latest != null ? latest['mood'] : null,
          'score': i == 0 && latest != null ? latest['score'] : null,
        },
    ],
    'averages': {
      'last_7_days': {
        'score': latest == null ? null : 7,
        'anxiety': null,
        'stress': null,
        'energy': null,
        'sleep_hours': latest == null ? null : 7.5,
        'sleep_quality': null,
      },
      'last_30_days': {
        'score': null,
        'anxiety': null,
        'stress': null,
        'energy': null,
        'sleep_hours': null,
        'sleep_quality': null,
      },
    },
    'top_symptoms': <Object>[],
  };
}

Map<String, dynamic> insightsJson({List<Map<String, dynamic>> items = const []}) => {
  'items': items,
  'disclaimer': 'These observations are based only on what you recorded.',
  'computed_at': '2026-11-26T10:00:00Z',
  'refreshing': false,
};

extension TrackingFakes on FakeBackend {
  void trackingHome({Map<String, dynamic>? latest, int streak = 0, int total = 0}) {
    ok('GET /tracking/overview', overviewJson(latest: latest, streak: streak, total: total));
    ok('GET /tracking/insights', insightsJson());
    ok('GET /tracking/symptom-categories', [
      symptomCategoryJson('anxiety', 'Anxiety'),
      symptomCategoryJson('restlessness', 'Restlessness'),
    ]);
  }
}
