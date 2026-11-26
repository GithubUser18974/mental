import 'package:mindful/features/authentication/domain/entities/account.dart';

/// Authentication operations. Implementations throw `AppException`s.
abstract interface class AuthRepository {
  Future<AuthSessionToken> register({
    required String email,
    required String password,
    required bool ageConfirmed,
    required bool termsAccepted,
  });

  Future<AuthSessionToken> login({required String email, required String password});

  Future<AuthSessionToken> refresh();

  /// Revokes the current token on the server.
  Future<void> logout();

  /// Always succeeds for a well-formed email (the server never reveals whether it exists).
  Future<void> requestPasswordReset(String email);

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  });
}
