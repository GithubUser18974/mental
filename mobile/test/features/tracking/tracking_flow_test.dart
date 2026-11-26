import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/tracking/presentation/pages/check_in_page.dart';
import 'package:mindful/features/tracking/presentation/pages/history_page.dart';
import 'package:mindful/features/tracking/presentation/pages/track_page.dart';

import '../../helpers/community_fixtures.dart';
import '../../helpers/fake_backend.dart';
import '../../helpers/fakes.dart';
import '../../helpers/pump_y_app.dart';
import '../../helpers/tracking_fixtures.dart';

Future<FakeBackend> openTrack(
  WidgetTester tester, {
  Map<String, dynamic>? latest,
  int streak = 0,
  int total = 0,
  Map<String, Object> prefs = const {},
  List<Map<String, dynamic>> insights = const [],
}) async {
  final backend = FakeBackend()
    ..communityHome()
    ..trackingHome(latest: latest, streak: streak, total: total)
    ..ok('GET /tracking/insights', insightsJson(items: insights));
  await pumpYApp(tester, backend: backend, token: 'stored', prefs: prefs);
  await tester.tap(find.text(prefs.isEmpty ? 'Track' : 'متابعتي'));
  await tester.pumpAndSettle();
  return backend;
}

List<String> routes(FakeBackend backend) => [for (final (r, _) in backend.calls) r];

