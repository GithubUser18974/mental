import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';

/// Result of the picker: a reaction, or removal of the current one.
sealed class ReactionChoice {
  const ReactionChoice();
}

final class ReactionChosen extends ReactionChoice {
  const ReactionChosen(this.type);

  final ReactionType type;
}

final class ReactionRemoved extends ReactionChoice {
  const ReactionRemoved();
}

/// Bottom sheet with the five supportive reactions and their counts (FR-COM-005).
Future<ReactionChoice?> showReactionPicker(BuildContext context, ReactionSummary summary) =>
    showModalBottomSheet<ReactionChoice>(
      context: context,
      showDragHandle: true,
      builder: (_) => _ReactionPicker(summary: summary),
    );

class _ReactionPicker extends StatelessWidget {
  const _ReactionPicker({required this.summary});

  final ReactionSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.reactionsTitle, style: context.textStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final type in ReactionType.values)
              ListTile(
                contentPadding: EdgeInsetsDirectional.zero,
                selected: summary.mine == type,
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: summary.mine == type ? p.primaryGradient : null,
                    color: summary.mine == type ? null : p.primarySoft,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: SizedBox.square(
                    dimension: AppSizes.actionWell,
                    child: Icon(
                      summary.mine == type ? type.selectedIcon : type.icon,
                      size: 20,
                      color: summary.mine == type ? p.onPrimary : p.primary,
                    ),
                  ),
                ),
                title: Text(type.label(l10n), style: context.textStyles.labelLarge),
                trailing: summary.countOf(type) > 0
                    ? Text('${summary.countOf(type)}', style: context.textStyles.labelMedium)
                    : null,
                onTap: () => Navigator.of(context).pop(ReactionChosen(type)),
              ),
            if (summary.mine != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(const ReactionRemoved()),
                child: Text(l10n.removeReaction),
              ),
          ],
        ),
      ),
    );
  }
}
