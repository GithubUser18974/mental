import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';

/// Localized labels and icons for community enums (UI only).
extension ReactionTypeUi on ReactionType {
  String label(AppLocalizations l10n) => switch (this) {
    ReactionType.understand => l10n.reactionUnderstand,
    ReactionType.support => l10n.reactionSupport,
    ReactionType.notAlone => l10n.reactionNotAlone,
    ReactionType.proud => l10n.reactionProud,
    ReactionType.thankYou => l10n.reactionThankYou,
  };

  IconData get icon => switch (this) {
    ReactionType.understand => Icons.favorite_outline_rounded,
    ReactionType.support => Icons.volunteer_activism_outlined,
    ReactionType.notAlone => Icons.people_outline_rounded,
    ReactionType.proud => Icons.star_outline_rounded,
    ReactionType.thankYou => Icons.local_florist_outlined,
  };

  /// Filled variant for the selected state.
  IconData get selectedIcon => switch (this) {
    ReactionType.understand => Icons.favorite_rounded,
    ReactionType.support => Icons.volunteer_activism_rounded,
    ReactionType.notAlone => Icons.people_rounded,
    ReactionType.proud => Icons.star_rounded,
    ReactionType.thankYou => Icons.local_florist_rounded,
  };
}

extension ContentWarningUi on ContentWarning {
  String label(AppLocalizations l10n) => switch (this) {
    ContentWarning.selfHarm => l10n.cwSelfHarm,
    ContentWarning.suicide => l10n.cwSuicide,
    ContentWarning.eatingDisorder => l10n.cwEatingDisorder,
    ContentWarning.substanceUse => l10n.cwSubstanceUse,
    ContentWarning.abuseTrauma => l10n.cwAbuseTrauma,
    ContentWarning.sensitive => l10n.cwSensitive,
  };

  /// Topics where the reader is also shown the gentle crisis hint.
  bool get isCrisisRelated => this == ContentWarning.selfHarm || this == ContentWarning.suicide;
}

/// Maps the server's Material icon names for categories to outlined icons.
IconData categoryIcon(String name) => switch (name) {
  'auto_stories' => Icons.auto_stories_outlined,
  'volunteer_activism' => Icons.volunteer_activism_outlined,
  'wb_sunny' => Icons.wb_sunny_outlined,
  'medication' => Icons.medication_outlined,
  'trending_up' => Icons.trending_up_rounded,
  'help_outline' => Icons.help_outline_rounded,
  'self_improvement' => Icons.self_improvement_rounded,
  _ => Icons.forum_outlined,
};

/// "just now", "5m", "3h", "2d", then a short date in the app language.
String relativeTime(DateTime time, AppLocalizations l10n, {DateTime? now}) {
  final diff = (now ?? DateTime.now().toUtc()).difference(time.toUtc());
  if (diff.inMinutes < 1) return l10n.timeJustNow;
  if (diff.inHours < 1) return l10n.timeMinutes(diff.inMinutes);
  if (diff.inDays < 1) return l10n.timeHours(diff.inHours);
  if (diff.inDays < 7) return l10n.timeDays(diff.inDays);
  return DateFormat.yMMMd(l10n.localeName).format(time.toLocal());
}
