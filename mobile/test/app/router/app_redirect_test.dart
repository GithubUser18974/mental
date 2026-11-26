import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/router/app_redirect.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

String? go(AuthStatus status, String location, [SetupStatus setup = SetupStatus.unknown]) =>
    appRedirect(status: status, setup: setup, location: location);

void main() {
  const signedIn = AuthStatus.authenticated;
  const signedOut = AuthStatus.unauthenticated;

  test('holds every route on splash while the session restores', () {
    expect(go(AuthStatus.unknown, AppRoutes.home), AppRoutes.splash);
    expect(go(AuthStatus.unknown, AppRoutes.login), AppRoutes.splash);
    expect(go(AuthStatus.unknown, AppRoutes.splash), isNull);
  });

  group('signed out', () {
    test('may use every signed-out route', () {
      for (final route in AppRoutes.signedOutOnly) {
        expect(go(signedOut, route), isNull, reason: route);
      }
    });

    test('is sent to welcome from splash, setup and app routes', () {
      for (final route in [AppRoutes.splash, AppRoutes.setup, AppRoutes.home]) {
        expect(go(signedOut, route), AppRoutes.welcome, reason: route);
      }
    });
  });

  group('signed in', () {
    test('waits on splash until the profile is known', () {
      expect(go(signedIn, AppRoutes.home), AppRoutes.splash);
      expect(go(signedIn, AppRoutes.splash), isNull);
    });

    test('must finish setup before anything else', () {
      for (final route in [AppRoutes.home, AppRoutes.splash, AppRoutes.login, AppRoutes.welcome]) {
        expect(go(signedIn, route, SetupStatus.required), AppRoutes.setup, reason: route);
      }
      expect(go(signedIn, AppRoutes.setup, SetupStatus.required), isNull);
    });

    test('once set up, leaves splash, auth and setup screens for home', () {
      for (final route in [AppRoutes.splash, AppRoutes.setup, ...AppRoutes.signedOutOnly]) {
        expect(go(signedIn, route, SetupStatus.completed), AppRoutes.home, reason: route);
      }
      expect(go(signedIn, AppRoutes.home, SetupStatus.completed), isNull);
    });
  });

  test('debug design showcase is reachable once the session is known', () {
    expect(go(signedOut, AppRoutes.designShowcase), isNull);
    expect(go(signedIn, AppRoutes.designShowcase, SetupStatus.completed), isNull);
    expect(go(AuthStatus.unknown, AppRoutes.designShowcase), AppRoutes.splash);
  });
}
