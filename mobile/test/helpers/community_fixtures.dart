import 'fake_backend.dart';
import 'fakes.dart';

/// JSON shaped exactly like the API's community resources (keep in sync with the
/// backend resources — a mismatch here hides real parsing bugs).
Map<String, dynamic> categoryJson({String slug = 'my-story', String name = 'My Story'}) => {
  'slug': slug,
  'name': name,
  'description': 'Personal experiences',
  'icon': 'auto_stories',
};

Map<String, dynamic> postJson({
  String id = 'p1',
  String content = 'Small win today: I went for a walk.',
  String username = 'GentleWillow',
  bool isOwn = false,
  String? contentWarning,
  bool allowComments = true,
  bool isSaved = false,
  int commentsCount = 0,
  Map<String, int>? counts,
  String? mine,
  String visibility = 'community',
}) {
  final reactionCounts = {
    'understand': 0,
    'support': 0,
    'not_alone': 0,
    'proud': 0,
    'thank_you': 0,
    ...?counts,
  };
  return {
    'id': id,
    'author': {'id': 'author-$username', 'username': username, 'avatar': 'leaf-mint'},
    'category': categoryJson(),
    'content': content,
    'hashtags': <String>[],
    'content_warning': contentWarning,
    'allow_comments': allowComments,
    'visibility': visibility,
    'media': <Object>[],
    'reactions': {
      'counts': reactionCounts,
      'total': reactionCounts.values.fold<int>(0, (a, b) => a + b),
      'mine': mine,
    },
    'comments_count': commentsCount,
    'is_saved': isSaved,
    'is_own': isOwn,
    if (isOwn) 'moderation_status': 'visible',
    'edited': false,
    'created_at': DateTime.now().toUtc().subtract(const Duration(hours: 2)).toIso8601String(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };
}

Map<String, dynamic> commentJson({
  String id = 'c1',
  String postId = 'p1',
  String? parentId,
  String content = 'You are not alone in this.',
  String username = 'SoftHarbor',
  bool isOwn = false,
  int repliesCount = 0,
}) => {
  'id': id,
  'post_id': postId,
  'parent_id': parentId,
  'is_removed': false,
  'author': {'id': 'author-$username', 'username': username, 'avatar': 'cloud-sky'},
  'content': content,
  'is_own': isOwn,
  'is_post_author': false,
  'replies_count': ?(parentId == null ? repliesCount : null),
  'edited': false,
  'created_at': DateTime.now().toUtc().subtract(const Duration(minutes: 5)).toIso8601String(),
};

Map<String, dynamic> publicProfileJson({
  String username = 'GentleWillow',
  bool isSelf = false,
  bool isFollowing = false,
  bool isBlocked = false,
  bool canFollow = true,
  int followers = 3,
  String? bio = 'Learning to be kind to myself.',
}) => {
  'id': 'author-$username',
  'username': username,
  'avatar': 'leaf-mint',
  'bio': bio,
  'is_private': false,
  'joined_on': '2026-11-14',
  'stats': {'followers': followers, 'following': 1},
  'relationship': {
    'is_self': isSelf,
    'is_following': isFollowing,
    'follows_you': false,
    'is_blocked': isBlocked,
    'can_follow': canFollow,
  },
};

Map<String, dynamic> memberCardJson(String username, {bool? isFollowing}) => {
  'id': 'author-$username',
  'username': username,
  'avatar': 'cloud-sky',
  'is_following': ?isFollowing,
};

extension CommunityFakes on FakeBackend {
  /// A cursor-paginated success envelope.
  void okPage(String route, List<Object?> items, {String? nextCursor}) => on(
    route,
    (_, _) => jsonBody(200, {
      'success': true,
      'message': 'OK',
      'data': items,
      'meta': {
        'pagination': {
          'per_page': 20,
          'next_cursor': nextCursor,
          'prev_cursor': null,
          'has_more': nextCursor != null,
        },
      },
    }),
  );

  /// Signed-in, set-up member with the given feed.
  void communityHome({List<Object?> posts = const []}) {
    ok('GET /profile', profileJson(setupCompleted: true));
    ok('GET /categories', [
      categoryJson(),
      categoryJson(slug: 'need-support', name: 'Need Support'),
    ]);
    okPage('GET /posts', posts);
  }
}
