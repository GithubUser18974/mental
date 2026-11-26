import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/features/community/presentation/pages/public_profile_page.dart';
import 'package:mindful/features/community/presentation/pages/search_page.dart';

import '../../helpers/community_fixtures.dart';
import '../../helpers/fake_backend.dart';
import '../../helpers/fakes.dart';
import '../../helpers/pump_y_app.dart';

void main() {
  group('reporting', () {
    Future<FakeBackend> openReport(WidgetTester tester, {bool crisis = false}) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..ok(
          'POST /reports',
          {
            'id': 'r1',
            'target_type': 'post',
            'target_id': 'p1',
            'reason': 'spam',
            'status': 'open',
            'crisis_support': crisis,
            'created_at': '2026-11-26T10:00:00Z',
          },
          status: 201,
          message: 'Thank you for letting us know. Our moderators will review this.',
        );
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.byTooltip('Post options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report post'));
      await tester.pumpAndSettle();
      expect(find.text("What's wrong?"), findsOneWidget);
      return backend;
    }

    testWidgets('reports a post anonymously and thanks the reporter', (tester) async {
      final backend = await openReport(tester);

      await tester.tap(find.text('Spam'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();

      expect(backend.bodiesFor('POST /reports').single, {
        'target_type': 'post',
        'target_id': 'p1',
        'reason': 'spam',
      });
      expect(
        find.text('Thank you for letting us know. Our moderators will review this.'),
        findsOneWidget,
      );
    });

    testWidgets('offers crisis support after a suicide-risk report', (tester) async {
      await openReport(tester, crisis: true);

      await tester.tap(find.text('Someone may be at risk of suicide'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();

      expect(find.text('Thank you for looking out for someone'), findsOneWidget);
      expect(find.textContaining('contact local emergency services'), findsOneWidget);
    });

    testWidgets('"Something else" needs a description', (tester) async {
      final backend = await openReport(tester);

      await tester.tap(find.text('Something else'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(find.text('Please describe the problem.'), findsOneWidget);
      expect(backend.bodiesFor('POST /reports'), isEmpty);

      await tester.enterText(find.byType(TextField).last, 'Selling things');
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(backend.bodiesFor('POST /reports').single['details'], 'Selling things');
    });
  });

  group('public profile', () {
    Future<FakeBackend> openProfile(WidgetTester tester, Map<String, dynamic> profile) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..ok('GET /profiles/GentleWillow', profile)
        ..okPage('GET /profiles/GentleWillow/posts', [postJson(id: 'p9', content: 'Their post')]);
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.text('GentleWillow'));
      await tester.pumpAndSettle();
      expect(find.byType(PublicProfilePage), findsOneWidget);
      return backend;
    }

    testWidgets('shows the anonymous profile, stats and posts, and follows', (tester) async {
      final backend = await openProfile(tester, publicProfileJson());
      backend.on('POST /profiles/author-GentleWillow/follow', (_, _) => jsonBody(204, ''));

      expect(find.text('Learning to be kind to myself.'), findsOneWidget);
      expect(find.textContaining('3 followers'), findsOneWidget);
      expect(find.text('Their post'), findsOneWidget);

      backend.ok(
        'GET /profiles/GentleWillow',
        publicProfileJson(isFollowing: true, canFollow: false, followers: 4),
      );
      await tapVisible(tester, find.text('Follow'));

      expect(backend.calls.map((c) => c.$1), contains('POST /profiles/author-GentleWillow/follow'));
      expect(find.textContaining('4 followers'), findsOneWidget);
      expect(find.text('Following'), findsWidgets);
    });

    testWidgets('blocks after confirming, then hides their posts', (tester) async {
      final backend = await openProfile(tester, publicProfileJson());
      backend.on('POST /profiles/author-GentleWillow/block', (_, _) => jsonBody(204, ''));

      await tester.tap(find.byTooltip('Profile options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Block member'));
      await tester.pumpAndSettle();
      expect(find.text('Block GentleWillow?'), findsOneWidget);

      backend.ok(
        'GET /profiles/GentleWillow',
        publicProfileJson(isBlocked: true, canFollow: false, bio: null),
      );
      await tester.tap(find.text('Block member').last);
      await tester.pumpAndSettle();

      expect(backend.calls.map((c) => c.$1), contains('POST /profiles/author-GentleWillow/block'));
      expect(find.textContaining('You blocked this member'), findsOneWidget);
      expect(find.text('Their post'), findsNothing);
      expect(find.text('Unblock'), findsOneWidget);
    });

    testWidgets('my own profile has no follow or block actions', (tester) async {
      await openProfile(tester, publicProfileJson(isSelf: true, canFollow: false));

      expect(find.text('This is how others see your profile.'), findsOneWidget);
      expect(find.text('Follow'), findsNothing);
      expect(find.byTooltip('Profile options'), findsNothing);
    });
  });

  group('me tab', () {
    Future<FakeBackend> openMe(WidgetTester tester) async {
      final backend = FakeBackend()..communityHome();
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.text('Me'));
      await tester.pumpAndSettle();
      return backend;
    }

    testWidgets('lists my saved posts privately', (tester) async {
      final backend = await openMe(tester);
      backend.okPage('GET /saved-posts', [postJson(content: 'Kept for later', isSaved: true)]);

      await tester.tap(find.text('Saved posts'));
      await tester.pumpAndSettle();

      expect(find.text('Kept for later'), findsOneWidget);
    });

    testWidgets('unblocks a member from the blocked list', (tester) async {
      final backend = await openMe(tester);
      backend
        ..okPage('GET /profile/blocks', [memberCardJson('LoudStorm')])
        ..on('DELETE /profiles/author-LoudStorm/block', (_, _) => jsonBody(204, ''));

      await tester.tap(find.text('Blocked members'));
      await tester.pumpAndSettle();
      expect(find.text('LoudStorm'), findsOneWidget);

      backend.okPage('GET /profile/blocks', []);
      await tester.tap(find.text('Unblock'));
      await tester.pumpAndSettle();

      expect(backend.calls.map((c) => c.$1), contains('DELETE /profiles/author-LoudStorm/block'));
      expect(find.text("You haven't blocked anyone."), findsOneWidget);
    });

    testWidgets('shows followers with an empty state', (tester) async {
      final backend = await openMe(tester);
      backend.okPage('GET /profile/followers', []);

      await tester.tap(find.text('Followers'));
      await tester.pumpAndSettle();

      expect(find.text('No followers yet.'), findsOneWidget);
    });
  });

  group('search & discovery', () {
    Future<FakeBackend> openSearch(WidgetTester tester) async {
      final backend = FakeBackend()
        ..communityHome()
        ..ok('GET /hashtags/trending', [
          {'name': 'gratitude', 'posts_count': 4},
        ]);
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.bySemanticsLabel('Search'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      return backend;
    }

    testWidgets('shows trending hashtags and opens a hashtag feed', (tester) async {
      final backend = await openSearch(tester);
      backend.okPage('GET /posts', [postJson(content: 'Thankful today #gratitude')]);

      expect(find.text('Trending this week'), findsOneWidget);
      await tester.tap(find.text('gratitude'));
      await tester.pumpAndSettle();

      expect(find.text('#gratitude'), findsOneWidget);
      expect(backend.lastQuery('GET /posts'), {'hashtag': 'gratitude'});
    });

    testWidgets('searches posts, then people', (tester) async {
      final backend = await openSearch(tester);
      backend
        ..okPage('GET /posts', [postJson(content: 'Evenings are hard')])
        ..ok('GET /search/profiles', [memberCardJson('CalmSea', isFollowing: false)]);

      await tester.enterText(find.byType(TextField), 'evening');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Evenings are hard'), findsOneWidget);
      expect(backend.lastQuery('GET /posts'), {'q': 'evening'});

      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();
      expect(find.text('CalmSea'), findsOneWidget);
      expect(backend.lastQuery('GET /search/profiles'), {'q': 'evening'});
    });

    testWidgets('asks for at least 2 characters', (tester) async {
      await openSearch(tester);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Type at least 2 characters.'), findsOneWidget);
    });
  });
}
