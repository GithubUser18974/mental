import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/core/storage/token_storage.dart';

import '../../helpers/fakes.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  ProviderContainer containerWith(FakeTokenStorage tokens) {
    final c = ProviderContainer(overrides: [tokenStorageProvider.overrideWithValue(tokens)]);
    addTearDown(c.dispose);
    c.listen(authSessionProvider, (_, _) {}); // kept alive, as by the router
    return c;
  }

  test('starts unknown, then restores authenticated when a token exists', () async {
    final c = containerWith(FakeTokenStorage('t'));
    expect(c.read(authSessionProvider), AuthStatus.unknown);
    await settle();
    expect(c.read(authSessionProvider), AuthStatus.authenticated);
  });

  test('restores unauthenticated without a token', () async {
    final c = containerWith(FakeTokenStorage())..read(authSessionProvider);
    await settle();
    expect(c.read(authSessionProvider), AuthStatus.unauthenticated);
  });

  test('signIn stores the token; signOut wipes secure storage', () async {
    final tokens = FakeTokenStorage();
    final c = containerWith(tokens)..read(authSessionProvider);
    await settle();

    await c.read(authSessionProvider.notifier).signIn('new');
    expect(tokens.token, 'new');
    expect(c.read(authSessionProvider), AuthStatus.authenticated);

    await c.read(authSessionProvider.notifier).signOut();
    expect(tokens.token, isNull);
    expect(tokens.clearCalls, 1);
    expect(c.read(authSessionProvider), AuthStatus.unauthenticated);
  });

  test('session expiry is a no-op when already signed out', () async {
    final tokens = FakeTokenStorage();
    final c = containerWith(tokens)..read(authSessionProvider);
    await settle();

    await c.read(authSessionProvider.notifier).onSessionExpired();
    expect(tokens.clearCalls, 0);
  });
}