/// The Track list builds lazily: scroll until [finder] exists, then tap it.
Future<void> scrollTrackTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find
        .descendant(of: find.byType(TrackPage), matching: find.byType(Scrollable))
        .first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('no private health data is fetched until the Track tab is opened', (tester) async {
    final backend = FakeBackend()
      ..communityHome()
      ..trackingHome();
    await pumpYApp(tester, backend: backend, token: 'stored');

    expect(routes(backend).where((r) => r.contains('/tracking')), isEmpty);
  });

  testWidgets('Track tab invites a first check-in and shows it is private', (tester) async {
    await openTrack(tester);

    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(
      find.text("Only you can see this. It's never shared with the community."),
      findsOneWidget,
    );
    expect(find.text('Check in'), findsOneWidget);
    expect(find.text('No streak yet'), findsOneWidget);
  });

  testWidgets('shows the latest check-in, streak and 7-day averages', (tester) async {
    await openTrack(tester, latest: moodJson(), streak: 3, total: 5);

    expect(find.text('Latest: Good'), findsOneWidget);
    expect(find.text('3-day streak'), findsOneWidget);
    expect(find.text('5 check-ins'), findsOneWidget);
    expect(find.text('7.5 h'), findsOneWidget);
    expect(find.text('Add another check-in'), findsOneWidget);
  });

  testWidgets('a check-in needs a mood, keeps skipped scales empty, and saves', (tester) async {
    final backend = await openTrack(tester);
    backend.ok('POST /tracking/moods', moodJson(score: 5), status: 201);

    await tapVisible(tester, find.text('Check in'));
    expect(find.byType(CheckInPage), findsOneWidget);

    await tapVisible(tester, find.text('Save'));
    expect(find.text('Please choose how you feel.'), findsOneWidget);
    expect(backend.bodiesFor('POST /tracking/moods'), isEmpty);

    await tapVisible(tester, find.bySemanticsLabel('Good'));
    // Rate the mood score only (the slider starts at 5).
    await tapVisible(tester, find.text('Add').first);
    await tester.enterText(find.byType(TextFormField), '  Calm evening  ');
    await tapVisible(tester, find.text('Save'));

    expect(backend.bodiesFor('POST /tracking/moods').single, {
      'mood': 'good',
      'score': 5,
      'anxiety': null,
      'stress': null,
      'energy': null,
      'notes': 'Calm evening',
    });
    expect(find.byType(CheckInPage), findsNothing);
    expect(find.text('Saved.'), findsOneWidget);
    // The overview reloads after saving.
    expect(routes(backend).where((r) => r == 'GET /tracking/overview').length, greaterThan(1));
  });

  testWidgets('logs a symptom with severity and duration', (tester) async {
    final backend = await openTrack(tester);
    backend.ok('POST /tracking/symptoms', symptomJson(), status: 201);

    await tapVisible(tester, find.text('Log a symptom'));
    await tapVisible(tester, find.text('Save'));
    expect(find.text('Please choose a symptom.'), findsOneWidget);

    await tapVisible(tester, find.text('Restlessness'));
    await tapVisible(tester, find.text('30 min'));
    await tapVisible(tester, find.text('Save'));

    expect(backend.bodiesFor('POST /tracking/symptoms').single, {
      'category': 'restlessness',
      'severity': 5,
      'duration_minutes': 30,
      'notes': null,
    });
  });

  testWidgets('logs sleep (7 hours by default, quality optional)', (tester) async {
    final backend = await openTrack(tester);
    backend.ok('POST /tracking/sleep', sleepJson(minutes: 420, quality: null), status: 201);

    await tapVisible(tester, find.text('Log sleep'));
    expect(find.text('7 hours'), findsOneWidget);
    await tapVisible(tester, find.text('Save'));

    expect(backend.bodiesFor('POST /tracking/sleep').single, {
      'duration_minutes': 420,
      'quality': null,
    });
  });

  testWidgets('history shows the month, opens an entry, and deletes it after confirming', (
    tester,
  ) async {
    final backend = await openTrack(tester, latest: moodJson(), total: 1);
    final now = DateTime.now();
    backend
      ..okPage('GET /tracking/moods', [
        moodJson(notes: 'Walked by the river', recordedAt: now.toUtc().toIso8601String()),
      ])
      ..okPage('GET /tracking/symptoms', [symptomJson()])
      ..okPage('GET /tracking/sleep', [sleepJson()])
      ..ok('GET /tracking/moods/m1', moodJson(notes: 'Walked by the river'))
      ..on('DELETE /tracking/moods/m1', (_, _) => jsonBody(204, ''));

    await scrollTrackTo(tester, find.text('See history'));
    expect(find.byType(HistoryPage), findsOneWidget);

    final query = backend.lastQuery('GET /tracking/moods')!;
    final monthStart = DateTime(now.year, now.month);
    expect(query['from'], monthStart.toIso8601String().substring(0, 10));
    expect(query['per_page'], '100');
    expect(find.textContaining('Walked by the river'), findsOneWidget);

    await tester.tap(find.text('Symptoms'));
    await tester.pumpAndSettle();
    expect(find.text('Severity 6/10'), findsOneWidget);

    await tester.tap(find.text('Moods'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.textContaining('Walked by the river'));
    expect(find.text('Edit check-in'), findsOneWidget);

    await tapVisible(tester, find.text('Delete entry'));
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(routes(backend), contains('DELETE /tracking/moods/m1'));
    expect(find.text('Entry deleted.'), findsOneWidget);
  });

  testWidgets('insights show non-diagnostic observations with the disclaimer', (tester) async {
    await openTrack(
      tester,
      insights: [
        {
          'key': 'mood_trend_up',
          'kind': 'observation',
          'text': 'Your mood scores were a little higher.',
        },
        {
          'key': 'milestone_streak',
          'kind': 'milestone',
          'text': "You've checked in 7 days in a row.",
        },
      ],
    );

    await scrollTrackTo(tester, find.text('Insights'));
    await tester.pumpAndSettle();

    expect(find.text('Your mood scores were a little higher.'), findsOneWidget);
    expect(find.text("You've checked in 7 days in a row."), findsOneWidget);
    expect(find.text('These observations are based only on what you recorded.'), findsOneWidget);
  });

  testWidgets('Track tab renders right-to-left in Arabic', (tester) async {
    await openTrack(tester, prefs: {PrefKeys.locale: 'ar'});

    expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('كيف تشعر اليوم؟'))),
      TextDirection.rtl,
    );
  });
}
