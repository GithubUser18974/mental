import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/comments_controller.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';
import 'package:mindful/features/community/presentation/widgets/hashtag_text.dart';
import 'package:mindful/features/community/presentation/widgets/report_sheet.dart';

/// One comment or reply: author, text, reply button and (own) edit/delete menu.
/// Removed comments render as an anonymous placeholder.
class CommentTile extends ConsumerWidget {
  const CommentTile({required this.post, required this.comment, this.onReply, super.key});

  final Post post;
  final Comment comment;
  final ValueChanged<Comment>? onReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    if (comment.isRemoved || comment.author == null) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
        child: Text(
          l10n.commentRemoved,
          style: context.textStyles.bodyMedium?.copyWith(
            color: p.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final author = comment.author!; // Checked above: present unless removed.
    final meta = [
      relativeTime(comment.createdAt, l10n),
      if (comment.edited) l10n.edited,
      if (comment.moderationState == ModerationState.underReview) l10n.postUnderReview,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarView(avatarKey: author.avatar, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: p.border),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.sm,
                  AppSpacing.xs,
                  AppSpacing.xxs,
                  AppSpacing.xxs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            author.username,
                            style: context.textStyles.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (comment.isPostAuthor) ...[
                          const SizedBox(width: AppSpacing.xxs),
                          _AuthorBadge(label: l10n.postAuthorBadge),
                        ],
                        const Spacer(),
                        if (comment.isOwn)
                          _CommentMenu(post: post, comment: comment)
                        else
                          PopupMenuButton<bool>(
                            tooltip: l10n.commentOptions,
                            icon: Icon(Icons.more_horiz_rounded, size: 20, color: p.textTertiary),
                            onSelected: (_) => showReportSheet(
                              context,
                              type: ReportTargetType.comment,
                              targetId: comment.id,
                            ),
                            itemBuilder: (_) => [
                              PopupMenuItem<bool>(value: true, child: Text(l10n.reportComment)),
                            ],
                          ),
                      ],
                    ),
                    HashtagText(comment.content ?? '', style: context.textStyles.bodyMedium),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meta,
                            style: context.textStyles.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onReply != null)
                          TextButton(
                            onPressed: () => onReply!(comment),
                            child: Text(l10n.replyAction),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorBadge extends StatelessWidget {
  const _AuthorBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(color: p.primarySoft, borderRadius: AppRadius.pillAll),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs, vertical: 2),
        child: Text(label, style: context.textStyles.labelSmall?.copyWith(color: p.primary)),
      ),
    );
  }
}

enum _CommentAction { edit, delete }

class _CommentMenu extends ConsumerWidget {
  const _CommentMenu({required this.post, required this.comment});

  final Post post;
  final Comment comment;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _EditCommentDialog(initial: comment.content ?? ''),
    );
    if (text == null || text.trim().isEmpty || !context.mounted) return;
    try {
      await ref.read(commentsControllerProvider(post.id).notifier).edit(comment, text.trim());
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteCommentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(commentsControllerProvider(post.id).notifier).delete(comment);
      ref.read(postActionsProvider).adjustCommentCount(post, -1);
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_CommentAction>(
      tooltip: l10n.commentOptions,
      icon: Icon(Icons.more_horiz_rounded, size: 20, color: context.palette.textTertiary),
      onSelected: (action) => switch (action) {
        _CommentAction.edit => _edit(context, ref),
        _CommentAction.delete => _delete(context, ref),
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: _CommentAction.edit, child: Text(l10n.editComment)),
        PopupMenuItem(value: _CommentAction.delete, child: Text(l10n.deleteComment)),
      ],
    );
  }
}

class _EditCommentDialog extends StatefulWidget {
  const _EditCommentDialog({required this.initial});

  final String initial;

  @override
  State<_EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<_EditCommentDialog> {
  late final _text = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.editComment),
      content: TextField(
        controller: _text,
        autofocus: true,
        maxLength: 1000,
        minLines: 1,
        maxLines: 5,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionCancel)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_text.text),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
