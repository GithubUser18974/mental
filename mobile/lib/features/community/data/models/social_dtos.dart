import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/community/data/models/community_dtos.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';

part 'social_dtos.freezed.dart';
part 'social_dtos.g.dart';

@freezed
abstract class RelationshipDto with _$RelationshipDto {
  const factory RelationshipDto({
    @Default(false) bool isSelf,
    @Default(false) bool isFollowing,
    @Default(false) bool followsYou,
    @Default(false) bool isBlocked,
    @Default(false) bool canFollow,
  }) = _RelationshipDto;

  factory RelationshipDto.fromJson(Map<String, dynamic> json) => _$RelationshipDtoFromJson(json);
}

@freezed
abstract class ProfileStatsDto with _$ProfileStatsDto {
  const factory ProfileStatsDto({@Default(0) int followers, @Default(0) int following}) =
      _ProfileStatsDto;

  factory ProfileStatsDto.fromJson(Map<String, dynamic> json) => _$ProfileStatsDtoFromJson(json);
}

@freezed
abstract class PublicProfileDto with _$PublicProfileDto {
  const factory PublicProfileDto({
    required String id,
    required String username,
    required String avatar,
    required DateTime joinedOn,
    String? bio,
    @Default(false) bool isPrivate,
    @Default(ProfileStatsDto()) ProfileStatsDto stats,
    @Default(RelationshipDto()) RelationshipDto relationship,
  }) = _PublicProfileDto;

  const PublicProfileDto._();

  factory PublicProfileDto.fromJson(Map<String, dynamic> json) => _$PublicProfileDtoFromJson(json);

  PublicProfile toEntity() => PublicProfile(
    member: MemberSummary(id: id, username: username, avatar: avatar),
    bio: bio,
    isPrivate: isPrivate,
    joinedOn: joinedOn,
    followers: stats.followers,
    following: stats.following,
    relationship: Relationship(
      isSelf: relationship.isSelf,
      isFollowing: relationship.isFollowing,
      followsYou: relationship.followsYou,
      isBlocked: relationship.isBlocked,
      canFollow: relationship.canFollow,
    ),
  );
}

@freezed
abstract class MemberCardDto with _$MemberCardDto {
  const factory MemberCardDto({
    required String id,
    required String username,
    required String avatar,
    bool? isFollowing,
  }) = _MemberCardDto;

  const MemberCardDto._();

  factory MemberCardDto.fromJson(Map<String, dynamic> json) => _$MemberCardDtoFromJson(json);

  MemberCard toEntity() => MemberCard(
    member: MemberDto(id: id, username: username, avatar: avatar).toEntity(),
    isFollowing: isFollowing,
  );
}

@freezed
abstract class HashtagDto with _$HashtagDto {
  const factory HashtagDto({required String name, @Default(0) int postsCount}) = _HashtagDto;

  const HashtagDto._();

  factory HashtagDto.fromJson(Map<String, dynamic> json) => _$HashtagDtoFromJson(json);

  HashtagStat toEntity() => HashtagStat(name: name, postsCount: postsCount);
}
