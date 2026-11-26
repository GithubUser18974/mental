import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/circle_icon_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/providers/comments_controller.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/providers/post_store.dart';
import 'package:mindful/features/community/presentation/widgets/comment_input_bar.dart';
import 'package:mindful/features/community/presentation/widgets/comment_thread.dart';
import 'package:mindful/features/community/presentation/widgets/post_card.dart';

/// A post with its comments (FR-COM-004) and a comment bar pinned at the bottom.
class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({required this.postId, super.key});

  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  Comment? _replyTo;

  void _leave() => context.canPop() ? context.pop() : context.go(AppRoutes.home);

  Future<bool> _send(Post post, String text) async {
    final controller = ref.read(commentsControllerProvider(widget.postId).notifier);
    try {
      await controller.add(text, replyTo: _replyTo);
      ref.read(postActionsProvider).adjustCommentCount(post, 1);
      if (mounted) setState(() => _replyTo = null);
      return true;
    } on Object catch (error) {
      if (mounted) showErrorSnackBar(context, error);
      return false;
    }
  }

  Widget _bodyFor(Post known, PostStoreState store, AppLocalizations l10n) {
    final post = store.resolve(known);
    if (post == null) return EmptyView(title: l10n.postUnavailable);
    return _Body(
      post: post,
      replyTo: _replyTo,
      onReply: (comment) => setState(() => _replyTo = comment),
      onCancelReply: () => setState(() => _replyTo = null),
      onSend: (text) => _send(post, text),
      onDeleted: _leave,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(postDetailProvider(widget.postId));
    final store = ref.watch(postStoreProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screen - AppSpacing.xxs,
                  AppSpacing.xs,
                  AppSpacing.screen,
                  AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    CircleIconButton.back(onPressed: _leave, semanticLabel: l10n.actionBack),
                    const SizedBox(width: AppSpacing.sm),
                    Text(l10n.postTitle, style: context.textStyles.titleLarge),
                  ],
                ),
              ),
              Expanded(
                child: loaded.when(
                  // The feed's copy shows instantly while the fresh one loads.
                  loading: () => switch (store.latest[widget.postId]) {
                    final cached? => _bodyFor(cached, store, l10n),
                    null => const LoadingView(),
                  },
                  error: (error, _) => ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(postDetailProvider(widget.postId)),
                  ),
                  data: (fetched) => _bodyFor(fetched, store, l10n),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.post,
    required this.replyTo,
    required this.onReply,
    required this.onCancelReply,
    required this.onSend,
    required this.onDeleted,
  });

  final Post post;
  final Comment? replyTo;
  final ValueChanged<Comment> onReply;
  final VoidCallback onCancelReply;
  final Future<bool> Function(String text) onSend;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 400) {
                ref.read(commentsControllerProvider(post.id).notifier).loadMore().ignore();
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.screen,
                    vertical: AppSpacing.xs,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: PostCard(post: post, expanded: true, onDeleted: onDeleted),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    AppSpacing.xs,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Semantics(
                      header: true,
                      child: Text(l10n.commentsTitle, style: context.textStyles.titleMedium),
                    ),
                  ),
                ),
                CommentThread(post: post, onReply: post.allowComments ? onReply : null),
              ],
            ),
          ),
        ),
        if (post.allowComments)
          CommentInputBar(
            key: ValueKey('input-${post.id}'),
            replyTo: replyTo,
            onCancelReply: onCancelReply,
            onSend: onSend,
          )
        else
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            child: Text(
              l10n.commentsDisabled,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmall,
            ),
          ),
      ],
    );
  }
}
