/// Overall emotional state (FR-TRACK-002), lowest to highest.
enum Mood {
  verySad('very_sad'),
  sad('sad'),
  neutral('neutral'),
  good('good'),
  veryGood('very_good')
  ;

  const Mood(this.wire);

  final String wire;

  /// 1 (very sad) … 5 (very good).
  int get level => index + 1;

  static Mood? fromWire(String? value) => values.where((m) => m.wire == value).firstOrNull;
}

/// A daily check-in (FR-TRACK-001). Private: only ever the owner's own.
class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.mood,
    required this.recordedAt,
    this.score,
    this.anxiety,
    this.stress,
    this.energy,
    this.notes,
  });

  final String id;
  final Mood mood;
  final int? score;
  final int? anxiety;
  final int? stress;
  final int? energy;
  final String? notes;
  final DateTime recordedAt;
}

class SymptomCategory {
  const SymptomCategory({required this.slug, required this.name, required this.icon});

  final String slug;
  final String name;
  final String icon;
}

class SymptomEntry {
  const SymptomEntry({
    required this.id,
    required this.category,
    required this.severity,
    required this.recordedAt,
    this.durationMinutes,
    this.notes,
  });

  final String id;
  final SymptomCategory category;
  final int severity;
  final int? durationMinutes;
  final String? notes;
  final DateTime recordedAt;
}

class SleepEntry {
  const SleepEntry({
    required this.id,
    required this.durationMinutes,
    required this.recordedAt,
    this.quality,
  });

  final String id;
  final int durationMinutes;
  final int? quality;

  /// Wake-up time.
  final DateTime recordedAt;
}

/// One day in the 7-day strip.
class DaySummary {
  const DaySummary({required this.date, this.mood, this.score});

  final DateTime date;
  final Mood? mood;
  final double? score;
}

class Averages {
  const Averages({
    this.score,
    this.anxiety,
    this.stress,
    this.energy,
    this.sleepHours,
    this.sleepQuality,
  });

  final double? score;
  final double? anxiety;
  final double? stress;
  final double? energy;
  final double? sleepHours;
  final double? sleepQuality;
}

class TopSymptom {
  const TopSymptom({required this.category, required this.count, required this.averageSeverity});

  final SymptomCategory category;
  final int count;
  final double averageSeverity;
}

/// GET /tracking/overview.
class TrackingOverview {
  const TrackingOverview({
    required this.streakDays,
    required this.totalCheckIns,
    required this.lastSevenDays,
    required this.week,
    required this.month,
    required this.topSymptoms,
    this.latest,
  });

  final MoodEntry? latest;
  final int streakDays;
  final int totalCheckIns;
  final List<DaySummary> lastSevenDays;
  final Averages week;
  final Averages month;
  final List<TopSymptom> topSymptoms;
}

class Insight {
  const Insight({required this.key, required this.text, required this.isMilestone});

  final String key;

  /// Localized by the server; non-diagnostic.
  final String text;
  final bool isMilestone;
}

class Insights {
  const Insights({required this.items, required this.disclaimer, required this.refreshing});

  final List<Insight> items;
  final String disclaimer;
  final bool refreshing;
}

/// What the check-in form sends.
class MoodDraft {
  const MoodDraft({
    required this.mood,
    this.score,
    this.anxiety,
    this.stress,
    this.energy,
    this.notes,
  });

  final Mood mood;
  final int? score;
  final int? anxiety;
  final int? stress;
  final int? energy;
  final String? notes;
}

class SymptomDraft {
  const SymptomDraft({
    required this.categorySlug,
    required this.severity,
    this.durationMinutes,
    this.notes,
  });

  final String categorySlug;
  final int severity;
  final int? durationMinutes;
  final String? notes;
}

class SleepDraft {
  const SleepDraft({required this.durationMinutes, this.quality});

  final int durationMinutes;
  final int? quality;
}

/// Inclusive range of local calendar days.
typedef DayRange = ({DateTime from, DateTime to});
