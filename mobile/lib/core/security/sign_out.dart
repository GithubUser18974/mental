import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/security/auth_session.dart';

/// Revokes the current token on the server. Provided by the auth feature in `main()`
/// so any screen can sign out without depending on feature internals. Receives the
/// caller's [Ref] (see `SessionRenewer` for why).
typedef ServerLogout = Future<void> Function(Ref ref);

final serverLogoutProvider = Provider<ServerLogout?>((ref) => null);

final NotifierProvider<SignOutController, AsyncValue<void>> signOutControllerProvider =
    NotifierProvider.autoDispose<SignOutController, AsyncValue<void>>(SignOutController.new);

class SignOutController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Server revocation is best effort; the device is always cleared.
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(serverLogoutProvider)?.call(ref);
    } on Object {
      // Offline or already expired: still sign out locally.
    }
    await ref.read(authSessionProvider.notifier).signOut();
    if (ref.mounted) state = const AsyncData(null);
  }
}
