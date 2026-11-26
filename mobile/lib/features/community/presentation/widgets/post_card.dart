import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/widgets/action_well.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';
import 'package:mindful/features/community/presentation/widgets/content_warning_cover.dart';
import 'package:mindful/features/community/presentation/widgets/hashtag_text.dart';
import 'package:mindful/features/community/presentation/widgets/post_images.dart';
import 'package:mindful/features/community/presentation/widgets/reaction_picker.dart';
import 'package:mindful/features/community/presentation/widgets/report_sheet.dart';

/// A post in the feed or on its detail page. Actions (react, save, edit, delete) go
/// through [postActionsProvider], so every screen showing the post updates at once.
class PostCard extends ConsumerWidget {
  const PostCard({
    required this.post,
    this.onOpen,
    this.onDeleted,
    this.expanded = false,
    super.key,
  });

  final Post post;

  /// Opens the detail page (null on the detail page itself).
  final VoidCallback? onOpen;
  final VoidCallback? onDeleted;

  /// Detail page: full text, no truncation.
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(post: post, onDeleted: onDeleted),
          if (post.isOwn) _OwnStatus(post: post),
          const SizedBox(height: AppSpacing.sm),
          ContentWarningCover(
            key: ValueKey('cw-${post.id}'),
            warning: post.contentWarning,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HashtagText(post.content, maxLines: expanded ? null : 6),
                if (post.images.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PostImages(images: post.images),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionRow(post: post, onOpen: onOpen),
          if (post.reactions.total > 0)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxs),
              child: Text(
                l10n.reactionsCount(post.reactions.total),
                style: context.textStyles.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.post, required this.onDeleted});

  final Post post;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final meta = [
      post.category.name,
      relativeTime(post.createdAt, l10n),
      if (post.edited) l10n.edited,
    ].join(' · ');

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: AppRadius.smAll,
            onTap: () => context.push(AppRoutes.profilePath(post.author.username)),
            child: Row(
              children: [
                AvatarView(avatarKey: post.author.avatar, size: 40),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.username,
                        style: context.textStyles.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        meta,
                        style: context.textStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (post.isOwn)
          _OwnPostMenu(post: post, onDeleted: onDeleted)
        else
          PopupMenuButton<bool>(
            tooltip: l10n.postOptions,
            icon: Icon(Icons.more_horiz_rounded, color: context.palette.textSecondary),
            onSelected: (_) =>
                showReportSheet(context, type: ReportTargetType.post, targetId: post.id),
            itemBuilder: (_) => [PopupMenuItem<bool>(value: true, child: Text(l10n.reportPost))],
          ),
      ],
    );
  }
}

enum _PostMenuAction { edit, delete }

class _OwnPostMenu extends ConsumerWidget {
  const _OwnPostMenu({required this.post, required this.onDeleted});

  final Post post;
  final VoidCallback? onDeleted;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePostConfirmTitle),
        content: Text(l10n.deletePostConfirmBody),
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

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(postActionsProvider).delete(post);
      messenger.showSnackBar(SnackBar(content: Text(l10n.postDeleted)));
      onDeleted?.call();
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_PostMenuAction>(
      tooltip: l10n.postOptions,
      icon: Icon(Icons.more_horiz_rounded, color: context.palette.textSecondary),
      onSelected: (action) => switch (action) {
        _PostMenuAction.edit => context.push(AppRoutes.editPostPath(post.id)),
        _PostMenuAction.delete => _delete(context, ref),
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: _PostMenuAction.edit, child: Text(l10n.editPost)),
        PopupMenuItem(value: _PostMenuAction.delete, child: Text(l10n.deletePost)),
      ],
    );
  }
}

/// Author-only notes: private post, or moderation state.
class _OwnStatus extends StatelessWidget {
  const _OwnStatus({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = switch (post.moderationState) {
      ModerationState.underReview => l10n.postUnderReview,
      ModerationState.hidden => l10n.postHiddenByModeration,
      _ => post.visibility == PostVisibility.onlyMe ? l10n.postOnlyMe : null,
    };
    if (text == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 16, color: context.palette.textSecondary),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(child: Text(text, style: context.textStyles.labelMedium)),
        ],
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.post, required this.onOpen});

  final Post post;
  final VoidCallback? onOpen;

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mine = post.reactions.mine;
    final actions = ref.read(postActionsProvider);

    return Row(
      children: [
        ActionWell(
          icon: mine?.selectedIcon ?? Icons.favorite_outline_rounded,
          selected: mine != null,
          semanticLabel: mine?.label(l10n) ?? l10n.reactAction,
          label: post.reactions.total > 0 ? '${post.reactions.total}' : null,
          onTap: () async {
            final choice = await showReactionPicker(context, post.reactions);
            if (choice == null || !context.mounted) return;
            final type = switch (choice) {
              ReactionChosen(:final type) => type,
              ReactionRemoved() => null,
            };
            if (type == mine) return;
            await _run(context, () => actions.react(post, type));
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        ActionWell(
          icon: Icons.chat_bubble_outline_rounded,
          semanticLabel: l10n.commentsCount(post.commentsCount),
          label: post.commentsCount > 0 ? '${post.commentsCount}' : null,
          onTap: onOpen,
        ),
        const Spacer(),
        ActionWell(
          icon: post.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          selected: post.isSaved,
          semanticLabel: post.isSaved ? l10n.unsavePost : l10n.savePost,
          onTap: () => _run(context, () => actions.toggleSaved(post)),
        ),
      ],
    );
  }
}
