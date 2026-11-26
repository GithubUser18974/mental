import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show AsyncNotifierProviderFamily;
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/community/data/repositories/community_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';

/// Replies under one top-level comment, loaded on demand.
class ReplyThread {
  const ReplyThread({
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.loading = false,
    this.expanded = false,
    this.error,
  });

  final List<Comment> items;
  final String? nextCursor;
  final bool hasMore;
  final bool loading;
  final bool expanded;
  final Object? error;

  bool get loaded => items.isNotEmpty || (!loading && !hasMore && error == null && expanded);

  ReplyThread copyWith({
    List<Comment>? items,
    String? nextCursor,
    bool? hasMore,
    bool? loading,
    bool? expanded,
    Object? error,
  }) => ReplyThread(
    items: items ?? this.items,
    nextCursor: nextCursor ?? this.nextCursor,
    hasMore: hasMore ?? this.hasMore,
    loading: loading ?? this.loading,
    expanded: expanded ?? this.expanded,
    error: error,
  );
}

/// A post's conversation: top-level comments (oldest first) + reply threads.
class CommentsState {
  const CommentsState({
    required this.comments,
    required this.hasMore,
    this.nextCursor,
    this.loadingMore = false,
    this.replies = const {},
  });

  final List<Comment> comments;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;

  /// Top-level comment id → its replies.
  final Map<String, ReplyThread> replies;

  ReplyThread threadOf(String rootId) => replies[rootId] ?? const ReplyThread();

  CommentsState copyWith({
    List<Comment>? comments,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
    Map<String, ReplyThread>? replies,
  }) => CommentsState(
    comments: comments ?? this.comments,
    nextCursor: nextCursor ?? this.nextCursor,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    replies: replies ?? this.replies,
  );
}

final AsyncNotifierProviderFamily<CommentsController, CommentsState, String>
commentsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<CommentsController, CommentsState, String>(CommentsController.new);

class CommentsController extends AsyncNotifier<CommentsState> {
  CommentsController(this.postId);

  final String postId;

  @override
  Future<CommentsState> build() async {
    ref.watch(authSessionProvider);
    final page = await ref.read(communityRepositoryProvider).comments(postId);
    return CommentsState(comments: page.items, nextCursor: page.nextCursor, hasMore: page.hasMore);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .comments(postId, cursor: current.nextCursor);
      if (!ref.mounted) return;
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          comments: _merge(latest.comments, page.items),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          loadingMore: false,
        ),
      );
    } on Object {
      if (ref.mounted) state = AsyncData((state.value ?? current).copyWith(loadingMore: false));
      rethrow;
    }
  }

  /// Expands (loading the first page if needed) or collapses a reply thread.
  Future<void> toggleReplies(String rootId) async {
    final current = state.value;
    if (current == null) return;
    final thread = current.threadOf(rootId);
    if (thread.expanded) {
      _setThread(rootId, thread.copyWith(expanded: false));
      return;
    }
    _setThread(rootId, thread.copyWith(expanded: true));
    if (thread.items.isEmpty) await loadMoreReplies(rootId);
  }

  Future<void> loadMoreReplies(String rootId) async {
    final thread = state.value?.threadOf(rootId);
    if (thread == null || thread.loading) return;
    _setThread(rootId, thread.copyWith(loading: true));
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .replies(rootId, cursor: thread.nextCursor);
      if (!ref.mounted) return;
      final latest = state.value?.threadOf(rootId) ?? thread;
      _setThread(
        rootId,
        latest.copyWith(
          items: _merge(latest.items, page.items),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          loading: false,
        ),
      );
    } on Object catch (error) {
      if (ref.mounted) {
        _setThread(
          rootId,
          (state.value?.threadOf(rootId) ?? thread).copyWith(
            loading: false,
            error: error,
          ),
        );
      }
    }
  }

  /// Posts a comment, or a reply when [replyTo] is given (replies attach to its thread).
  Future<Comment> add(String content, {Comment? replyTo}) async {
    final rootId = replyTo == null ? null : (replyTo.parentId ?? replyTo.id);
    final comment = await ref
        .read(communityRepositoryProvider)
        .addComment(postId, content, parentId: replyTo?.id);
    if (!ref.mounted) return comment;

    final current = state.value;
    if (current == null) return comment;
    if (rootId == null) {
      state = AsyncData(current.copyWith(comments: _merge(current.comments, [comment])));
    } else {
      final thread = current.threadOf(rootId);
      state = AsyncData(
        current.copyWith(
          comments: [
            for (final c in current.comments)
              c.id == rootId ? c.copyWith(repliesCount: c.repliesCount + 1) : c,
          ],
          replies: {
            ...current.replies,
            rootId: thread.copyWith(items: _merge(thread.items, [comment]), expanded: true),
          },
        ),
      );
    }
    return comment;
  }

  Future<void> edit(Comment comment, String content) async {
    final updated = await ref.read(communityRepositoryProvider).editComment(comment.id, content);
    if (!ref.mounted) return;
    _replace(comment.id, (_) => updated);
  }

  Future<void> delete(Comment comment) async {
    await ref.read(communityRepositoryProvider).deleteComment(comment.id);
    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;

    if (comment.isTopLevel) {
      // With replies it stays as an anonymous placeholder (same as the server).
      state = AsyncData(
        current.copyWith(
          comments: [
            for (final c in current.comments)
              if (c.id != comment.id) c else if (c.repliesCount > 0) _placeholder(c),
          ],
        ),
      );
    } else {
      final rootId = comment.parentId!; // Replies always have a parent.
      final thread = current.threadOf(rootId);
      state = AsyncData(
        current.copyWith(
          comments: [
            for (final c in current.comments)
              c.id == rootId ? c.copyWith(repliesCount: c.repliesCount - 1) : c,
          ],
          replies: {
            ...current.replies,
            rootId: thread.copyWith(items: [...thread.items.where((r) => r.id != comment.id)]),
          },
        ),
      );
    }
  }

  void _setThread(String rootId, ReplyThread thread) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(replies: {...current.replies, rootId: thread}));
  }

  void _replace(String id, Comment Function(Comment) update) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        comments: [for (final c in current.comments) c.id == id ? update(c) : c],
        replies: {
          for (final MapEntry(:key, :value) in current.replies.entries)
            key: value.copyWith(items: [for (final r in value.items) r.id == id ? update(r) : r]),
        },
      ),
    );
  }

  static List<Comment> _merge(List<Comment> existing, List<Comment> incoming) {
    final known = {for (final c in existing) c.id};
    return [...existing, ...incoming.where((c) => !known.contains(c.id))];
  }

  static Comment _placeholder(Comment c) => Comment(
    id: c.id,
    postId: c.postId,
    isRemoved: true,
    isOwn: false,
    isPostAuthor: false,
    repliesCount: c.repliesCount,
    edited: false,
    createdAt: c.createdAt,
  );
}
