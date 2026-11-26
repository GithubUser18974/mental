import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/authentication/presentation/pages/login_page.dart';
import 'package:mindful/features/authentication/presentation/pages/register_page.dart';
import 'package:mindful/features/home/presentation/pages/home_page.dart';
import 'package:mindful/features/onboarding/presentation/pages/onboarding_intro_page.dart';
import 'package:mindful/features/profile/presentation/pages/profile_setup_page.dart';

import '../../helpers/fake_backend.dart';
import '../../helpers/pump_y_app.dart';

Future<void> enter(WidgetTester tester, String label, String text) async {
  final field = find.ancestor(of: find.text(label), matching: find.byType(Column)).first;
  await tester.enterText(find.descendant(of: field, matching: find.byType(TextField)), text);
}

void main() {
  group('onboarding intro', () {
    testWidgets('walks through all five pages to registration and is shown only once', (
      tester,
    ) async {
      final app = await pumpYApp(tester);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingIntroPage), findsOneWidget);

      for (final title in [
        'A gentle space for your mind',
        "You're anonymous here",
        "Notice how you're doing",
        'Your data stays yours',
      ]) {
        expect(find.text(title), findsOneWidget);
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
      expect(find.text('Kindness first'), findsOneWidget);
      await tester.tap(find.text('Create my space'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
      expect(app.backend.calls, isEmpty);
    });

    testWidgets('skips the intro when it was already seen', (tester) async {
      await pumpYApp(tester, prefs: {PrefKeys.onboardingSeen: true});

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });

  group('registration', () {
    Future<void> openRegister(WidgetTester tester, FakeBackend backend) async {
      await pumpYApp(tester, backend: backend, prefs: {PrefKeys.onboardingSeen: true});
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
    }

    testWidgets('validates on device before calling the API', (tester) async {
      final backend = FakeBackend();
      await openRegister(tester, backend);

      await enter(tester, 'Email', 'not-an-email');
      await enter(tester, 'Password', 'short');
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address.'), findsOneWidget);
      expect(
        find.text('Use at least 10 characters, including letters and numbers.'),
        findsOneWidget,
      );
      expect(find.text('You must be 18 or older to use Y.'), findsOneWidget);
      expect(find.text('Please accept to continue.'), findsOneWidget);
      expect(backend.calls, isEmpty);
    });

    testWidgets('creates the account with explicit consents, then opens profile setup', (
      tester,
    ) async {
      final backend = FakeBackend()
        ..ok('POST /auth/register', tokenJson(), status: 201)
        ..ok('GET /profile', profileJson());
      await openRegister(tester, backend);

      await enter(tester, 'Email', 'me@example.com');
      await enter(tester, 'Password', 'calm-river-42');
      await enter(tester, 'Confirm password', 'calm-river-42');
      await tapVisible(tester, find.text('I am 18 years or older'));
      await tapVisible(tester, find.text('I accept the Terms of Use and the Privacy Policy'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      final sent = backend.bodiesFor('POST /auth/register').single;
      expect(sent['email'], 'me@example.com');
      expect(sent['age_confirmed'], isTrue);
      expect(sent['terms_accepted'], isTrue);
      expect(sent['password_confirmation'], sent['password']);
      expect(find.byType(ProfileSetupPage), findsOneWidget);
    });

    testWidgets('shows server validation errors under the right field', (tester) async {
      final backend = FakeBackend()
        ..on(
          'POST /auth/register',
          (_, _) => validationError({
            'email': ['The email has already been taken.'],
          }),
        );
      await openRegister(tester, backend);

      await enter(tester, 'Email', 'taken@example.com');
      await enter(tester, 'Password', 'calm-river-42');
      await enter(tester, 'Confirm password', 'calm-river-42');
      await tapVisible(tester, find.text('I am 18 years or older'));
      await tapVisible(tester, find.text('I accept the Terms of Use and the Privacy Policy'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('The email has already been taken.'), findsOneWidget);
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });

  group('sign in', () {
    Future<void> openLogin(WidgetTester tester, FakeBackend backend) async {
      await pumpYApp(tester, backend: backend);
      await tester.tap(find.text('I already have an account'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    }

    testWidgets('signs in and goes home when setup is done', (tester) async {
      final backend = FakeBackend()
        ..ok('POST /auth/login', tokenJson(token: 'fresh'))
        ..ok('GET /profile', profileJson(setupCompleted: true, username: 'SoftHarbor'));
      await openLogin(tester, backend);

      await enter(tester, 'Email', ' Me@Example.com ');
      await enter(tester, 'Password', 'calm-river-42');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(backend.bodiesFor('POST /auth/login').single['email'], 'Me@Example.com');
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('shows the generic credentials error from the server', (tester) async {
      final backend = FakeBackend()
        ..on(
          'POST /auth/login',
          (_, _) => validationError({
            'email': ['The email or password is incorrect.'],
          }),
        );
      await openLogin(tester, backend);

      await enter(tester, 'Email', 'me@example.com');
      await enter(tester, 'Password', 'wrong-pass-1');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('The email or password is incorrect.'), findsOneWidget);
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });

  group('password recovery', () {
    testWidgets('confirms without revealing whether the account exists', (tester) async {
      final backend = FakeBackend()..ok('POST /auth/forgot-password', null);
      await pumpYApp(tester, backend: backend);
      await tester.tap(find.text('I already have an account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      await enter(tester, 'Email', 'someone@example.com');
      await tester.tap(find.text('Send reset link'));
      await tester.pumpAndSettle();

      expect(find.text('Check your email'), findsOneWidget);
      expect(find.textContaining('If an account exists for someone@example.com'), findsOneWidget);
    });
  });

  group('profile setup', () {
    testWidgets('saves privacy then profile, completing setup and opening home', (tester) async {
      final backend = FakeBackend()
        ..ok('GET /profile', profileJson())
        ..ok('PUT /profile/privacy', profileJson(visibility: 'private'))
        ..ok(
          'PUT /profile',
          profileJson(setupCompleted: true, username: 'SoftHarbor', visibility: 'private'),
        )
        ..ok('GET /profile/username-availability', {
          'username': 'SoftHarbor',
          'available': true,
          'reason': null,
        });
      await pumpYApp(tester, backend: backend, token: 'stored');
      expect(find.byType(ProfileSetupPage), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'QuietRiver12'), 'SoftHarbor');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Your privacy'), findsOneWidget);

      await tapVisible(tester, find.text('Private'));
      await tester.pump();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      final order = backend.calls.map((c) => c.$1).where((r) => r.startsWith('PUT')).toList();
      expect(order, ['PUT /profile/privacy', 'PUT /profile']);
      expect(backend.bodiesFor('PUT /profile/privacy').single['profile_visibility'], 'private');
      expect(backend.bodiesFor('PUT /profile/privacy').single['analytics_consent'], isFalse);
      expect(backend.bodiesFor('PUT /profile').single['username'], 'SoftHarbor');
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('blocks continuing with a taken username', (tester) async {
      final backend = FakeBackend()
        ..ok('GET /profile', profileJson())
        ..ok('GET /profile/username-availability', {
          'username': 'TakenName',
          'available': false,
          'reason': 'taken',
        });
      await pumpYApp(tester, backend: backend, token: 'stored');

      await tester.enterText(find.widgetWithText(TextField, 'QuietRiver12'), 'TakenName');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Already taken'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text("How you'll appear"), findsOneWidget);
    });
  });
}
