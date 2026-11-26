// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AccountDto', json, ($checkedConvert) {
      final val = _AccountDto(
        id: $checkedConvert('id', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        emailVerified: $checkedConvert('email_verified', (v) => v as bool),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'emailVerified': 'email_verified'});

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'email_verified': instance.emailVerified,
  'status': instance.status,
};

_AuthTokenDto _$AuthTokenDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_AuthTokenDto',
  json,
  ($checkedConvert) {
    final val = _AuthTokenDto(
      token: $checkedConvert('token', (v) => v as String),
      tokenType: $checkedConvert('token_type', (v) => v as String),
      expiresAt: $checkedConvert(
        'expires_at',
        (v) => DateTime.parse(v as String),
      ),
      account: $checkedConvert(
        'account',
        (v) => AccountDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'tokenType': 'token_type', 'expiresAt': 'expires_at'},
);

Map<String, dynamic> _$AuthTokenDtoToJson(_AuthTokenDto instance) => <String, dynamic>{
  'token': instance.token,
  'token_type': instance.tokenType,
  'expires_at': instance.expiresAt.toIso8601String(),
  'account': instance.account.toJson(),
};
