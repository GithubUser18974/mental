import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/authentication/data/models/auth_token_dto.dart';
import 'package:mindful/features/authentication/domain/entities/account.dart';
import 'package:mindful/features/authentication/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Remote implementation over `/api/v1/auth/*`.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);

  final ApiClient _api;

  /// Shown in "signed in devices" later; never contains personal data.
  static const _deviceName = 'Y mobile app';

  static AuthSessionToken _token(Object? data) =>
      AuthTokenDto.fromJson(ApiData.object(data)).toEntity();

  @override
  Future<AuthSessionToken> register({
    required String email,
    required String password,
    required bool ageConfirmed,
    required bool termsAccepted,
  }) async {
    final envelope = await _api.post(
      '/auth/register',
      authenticated: false,
      parse: _token,
      body: {
        'email': email.trim(),
        'password': password,
        'password_confirmation': password,
        'age_confirmed': ageConfirmed,
        'terms_accepted': termsAccepted,
        'device_name': _deviceName,
      },
    );
    return envelope.data;
  }

  @override
  Future<AuthSessionToken> login({required String email, required String password}) async {
    final envelope = await _api.post(
      '/auth/login',
      authenticated: false,
      parse: _token,
      body: {'email': email.trim(), 'password': password, 'device_name': _deviceName},
    );
    return envelope.data;
  }

  @override
  Future<AuthSessionToken> refresh() async {
    final envelope = await _api.post('/auth/refresh', parse: _token);
    return envelope.data;
  }

  @override
  Future<void> logout() => _api.post<void>('/auth/logout', parse: (_) {});

  @override
  Future<void> requestPasswordReset(String email) => _api.post<void>(
    '/auth/forgot-password',
    authenticated: false,
    parse: (_) {},
    body: {'email': email.trim()},
  );

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  }) => _api.post<void>(
    '/auth/reset-password',
    authenticated: false,
    parse: (_) {},
    body: {
      'email': email.trim(),
      'token': token,
      'password': password,
      'password_confirmation': password,
    },
  );
}
