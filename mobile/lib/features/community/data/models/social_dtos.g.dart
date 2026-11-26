// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RelationshipDto _$RelationshipDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_RelationshipDto',
  json,
  ($checkedConvert) {
    final val = _RelationshipDto(
      isSelf: $checkedConvert('is_self', (v) => v as bool? ?? false),
      isFollowing: $checkedConvert('is_following', (v) => v as bool? ?? false),
      followsYou: $checkedConvert('follows_you', (v) => v as bool? ?? false),
      isBlocked: $checkedConvert('is_blocked', (v) => v as bool? ?? false),
      canFollow: $checkedConvert('can_follow', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'isSelf': 'is_self',
    'isFollowing': 'is_following',
    'followsYou': 'follows_you',
    'isBlocked': 'is_blocked',
    'canFollow': 'can_follow',
  },
);

Map<String, dynamic> _$RelationshipDtoToJson(_RelationshipDto instance) => <String, dynamic>{
  'is_self': instance.isSelf,
  'is_following': instance.isFollowing,
  'follows_you': instance.followsYou,
  'is_blocked': instance.isBlocked,
  'can_follow': instance.canFollow,
};

_ProfileStatsDto _$ProfileStatsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ProfileStatsDto', json, ($checkedConvert) {
  final val = _ProfileStatsDto(
    followers: $checkedConvert('followers', (v) => (v as num?)?.toInt() ?? 0),
    following: $checkedConvert('following', (v) => (v as num?)?.toInt() ?? 0),
  );
  return val;
});

Map<String, dynamic> _$ProfileStatsDtoToJson(_ProfileStatsDto instance) => <String, dynamic>{
  'followers': instance.followers,
  'following': instance.following,
};

_PublicProfileDto _$PublicProfileDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_PublicProfileDto',
  json,
  ($checkedConvert) {
    final val = _PublicProfileDto(
      id: $checkedConvert('id', (v) => v as String),
      username: $checkedConvert('username', (v) => v as String),
      avatar: $checkedConvert('avatar', (v) => v as String),
      joinedOn: $checkedConvert(
        'joined_on',
        (v) => DateTime.parse(v as String),
      ),
      bio: $checkedConvert('bio', (v) => v as String?),
      isPrivate: $checkedConvert('is_private', (v) => v as bool? ?? false),
      stats: $checkedConvert(
        'stats',
        (v) => v == null
            ? const ProfileStatsDto()
            : ProfileStatsDto.fromJson(v as Map<String, dynamic>),
      ),
      relationship: $checkedConvert(
        'relationship',
        (v) => v == null
            ? const RelationshipDto()
            : RelationshipDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'joinedOn': 'joined_on', 'isPrivate': 'is_private'},
);

Map<String, dynamic> _$PublicProfileDtoToJson(_PublicProfileDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
  'joined_on': instance.joinedOn.toIso8601String(),
  'bio': instance.bio,
  'is_private': instance.isPrivate,
  'stats': instance.stats.toJson(),
  'relationship': instance.relationship.toJson(),
};

_MemberCardDto _$MemberCardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemberCardDto', json, ($checkedConvert) {
      final val = _MemberCardDto(
        id: $checkedConvert('id', (v) => v as String),
        username: $checkedConvert('username', (v) => v as String),
        avatar: $checkedConvert('avatar', (v) => v as String),
        isFollowing: $checkedConvert('is_following', (v) => v as bool?),
      );
      return val;
    }, fieldKeyMap: const {'isFollowing': 'is_following'});

Map<String, dynamic> _$MemberCardDtoToJson(_MemberCardDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
  'is_following': instance.isFollowing,
};

_HashtagDto _$HashtagDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_HashtagDto', json, ($checkedConvert) {
      final val = _HashtagDto(
        name: $checkedConvert('name', (v) => v as String),
        postsCount: $checkedConvert(
          'posts_count',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    }, fieldKeyMap: const {'postsCount': 'posts_count'});

Map<String, dynamic> _$HashtagDtoToJson(_HashtagDto instance) => <String, dynamic>{
  'name': instance.name,
  'posts_count': instance.postsCount,
};
