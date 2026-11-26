import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/domain/entities/social.dart';

/// Profiles, follows, blocks, saved posts, search and reports.
/// Implementations throw `AppException`s.
abstract interface class SocialRepository {
  Future<PublicProfile> profile(String username);

  Future<CursorPage<Post>> profilePosts(String username, {String? cursor});

  Future<void> setFollowing(String profileId, {required bool following});

  Future<void> setBlocked(String profileId, {required bool blocked});

  Future<CursorPage<MemberCard>> members(MemberListKind kind, {String? cursor});

  Future<CursorPage<Post>> savedPosts({String? cursor});

  Future<CursorPage<Post>> searchPosts({String? query, String? hashtag, String? cursor});

  Future<List<MemberCard>> searchMembers(String query);

  Future<List<HashtagStat>> searchHashtags(String query);

  Future<List<HashtagStat>> trendingHashtags();

  Future<ReportReceipt> report(
    ReportTargetType type,
    String targetId,
    ReportReason reason, {
    String? details,
  });
}
