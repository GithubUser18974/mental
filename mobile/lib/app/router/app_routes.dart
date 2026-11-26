/// Route paths. Use these constants — never string literals in widgets.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  /// Deep-link target of the reset email: `/reset-password?token=…&email=…`.
  static const String resetPassword = '/reset-password';

  /// Anonymous profile + privacy setup after registration (FR-ONB-002/003).
  static const String setup = '/setup';

  /// App shell (community tab first).
  static const String home = '/home';

  /// Community (FR-COM-*). Post ids are opaque UUIDs — no content in URLs.
  static const String newPost = '/posts/new';
  static const String postDetail = '/posts/:id';
  static const String editPost = '/posts/:id/edit';

  static String postPath(String id) => '/posts/$id';

  static String editPostPath(String id) => '/posts/$id/edit';

  /// Public profiles by anonymous username (never account ids).
  static const String profile = '/profiles/:username';
  static const String savedPosts = '/saved';
  static const String members = '/members/:kind';
  static const String search = '/search';
  static const String hashtag = '/hashtags/:tag';

  /// Private tracking (FR-TRACK-*). Paths carry opaque entry ids only — never health data.
  static const String trackCheckIn = '/track/check-in';
  static const String trackCheckInEdit = '/track/check-in/:id';
  static const String trackSymptom = '/track/symptom';
  static const String trackSymptomEdit = '/track/symptom/:id';
  static const String trackSleep = '/track/sleep';
  static const String trackSleepEdit = '/track/sleep/:id';
  static const String trackHistory = '/track/history';
  static const String trackInsights = '/track/insights';

  /// Private medications (FR-MED-*). Opaque ids only in paths.
  static const String medicationNew = '/meds/new';
  static const String medicationsPast = '/meds/past';
  static const String medicationDetail = '/meds/:id';
  static const String medicationEdit = '/meds/:id/edit';

  static String medicationPath(String id) => '/meds/$id';

  static String medicationEditPath(String id) => '/meds/$id/edit';

  static String trackCheckInPath(String id) => '/track/check-in/$id';

  static String trackSymptomPath(String id) => '/track/symptom/$id';

  static String trackSleepPath(String id) => '/track/sleep/$id';

  static String profilePath(String username) => '/profiles/${Uri.encodeComponent(username)}';

  static String membersPath(String kind) => '/members/$kind';

  static String hashtagPath(String tag) => '/hashtags/${Uri.encodeComponent(tag)}';

  /// Debug-only design system gallery.
  static const String designShowcase = '/dev/design';

  /// Reachable only while signed out.
  static const Set<String> signedOutOnly = {
    welcome,
    onboarding,
    login,
    register,
    forgotPassword,
    resetPassword,
  };
}
