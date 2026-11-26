import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/splash_page.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/home/presentation/pages/home_page.dart';
import 'package:mindful/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:mindful/features/profile/presentation/pages/profile_setup_page.dart';

import '../helpers/fake_backend.dart';
import '../helpers/fakes.dart';
import '../helpers/pump_y_app.dart';

void main() {
  testWidgets('signed-out users land on welcome (English, LTR)', (tester) async {
    await pumpYApp(tester);

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.text('A safe space to be heard'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(WelcomePage))), TextDirection.ltr);
  });

  testWidgets('saved Arabic preference renders right-to-left', (tester) async {
    await pumpYApp(tester, prefs: {PrefKeys.locale: 'ar'});

    expect(find.text('مساحة آمنة لتُسمَع'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(WelcomePage))), TextDirection.rtl);
  });

  testWidgets('saved dark mode preference is applied', (tester) async {
    await pumpYApp(tester, prefs: {PrefKeys.themeMode: 'dark'});

    expect(Theme.of(tester.element(find.byType(WelcomePage))).brightness, Brightness.dark);
  });

  testWidgets('a stored session with unfinished setup opens profile setup', (tester) async {
    final backend = FakeBackend()..ok('GET /profile', profileJson());

    await pumpYApp(tester, backend: backend, token: 'stored');

    expect(find.byType(ProfileSetupPage), findsOneWidget);
    expect(find.text('QuietRiver12'), findsOneWidget, reason: 'prefilled generated username');
  });

  testWidgets('a stored, set-up session goes straight home and greets by pseudonym', (
    tester,
  ) async {
    final backend = FakeBackend()
      ..ok('GET /profile', profileJson(setupCompleted: true, username: 'SoftHarbor'));

    await pumpYApp(tester, backend: backend, token: 'stored');

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Hi, SoftHarbor'), findsOneWidget);
  });

  testWidgets('if the profile cannot load, splash offers retry and sign-out', (tester) async {
    final backend = FakeBackend()
      ..on('GET /profile', (_, _) => jsonBody(500, {'success': false, 'message': 'x'}));

    final app = await pumpYApp(tester, backend: backend, token: 'stored');

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('Something went wrong on our side. Please try again later.'), findsOneWidget);

    backend.ok('GET /profile', profileJson(setupCompleted: true));
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(app.tokens.token, 'stored');
  });

  testWidgets('an expired session (401) returns to welcome and wipes the token', (tester) async {
    final backend = FakeBackend()
      ..on('GET /profile', (_, _) => jsonBody(401, {'success': false, 'message': 'x'}));

    final app = await pumpYApp(tester, backend: backend, token: 'expired');

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(app.tokens.token, isNull);
  });

  testWidgets('sign out revokes the token on the server and returns to welcome', (tester) async {
    final backend = FakeBackend()
      ..ok('GET /profile', profileJson(setupCompleted: true))
      ..ok('POST /auth/logout', null);

    final app = await pumpYApp(tester, backend: backend, token: 'stored');
    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(app.tokens.token, isNull);
    expect(backend.calls.map((c) => c.$1), contains('POST /auth/logout'));
  });

  testWidgets('sign out still works offline', (tester) async {
    final backend = FakeBackend()
      ..ok('GET /profile', profileJson(setupCompleted: true))
      ..on('POST /auth/logout', (_, _) => jsonBody(500, {'success': false, 'message': 'x'}));

    final app = await pumpYApp(tester, backend: backend, token: 'stored');
    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(app.tokens.token, isNull);
  });
}
