// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberDto _$MemberDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemberDto', json, ($checkedConvert) {
      final val = _MemberDto(
        id: $checkedConvert('id', (v) => v as String),
        username: $checkedConvert('username', (v) => v as String),
        avatar: $checkedConvert('avatar', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MemberDtoToJson(_MemberDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
};

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CategoryDto', json, ($checkedConvert) {
      final val = _CategoryDto(
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String? ?? ''),
        icon: $checkedConvert('icon', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
};

_MediaDto _$MediaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MediaDto', json, ($checkedConvert) {
      final val = _MediaDto(
        id: $checkedConvert('id', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
        width: $checkedConvert('width', (v) => (v as num?)?.toInt() ?? 0),
        height: $checkedConvert('height', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$MediaDtoToJson(_MediaDto instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};

_ReactionSummaryDto _$ReactionSummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReactionSummaryDto', json, ($checkedConvert) {
      final val = _ReactionSummaryDto(
        counts: $checkedConvert(
          'counts',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
        ),
        total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
        mine: $checkedConvert('mine', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReactionSummaryDtoToJson(_ReactionSummaryDto instance) => <String, dynamic>{
  'counts': instance.counts,
  'total': instance.total,
  'mine': instance.mine,
};

_PostDto _$PostDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_PostDto',
  json,
  ($checkedConvert) {
    final val = _PostDto(
      id: $checkedConvert('id', (v) => v as String),
      author: $checkedConvert(
        'author',
        (v) => MemberDto.fromJson(v as Map<String, dynamic>),
      ),
      category: $checkedConvert(
        'category',
        (v) => CategoryDto.fromJson(v as Map<String, dynamic>),
      ),
      content: $checkedConvert('content', (v) => v as String),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      hashtags: $checkedConvert(
        'hashtags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
      ),
      contentWarning: $checkedConvert('content_warning', (v) => v as String?),
      allowComments: $checkedConvert(
        'allow_comments',
        (v) => v as bool? ?? true,
      ),
      visibility: $checkedConvert(
        'visibility',
        (v) => v as String? ?? 'community',
      ),
      media: $checkedConvert(
        'media',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => MediaDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <MediaDto>[],
      ),
      reactions: $checkedConvert(
        'reactions',
        (v) => v == null ? null : ReactionSummaryDto.fromJson(v as Map<String, dynamic>),
      ),
      commentsCount: $checkedConvert(
        'comments_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      isSaved: $checkedConvert('is_saved', (v) => v as bool? ?? false),
      isOwn: $checkedConvert('is_own', (v) => v as bool? ?? false),
      moderationStatus: $checkedConvert(
        'moderation_status',
        (v) => v as String?,
      ),
      edited: $checkedConvert('edited', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'createdAt': 'created_at',
    'contentWarning': 'content_warning',
    'allowComments': 'allow_comments',
    'commentsCount': 'comments_count',
    'isSaved': 'is_saved',
    'isOwn': 'is_own',
    'moderationStatus': 'moderation_status',
  },
);

Map<String, dynamic> _$PostDtoToJson(_PostDto instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author.toJson(),
  'category': instance.category.toJson(),
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'hashtags': instance.hashtags,
  'content_warning': instance.contentWarning,
  'allow_comments': instance.allowComments,
  'visibility': instance.visibility,
  'media': instance.media.map((e) => e.toJson()).toList(),
  'reactions': instance.reactions?.toJson(),
  'comments_count': instance.commentsCount,
  'is_saved': instance.isSaved,
  'is_own': instance.isOwn,
  'moderation_status': instance.moderationStatus,
  'edited': instance.edited,
};

_CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_CommentDto',
  json,
  ($checkedConvert) {
    final val = _CommentDto(
      id: $checkedConvert('id', (v) => v as String),
      postId: $checkedConvert('post_id', (v) => v as String),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      parentId: $checkedConvert('parent_id', (v) => v as String?),
      isRemoved: $checkedConvert('is_removed', (v) => v as bool? ?? false),
      author: $checkedConvert(
        'author',
        (v) => v == null ? null : MemberDto.fromJson(v as Map<String, dynamic>),
      ),
      content: $checkedConvert('content', (v) => v as String?),
      isOwn: $checkedConvert('is_own', (v) => v as bool? ?? false),
      isPostAuthor: $checkedConvert(
        'is_post_author',
        (v) => v as bool? ?? false,
      ),
      moderationStatus: $checkedConvert(
        'moderation_status',
        (v) => v as String?,
      ),
      repliesCount: $checkedConvert(
        'replies_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      edited: $checkedConvert('edited', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'postId': 'post_id',
    'createdAt': 'created_at',
    'parentId': 'parent_id',
    'isRemoved': 'is_removed',
    'isOwn': 'is_own',
    'isPostAuthor': 'is_post_author',
    'moderationStatus': 'moderation_status',
    'repliesCount': 'replies_count',
  },
);

Map<String, dynamic> _$CommentDtoToJson(_CommentDto instance) => <String, dynamic>{
  'id': instance.id,
  'post_id': instance.postId,
  'created_at': instance.createdAt.toIso8601String(),
  'parent_id': instance.parentId,
  'is_removed': instance.isRemoved,
  'author': instance.author?.toJson(),
  'content': instance.content,
  'is_own': instance.isOwn,
  'is_post_author': instance.isPostAuthor,
  'moderation_status': instance.moderationStatus,
  'replies_count': instance.repliesCount,
  'edited': instance.edited,
};
