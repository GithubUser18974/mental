import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/core/widgets/segmented_pills.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';

/// Recent / Popular / Following (FR-COM-001).
class FeedTabs extends StatelessWidget {
  const FeedTabs({required this.selected, required this.onChanged, super.key});

  final FeedKind selected;
  final ValueChanged<FeedKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedPills(
      labels: [
        for (final kind in FeedKind.values)
          switch (kind) {
            FeedKind.recent => l10n.feedRecent,
            FeedKind.popular => l10n.feedPopular,
            FeedKind.following => l10n.feedFollowing,
          },
      ],
      selectedIndex: selected.index,
      onChanged: (i) => onChanged(FeedKind.values[i]),
    );
  }
}
