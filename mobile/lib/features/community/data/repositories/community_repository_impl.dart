import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/community/data/models/community_dtos.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/repositories/community_repository.dart';

final communityRepositoryProvider = Provider<CommunityRepository>(
  (ref) => CommunityRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Remote implementation over `/api/v1` community endpoints.
class CommunityRepositoryImpl implements CommunityRepository {
  CommunityRepositoryImpl(this._api);

  final ApiClient _api;

  static Post _post(Object? data) => PostDto.fromJson(ApiData.object(data)).toEntity();

  static List<Post> _posts(Object? data) =>
      ApiData.list(data).map((j) => PostDto.fromJson(j).toEntity()).toList();

  static Comment _comment(Object? data) => CommentDto.fromJson(ApiData.object(data)).toEntity();

  static List<Comment> _comments(Object? data) =>
      ApiData.list(data).map((j) => CommentDto.fromJson(j).toEntity()).toList();

  static CursorPage<T> _page<T>(ApiEnvelope<List<T>> envelope) => CursorPage(
    items: envelope.data,
    nextCursor: envelope.pagination?.nextCursor,
    hasMore: envelope.pagination?.hasMore ?? false,
  );

  static Map<String, dynamic> _draftBody(PostDraft draft) => {
    'category': draft.categorySlug,
    'content': draft.content,
    'content_warning': draft.contentWarning?.wire,
    'allow_comments': draft.allowComments,
    'visibility': draft.visibility.wire,
  };

  @override
  Future<List<Category>> categories() async {
    final envelope = await _api.get(
      '/categories',
      parse: (data) => ApiData.list(data).map((j) => CategoryDto.fromJson(j).toEntity()).toList(),
    );
    return envelope.data;
  }

  @override
  Future<CursorPage<Post>> feed({
    required FeedKind kind,
    String? categorySlug,
    String? cursor,
  }) async {
    final envelope = await _api.get(
      '/posts',
      query: {
        'sort': kind == FeedKind.popular ? 'popular' : 'recent',
        if (kind == FeedKind.following) 'following': 1,
        'category': ?categorySlug,
        'cursor': ?cursor,
      },
      parse: _posts,
    );
    return _page(envelope);
  }

  @override
  Future<Post> post(String id) async => (await _api.get('/posts/$id', parse: _post)).data;

  @override
  Future<Post> createPost(PostDraft draft) async =>
      (await _api.post('/posts', parse: _post, body: _draftBody(draft))).data;

  @override
  Future<Post> updatePost(String id, PostDraft draft) async =>
      (await _api.put('/posts/$id', parse: _post, body: _draftBody(draft))).data;

  @override
  Future<void> deletePost(String id) => _api.delete('/posts/$id');

  @override
  Future<ReactionSummary> react(String postId, ReactionType type) async {
    final envelope = await _api.post(
      '/posts/$postId/reactions',
      body: {'type': type.wire},
      parse: (data) => ReactionSummaryDto.fromJson(ApiData.object(data)).toEntity(),
    );
    return envelope.data;
  }

  @override
  Future<void> removeReaction(String postId) => _api.delete('/posts/$postId/reactions');

  @override
  Future<void> setSaved(String postId, {required bool saved}) async {
    if (saved) {
      await _api.postNoContent('/posts/$postId/save');
    } else {
      await _api.delete('/posts/$postId/save');
    }
  }

  @override
  Future<CursorPage<Comment>> comments(String postId, {String? cursor}) async => _page(
    await _api.get('/posts/$postId/comments', query: {'cursor': ?cursor}, parse: _comments),
  );

  @override
  Future<CursorPage<Comment>> replies(String commentId, {String? cursor}) async => _page(
    await _api.get('/comments/$commentId/replies', query: {'cursor': ?cursor}, parse: _comments),
  );

  @override
  Future<Comment> addComment(String postId, String content, {String? parentId}) async {
    final envelope = await _api.post(
      '/posts/$postId/comments',
      body: {'content': content, 'parent_id': ?parentId},
      parse: _comment,
    );
    return envelope.data;
  }

  @override
  Future<Comment> editComment(String commentId, String content) async =>
      (await _api.put('/comments/$commentId', body: {'content': content}, parse: _comment)).data;

  @override
  Future<void> deleteComment(String commentId) => _api.delete('/comments/$commentId');
}
