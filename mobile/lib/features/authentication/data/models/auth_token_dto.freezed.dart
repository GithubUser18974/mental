// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_token_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDto {

 String get id; String get email; bool get emailVerified; String get status;
/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountDtoCopyWith<AccountDto> get copyWith => _$AccountDtoCopyWithImpl<AccountDto>(this as AccountDto, _$identity);

  /// Serializes this AccountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,emailVerified,status);

@override
String toString() {
  return 'AccountDto(id: $id, email: $email, emailVerified: $emailVerified, status: $status)';
}


}

/// @nodoc
abstract mixin class $AccountDtoCopyWith<$Res>  {
  factory $AccountDtoCopyWith(AccountDto value, $Res Function(AccountDto) _then) = _$AccountDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, bool emailVerified, String status
});




}
/// @nodoc
class _$AccountDtoCopyWithImpl<$Res>
    implements $AccountDtoCopyWith<$Res> {
  _$AccountDtoCopyWithImpl(this._self, this._then);

  final AccountDto _self;
  final $Res Function(AccountDto) _then;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? emailVerified = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountDto].
extension AccountDtoPatterns on AccountDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountDto value)  $default,){
final _that = this;
switch (_that) {
case _AccountDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountDto value)?  $default,){
final _that = this;
switch (_that) {
case _AccountDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  bool emailVerified,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountDto() when $default != null:
return $default(_that.id,_that.email,_that.emailVerified,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  bool emailVerified,  String status)  $default,) {final _that = this;
switch (_that) {
case _AccountDto():
return $default(_that.id,_that.email,_that.emailVerified,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  bool emailVerified,  String status)?  $default,) {final _that = this;
switch (_that) {
case _AccountDto() when $default != null:
return $default(_that.id,_that.email,_that.emailVerified,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountDto extends AccountDto {
  const _AccountDto({required this.id, required this.email, required this.emailVerified, required this.status}): super._();
  factory _AccountDto.fromJson(Map<String, dynamic> json) => _$AccountDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  bool emailVerified;
@override final  String status;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountDtoCopyWith<_AccountDto> get copyWith => __$AccountDtoCopyWithImpl<_AccountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,emailVerified,status);

@override
String toString() {
  return 'AccountDto(id: $id, email: $email, emailVerified: $emailVerified, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AccountDtoCopyWith<$Res> implements $AccountDtoCopyWith<$Res> {
  factory _$AccountDtoCopyWith(_AccountDto value, $Res Function(_AccountDto) _then) = __$AccountDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, bool emailVerified, String status
});




}
/// @nodoc
class __$AccountDtoCopyWithImpl<$Res>
    implements _$AccountDtoCopyWith<$Res> {
  __$AccountDtoCopyWithImpl(this._self, this._then);

  final _AccountDto _self;
  final $Res Function(_AccountDto) _then;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? emailVerified = null,Object? status = null,}) {
  return _then(_AccountDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuthTokenDto {

 String get token; String get tokenType; DateTime get expiresAt; AccountDto get account;
/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokenDtoCopyWith<AuthTokenDto> get copyWith => _$AuthTokenDtoCopyWithImpl<AuthTokenDto>(this as AuthTokenDto, _$identity);

  /// Serializes this AuthTokenDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokenDto&&(identical(other.token, token) || other.token == token)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,tokenType,expiresAt,account);

@override
String toString() {
  return 'AuthTokenDto(token: $token, tokenType: $tokenType, expiresAt: $expiresAt, account: $account)';
}


}

/// @nodoc
abstract mixin class $AuthTokenDtoCopyWith<$Res>  {
  factory $AuthTokenDtoCopyWith(AuthTokenDto value, $Res Function(AuthTokenDto) _then) = _$AuthTokenDtoCopyWithImpl;
@useResult
$Res call({
 String token, String tokenType, DateTime expiresAt, AccountDto account
});


$AccountDtoCopyWith<$Res> get account;

}
/// @nodoc
class _$AuthTokenDtoCopyWithImpl<$Res>
    implements $AuthTokenDtoCopyWith<$Res> {
  _$AuthTokenDtoCopyWithImpl(this._self, this._then);

  final AuthTokenDto _self;
  final $Res Function(AuthTokenDto) _then;

/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? tokenType = null,Object? expiresAt = null,Object? account = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountDto,
  ));
}
/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountDtoCopyWith<$Res> get account {
  
  return $AccountDtoCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthTokenDto].
extension AuthTokenDtoPatterns on AuthTokenDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokenDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokenDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokenDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokenDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokenDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokenDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String tokenType,  DateTime expiresAt,  AccountDto account)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokenDto() when $default != null:
return $default(_that.token,_that.tokenType,_that.expiresAt,_that.account);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String tokenType,  DateTime expiresAt,  AccountDto account)  $default,) {final _that = this;
switch (_that) {
case _AuthTokenDto():
return $default(_that.token,_that.tokenType,_that.expiresAt,_that.account);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String tokenType,  DateTime expiresAt,  AccountDto account)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokenDto() when $default != null:
return $default(_that.token,_that.tokenType,_that.expiresAt,_that.account);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokenDto extends AuthTokenDto {
  const _AuthTokenDto({required this.token, required this.tokenType, required this.expiresAt, required this.account}): super._();
  factory _AuthTokenDto.fromJson(Map<String, dynamic> json) => _$AuthTokenDtoFromJson(json);

@override final  String token;
@override final  String tokenType;
@override final  DateTime expiresAt;
@override final  AccountDto account;

/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokenDtoCopyWith<_AuthTokenDto> get copyWith => __$AuthTokenDtoCopyWithImpl<_AuthTokenDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokenDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokenDto&&(identical(other.token, token) || other.token == token)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,tokenType,expiresAt,account);

@override
String toString() {
  return 'AuthTokenDto(token: $token, tokenType: $tokenType, expiresAt: $expiresAt, account: $account)';
}


}

/// @nodoc
abstract mixin class _$AuthTokenDtoCopyWith<$Res> implements $AuthTokenDtoCopyWith<$Res> {
  factory _$AuthTokenDtoCopyWith(_AuthTokenDto value, $Res Function(_AuthTokenDto) _then) = __$AuthTokenDtoCopyWithImpl;
@override @useResult
$Res call({
 String token, String tokenType, DateTime expiresAt, AccountDto account
});


@override $AccountDtoCopyWith<$Res> get account;

}
/// @nodoc
class __$AuthTokenDtoCopyWithImpl<$Res>
    implements _$AuthTokenDtoCopyWith<$Res> {
  __$AuthTokenDtoCopyWithImpl(this._self, this._then);

  final _AuthTokenDto _self;
  final $Res Function(_AuthTokenDto) _then;

/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? tokenType = null,Object? expiresAt = null,Object? account = null,}) {
  return _then(_AuthTokenDto(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountDto,
  ));
}

/// Create a copy of AuthTokenDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountDtoCopyWith<$Res> get account {
  
  return $AccountDtoCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}

// dart format on
