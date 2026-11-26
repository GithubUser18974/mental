import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mindful/app/localization/generated/app_localizations_en.dart';
import 'package:mindful/features/community/data/models/community_dtos.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';

import '../../helpers/community_fixtures.dart';

void main() {
  group('ReactionSummary.withMine (optimistic update)', () {
    const none = ReactionSummary(counts: {ReactionType.support: 2}, total: 2);

    test('adds my reaction', () {
      final next = none.withMine(ReactionType.proud);
      expect(next.mine, ReactionType.proud);
      expect(next.countOf(ReactionType.proud), 1);
      expect(next.total, 3);
    });

    test('switching moves my single reaction', () {
      final mine = none.withMine(ReactionType.proud).withMine(ReactionType.support);
      expect(mine.countOf(ReactionType.proud), 0);
      expect(mine.countOf(ReactionType.support), 3);
      expect(mine.total, 3);
    });

    test('removing takes it away', () {
      final removed = none.withMine(ReactionType.proud).withMine(null);
      expect(removed.mine, isNull);
      expect(removed.total, 2);
    });
  });

  group('PostDto', () {
    test('parses a verbatim API response (contract check)', () {
      // Captured from GET /api/v1/posts — keep in sync with the backend PostResource.
      final json =
          jsonDecode('''
        {"id": "01a2179f-36cd-72ad-821c-b1b4584257c3",
         "author": {"id": "01a2179e-bf42-73ef-82ba-100116df9bf9", "username": "CalmSea", "avatar": "wave-sky"},
         "category": {"slug": "daily-thoughts", "name": "Daily Thoughts", "description": "Sharing daily feelings", "icon": "wb_sunny"},
         "content": "Evenings are the hardest #sleep", "hashtags": ["sleep"], "content_warning": null,
         "allow_comments": true, "visibility": "community", "media": [],
         "reactions": {"counts": {"understand": 0, "support": 0, "not_alone": 0, "proud": 0, "thank_you": 1}, "total": 1, "mine": null},
         "comments_count": 0, "is_saved": false, "is_own": false, "edited": false,
         "created_at": "2026-11-26T11:30:39Z", "updated_at": "2026-11-26T11:30:39Z"}
      ''')
              as Map<String, dynamic>;

      final post = PostDto.fromJson(json).toEntity();

      expect(post.category.slug, 'daily-thoughts');
      expect(post.reactions.countOf(ReactionType.thankYou), 1);
      expect(post.hashtags, ['sleep']);
    });

    test('maps the API post, ignoring unknown reaction types', () {
      final json = postJson(counts: {'support': 2}, mine: 'support', contentWarning: 'self_harm')
        ..['reactions'] = {
          'counts': {'support': 2, 'like': 9},
          'total': 2,
          'mine': 'support',
        };

      final post = PostDto.fromJson(json).toEntity();

      expect(post.author.username, 'GentleWillow');
      expect(post.reactions.countOf(ReactionType.support), 2);
      expect(post.reactions.counts, hasLength(1));
      expect(post.reactions.mine, ReactionType.support);
      expect(post.contentWarning, ContentWarning.selfHarm);
      expect(post.visibility, PostVisibility.community);
      expect(post.createdAt.isUtc, isTrue);
    });

    test('maps a removed comment placeholder', () {
      final comment = CommentDto.fromJson({
        ...commentJson(repliesCount: 2),
        'is_removed': true,
        'author': null,
        'content': null,
      }).toEntity();

      expect(comment.isRemoved, isTrue);
      expect(comment.author, isNull);
      expect(comment.repliesCount, 2);
      expect(comment.isTopLevel, isTrue);
    });
  });

  test('relativeTime', () async {
    // In the app the Material localization delegates load date symbols.
    await initializeDateFormatting('en');
    final l10n = AppLocalizationsEn();
    final now = DateTime.utc(2026, 11, 26, 12);

    expect(relativeTime(now.subtract(const Duration(seconds: 20)), l10n, now: now), 'just now');
    expect(relativeTime(now.subtract(const Duration(minutes: 5)), l10n, now: now), '5m');
    expect(relativeTime(now.subtract(const Duration(hours: 3)), l10n, now: now), '3h');
    expect(relativeTime(now.subtract(const Duration(days: 2)), l10n, now: now), '2d');
    expect(relativeTime(DateTime.utc(2026, 10, 3, 12), l10n, now: now), 'Oct 3, 2026');
  });
}
