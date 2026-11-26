// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'own_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileInfoDto {

 String get id; String get username; String get avatar; bool get setupCompleted; String? get bio; DateTime? get usernameChangeAvailableAt;
/// Create a copy of ProfileInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileInfoDtoCopyWith<ProfileInfoDto> get copyWith => _$ProfileInfoDtoCopyWithImpl<ProfileInfoDto>(this as ProfileInfoDto, _$identity);

  /// Serializes this ProfileInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInfoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.setupCompleted, setupCompleted) || other.setupCompleted == setupCompleted)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.usernameChangeAvailableAt, usernameChangeAvailableAt) || other.usernameChangeAvailableAt == usernameChangeAvailableAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,setupCompleted,bio,usernameChangeAvailableAt);

@override
String toString() {
  return 'ProfileInfoDto(id: $id, username: $username, avatar: $avatar, setupCompleted: $setupCompleted, bio: $bio, usernameChangeAvailableAt: $usernameChangeAvailableAt)';
}


}

/// @nodoc
abstract mixin class $ProfileInfoDtoCopyWith<$Res>  {
  factory $ProfileInfoDtoCopyWith(ProfileInfoDto value, $Res Function(ProfileInfoDto) _then) = _$ProfileInfoDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String avatar, bool setupCompleted, String? bio, DateTime? usernameChangeAvailableAt
});




}
/// @nodoc
class _$ProfileInfoDtoCopyWithImpl<$Res>
    implements $ProfileInfoDtoCopyWith<$Res> {
  _$ProfileInfoDtoCopyWithImpl(this._self, this._then);

  final ProfileInfoDto _self;
  final $Res Function(ProfileInfoDto) _then;

/// Create a copy of ProfileInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? setupCompleted = null,Object? bio = freezed,Object? usernameChangeAvailableAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,setupCompleted: null == setupCompleted ? _self.setupCompleted : setupCompleted // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,usernameChangeAvailableAt: freezed == usernameChangeAvailableAt ? _self.usernameChangeAvailableAt : usernameChangeAvailableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileInfoDto].
extension ProfileInfoDtoPatterns on ProfileInfoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileInfoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileInfoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileInfoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  bool setupCompleted,  String? bio,  DateTime? usernameChangeAvailableAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileInfoDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.setupCompleted,_that.bio,_that.usernameChangeAvailableAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  bool setupCompleted,  String? bio,  DateTime? usernameChangeAvailableAt)  $default,) {final _that = this;
switch (_that) {
case _ProfileInfoDto():
return $default(_that.id,_that.username,_that.avatar,_that.setupCompleted,_that.bio,_that.usernameChangeAvailableAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String avatar,  bool setupCompleted,  String? bio,  DateTime? usernameChangeAvailableAt)?  $default,) {final _that = this;
switch (_that) {
case _ProfileInfoDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.setupCompleted,_that.bio,_that.usernameChangeAvailableAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileInfoDto implements ProfileInfoDto {
  const _ProfileInfoDto({required this.id, required this.username, required this.avatar, required this.setupCompleted, this.bio, this.usernameChangeAvailableAt});
  factory _ProfileInfoDto.fromJson(Map<String, dynamic> json) => _$ProfileInfoDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String avatar;
@override final  bool setupCompleted;
@override final  String? bio;
@override final  DateTime? usernameChangeAvailableAt;

/// Create a copy of ProfileInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileInfoDtoCopyWith<_ProfileInfoDto> get copyWith => __$ProfileInfoDtoCopyWithImpl<_ProfileInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileInfoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.setupCompleted, setupCompleted) || other.setupCompleted == setupCompleted)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.usernameChangeAvailableAt, usernameChangeAvailableAt) || other.usernameChangeAvailableAt == usernameChangeAvailableAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,setupCompleted,bio,usernameChangeAvailableAt);

@override
String toString() {
  return 'ProfileInfoDto(id: $id, username: $username, avatar: $avatar, setupCompleted: $setupCompleted, bio: $bio, usernameChangeAvailableAt: $usernameChangeAvailableAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileInfoDtoCopyWith<$Res> implements $ProfileInfoDtoCopyWith<$Res> {
  factory _$ProfileInfoDtoCopyWith(_ProfileInfoDto value, $Res Function(_ProfileInfoDto) _then) = __$ProfileInfoDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String avatar, bool setupCompleted, String? bio, DateTime? usernameChangeAvailableAt
});




}
/// @nodoc
class __$ProfileInfoDtoCopyWithImpl<$Res>
    implements _$ProfileInfoDtoCopyWith<$Res> {
  __$ProfileInfoDtoCopyWithImpl(this._self, this._then);

  final _ProfileInfoDto _self;
  final $Res Function(_ProfileInfoDto) _then;

/// Create a copy of ProfileInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? setupCompleted = null,Object? bio = freezed,Object? usernameChangeAvailableAt = freezed,}) {
  return _then(_ProfileInfoDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,setupCompleted: null == setupCompleted ? _self.setupCompleted : setupCompleted // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,usernameChangeAvailableAt: freezed == usernameChangeAvailableAt ? _self.usernameChangeAvailableAt : usernameChangeAvailableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PreferencesDto {

 String get language; String get timezone;
/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<PreferencesDto> get copyWith => _$PreferencesDtoCopyWithImpl<PreferencesDto>(this as PreferencesDto, _$identity);

  /// Serializes this PreferencesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesDto&&(identical(other.language, language) || other.language == language)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,timezone);

@override
String toString() {
  return 'PreferencesDto(language: $language, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $PreferencesDtoCopyWith<$Res>  {
  factory $PreferencesDtoCopyWith(PreferencesDto value, $Res Function(PreferencesDto) _then) = _$PreferencesDtoCopyWithImpl;
@useResult
$Res call({
 String language, String timezone
});




}
/// @nodoc
class _$PreferencesDtoCopyWithImpl<$Res>
    implements $PreferencesDtoCopyWith<$Res> {
  _$PreferencesDtoCopyWithImpl(this._self, this._then);

  final PreferencesDto _self;
  final $Res Function(PreferencesDto) _then;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesDto].
extension PreferencesDtoPatterns on PreferencesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesDto value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesDto value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String language,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
return $default(_that.language,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String language,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _PreferencesDto():
return $default(_that.language,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String language,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
return $default(_that.language,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreferencesDto implements PreferencesDto {
  const _PreferencesDto({required this.language, required this.timezone});
  factory _PreferencesDto.fromJson(Map<String, dynamic> json) => _$PreferencesDtoFromJson(json);

@override final  String language;
@override final  String timezone;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesDtoCopyWith<_PreferencesDto> get copyWith => __$PreferencesDtoCopyWithImpl<_PreferencesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreferencesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesDto&&(identical(other.language, language) || other.language == language)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,timezone);

@override
String toString() {
  return 'PreferencesDto(language: $language, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$PreferencesDtoCopyWith<$Res> implements $PreferencesDtoCopyWith<$Res> {
  factory _$PreferencesDtoCopyWith(_PreferencesDto value, $Res Function(_PreferencesDto) _then) = __$PreferencesDtoCopyWithImpl;
@override @useResult
$Res call({
 String language, String timezone
});




}
/// @nodoc
class __$PreferencesDtoCopyWithImpl<$Res>
    implements _$PreferencesDtoCopyWith<$Res> {
  __$PreferencesDtoCopyWithImpl(this._self, this._then);

  final _PreferencesDto _self;
  final $Res Function(_PreferencesDto) _then;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? timezone = null,}) {
  return _then(_PreferencesDto(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PrivacyDto {

 String get profileVisibility; String get followPolicy; bool get analyticsConsent;
/// Create a copy of PrivacyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyDtoCopyWith<PrivacyDto> get copyWith => _$PrivacyDtoCopyWithImpl<PrivacyDto>(this as PrivacyDto, _$identity);

  /// Serializes this PrivacyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyDto&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.followPolicy, followPolicy) || other.followPolicy == followPolicy)&&(identical(other.analyticsConsent, analyticsConsent) || other.analyticsConsent == analyticsConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileVisibility,followPolicy,analyticsConsent);

@override
String toString() {
  return 'PrivacyDto(profileVisibility: $profileVisibility, followPolicy: $followPolicy, analyticsConsent: $analyticsConsent)';
}


}

/// @nodoc
abstract mixin class $PrivacyDtoCopyWith<$Res>  {
  factory $PrivacyDtoCopyWith(PrivacyDto value, $Res Function(PrivacyDto) _then) = _$PrivacyDtoCopyWithImpl;
@useResult
$Res call({
 String profileVisibility, String followPolicy, bool analyticsConsent
});




}
/// @nodoc
class _$PrivacyDtoCopyWithImpl<$Res>
    implements $PrivacyDtoCopyWith<$Res> {
  _$PrivacyDtoCopyWithImpl(this._self, this._then);

  final PrivacyDto _self;
  final $Res Function(PrivacyDto) _then;

/// Create a copy of PrivacyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileVisibility = null,Object? followPolicy = null,Object? analyticsConsent = null,}) {
  return _then(_self.copyWith(
profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as String,followPolicy: null == followPolicy ? _self.followPolicy : followPolicy // ignore: cast_nullable_to_non_nullable
as String,analyticsConsent: null == analyticsConsent ? _self.analyticsConsent : analyticsConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacyDto].
extension PrivacyDtoPatterns on PrivacyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyDto value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileVisibility,  String followPolicy,  bool analyticsConsent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacyDto() when $default != null:
return $default(_that.profileVisibility,_that.followPolicy,_that.analyticsConsent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileVisibility,  String followPolicy,  bool analyticsConsent)  $default,) {final _that = this;
switch (_that) {
case _PrivacyDto():
return $default(_that.profileVisibility,_that.followPolicy,_that.analyticsConsent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileVisibility,  String followPolicy,  bool analyticsConsent)?  $default,) {final _that = this;
switch (_that) {
case _PrivacyDto() when $default != null:
return $default(_that.profileVisibility,_that.followPolicy,_that.analyticsConsent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivacyDto implements PrivacyDto {
  const _PrivacyDto({required this.profileVisibility, required this.followPolicy, required this.analyticsConsent});
  factory _PrivacyDto.fromJson(Map<String, dynamic> json) => _$PrivacyDtoFromJson(json);

@override final  String profileVisibility;
@override final  String followPolicy;
@override final  bool analyticsConsent;

/// Create a copy of PrivacyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyDtoCopyWith<_PrivacyDto> get copyWith => __$PrivacyDtoCopyWithImpl<_PrivacyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyDto&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.followPolicy, followPolicy) || other.followPolicy == followPolicy)&&(identical(other.analyticsConsent, analyticsConsent) || other.analyticsConsent == analyticsConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileVisibility,followPolicy,analyticsConsent);

@override
String toString() {
  return 'PrivacyDto(profileVisibility: $profileVisibility, followPolicy: $followPolicy, analyticsConsent: $analyticsConsent)';
}


}

/// @nodoc
abstract mixin class _$PrivacyDtoCopyWith<$Res> implements $PrivacyDtoCopyWith<$Res> {
  factory _$PrivacyDtoCopyWith(_PrivacyDto value, $Res Function(_PrivacyDto) _then) = __$PrivacyDtoCopyWithImpl;
@override @useResult
$Res call({
 String profileVisibility, String followPolicy, bool analyticsConsent
});




}
/// @nodoc
class __$PrivacyDtoCopyWithImpl<$Res>
    implements _$PrivacyDtoCopyWith<$Res> {
  __$PrivacyDtoCopyWithImpl(this._self, this._then);

  final _PrivacyDto _self;
  final $Res Function(_PrivacyDto) _then;

/// Create a copy of PrivacyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileVisibility = null,Object? followPolicy = null,Object? analyticsConsent = null,}) {
  return _then(_PrivacyDto(
profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as String,followPolicy: null == followPolicy ? _self.followPolicy : followPolicy // ignore: cast_nullable_to_non_nullable
as String,analyticsConsent: null == analyticsConsent ? _self.analyticsConsent : analyticsConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OwnProfileDto {

 ProfileInfoDto get profile; PreferencesDto get preferences; PrivacyDto get privacy;
/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnProfileDtoCopyWith<OwnProfileDto> get copyWith => _$OwnProfileDtoCopyWithImpl<OwnProfileDto>(this as OwnProfileDto, _$identity);

  /// Serializes this OwnProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnProfileDto&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.privacy, privacy) || other.privacy == privacy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,preferences,privacy);

@override
String toString() {
  return 'OwnProfileDto(profile: $profile, preferences: $preferences, privacy: $privacy)';
}


}

/// @nodoc
abstract mixin class $OwnProfileDtoCopyWith<$Res>  {
  factory $OwnProfileDtoCopyWith(OwnProfileDto value, $Res Function(OwnProfileDto) _then) = _$OwnProfileDtoCopyWithImpl;
@useResult
$Res call({
 ProfileInfoDto profile, PreferencesDto preferences, PrivacyDto privacy
});


$ProfileInfoDtoCopyWith<$Res> get profile;$PreferencesDtoCopyWith<$Res> get preferences;$PrivacyDtoCopyWith<$Res> get privacy;

}
/// @nodoc
class _$OwnProfileDtoCopyWithImpl<$Res>
    implements $OwnProfileDtoCopyWith<$Res> {
  _$OwnProfileDtoCopyWithImpl(this._self, this._then);

  final OwnProfileDto _self;
  final $Res Function(OwnProfileDto) _then;

/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? preferences = null,Object? privacy = null,}) {
  return _then(_self.copyWith(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileInfoDto,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as PreferencesDto,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as PrivacyDto,
  ));
}
/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileInfoDtoCopyWith<$Res> get profile {
  
  return $ProfileInfoDtoCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<$Res> get preferences {
  
  return $PreferencesDtoCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivacyDtoCopyWith<$Res> get privacy {
  
  return $PrivacyDtoCopyWith<$Res>(_self.privacy, (value) {
    return _then(_self.copyWith(privacy: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnProfileDto].
extension OwnProfileDtoPatterns on OwnProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _OwnProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _OwnProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileInfoDto profile,  PreferencesDto preferences,  PrivacyDto privacy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnProfileDto() when $default != null:
return $default(_that.profile,_that.preferences,_that.privacy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileInfoDto profile,  PreferencesDto preferences,  PrivacyDto privacy)  $default,) {final _that = this;
switch (_that) {
case _OwnProfileDto():
return $default(_that.profile,_that.preferences,_that.privacy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileInfoDto profile,  PreferencesDto preferences,  PrivacyDto privacy)?  $default,) {final _that = this;
switch (_that) {
case _OwnProfileDto() when $default != null:
return $default(_that.profile,_that.preferences,_that.privacy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnProfileDto extends OwnProfileDto {
  const _OwnProfileDto({required this.profile, required this.preferences, required this.privacy}): super._();
  factory _OwnProfileDto.fromJson(Map<String, dynamic> json) => _$OwnProfileDtoFromJson(json);

@override final  ProfileInfoDto profile;
@override final  PreferencesDto preferences;
@override final  PrivacyDto privacy;

/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnProfileDtoCopyWith<_OwnProfileDto> get copyWith => __$OwnProfileDtoCopyWithImpl<_OwnProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnProfileDto&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.privacy, privacy) || other.privacy == privacy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,preferences,privacy);

@override
String toString() {
  return 'OwnProfileDto(profile: $profile, preferences: $preferences, privacy: $privacy)';
}


}

/// @nodoc
abstract mixin class _$OwnProfileDtoCopyWith<$Res> implements $OwnProfileDtoCopyWith<$Res> {
  factory _$OwnProfileDtoCopyWith(_OwnProfileDto value, $Res Function(_OwnProfileDto) _then) = __$OwnProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 ProfileInfoDto profile, PreferencesDto preferences, PrivacyDto privacy
});


@override $ProfileInfoDtoCopyWith<$Res> get profile;@override $PreferencesDtoCopyWith<$Res> get preferences;@override $PrivacyDtoCopyWith<$Res> get privacy;

}
/// @nodoc
class __$OwnProfileDtoCopyWithImpl<$Res>
    implements _$OwnProfileDtoCopyWith<$Res> {
  __$OwnProfileDtoCopyWithImpl(this._self, this._then);

  final _OwnProfileDto _self;
  final $Res Function(_OwnProfileDto) _then;

/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? preferences = null,Object? privacy = null,}) {
  return _then(_OwnProfileDto(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileInfoDto,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as PreferencesDto,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as PrivacyDto,
  ));
}

/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileInfoDtoCopyWith<$Res> get profile {
  
  return $ProfileInfoDtoCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<$Res> get preferences {
  
  return $PreferencesDtoCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of OwnProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivacyDtoCopyWith<$Res> get privacy {
  
  return $PrivacyDtoCopyWith<$Res>(_self.privacy, (value) {
    return _then(_self.copyWith(privacy: value));
  });
}
}

// dart format on
