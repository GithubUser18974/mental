import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show AsyncNotifierProviderFamily, FutureProviderFamily;
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/community/data/repositories/social_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/feed_controller.dart';

/// Loaded pages of any cursor-paginated list.
class PagedState<T> {
  const PagedState({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.loadingMore = false,
    this.loadMoreError,
  });

  factory PagedState.fromPage(CursorPage<T> page) =>
      PagedState(items: page.items, nextCursor: page.nextCursor, hasMore: page.hasMore);

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;
  final Object? loadMoreError;
}

/// Shared paging logic: subclasses only say how to fetch a page.
abstract class PagedController<T> extends AsyncNotifier<PagedState<T>> {
  Future<CursorPage<T>> fetch(String? cursor);

  String idOf(T item);

  @override
  Future<PagedState<T>> build() async {
    ref.watch(authSessionProvider);
    return PagedState.fromPage(await fetch(null));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(
      PagedState(
        items: current.items,
        nextCursor: current.nextCursor,
        hasMore: current.hasMore,
        loadingMore: true,
      ),
    );
    try {
      final page = await fetch(current.nextCursor);
      if (!ref.mounted) return;
      final known = {for (final i in current.items) idOf(i)};
      state = AsyncData(
        PagedState(
          items: [...current.items, ...page.items.where((i) => !known.contains(idOf(i)))],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      );
    } on Object catch (error) {
      if (ref.mounted) {
        state = AsyncData(
          PagedState(
            items: current.items,
            nextCursor: current.nextCursor,
            hasMore: current.hasMore,
            loadMoreError: error,
          ),
        );
      }
    }
  }

  /// Drops an item locally (e.g. after unblocking someone).
  void remove(String id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      PagedState(
        items: [...current.items.where((i) => idOf(i) != id)],
        nextCursor: current.nextCursor,
        hasMore: current.hasMore,
      ),
    );
  }
}

/// Which post list to show besides the main feeds (provider family key → value equality).
@immutable
sealed class PostListSource {
  const PostListSource();
}

final class SavedPostsSource extends PostListSource {
  const SavedPostsSource();

  @override
  bool operator ==(Object other) => other is SavedPostsSource;

  @override
  int get hashCode => 1;
}

final class ProfilePostsSource extends PostListSource {
  const ProfilePostsSource(this.username);

  final String username;

  @override
  bool operator ==(Object other) =>
      other is ProfilePostsSource && other.username.toLowerCase() == username.toLowerCase();

  @override
  int get hashCode => Object.hash(2, username.toLowerCase());
}

final class HashtagPostsSource extends PostListSource {
  const HashtagPostsSource(this.hashtag);

  final String hashtag;

  @override
  bool operator ==(Object other) => other is HashtagPostsSource && other.hashtag == hashtag;

  @override
  int get hashCode => Object.hash(3, hashtag);
}

final class SearchPostsSource extends PostListSource {
  const SearchPostsSource(this.query);

  final String query;

  @override
  bool operator ==(Object other) => other is SearchPostsSource && other.query == query;

  @override
  int get hashCode => Object.hash(4, query);
}

final AsyncNotifierProviderFamily<PostListController, PagedState<Post>, PostListSource>
postListProvider = AsyncNotifierProvider.autoDispose
    .family<PostListController, PagedState<Post>, PostListSource>(PostListController.new);

class PostListController extends PagedController<Post> {
  PostListController(this.source);

  final PostListSource source;

  @override
  String idOf(Post item) => item.id;

  @override
  Future<CursorPage<Post>> fetch(String? cursor) {
    final repo = ref.read(socialRepositoryProvider);
    return switch (source) {
      SavedPostsSource() => repo.savedPosts(cursor: cursor),
      ProfilePostsSource(:final username) => repo.profilePosts(username, cursor: cursor),
      HashtagPostsSource(:final hashtag) => repo.searchPosts(hashtag: hashtag, cursor: cursor),
      SearchPostsSource(:final query) => repo.searchPosts(query: query, cursor: cursor),
    };
  }
}

final AsyncNotifierProviderFamily<MemberListController, PagedState<MemberCard>, MemberListKind>
memberListProvider = AsyncNotifierProvider.autoDispose
    .family<MemberListController, PagedState<MemberCard>, MemberListKind>(
      MemberListController.new,
    );

class MemberListController extends PagedController<MemberCard> {
  MemberListController(this.kind);

  final MemberListKind kind;

  @override
  String idOf(MemberCard item) => item.member.id;

  @override
  Future<CursorPage<MemberCard>> fetch(String? cursor) =>
      ref.read(socialRepositoryProvider).members(kind, cursor: cursor);
}

/// A member's public profile.
final FutureProviderFamily<PublicProfile, String> publicProfileProvider = FutureProvider.autoDispose
    .family<PublicProfile, String>((ref, username) async {
      ref.watch(authSessionProvider);
      return ref.read(socialRepositoryProvider).profile(username);
    });

final FutureProvider<List<HashtagStat>> trendingHashtagsProvider =
    FutureProvider.autoDispose<List<HashtagStat>>((ref) async {
      ref.watch(authSessionProvider);
      return ref.read(socialRepositoryProvider).trendingHashtags();
    });

/// Follow / block / report. After a block or unblock, every list that could contain the
/// member reloads (feeds, profile, member lists) — the server is the source of truth.
final socialActionsProvider = Provider<SocialActions>(SocialActions.new);

class SocialActions {
  SocialActions(this._ref);

  final Ref _ref;

  Future<void> setFollowing(PublicProfile profile, {required bool following}) async {
    await _ref.read(socialRepositoryProvider).setFollowing(profile.member.id, following: following);
    _ref
      ..invalidate(publicProfileProvider(profile.member.username))
      ..invalidate(memberListProvider)
      ..invalidate(feedControllerProvider);
  }

  Future<void> setBlocked(String profileId, String username, {required bool blocked}) async {
    await _ref.read(socialRepositoryProvider).setBlocked(profileId, blocked: blocked);
    _ref
      ..invalidate(publicProfileProvider(username))
      ..invalidate(memberListProvider)
      ..invalidate(feedControllerProvider)
      ..invalidate(postListProvider);
  }

  Future<ReportReceipt> report(
    ReportTargetType type,
    String id,
    ReportReason reason, {
    String? details,
  }) => _ref.read(socialRepositoryProvider).report(type, id, reason, details: details);
}
