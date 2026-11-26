import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/community/data/repositories/community_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/providers/post_store.dart';

/// Active categories (localized by the server). Refetched after sign-in / language change
/// via invalidation; wiped on sign-out.
final FutureProvider<List<Category>> categoriesProvider =
    FutureProvider.autoDispose<List<Category>>((ref) async {
      ref.watch(authSessionProvider);
      final categories = await ref.read(communityRepositoryProvider).categories();
      ref.keepAlive();
      return categories;
    });

/// A single post (detail page). The fresh server copy goes into the [postStoreProvider],
/// replacing whatever version the feed handed over for instant display.
final FutureProviderFamily<Post, String> postDetailProvider = FutureProvider.autoDispose
    .family<Post, String>((ref, id) async {
      ref.watch(authSessionProvider);
      final post = await ref.read(communityRepositoryProvider).post(id);
      if (ref.mounted) ref.read(postStoreProvider.notifier).put(post);
      return post;
    });

/// Post-level actions with optimistic updates through the [postStoreProvider].
///
/// Methods take the caller's [Ref]-independent inputs; this provider is never disposed
/// while the app runs (no autoDispose), so its `ref` stays valid across awaits.
final postActionsProvider = Provider<PostActions>(PostActions.new);

class PostActions {
  PostActions(this._ref);

  final Ref _ref;

  PostStore get _store => _ref.read(postStoreProvider.notifier);

  /// Sets (or with `null` removes) the viewer's reaction. Reverts on failure and rethrows.
  Future<void> react(Post post, ReactionType? type) async {
    final repo = _ref.read(communityRepositoryProvider);
    _store.put(post.copyWith(reactions: post.reactions.withMine(type)));
    try {
      if (type == null) {
        await repo.removeReaction(post.id);
      } else {
        final summary = await repo.react(post.id, type);
        _store.put(post.copyWith(reactions: summary));
      }
    } on Object {
      _store.put(post);
      rethrow;
    }
  }

  Future<void> toggleSaved(Post post) async {
    final saved = !post.isSaved;
    _store.put(post.copyWith(isSaved: saved));
    try {
      await _ref.read(communityRepositoryProvider).setSaved(post.id, saved: saved);
    } on Object {
      _store.put(post);
      rethrow;
    }
  }

  Future<void> delete(Post post) async {
    await _ref.read(communityRepositoryProvider).deletePost(post.id);
    _store.markDeleted(post.id);
  }

  /// Keeps the card's comment count in step with the thread.
  void adjustCommentCount(Post post, int delta) {
    final count = post.commentsCount + delta;
    _store.put(post.copyWith(commentsCount: count < 0 ? 0 : count));
  }

  void replace(Post post) => _store.put(post);
}
