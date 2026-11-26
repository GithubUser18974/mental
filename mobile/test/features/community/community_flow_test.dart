import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/community/presentation/pages/post_composer_page.dart';
import 'package:mindful/features/community/presentation/pages/post_detail_page.dart';

import '../../helpers/community_fixtures.dart';
import '../../helpers/fake_backend.dart';
import '../../helpers/fakes.dart';
import '../../helpers/pump_y_app.dart';

void main() {
  group('feed', () {
    testWidgets('shows posts with the anonymous author, category and disclaimer', (tester) async {
      final backend = FakeBackend()..communityHome(posts: [postJson()]);
      await pumpYApp(tester, backend: backend, token: 'stored');

      expect(find.text('Hi, QuietRiver12'), findsOneWidget);
      expect(find.text('Posts share personal experiences, not medical advice.'), findsOneWidget);
      expect(find.text('GentleWillow'), findsOneWidget);
      expect(find.text('Small win today: I went for a walk.'), findsOneWidget);
      expect(find.textContaining('My Story'), findsWidgets);
    });

    testWidgets('shows a gentle empty state', (tester) async {
      final backend = FakeBackend()..communityHome();
      await pumpYApp(tester, backend: backend, token: 'stored');

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Be the first to share something kind.'), findsOneWidget);
    });

    testWidgets('shows an error with retry', (tester) async {
      final backend = FakeBackend()
        ..communityHome()
        ..on('GET /posts', (_, _) => jsonBody(500, {'success': false, 'message': 'x'}));
      await pumpYApp(tester, backend: backend, token: 'stored');
      expect(find.text('Try again'), findsOneWidget);

      backend.okPage('GET /posts', [postJson()]);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('GentleWillow'), findsOneWidget);
    });

    testWidgets('switches to the following feed and filters by category', (tester) async {
      final backend = FakeBackend()..communityHome();
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.text('Following'));
      await tester.pumpAndSettle();
      expect(find.text('Posts from members you follow will appear here.'), findsOneWidget);

      await tester.tap(find.text('Need Support'));
      await tester.pumpAndSettle();

      final queries = [
        for (final (route, _) in backend.calls)
          if (route == 'GET /posts') route,
      ];
      expect(queries, hasLength(3));
      expect(backend.lastQuery('GET /posts'), {
        'sort': 'recent',
        'following': '1',
        'category': 'need-support',
      });
    });

    testWidgets('loads the next page when scrolling down', (tester) async {
      final backend = FakeBackend()
        ..communityHome()
        ..on('GET /posts', (request, _) {
          final second = request.queryParameters['cursor'] == 'page2';
          return jsonBody(200, {
            'success': true,
            'message': 'OK',
            'data': [
              for (var i = 0; i < 5; i++)
                postJson(id: second ? 'b$i' : 'a$i', content: second ? 'Later $i' : 'Early $i'),
            ],
            'meta': {
              'pagination': {
                'per_page': 5,
                'next_cursor': second ? null : 'page2',
                'prev_cursor': null,
                'has_more': !second,
              },
            },
          });
        });
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.scrollUntilVisible(
        find.text('Later 4'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Later 4'), findsOneWidget);
    });
  });

  group('post card', () {
    testWidgets('blurs content behind its warning until the reader chooses to see it', (
      tester,
    ) async {
      final backend = FakeBackend()
        ..communityHome(
          posts: [postJson(content: 'A hard night', contentWarning: 'suicide')],
        );
      await pumpYApp(tester, backend: backend, token: 'stored');

      expect(find.text('A hard night'), findsNothing);
      expect(find.text('Content warning: Suicide'), findsOneWidget);
      expect(find.textContaining('contact local emergency services'), findsOneWidget);

      await tester.tap(find.text('Show post'));
      await tester.pumpAndSettle();
      expect(find.text('A hard night'), findsOneWidget);
    });

    testWidgets('sends a supportive reaction and updates the count at once', (tester) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..ok('POST /posts/p1/reactions', {
          'counts': {'understand': 0, 'support': 1, 'not_alone': 0, 'proud': 0, 'thank_you': 0},
          'total': 1,
          'mine': 'support',
        });
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.bySemanticsLabel('React'));
      await tester.pumpAndSettle();
      expect(find.text('Send a supportive reaction'), findsOneWidget);
      await tester.tap(find.text('Sending support'));
      await tester.pumpAndSettle();

      expect(backend.bodiesFor('POST /posts/p1/reactions'), [
        {'type': 'support'},
      ]);
      expect(find.text('1 reaction'), findsOneWidget);
      expect(find.bySemanticsLabel('Sending support'), findsOneWidget);
    });

    testWidgets('reverts the reaction if the server refuses it', (tester) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..on(
          'POST /posts/p1/reactions',
          (_, _) => jsonBody(404, {'success': false, 'message': 'x'}),
        );
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.bySemanticsLabel('React'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Proud of you'));
      await tester.pumpAndSettle();

      expect(find.text('1 reaction'), findsNothing);
      expect(find.bySemanticsLabel('React'), findsOneWidget);
    });

    testWidgets('saves a post privately', (tester) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..on('POST /posts/p1/save', (_, _) => jsonBody(204, ''));
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.bySemanticsLabel('Save post'));
      await tester.pumpAndSettle();

      expect(backend.calls.map((c) => c.$1), contains('POST /posts/p1/save'));
      expect(find.bySemanticsLabel('Remove from saved'), findsOneWidget);
    });

    testWidgets('lets me delete my own post after confirming', (tester) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson(isOwn: true, username: 'QuietRiver12')])
        ..on('DELETE /posts/p1', (_, _) => jsonBody(204, ''));
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.byTooltip('Post options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete post'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this post?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(backend.calls.map((c) => c.$1), contains('DELETE /posts/p1'));
      expect(find.text('Small win today: I went for a walk.'), findsNothing);
      expect(find.text('Your post was deleted.'), findsOneWidget);
    });

    testWidgets("offers only reporting on other members' posts", (tester) async {
      final backend = FakeBackend()..communityHome(posts: [postJson()]);
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.byTooltip('Post options'));
      await tester.pumpAndSettle();

      expect(find.text('Report post'), findsOneWidget);
      expect(find.text('Edit post'), findsNothing);
      expect(find.text('Delete post'), findsNothing);
    });
  });

  group('post details and comments', () {
    Future<FakeBackend> openPost(
      WidgetTester tester, {
      Map<String, dynamic>? post,
      List<Object?> comments = const [],
    }) async {
      final json = post ?? postJson(commentsCount: comments.length);
      final backend = FakeBackend()
        ..communityHome(posts: [json])
        ..ok('GET /posts/p1', json)
        ..okPage('GET /posts/p1/comments', comments);
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.text(json['content'] as String));
      await tester.pumpAndSettle();
      expect(find.byType(PostDetailPage), findsOneWidget);
      return backend;
    }

    testWidgets('shows comments and adds a new one', (tester) async {
      final backend = await openPost(tester, comments: [commentJson()]);
      backend.ok(
        'POST /posts/p1/comments',
        commentJson(
          id: 'c2',
          content: 'Sending you strength',
          username: 'QuietRiver12',
          isOwn: true,
        ),
        status: 201,
      );

      expect(find.text('You are not alone in this.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '  Sending you strength  ');
      await tester.tap(find.bySemanticsLabel('Send'));
      await tester.pumpAndSettle();

      expect(backend.bodiesFor('POST /posts/p1/comments'), [
        {'content': 'Sending you strength'},
      ]);
      expect(find.text('Sending you strength'), findsOneWidget);
      // The card's comment count followed (1 → 2).
      expect(find.bySemanticsLabel('2 comments'), findsOneWidget);
    });

    testWidgets('replies to a comment and expands its thread', (tester) async {
      final backend = await openPost(tester, comments: [commentJson(repliesCount: 1)]);
      backend
        ..okPage('GET /comments/c1/replies', [
          commentJson(id: 'r1', parentId: 'c1', content: 'Same here', username: 'CalmSea'),
        ])
        ..ok(
          'POST /posts/p1/comments',
          commentJson(id: 'r2', parentId: 'c1', content: 'Thank you both', isOwn: true),
          status: 201,
        );

      await tester.tap(find.text('View 1 reply'));
      await tester.pumpAndSettle();
      expect(find.text('Same here'), findsOneWidget);

      await tester.tap(find.text('Reply').first);
      await tester.pumpAndSettle();
      expect(find.text('Replying to SoftHarbor'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Thank you both');
      await tester.tap(find.bySemanticsLabel('Send'));
      await tester.pumpAndSettle();

      expect(backend.bodiesFor('POST /posts/p1/comments').single, {
        'content': 'Thank you both',
        'parent_id': 'c1',
      });
      expect(find.text('Thank you both'), findsOneWidget);
      expect(find.text('Replying to SoftHarbor'), findsNothing);
    });

    testWidgets('respects "comments off"', (tester) async {
      await openPost(tester, post: postJson(allowComments: false));

      expect(find.text('Comments are turned off for this post.'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows removed comments as an anonymous placeholder', (tester) async {
      await openPost(
        tester,
        comments: [
          {
            ...commentJson(repliesCount: 1),
            'is_removed': true,
            'author': null,
            'content': null,
          },
        ],
      );

      expect(find.text("This comment isn't available."), findsOneWidget);
      expect(find.text('SoftHarbor'), findsNothing);
    });

    testWidgets('lets me delete my own comment', (tester) async {
      final backend = await openPost(tester, comments: [commentJson(isOwn: true)]);
      backend.on('DELETE /comments/c1', (_, _) => jsonBody(204, ''));

      await tester.tap(find.byTooltip('Comment options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete comment'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(backend.calls.map((c) => c.$1), contains('DELETE /comments/c1'));
      expect(find.text('You are not alone in this.'), findsNothing);
      expect(find.text('No comments yet. Offer a kind word.'), findsOneWidget);
    });

    testWidgets('a deleted or hidden post shows a not-found message', (tester) async {
      final backend = FakeBackend()
        ..communityHome(posts: [postJson()])
        ..on('GET /posts/p1', (_, _) => jsonBody(404, {'success': false, 'message': 'x'}))
        ..okPage('GET /posts/p1/comments', []);
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.tap(find.text('Small win today: I went for a walk.'));
      await tester.pumpAndSettle();

      expect(find.text('Try again'), findsOneWidget);
    });
  });

  group('composer', () {
    Future<FakeBackend> openComposer(WidgetTester tester) async {
      final backend = FakeBackend()..communityHome();
      await pumpYApp(tester, backend: backend, token: 'stored');
      await tester.tap(find.bySemanticsLabel('Create post'));
      await tester.pumpAndSettle();
      expect(find.byType(PostComposerPage), findsOneWidget);
      return backend;
    }

    testWidgets('requires a category and some text before posting', (tester) async {
      final backend = await openComposer(tester);

      await tapVisible(tester, find.text('Share post'));

      expect(find.text('Please choose a category.'), findsOneWidget);
      expect(find.text('Please write something to share.'), findsOneWidget);
      expect(backend.bodiesFor('POST /posts'), isEmpty);
    });

    testWidgets('shares a post with a content warning and returns to the feed', (tester) async {
      final backend = await openComposer(tester);
      backend.ok(
        'POST /posts',
        postJson(id: 'new', content: 'Today was heavy', isOwn: true, contentWarning: 'sensitive'),
        status: 201,
      );

      await tapVisible(tester, find.text('Need Support').last);
      await tester.enterText(find.byType(TextFormField), 'Today was heavy');
      await tapVisible(tester, find.text('Sensitive topic'));
      await tapVisible(tester, find.text('Hide from community'));
      await tapVisible(tester, find.text('Share post'));

      expect(backend.bodiesFor('POST /posts').single, {
        'category': 'need-support',
        'content': 'Today was heavy',
        'content_warning': 'sensitive',
        'allow_comments': true,
        'visibility': 'only_me',
      });
      expect(find.byType(PostComposerPage), findsNothing);
      expect(find.text('Your post has been shared.'), findsOneWidget);
    });

    testWidgets('shows server validation errors under the field', (tester) async {
      final backend = await openComposer(tester);
      backend.on(
        'POST /posts',
        (_, _) => validationError({
          'content': ['Please keep it under 2000 characters.'],
        }),
      );

      await tapVisible(tester, find.text('My Story').last);
      await tester.enterText(find.byType(TextFormField), 'Hello');
      await tapVisible(tester, find.text('Share post'));

      expect(find.text('Please keep it under 2000 characters.'), findsOneWidget);
      expect(find.byType(PostComposerPage), findsOneWidget);
    });
  });

  testWidgets('community renders right-to-left in Arabic', (tester) async {
    final backend = FakeBackend()..communityHome(posts: [postJson(content: 'يوم هادئ')]);
    await pumpYApp(
      tester,
      backend: backend,
      token: 'stored',
      prefs: {PrefKeys.locale: 'ar'},
    );

    expect(find.text('يوم هادئ'), findsOneWidget);
    expect(find.text('المجتمع'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('يوم هادئ'))),
      TextDirection.rtl,
    );
  });
}
