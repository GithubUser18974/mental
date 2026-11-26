import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

/// Community posts, comments, reactions and bookmarks. Implementations throw `AppException`s.
abstract interface class CommunityRepository {
  Future<List<Category>> categories();

  Future<CursorPage<Post>> feed({required FeedKind kind, String? categorySlug, String? cursor});

  Future<Post> post(String id);

  Future<Post> createPost(PostDraft draft);

  Future<Post> updatePost(String id, PostDraft draft);

  Future<void> deletePost(String id);

  /// Returns the fresh summary from the server.
  Future<ReactionSummary> react(String postId, ReactionType type);

  Future<void> removeReaction(String postId);

  Future<void> setSaved(String postId, {required bool saved});

  Future<CursorPage<Comment>> comments(String postId, {String? cursor});

  Future<CursorPage<Comment>> replies(String commentId, {String? cursor});

  Future<Comment> addComment(String postId, String content, {String? parentId});

  Future<Comment> editComment(String commentId, String content);

  Future<void> deleteComment(String commentId);
}
