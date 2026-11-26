/// Supportive reactions (FR-COM-005). Order = display order.
enum ReactionType {
  understand('understand'),
  support('support'),
  notAlone('not_alone'),
  proud('proud'),
  thankYou('thank_you')
  ;

  const ReactionType(this.wire);

  final String wire;

  static ReactionType? fromWire(String? value) => values.where((t) => t.wire == value).firstOrNull;
}

/// Author-selected content warnings (FR-COM-002). Posts with one are blurred until revealed.
enum ContentWarning {
  selfHarm('self_harm'),
  suicide('suicide'),
  eatingDisorder('eating_disorder'),
  substanceUse('substance_use'),
  abuseTrauma('abuse_trauma'),
  sensitive('sensitive')
  ;

  const ContentWarning(this.wire);

  final String wire;

  static ContentWarning? fromWire(String? value) =>
      values.where((w) => w.wire == value).firstOrNull;
}

enum PostVisibility {
  community('community'),
  onlyMe('only_me')
  ;

  const PostVisibility(this.wire);

  final String wire;

  static PostVisibility fromWire(String? value) =>
      values.firstWhere((v) => v.wire == value, orElse: () => PostVisibility.community);
}

/// Moderation state — only ever shown to the author of their own post/comment.
enum ModerationState {
  visible('visible'),
  underReview('under_review'),
  hidden('hidden')
  ;

  const ModerationState(this.wire);

  final String wire;

  static ModerationState? fromWire(String? value) =>
      values.where((s) => s.wire == value).firstOrNull;
}

/// Feed tabs (FR-COM-001).
enum FeedKind { recent, popular, following }
