import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';

/// Hides a post's content behind its warning until the reader chooses to see it
/// (FR-COM-002). Crisis-related warnings also show a gentle safety hint.
class ContentWarningCover extends StatefulWidget {
  const ContentWarningCover({required this.warning, required this.child, super.key});

  final ContentWarning? warning;
  final Widget child;

  @override
  State<ContentWarningCover> createState() => _ContentWarningCoverState();
}

class _ContentWarningCoverState extends State<ContentWarningCover> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final warning = widget.warning;
    if (warning == null || _revealed) return widget.child;

    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(color: p.surfaceMuted, borderRadius: AppRadius.mdAll),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility_off_outlined, size: 20, color: p.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.contentWarningLabel(warning.label(l10n)),
                    style: context.textStyles.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.contentWarningBody,
              style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
            ),
            if (warning.isCrisisRelated) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.crisisHint,
                style: context.textStyles.bodySmall?.copyWith(color: p.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => setState(() => _revealed = true),
                child: Text(l10n.contentWarningShow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
