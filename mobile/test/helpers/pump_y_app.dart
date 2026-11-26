import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/app.dart';
import 'package:mindful/app/provider_overrides.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_backend.dart';
import 'fakes.dart';

/// Boots the real app (router, theme, l10n, providers) against a [FakeBackend].
Future<({FakeBackend backend, FakeTokenStorage tokens})> pumpYApp(
  WidgetTester tester, {
  FakeBackend? backend,
  String? token,
  DateTime? expiresAt,
  Map<String, Object> prefs = const {},
}) async {
  usePhoneViewport(tester);
  SharedPreferences.setMockInitialValues(prefs);
  final sharedPrefs = await SharedPreferences.getInstance();
  final fake = backend ?? FakeBackend();
  final tokens = FakeTokenStorage(token, expiresAt);

  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        ...appProviderOverrides(sharedPrefs),
        tokenStorageProvider.overrideWithValue(tokens),
        httpClientAdapterProvider.overrideWithValue(fake.adapter),
      ],
      child: const YApp(),
    ),
  );
  await tester.pumpAndSettle();

  return (backend: fake, tokens: tokens);
}

/// A typical phone (Pixel-class, 411×891 logical px) instead of the 800×600 default.
void usePhoneViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1080, 2340)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

/// Scrolls [finder] into view (forms scroll under pinned buttons), then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
