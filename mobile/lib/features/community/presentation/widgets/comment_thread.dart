import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/providers/comments_controller.dart';
import 'package:mindful/features/community/presentation/widgets/comment_tile.dart';

/// Top-level comments (oldest first) with expandable reply threads, as a sliver.
class CommentThread extends ConsumerWidget {
  const CommentThread({required this.post, required this.onReply, super.key});

  final Post post;

  /// Null when comments are turned off (no reply buttons).
  final ValueChanged<Comment>? onReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final comments = ref.watch(commentsControllerProvider(post.id));

    return comments.when(
      skipLoadingOnRefresh: true,
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsetsDirectional.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(commentsControllerProvider(post.id)),
        ),
      ),
      data: (state) {
        if (state.comments.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.xl),
              child: Text(
                l10n.commentsEmpty,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          sliver: SliverList.list(
            children: [
              for (final comment in state.comments)
                _CommentWithReplies(
                  key: ValueKey(comment.id),
                  post: post,
                  comment: comment,
                  thread: state.threadOf(comment.id),
                  onReply: onReply,
                ),
              if (state.loadingMore)
                const Padding(
                  padding: EdgeInsetsDirectional.all(AppSpacing.md),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.hasMore)
                TextButton(
                  onPressed: () =>
                      ref.read(commentsControllerProvider(post.id).notifier).loadMore().ignore(),
                  child: Text(l10n.moreComments),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentWithReplies extends ConsumerWidget {
  const _CommentWithReplies({
    required this.post,
    required this.comment,
    required this.thread,
    required this.onReply,
    super.key,
  });

  final Post post;
  final Comment comment;
  final ReplyThread thread;
  final ValueChanged<Comment>? onReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(commentsControllerProvider(post.id).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommentTile(post: post, comment: comment, onReply: onReply),
        if (comment.repliesCount > 0)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 44),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => controller.toggleReplies(comment.id).ignore(),
                child: Text(
                  thread.expanded ? l10n.hideReplies : l10n.viewReplies(comment.repliesCount),
                ),
              ),
            ),
          ),
        if (thread.expanded)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final reply in thread.items)
                  CommentTile(
                    key: ValueKey(reply.id),
                    post: post,
                    comment: reply,
                    onReply: onReply,
                  ),
                if (thread.loading)
                  const Padding(
                    padding: EdgeInsetsDirectional.all(AppSpacing.xs),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (thread.hasMore || thread.error != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => controller.loadMoreReplies(comment.id).ignore(),
                      child: Text(thread.error != null ? l10n.loadMoreFailed : l10n.moreReplies),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
