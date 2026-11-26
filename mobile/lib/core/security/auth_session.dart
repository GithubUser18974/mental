import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/storage/token_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final authSessionProvider = NotifierProvider<AuthSession, AuthStatus>(AuthSession.new);

/// Renews a stored session that is about to expire and returns the new token, or null if
/// no renewal was needed. Set by the auth feature so this core class doesn't depend on
/// feature code. [AuthSession] stores the returned token itself.
///
/// Receives the CALLER's [Ref]: never capture a provider's own Ref in a long-lived
/// closure — Riverpod disposes unlistened providers and the Ref becomes unusable.
typedef SessionRenewer = Future<({String token, DateTime expiresAt})?> Function(Ref ref);

final sessionRenewerProvider = Provider<SessionRenewer?>((ref) => null);

/// Source of truth for "is the user signed in". Drives the router's auth guard.
class AuthSession extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    unawaited(_restore());
    return AuthStatus.unknown;
  }

  Future<void> _restore() async {
    final token = await ref.read(tokenStorageProvider).readToken();
    if (!ref.mounted) return;
    if (token == null) {
      state = AuthStatus.unauthenticated;
      return;
    }

    state = AuthStatus.authenticated;

    // Best effort: renew tokens close to expiry. Failures other than 401 are ignored
    // (a 401 signs the session out through the HTTP layer).
    final renew = ref.read(sessionRenewerProvider);
    if (renew != null) {
      try {
        final renewed = await renew(ref);
        if (renewed != null && ref.mounted) {
          await signIn(renewed.token, expiresAt: renewed.expiresAt);
        }
      } on Object {
        // Offline etc. — keep the current session.
      }
    }
  }

  Future<void> signIn(String token, {DateTime? expiresAt}) async {
    await ref.read(tokenStorageProvider).writeToken(token, expiresAt: expiresAt);
    state = AuthStatus.authenticated;
  }

  /// Local sign-out: wipes secure storage. Server-side revocation is done by the
  /// auth feature before calling this.
  Future<void> signOut() async {
    await ref.read(tokenStorageProvider).clear();
    state = AuthStatus.unauthenticated;
  }

  /// Called by the HTTP layer when an authenticated request returns 401.
  Future<void> onSessionExpired() async {
    if (state != AuthStatus.authenticated) return;
    await signOut();
  }
}
