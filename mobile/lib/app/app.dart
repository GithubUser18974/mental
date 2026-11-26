import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/app/router/app_router.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/app/theme/theme_mode_controller.dart';
import 'package:mindful/core/notifications/local_reminders.dart';

class YApp extends ConsumerWidget {
  const YApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cancels reminders whenever the session ends.
    ref.watch(remindersSessionGuardProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeControllerProvider),
      locale: ref.watch(localeControllerProvider),
      supportedLocales: AppLocales.supported,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
