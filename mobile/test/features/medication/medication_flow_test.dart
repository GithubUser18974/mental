import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/notifications/local_reminders.dart';
import 'package:mindful/features/medication/presentation/pages/medication_detail_page.dart';
import 'package:mindful/features/medication/presentation/pages/medication_form_page.dart';

import '../../helpers/community_fixtures.dart';
import '../../helpers/fake_backend.dart';
import '../../helpers/fakes.dart';
import '../../helpers/medication_fixtures.dart';
import '../../helpers/pump_y_app.dart';

typedef App = ({FakeBackend backend, FakeTokenStorage tokens, FakeLocalReminders reminders});

Future<App> openMeds(
  WidgetTester tester, {
  List<Object?> current = const [],
  List<Object?> doses = const [],
}) async {
  final backend = FakeBackend()
    ..communityHome()
    ..medsHome(current: current, doses: doses);
  final app = await pumpYApp(tester, backend: backend, token: 'stored');
  await tester.tap(find.text('Meds'));
  await tester.pumpAndSettle();
  return app;
}

List<String> routes(FakeBackend b) => [for (final (r, _) in b.calls) r];

Future<void> enterField(WidgetTester tester, String label, String text) async {
  final field = find.ancestor(of: find.text(label), matching: find.byType(Column)).first;
  await tester.enterText(find.descendant(of: field, matching: find.byType(TextFormField)), text);
}

