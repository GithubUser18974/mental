import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Router guard (pure, unit-tested). Returns where to go, or `null` to stay.
///
/// - Session restoring → splash.
/// - Signed out → only the signed-out routes (welcome, onboarding, auth forms).
/// - Signed in, profile still loading → splash.
/// - Signed in, setup unfinished → setup only.
/// - Signed in and set up → the app; splash/auth/setup routes go home.
///
/// The debug design showcase is always allowed once the session is known.
String? appRedirect({
  required AuthStatus status,
  required SetupStatus setup,
  required String location,
}) {
  if (location == AppRoutes.designShowcase && status != AuthStatus.unknown) return null;

  final isSplash = location == AppRoutes.splash;
  final isSignedOutRoute = AppRoutes.signedOutOnly.contains(location);
  final isSetup = location == AppRoutes.setup;

  switch (status) {
    case AuthStatus.unknown:
      return isSplash ? null : AppRoutes.splash;

    case AuthStatus.unauthenticated:
      return isSignedOutRoute ? null : AppRoutes.welcome;

    case AuthStatus.authenticated:
      return switch (setup) {
        SetupStatus.unknown => isSplash ? null : AppRoutes.splash,
        SetupStatus.required => isSetup ? null : AppRoutes.setup,
        SetupStatus.completed => (isSplash || isSignedOutRoute || isSetup) ? AppRoutes.home : null,
      };
  }
}
