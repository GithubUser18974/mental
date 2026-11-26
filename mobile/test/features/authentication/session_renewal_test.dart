import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/core/storage/token_storage.dart';
import 'package:mindful/features/authentication/presentation/providers/session_renewal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_backend.dart';
import '../../helpers/fakes.dart';

/// Lets the async restore → HTTP → storage chain run (no fixed sleep: the first test also
/// pays JIT warm-up). Polls until [done] or the timeout.
Future<void> settle([bool Function()? done]) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    if (done?.call() ?? false) return;
    if (done == null) return;
  }
}

void main() {
  Future<(FakeBackend, FakeTokenStorage)> start(DateTime? expiresAt) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final backend = FakeBackend()..ok('POST /auth/refresh', tokenJson(token: 'renewed'));
    final tokens = FakeTokenStorage('current', expiresAt);
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        tokenStorageProvider.overrideWithValue(tokens),
        httpClientAdapterProvider.overrideWithValue(backend.adapter),
        sessionRenewerProvider.overrideWithValue(renewSessionIfNeeded),
      ],
    );
    addTearDown(container.dispose);
    // Like the app's router: keep the session provider alive by listening to it.
    container.listen(authSessionProvider, (_, _) {});
    final expectRenewal =
        expiresAt != null && expiresAt.difference(DateTime.now().toUtc()).inDays < 7;
    await settle(expectRenewal ? () => tokens.token == 'renewed' : null);
    if (!expectRenewal) await Future<void>.delayed(const Duration(milliseconds: 300));
    return (backend, tokens);
  }

  test('renews a token that expires within a week', () async {
    final (backend, tokens) = await start(DateTime.now().toUtc().add(const Duration(days: 2)));

    expect(backend.calls.map((c) => c.$1), ['POST /auth/refresh']);
    expect(tokens.token, 'renewed');
    expect(tokens.expiresAt, DateTime.utc(2026, 12, 14, 10));
  });

  test('leaves a fresh token alone', () async {
    final (backend, tokens) = await start(DateTime.now().toUtc().add(const Duration(days: 20)));

    expect(backend.calls, isEmpty);
    expect(tokens.token, 'current');
  });

  test('leaves a token with unknown expiry alone', () async {
    final (backend, _) = await start(null);

    expect(backend.calls, isEmpty);
  });
}
