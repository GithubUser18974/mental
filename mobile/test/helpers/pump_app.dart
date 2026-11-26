import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/app/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside the app theme + localizations.
  Future<void> pumpApp(
    Widget widget, {
    Locale locale = AppLocales.en,
    ThemeData? theme,
  }) {
    return pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: theme ?? AppTheme.light(),
          locale: locale,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}
