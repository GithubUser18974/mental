import 'package:mindful/features/community/domain/entities/post.dart';

/// Viewer's relationship with a member (from the public profile).
class Relationship {
  const Relationship({
    required this.isSelf,
    required this.isFollowing,
    required this.followsYou,
    required this.isBlocked,
    required this.canFollow,
  });

  final bool isSelf;
  final bool isFollowing;
  final bool followsYou;

  /// The viewer blocked this member.
  final bool isBlocked;
  final bool canFollow;
}

/// Another member's public anonymous profile (FR-PRO-001/003). Never account data.
class PublicProfile {
  const PublicProfile({
    required this.member,
    required this.isPrivate,
    required this.joinedOn,
    required this.followers,
    required this.following,
    required this.relationship,
    this.bio,
  });

  final MemberSummary member;
  final String? bio;
  final bool isPrivate;
  final DateTime joinedOn;
  final int followers;
  final int following;
  final Relationship relationship;
}

/// A member in a list (followers, following, blocked, search results).
class MemberCard {
  const MemberCard({required this.member, this.isFollowing});

  final MemberSummary member;

  /// Null when the list doesn't say.
  final bool? isFollowing;
}

class HashtagStat {
  const HashtagStat({required this.name, required this.postsCount});

  final String name;
  final int postsCount;
}

/// Report reasons (FR-COM-010). Order = display order.
enum ReportReason {
  harassment('harassment'),
  dangerousMedicalAdvice('dangerous_medical_advice'),
  spam('spam'),
  selfHarmEncouragement('self_harm_encouragement'),
  suicidalContent('suicidal_content'),
  other('other')
  ;

  const ReportReason(this.wire);

  final String wire;
}

enum ReportTargetType {
  post('post'),
  comment('comment'),
  profile('profile')
  ;

  const ReportTargetType(this.wire);

  final String wire;
}

/// Result of filing a report.
class ReportReceipt {
  const ReportReceipt({required this.crisisSupport, required this.message});

  /// The app should offer crisis resources (FR-SAFETY-002).
  final bool crisisSupport;
  final String message;
}

/// Which members list to show.
enum MemberListKind { followers, following, blocked }
