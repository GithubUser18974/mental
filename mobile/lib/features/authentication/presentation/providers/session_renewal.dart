import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/storage/token_storage.dart';
import 'package:mindful/features/authentication/data/repositories/auth_repository_impl.dart';

/// Renew the token when it has less than this left (server default lifetime: 30 days).
const Duration renewWhenExpiringWithin = Duration(days: 7);

/// Plugged into `sessionRenewerProvider` (see `provider_overrides.dart`): on app start,
/// swaps a token that is close to expiry for a fresh one so active users aren't signed
/// out unexpectedly. Returns the new token (the session stores it) or null.
Future<({String token, DateTime expiresAt})?> renewSessionIfNeeded(Ref ref) async {
  final expiresAt = await ref.read(tokenStorageProvider).readExpiresAt();
  if (expiresAt == null) return null;
  if (expiresAt.difference(DateTime.now().toUtc()) > renewWhenExpiringWithin) return null;

  final renewed = await ref.read(authRepositoryProvider).refresh();
  return (token: renewed.token, expiresAt: renewed.expiresAt);
}
