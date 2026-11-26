import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/storage/preferences.dart';

/// Supported UI locales.
abstract final class AppLocales {
  static const en = Locale('en');
  static const ar = Locale('ar');
  static const List<Locale> supported = [en, ar];
}

/// Language actually in use: the user's choice, else the device language if supported, else English.
/// Sent as `Accept-Language` so the API answers (and sets the initial preference) in the same language.
String effectiveLanguageCode(Locale? chosen) {
  if (chosen != null) return chosen.languageCode;
  final device = PlatformDispatcher.instance.locale.languageCode;
  return AppLocales.supported.any((l) => l.languageCode == device) ? device : 'en';
}

/// User-chosen locale; `null` follows the device language.
final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(sharedPreferencesProvider).getString(PrefKeys.locale);
    return AppLocales.supported.where((l) => l.languageCode == code).firstOrNull;
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(PrefKeys.locale);
    } else {
      await prefs.setString(PrefKeys.locale, locale.languageCode);
    }
  }
}
