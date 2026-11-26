import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main()` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden in main()'),
);

/// Non-sensitive preferences only (theme, locale, onboarding seen).
/// Tokens → `TokenStorage`. Health data → never stored unencrypted.
abstract final class PrefKeys {
  static const String locale = 'pref.locale';
  static const String themeMode = 'pref.theme_mode';
  static const String onboardingSeen = 'pref.onboarding_seen';
}
