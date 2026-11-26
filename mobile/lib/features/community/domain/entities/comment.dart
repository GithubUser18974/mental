import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

/// A comment or reply (FR-COM-004). One level of threading: replies have a [parentId].
class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.isRemoved,
    required this.isOwn,
    required this.isPostAuthor,
    required this.repliesCount,
    required this.edited,
    required this.createdAt,
    this.parentId,
    this.author,
    this.content,
    this.moderationState,
  });

  final String id;
  final String postId;
  final String? parentId;

  /// Placeholder for a removed comment that still has replies: no author, no content.
  final bool isRemoved;
  final MemberSummary? author;
  final String? content;
  final bool isOwn;

  /// Written by the post's author (shows a badge).
  final bool isPostAuthor;
  final ModerationState? moderationState;

  /// Top-level comments only.
  final int repliesCount;
  final bool edited;
  final DateTime createdAt;

  bool get isTopLevel => parentId == null;

  Comment copyWith({String? content, bool? edited, int? repliesCount}) => Comment(
    id: id,
    postId: postId,
    parentId: parentId,
    isRemoved: isRemoved,
    author: author,
    content: content ?? this.content,
    isOwn: isOwn,
    isPostAuthor: isPostAuthor,
    moderationState: moderationState,
    repliesCount: repliesCount ?? this.repliesCount,
    edited: edited ?? this.edited,
    createdAt: createdAt,
  );
}
