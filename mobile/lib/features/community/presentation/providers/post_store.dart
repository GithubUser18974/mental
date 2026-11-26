import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

/// Latest known version of posts the user changed (reactions, saves, edits, comment
/// counts) plus deleted ids. Lists and the detail page render posts *through* this store,
/// so one action updates every screen at once without refetching.
///
/// Wiped on sign-out (watches the auth state).
class PostStoreState {
  const PostStoreState({this.latest = const {}, this.deleted = const {}});

  final Map<String, Post> latest;
  final Set<String> deleted;

  /// The freshest version of [post], or null if it was deleted.
  Post? resolve(Post post) => deleted.contains(post.id) ? null : latest[post.id] ?? post;
}

final postStoreProvider = NotifierProvider<PostStore, PostStoreState>(PostStore.new);

class PostStore extends Notifier<PostStoreState> {
  @override
  PostStoreState build() {
    ref.watch(authSessionProvider);
    return const PostStoreState();
  }

  void put(Post post) => state = PostStoreState(
    latest: {...state.latest, post.id: post},
    deleted: state.deleted,
  );

  void markDeleted(String id) => state = PostStoreState(
    latest: Map.of(state.latest)..remove(id),
    deleted: {...state.deleted, id},
  );
}
