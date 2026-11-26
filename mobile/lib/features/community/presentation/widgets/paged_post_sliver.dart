import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/providers/post_store.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';
import 'package:mindful/features/community/presentation/widgets/post_card.dart';

/// Posts from a [PostListSource] (saved, profile, hashtag, search) as a sliver with
/// loading / empty / error states and paging. Posts render through the post store.
class PagedPostSliver extends ConsumerWidget {
  const PagedPostSliver({required this.source, required this.emptyText, super.key});

  final PostListSource source;
  final String emptyText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final list = ref.watch(postListProvider(source));
    final store = ref.watch(postStoreProvider);

    return list.when(
      skipLoadingOnRefresh: true,
      loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(error: error, onRetry: () => ref.invalidate(postListProvider(source))),
      ),
      data: (state) {
        final posts = [for (final p in state.items) ?store.resolve(p)];
        if (posts.isEmpty) {
          return SliverFillRemaining(hasScrollBody: false, child: EmptyView(subtitle: emptyText));
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
                if (state.loadingMore) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.loadMoreError != null) {
                  return TextButton(
                    onPressed: () => ref.read(postListProvider(source).notifier).loadMore(),
                    child: Text(l10n.loadMoreFailed),
                  );
                }
                return const SizedBox.shrink();
              }
              final post = posts[index];
              return PostCard(
                key: ValueKey(post.id),
                post: post,
                onOpen: () {
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

/// Loads the next page of [source] when the scroll position nears the end.
void loadMoreOnScroll(WidgetRef ref, ScrollNotification n, PostListSource source) {
  if (n.metrics.extentAfter < 600) {
    ref.read(postListProvider(source).notifier).loadMore().ignore();
  }
}
