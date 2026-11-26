import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/dev/design_showcase_page.dart';
import 'package:mindful/app/router/app_redirect.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/splash_page.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:mindful/features/authentication/presentation/pages/login_page.dart';
import 'package:mindful/features/authentication/presentation/pages/register_page.dart';
import 'package:mindful/features/authentication/presentation/pages/reset_password_page.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/pages/members_page.dart';
import 'package:mindful/features/community/presentation/pages/post_composer_page.dart';
import 'package:mindful/features/community/presentation/pages/post_detail_page.dart';
import 'package:mindful/features/community/presentation/pages/post_list_page.dart';
import 'package:mindful/features/community/presentation/pages/public_profile_page.dart';
import 'package:mindful/features/community/presentation/pages/search_page.dart';
import 'package:mindful/features/home/presentation/pages/home_page.dart';
import 'package:mindful/features/onboarding/presentation/pages/onboarding_intro_page.dart';
import 'package:mindful/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:mindful/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:mindful/features/tracking/presentation/pages/check_in_page.dart';
import 'package:mindful/features/tracking/presentation/pages/history_page.dart';
import 'package:mindful/features/tracking/presentation/pages/insights_page.dart';
import 'package:mindful/features/tracking/presentation/pages/sleep_log_page.dart';
import 'package:mindful/features/tracking/presentation/pages/symptom_log_page.dart';

/// Snapshot of what the guard needs; a change triggers GoRouter's redirect.
typedef _GuardState = ({AuthStatus status, SetupStatus setup});

final routerProvider = Provider<GoRouter>((ref) {
  final guard = ValueNotifier<_GuardState>((
    status: ref.read(authSessionProvider),
    setup: ref.read(setupStatusProvider),
  ));

  void update() => guard.value = (
    status: ref.read(authSessionProvider),
    setup: ref.read(setupStatusProvider),
  );

  ref
    ..listen(authSessionProvider, (_, _) => update())
    ..listen(setupStatusProvider, (_, _) => update())
    ..onDispose(guard.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: guard,
    redirect: (context, state) => appRedirect(
      status: guard.value.status,
      setup: guard.value.setup,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingIntroPage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterPage()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, _) => const ForgotPasswordPage()),
      GoRoute(
        path: AppRoutes.resetPassword,
        // Query params come from the emailed link; never logged.
        builder: (_, state) => ResetPasswordPage(
          token: state.uri.queryParameters['token'],
          email: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(path: AppRoutes.setup, builder: (_, _) => const ProfileSetupPage()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      // `/posts/new` before `/posts/:id` so "new" isn't read as an id.
      GoRoute(path: AppRoutes.newPost, builder: (_, _) => const PostComposerPage()),
      GoRoute(
        path: AppRoutes.editPost,
        builder: (_, state) => PostComposerPage(postId: state.pathParameters['id']),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, state) => PublicProfilePage(username: state.pathParameters['username'] ?? ''),
      ),
      GoRoute(path: AppRoutes.savedPosts, builder: (_, _) => const PostListPage.saved()),
      GoRoute(
        path: AppRoutes.members,
        builder: (_, state) => MembersPage(
          kind: MemberListKind.values.firstWhere(
            (k) => k.name == state.pathParameters['kind'],
            orElse: () => MemberListKind.followers,
          ),
        ),
      ),
      GoRoute(path: AppRoutes.search, builder: (_, _) => const SearchPage()),
      GoRoute(path: AppRoutes.trackCheckIn, builder: (_, _) => const CheckInPage()),
      GoRoute(
        path: AppRoutes.trackCheckInEdit,
        builder: (_, state) => CheckInPage(entryId: state.pathParameters['id']),
      ),
      GoRoute(path: AppRoutes.trackSymptom, builder: (_, _) => const SymptomLogPage()),
      GoRoute(
        path: AppRoutes.trackSymptomEdit,
        builder: (_, state) => SymptomLogPage(entryId: state.pathParameters['id']),
      ),
      GoRoute(path: AppRoutes.trackSleep, builder: (_, _) => const SleepLogPage()),
      GoRoute(
        path: AppRoutes.trackSleepEdit,
        builder: (_, state) => SleepLogPage(entryId: state.pathParameters['id']),
      ),
      GoRoute(path: AppRoutes.trackHistory, builder: (_, _) => const HistoryPage()),
      GoRoute(path: AppRoutes.trackInsights, builder: (_, _) => const InsightsPage()),
      GoRoute(
        path: AppRoutes.hashtag,
        builder: (_, state) => PostListPage.hashtag(state.pathParameters['tag'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        builder: (_, state) => PostDetailPage(postId: state.pathParameters['id'] ?? ''),
      ),
      if (kDebugMode)
        GoRoute(path: AppRoutes.designShowcase, builder: (_, _) => const DesignShowcasePage()),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
