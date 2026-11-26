import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/providers/feed_controller.dart';
import 'package:mindful/features/community/presentation/providers/post_store.dart';
import 'package:mindful/features/community/presentation/widgets/post_card.dart';

/// The feed's posts as a sliver, with loading / empty / error states and a
/// "loading more" footer. Posts render through the post store (live updates).
class FeedSliver extends ConsumerWidget {
  const FeedSliver({required this.query, super.key});

  final FeedQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final feed = ref.watch(feedControllerProvider(query));
    final store = ref.watch(postStoreProvider);

    return feed.when(
      skipLoadingOnRefresh: true,
      loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(feedControllerProvider(query)),
        ),
      ),
      data: (state) {
        final posts = [for (final p in state.posts) ?store.resolve(p)];
        if (posts.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              title: l10n.feedEmptyTitle,
              subtitle: query.kind == FeedKind.following
                  ? l10n.feedFollowingEmpty
                  : l10n.feedEmptySubtitle,
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.xxl,
          ),
          sliver: SliverList.separated(
            itemCount: posts.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return _Footer(
                  state: state,
                  onRetry: () => ref.read(feedControllerProvider(query).notifier).loadMore(),
                );
              }
              final post = posts[index];
              return PostCard(
                key: ValueKey(post.id),
                post: post,
                onOpen: () {
                  // Hand the post over so the detail page shows it instantly.
                  ref.read(postActionsProvider).replace(post);
                  context.push(AppRoutes.postPath(post.id)).ignore();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetry});

  final FeedState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.loadingMore) {
      return const Padding(
        padding: EdgeInsetsDirectional.all(AppSpacing.md),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.loadMoreError != null) {
      return TextButton(
        onPressed: onRetry,
        child: Text(
          AppLocalizations.of(context).loadMoreFailed,
          style: context.textStyles.labelLarge?.copyWith(color: context.palette.primary),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
