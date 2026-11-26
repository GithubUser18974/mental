import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

part 'community_dtos.freezed.dart';
part 'community_dtos.g.dart';

@freezed
abstract class MemberDto with _$MemberDto {
  const factory MemberDto({
    required String id,
    required String username,
    required String avatar,
  }) = _MemberDto;

  const MemberDto._();

  factory MemberDto.fromJson(Map<String, dynamic> json) => _$MemberDtoFromJson(json);

  MemberSummary toEntity() => MemberSummary(id: id, username: username, avatar: avatar);
}

@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String slug,
    required String name,
    @Default('') String description,
    @Default('') String icon,
  }) = _CategoryDto;

  const CategoryDto._();

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  Category toEntity() => Category(slug: slug, name: name, description: description, icon: icon);
}

@freezed
abstract class MediaDto with _$MediaDto {
  const factory MediaDto({
    required String id,
    required String url,
    @Default(0) int width,
    @Default(0) int height,
  }) = _MediaDto;

  const MediaDto._();

  factory MediaDto.fromJson(Map<String, dynamic> json) => _$MediaDtoFromJson(json);

  PostImage toEntity() => PostImage(id: id, url: url, width: width, height: height);
}

@freezed
abstract class ReactionSummaryDto with _$ReactionSummaryDto {
  const factory ReactionSummaryDto({
    @Default(<String, int>{}) Map<String, int> counts,
    @Default(0) int total,
    String? mine,
  }) = _ReactionSummaryDto;

  const ReactionSummaryDto._();

  factory ReactionSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ReactionSummaryDtoFromJson(json);

  ReactionSummary toEntity() => ReactionSummary(
    counts: {
      for (final MapEntry(:key, :value) in counts.entries) ?ReactionType.fromWire(key): value,
    },
    total: total,
    mine: ReactionType.fromWire(mine),
  );
}

@freezed
abstract class PostDto with _$PostDto {
  const factory PostDto({
    required String id,
    required MemberDto author,
    required CategoryDto category,
    required String content,
    required DateTime createdAt,
    @Default(<String>[]) List<String> hashtags,
    String? contentWarning,
    @Default(true) bool allowComments,
    @Default('community') String visibility,
    @Default(<MediaDto>[]) List<MediaDto> media,
    ReactionSummaryDto? reactions,
    @Default(0) int commentsCount,
    @Default(false) bool isSaved,
    @Default(false) bool isOwn,
    String? moderationStatus,
    @Default(false) bool edited,
  }) = _PostDto;

  const PostDto._();

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Post toEntity() => Post(
    id: id,
    author: author.toEntity(),
    category: category.toEntity(),
    content: content,
    hashtags: hashtags,
    contentWarning: ContentWarning.fromWire(contentWarning),
    allowComments: allowComments,
    visibility: PostVisibility.fromWire(visibility),
    images: media.map((m) => m.toEntity()).toList(),
    reactions: reactions?.toEntity() ?? ReactionSummary.empty,
    commentsCount: commentsCount,
    isSaved: isSaved,
    isOwn: isOwn,
    moderationState: ModerationState.fromWire(moderationStatus),
    edited: edited,
    createdAt: createdAt.toUtc(),
  );
}

@freezed
abstract class CommentDto with _$CommentDto {
  const factory CommentDto({
    required String id,
    required String postId,
    required DateTime createdAt,
    String? parentId,
    @Default(false) bool isRemoved,
    MemberDto? author,
    String? content,
    @Default(false) bool isOwn,
    @Default(false) bool isPostAuthor,
    String? moderationStatus,
    @Default(0) int repliesCount,
    @Default(false) bool edited,
  }) = _CommentDto;

  const CommentDto._();

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);

  Comment toEntity() => Comment(
    id: id,
    postId: postId,
    parentId: parentId,
    isRemoved: isRemoved,
    author: author?.toEntity(),
    content: content,
    isOwn: isOwn,
    isPostAuthor: isPostAuthor,
    moderationState: ModerationState.fromWire(moderationStatus),
    repliesCount: repliesCount,
    edited: edited,
    createdAt: createdAt.toUtc(),
  );
}
