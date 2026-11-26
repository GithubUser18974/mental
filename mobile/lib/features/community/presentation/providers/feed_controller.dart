import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show AsyncNotifierProviderFamily;
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/community/data/repositories/community_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

/// Which feed to show: tab + optional category filter (FR-COM-001).
typedef FeedQuery = ({FeedKind kind, String? categorySlug});

/// Loaded pages of a feed.
class FeedState {
  const FeedState({
    required this.posts,
    required this.hasMore,
    this.nextCursor,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<Post> posts;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;
  final Object? loadMoreError;

  FeedState copyWith({
    List<Post>? posts,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
    Object? loadMoreError,
  }) => FeedState(
    posts: posts ?? this.posts,
    nextCursor: nextCursor ?? this.nextCursor,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError,
  );
}

final AsyncNotifierProviderFamily<FeedController, FeedState, FeedQuery> feedControllerProvider =
    AsyncNotifierProvider.autoDispose.family<FeedController, FeedState, FeedQuery>(
      FeedController.new,
    );

class FeedController extends AsyncNotifier<FeedState> {
  FeedController(this.query);

  final FeedQuery query;

  @override
  Future<FeedState> build() async {
    ref.watch(authSessionProvider);
    final page = await ref
        .read(communityRepositoryProvider)
        .feed(kind: query.kind, categorySlug: query.categorySlug);
    return FeedState(posts: page.items, nextCursor: page.nextCursor, hasMore: page.hasMore);
  }

  /// Pull-to-refresh: reload the first page, keeping the old list visible meanwhile.
  Future<void> refresh() async {
    final result = await AsyncValue.guard(build);
    if (ref.mounted) state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .feed(kind: query.kind, categorySlug: query.categorySlug, cursor: current.nextCursor);
      if (!ref.mounted) return;
      final known = {for (final p in current.posts) p.id};
      state = AsyncData(
        FeedState(
          posts: [...current.posts, ...page.items.where((p) => !known.contains(p.id))],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      );
    } on Object catch (error) {
      if (ref.mounted) state = AsyncData(current.copyWith(loadMoreError: error));
    }
  }
}
