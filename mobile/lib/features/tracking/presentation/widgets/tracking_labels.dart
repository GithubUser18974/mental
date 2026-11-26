import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/features/tracking/domain/entities/tracking.dart';

extension MoodUi on Mood {
  String label(AppLocalizations l10n) => switch (this) {
    Mood.verySad => l10n.moodVerySad,
    Mood.sad => l10n.moodSad,
    Mood.neutral => l10n.moodNeutral,
    Mood.good => l10n.moodGood,
    Mood.veryGood => l10n.moodVeryGood,
  };

  IconData get icon => switch (this) {
    Mood.verySad => Icons.mood_bad_outlined,
    Mood.sad => Icons.sentiment_dissatisfied_outlined,
    Mood.neutral => Icons.sentiment_neutral_outlined,
    Mood.good => Icons.sentiment_satisfied_outlined,
    Mood.veryGood => Icons.sentiment_very_satisfied_outlined,
  };

  IconData get selectedIcon => switch (this) {
    Mood.verySad => Icons.mood_bad_rounded,
    Mood.sad => Icons.sentiment_dissatisfied_rounded,
    Mood.neutral => Icons.sentiment_neutral_rounded,
    Mood.good => Icons.sentiment_satisfied_rounded,
    Mood.veryGood => Icons.sentiment_very_satisfied_rounded,
  };
}

/// Server icon names for symptom categories → outlined Material icons.
IconData symptomIcon(String name) => switch (name) {
  'psychology_alt' => Icons.psychology_alt_outlined,
  'battery_2_bar' => Icons.battery_2_bar_rounded,
  'center_focus_weak' => Icons.center_focus_weak_rounded,
  'bolt' => Icons.bolt_rounded,
  'bedtime' => Icons.bedtime_outlined,
  'trending_down' => Icons.trending_down_rounded,
  'directions_run' => Icons.directions_run_rounded,
  'water_drop' => Icons.water_drop_outlined,
  _ => Icons.healing_outlined,
};

/// Minutes → "7.5" (hours, at most one decimal).
String hoursOf(int minutes) {
  final hours = minutes / 60;
  return hours == hours.roundToDouble() ? hours.toStringAsFixed(0) : hours.toStringAsFixed(1);
}

/// Averages like 6.0 → "6", 6.5 → "6.5".
String formatAverage(double value) =>
    value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
