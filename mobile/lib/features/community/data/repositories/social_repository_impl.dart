import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/community/data/models/community_dtos.dart';
import 'package:mindful/features/community/data/models/social_dtos.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/domain/repositories/social_repository.dart';

final socialRepositoryProvider = Provider<SocialRepository>(
  (ref) => SocialRepositoryImpl(ref.watch(apiClientProvider)),
);

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl(this._api);

  final ApiClient _api;

  static List<Post> _posts(Object? data) =>
      ApiData.list(data).map((j) => PostDto.fromJson(j).toEntity()).toList();

  static List<MemberCard> _members(Object? data) =>
      ApiData.list(data).map((j) => MemberCardDto.fromJson(j).toEntity()).toList();

  static List<HashtagStat> _hashtags(Object? data) =>
      ApiData.list(data).map((j) => HashtagDto.fromJson(j).toEntity()).toList();

  static CursorPage<T> _page<T>(ApiEnvelope<List<T>> envelope) => CursorPage(
    items: envelope.data,
    nextCursor: envelope.pagination?.nextCursor,
    hasMore: envelope.pagination?.hasMore ?? false,
  );

  @override
  Future<PublicProfile> profile(String username) async {
    final envelope = await _api.get(
      '/profiles/${Uri.encodeComponent(username)}',
      parse: (data) => PublicProfileDto.fromJson(ApiData.object(data)).toEntity(),
    );
    return envelope.data;
  }

  @override
  Future<CursorPage<Post>> profilePosts(String username, {String? cursor}) async => _page(
    await _api.get(
      '/profiles/${Uri.encodeComponent(username)}/posts',
      query: {'cursor': ?cursor},
      parse: _posts,
    ),
  );

  @override
  Future<void> setFollowing(String profileId, {required bool following}) => following
      ? _api.postNoContent('/profiles/$profileId/follow')
      : _api.delete('/profiles/$profileId/follow');

  @override
  Future<void> setBlocked(String profileId, {required bool blocked}) => blocked
      ? _api.postNoContent('/profiles/$profileId/block')
      : _api.delete('/profiles/$profileId/block');

  @override
  Future<CursorPage<MemberCard>> members(MemberListKind kind, {String? cursor}) async {
    final path = switch (kind) {
      MemberListKind.followers => '/profile/followers',
      MemberListKind.following => '/profile/following',
      MemberListKind.blocked => '/profile/blocks',
    };
    return _page(await _api.get(path, query: {'cursor': ?cursor}, parse: _members));
  }

  @override
  Future<CursorPage<Post>> savedPosts({String? cursor}) async =>
      _page(await _api.get('/saved-posts', query: {'cursor': ?cursor}, parse: _posts));

  @override
  Future<CursorPage<Post>> searchPosts({String? query, String? hashtag, String? cursor}) async =>
      _page(
        await _api.get(
          '/posts',
          query: {'q': ?query, 'hashtag': ?hashtag, 'cursor': ?cursor},
          parse: _posts,
        ),
      );

  @override
  Future<List<MemberCard>> searchMembers(String query) async =>
      (await _api.get('/search/profiles', query: {'q': query}, parse: _members)).data;

  @override
  Future<List<HashtagStat>> searchHashtags(String query) async =>
      (await _api.get('/search/hashtags', query: {'q': query}, parse: _hashtags)).data;

  @override
  Future<List<HashtagStat>> trendingHashtags() async =>
      (await _api.get('/hashtags/trending', parse: _hashtags)).data;

  @override
  Future<ReportReceipt> report(
    ReportTargetType type,
    String targetId,
    ReportReason reason, {
    String? details,
  }) async {
    final envelope = await _api.post(
      '/reports',
      body: {
        'target_type': type.wire,
        'target_id': targetId,
        'reason': reason.wire,
        'details': ?details,
      },
      parse: (data) => ApiData.object(data)['crisis_support'] == true,
    );
    return ReportReceipt(crisisSupport: envelope.data, message: envelope.message);
  }
}