void main() {
  testWidgets('no medication data is fetched until the Meds tab is opened', (tester) async {
    final backend = FakeBackend()
      ..communityHome()
      ..medsHome();
    await pumpYApp(tester, backend: backend, token: 'stored');

    expect(routes(backend).where((r) => r.contains('/medications')), isEmpty);
  });

  testWidgets('shows a caring empty state and the not-medical-advice note', (tester) async {
    await openMeds(tester);

    expect(find.text('Add a medication to keep track of doses and how you feel.'), findsOneWidget);
    expect(find.textContaining('not medical advice'), findsOneWidget);
  });

  testWidgets('adds a medication with a daily schedule and schedules generic reminders', (
    tester,
  ) async {
    final app = await openMeds(tester);
    final soon = DateTime.now().add(const Duration(hours: 2));
    app.backend
      ..ok('POST /medications', medicationJson(), status: 201)
      ..ok('GET /medications/doses', [
        doseJson(at: soon),
        doseJson(at: DateTime.now().subtract(const Duration(hours: 1))), // already past
        doseJson(at: soon.add(const Duration(hours: 1)), reminder: false),
        doseJson(at: soon.add(const Duration(hours: 2)), log: intakeLogJson()),
      ]);

    await tapVisible(tester, find.text('Add medication'));
    expect(find.byType(MedicationFormPage), findsOneWidget);

    await tapVisible(tester, find.text('Save'));
    expect(find.text('Please enter a name.'), findsOneWidget);
    expect(find.text('Use a number, like 50 or 0.5.'), findsOneWidget);

    await enterField(tester, 'Medication name', 'Sertraline');
    await enterField(tester, 'Dosage', '50');
    await tapVisible(tester, find.text('Save'));

    final body = app.backend.bodiesFor('POST /medications').single;
    expect(body['name'], 'Sertraline');
    expect(body['dosage'], '50');
    expect(body['unit'], 'mg');
    expect(body['reminders_enabled'], true);
    expect(body['schedule'], {
      'type': 'daily',
      'times': ['08:00'],
    });

    // Permission asked once reminders matter; only the future, unlogged, reminder-enabled
    // dose is scheduled — with generic text, never the medication name.
    expect(app.reminders.permissionRequests, 1);
    expect(app.reminders.scheduled, hasLength(1));
    expect(app.reminders.scheduled.single.at.isAtSameMomentAs(soon.toUtc()), isTrue);
    expect(app.reminders.body, "It's time for your reminder.");
    expect('${app.reminders.title} ${app.reminders.body}', isNot(contains('Sertraline')));
  });

  testWidgets('weekly schedules need at least one day', (tester) async {
    final app = await openMeds(tester);

    await tapVisible(tester, find.text('Add medication'));
    await enterField(tester, 'Medication name', 'Vitamin D');
    await enterField(tester, 'Dosage', '1');
    await tapVisible(tester, find.text('Some days'));
    await tapVisible(tester, find.text('Save'));

    expect(find.text('Choose at least one day.'), findsOneWidget);
    expect(app.backend.bodiesFor('POST /medications'), isEmpty);
  });

  testWidgets("logs today's dose as taken", (tester) async {
    final eight = DateTime.now().copyWith(hour: 8, minute: 0, second: 0, millisecond: 0);
    final app = await openMeds(
      tester,
      current: [medicationJson()],
      doses: [doseJson(at: eight)],
    );
    app.backend.ok('POST /medications/med1/logs', intakeLogJson(at: eight), status: 201);

    expect(find.text('Sertraline'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();

    final body = app.backend.bodiesFor('POST /medications/med1/logs').single;
    expect(body['status'], 'taken');
    expect(DateTime.parse(body['scheduled_at'] as String).isAtSameMomentAs(eight.toUtc()), isTrue);
    expect(body['taken_at'], isNotNull);
  });

  testWidgets('stopping a medication clears its reminders', (tester) async {
    final app = await openMeds(tester, current: [medicationJson()]);
    app.backend
      ..ok('GET /medications/med1', medicationJson())
      ..okPage('GET /medications/med1/logs', [])
      ..ok('GET /medications/med1/experiences', [])
      ..ok('PUT /medications/med1', medicationJson(status: 'discontinued'));
    app.reminders.scheduled = [
      ReminderSlot(id: 1, at: DateTime.now().add(const Duration(hours: 1))),
    ];

    await tester.tap(find.textContaining('Sertraline'));
    await tester.pumpAndSettle();
    expect(find.byType(MedicationDetailPage), findsOneWidget);

    // After stopping, the server returns no doses for it.
    app.backend.ok('GET /medications/doses', []);
    await tapVisible(tester, find.text('Mark as stopped'));
    await tester.tap(find.text('Mark as stopped').last);
    await tester.pumpAndSettle();

    expect(app.backend.bodiesFor('PUT /medications/med1').single, {'status': 'discontinued'});
    expect(app.reminders.scheduled, isEmpty);
  });

  testWidgets('records a private experience note', (tester) async {
    final app = await openMeds(tester, current: [medicationJson()]);
    app.backend
      ..ok('GET /medications/med1', medicationJson())
      ..okPage('GET /medications/med1/logs', [])
      ..ok('GET /medications/med1/experiences', [])
      ..ok('POST /medications/med1/experiences', {
        'id': 'e1',
        'medication_id': 'med1',
        'kind': 'side_effect',
        'description': 'Dry mouth',
        'observed_on': '2026-11-26',
        'created_at': '2026-11-26T10:00:00Z',
      }, status: 201);

    await tester.tap(find.textContaining('Sertraline'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Add a note'));
    await tester.tap(find.text('Side effect'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Dry mouth');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();

    expect(app.backend.bodiesFor('POST /medications/med1/experiences').single, {
      'kind': 'side_effect',
      'description': 'Dry mouth',
    });
  });

  testWidgets('signing out cancels every scheduled reminder', (tester) async {
    final app = await openMeds(tester);
    app.backend.ok('POST /auth/logout', null);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(app.reminders.cancelAllCalls, greaterThanOrEqualTo(1));
  });

  testWidgets("sends the device's timezone when it differs from the account's", (tester) async {
    final backend = FakeBackend()
      ..communityHome()
      ..ok('PUT /profile/preferences', profileJson(setupCompleted: true));
    await pumpYApp(tester, backend: backend, token: 'stored', deviceTimezone: 'Africa/Cairo');

    expect(backend.bodiesFor('PUT /profile/preferences'), [
      {'timezone': 'Africa/Cairo'},
    ]);
  });
}
