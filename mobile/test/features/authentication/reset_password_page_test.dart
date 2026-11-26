import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/authentication/presentation/pages/reset_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_backend.dart';

Future<FakeBackend> pumpReset(WidgetTester tester, {String? token, String? email}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final backend = FakeBackend();
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        httpClientAdapterProvider.overrideWithValue(backend.adapter),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        supportedLocales: AppLocales.supported,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResetPasswordPage(token: token, email: email),
      ),
    ),
  );
  return backend;
}

void main() {
  testWidgets('an incomplete link asks for a new one', (tester) async {
    await pumpReset(tester, token: 'abc');

    expect(find.text('This reset link is incomplete. Please request a new one.'), findsOneWidget);
  });

  testWidgets('sets a new password from a valid link', (tester) async {
    final backend = await pumpReset(tester, token: 'tok', email: 'me@example.com');
    backend.ok('POST /auth/reset-password', null);

    await tester.enterText(find.byType(TextField).at(0), 'new-calm-river-7');
    await tester.enterText(find.byType(TextField).at(1), 'new-calm-river-7');
    await tester.tap(find.text('Save new password'));
    await tester.pumpAndSettle();

    expect(backend.bodiesFor('POST /auth/reset-password').single, {
      'email': 'me@example.com',
      'token': 'tok',
      'password': 'new-calm-river-7',
      'password_confirmation': 'new-calm-river-7',
    });
    expect(find.text('Password updated'), findsOneWidget);
  });

  testWidgets('shows an expired-link error from the server', (tester) async {
    final backend = await pumpReset(tester, token: 'old', email: 'me@example.com');
    backend.on(
      'POST /auth/reset-password',
      (_, _) => validationError({
        'token': ['This reset link is invalid or has expired. Please request a new one.'],
      }),
    );

    await tester.enterText(find.byType(TextField).at(0), 'new-calm-river-7');
    await tester.enterText(find.byType(TextField).at(1), 'new-calm-river-7');
    await tester.tap(find.text('Save new password'));
    await tester.pumpAndSettle();

    expect(
      find.text('This reset link is invalid or has expired. Please request a new one.'),
      findsOneWidget,
    );
  });
}
