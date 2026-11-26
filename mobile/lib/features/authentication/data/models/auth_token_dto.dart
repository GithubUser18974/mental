import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/authentication/domain/entities/account.dart';

part 'auth_token_dto.freezed.dart';
part 'auth_token_dto.g.dart';

@freezed
abstract class AccountDto with _$AccountDto {
  const factory AccountDto({
    required String id,
    required String email,
    required bool emailVerified,
    required String status,
  }) = _AccountDto;

  const AccountDto._();

  factory AccountDto.fromJson(Map<String, dynamic> json) => _$AccountDtoFromJson(json);

  Account toEntity() => Account(id: id, email: email, emailVerified: emailVerified, status: status);
}

@freezed
abstract class AuthTokenDto with _$AuthTokenDto {
  const factory AuthTokenDto({
    required String token,
    required String tokenType,
    required DateTime expiresAt,
    required AccountDto account,
  }) = _AuthTokenDto;

  const AuthTokenDto._();

  factory AuthTokenDto.fromJson(Map<String, dynamic> json) => _$AuthTokenDtoFromJson(json);

  AuthSessionToken toEntity() =>
      AuthSessionToken(token: token, expiresAt: expiresAt.toUtc(), account: account.toEntity());
}
