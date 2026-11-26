import 'package:mindful/features/community/domain/entities/community_enums.dart';

/// A member as shown in the community — anonymous profile only.
class MemberSummary {
  const MemberSummary({required this.id, required this.username, required this.avatar});

  /// Anonymous profile id.
  final String id;
  final String username;

  /// Avatar key, see `AvatarCatalog`.
  final String avatar;
}

/// Post category (FR-COM-003), localized by the server.
class Category {
  const Category({
    required this.slug,
    required this.name,
    required this.description,
    required this.icon,
  });

  /// Stable identifier (the API identifies categories by slug).
  final String slug;
  final String name;
  final String description;

  /// Material icon name from the server, mapped to an icon in the UI.
  final String icon;
}

class PostImage {
  const PostImage({required this.id, required this.url, required this.width, required this.height});

  final String id;

  /// Short-lived signed URL.
  final String url;
  final int width;
  final int height;
}

/// Reaction counts and the viewer's own reaction (never who reacted).
class ReactionSummary {
  const ReactionSummary({required this.counts, required this.total, this.mine});

  static const empty = ReactionSummary(counts: {}, total: 0);

  final Map<ReactionType, int> counts;
  final int total;
  final ReactionType? mine;

  int countOf(ReactionType type) => counts[type] ?? 0;

  /// Most-used reactions first (for the compact summary on cards).
  List<ReactionType> get topTypes {
    final used = ReactionType.values.where((t) => countOf(t) > 0).toList()
      ..sort((a, b) => countOf(b).compareTo(countOf(a)));
    return used;
  }

  /// Local prediction of the summary after choosing [type] (null = remove).
  ReactionSummary withMine(ReactionType? type) {
    final next = Map<ReactionType, int>.of(counts);
    if (mine != null) next[mine!] = (next[mine!] ?? 1) - 1;
    if (type != null) next[type] = (next[type] ?? 0) + 1;
    final total = next.values.fold<int>(0, (sum, n) => sum + n);
    return ReactionSummary(counts: next, total: total, mine: type);
  }
}

class Post {
  const Post({
    required this.id,
    required this.author,
    required this.category,
    required this.content,
    required this.hashtags,
    required this.allowComments,
    required this.visibility,
    required this.images,
    required this.reactions,
    required this.commentsCount,
    required this.isSaved,
    required this.isOwn,
    required this.edited,
    required this.createdAt,
    this.contentWarning,
    this.moderationState,
  });

  final String id;
  final MemberSummary author;
  final Category category;
  final String content;
  final List<String> hashtags;
  final ContentWarning? contentWarning;
  final bool allowComments;
  final PostVisibility visibility;
  final List<PostImage> images;
  final ReactionSummary reactions;
  final int commentsCount;
  final bool isSaved;
  final bool isOwn;

  /// Only set on the viewer's own posts.
  final ModerationState? moderationState;
  final bool edited;
  final DateTime createdAt;

  Post copyWith({ReactionSummary? reactions, int? commentsCount, bool? isSaved}) => Post(
    id: id,
    author: author,
    category: category,
    content: content,
    hashtags: hashtags,
    contentWarning: contentWarning,
    allowComments: allowComments,
    visibility: visibility,
    images: images,
    reactions: reactions ?? this.reactions,
    commentsCount: commentsCount ?? this.commentsCount,
    isSaved: isSaved ?? this.isSaved,
    isOwn: isOwn,
    moderationState: moderationState,
    edited: edited,
    createdAt: createdAt,
  );
}

/// What the composer sends (create or edit).
class PostDraft {
  const PostDraft({
    required this.categorySlug,
    required this.content,
    required this.allowComments,
    required this.visibility,
    this.contentWarning,
  });

  final String categorySlug;
  final String content;
  final ContentWarning? contentWarning;
  final bool allowComments;
  final PostVisibility visibility;
}
