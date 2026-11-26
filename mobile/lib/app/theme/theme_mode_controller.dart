import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/storage/preferences.dart';

final themeModeControllerProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

/// Light / dark / system appearance, persisted as a non-sensitive preference.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final name = ref.read(sharedPreferencesProvider).getString(PrefKeys.themeMode);
    return ThemeMode.values.where((m) => m.name == name).firstOrNull ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(PrefKeys.themeMode, mode.name);
  }
}
