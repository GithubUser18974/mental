// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RelationshipDto {

 bool get isSelf; bool get isFollowing; bool get followsYou; bool get isBlocked; bool get canFollow;
/// Create a copy of RelationshipDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelationshipDtoCopyWith<RelationshipDto> get copyWith => _$RelationshipDtoCopyWithImpl<RelationshipDto>(this as RelationshipDto, _$identity);

  /// Serializes this RelationshipDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelationshipDto&&(identical(other.isSelf, isSelf) || other.isSelf == isSelf)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.followsYou, followsYou) || other.followsYou == followsYou)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.canFollow, canFollow) || other.canFollow == canFollow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSelf,isFollowing,followsYou,isBlocked,canFollow);

@override
String toString() {
  return 'RelationshipDto(isSelf: $isSelf, isFollowing: $isFollowing, followsYou: $followsYou, isBlocked: $isBlocked, canFollow: $canFollow)';
}


}

/// @nodoc
abstract mixin class $RelationshipDtoCopyWith<$Res>  {
  factory $RelationshipDtoCopyWith(RelationshipDto value, $Res Function(RelationshipDto) _then) = _$RelationshipDtoCopyWithImpl;
@useResult
$Res call({
 bool isSelf, bool isFollowing, bool followsYou, bool isBlocked, bool canFollow
});




}
/// @nodoc
class _$RelationshipDtoCopyWithImpl<$Res>
    implements $RelationshipDtoCopyWith<$Res> {
  _$RelationshipDtoCopyWithImpl(this._self, this._then);

  final RelationshipDto _self;
  final $Res Function(RelationshipDto) _then;

/// Create a copy of RelationshipDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSelf = null,Object? isFollowing = null,Object? followsYou = null,Object? isBlocked = null,Object? canFollow = null,}) {
  return _then(_self.copyWith(
isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,followsYou: null == followsYou ? _self.followsYou : followsYou // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,canFollow: null == canFollow ? _self.canFollow : canFollow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RelationshipDto].
extension RelationshipDtoPatterns on RelationshipDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelationshipDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelationshipDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelationshipDto value)  $default,){
final _that = this;
switch (_that) {
case _RelationshipDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelationshipDto value)?  $default,){
final _that = this;
switch (_that) {
case _RelationshipDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSelf,  bool isFollowing,  bool followsYou,  bool isBlocked,  bool canFollow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RelationshipDto() when $default != null:
return $default(_that.isSelf,_that.isFollowing,_that.followsYou,_that.isBlocked,_that.canFollow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSelf,  bool isFollowing,  bool followsYou,  bool isBlocked,  bool canFollow)  $default,) {final _that = this;
switch (_that) {
case _RelationshipDto():
return $default(_that.isSelf,_that.isFollowing,_that.followsYou,_that.isBlocked,_that.canFollow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSelf,  bool isFollowing,  bool followsYou,  bool isBlocked,  bool canFollow)?  $default,) {final _that = this;
switch (_that) {
case _RelationshipDto() when $default != null:
return $default(_that.isSelf,_that.isFollowing,_that.followsYou,_that.isBlocked,_that.canFollow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RelationshipDto implements RelationshipDto {
  const _RelationshipDto({this.isSelf = false, this.isFollowing = false, this.followsYou = false, this.isBlocked = false, this.canFollow = false});
  factory _RelationshipDto.fromJson(Map<String, dynamic> json) => _$RelationshipDtoFromJson(json);

@override@JsonKey() final  bool isSelf;
@override@JsonKey() final  bool isFollowing;
@override@JsonKey() final  bool followsYou;
@override@JsonKey() final  bool isBlocked;
@override@JsonKey() final  bool canFollow;

/// Create a copy of RelationshipDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelationshipDtoCopyWith<_RelationshipDto> get copyWith => __$RelationshipDtoCopyWithImpl<_RelationshipDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RelationshipDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelationshipDto&&(identical(other.isSelf, isSelf) || other.isSelf == isSelf)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.followsYou, followsYou) || other.followsYou == followsYou)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.canFollow, canFollow) || other.canFollow == canFollow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSelf,isFollowing,followsYou,isBlocked,canFollow);

@override
String toString() {
  return 'RelationshipDto(isSelf: $isSelf, isFollowing: $isFollowing, followsYou: $followsYou, isBlocked: $isBlocked, canFollow: $canFollow)';
}


}

/// @nodoc
abstract mixin class _$RelationshipDtoCopyWith<$Res> implements $RelationshipDtoCopyWith<$Res> {
  factory _$RelationshipDtoCopyWith(_RelationshipDto value, $Res Function(_RelationshipDto) _then) = __$RelationshipDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isSelf, bool isFollowing, bool followsYou, bool isBlocked, bool canFollow
});




}
/// @nodoc
class __$RelationshipDtoCopyWithImpl<$Res>
    implements _$RelationshipDtoCopyWith<$Res> {
  __$RelationshipDtoCopyWithImpl(this._self, this._then);

  final _RelationshipDto _self;
  final $Res Function(_RelationshipDto) _then;

/// Create a copy of RelationshipDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSelf = null,Object? isFollowing = null,Object? followsYou = null,Object? isBlocked = null,Object? canFollow = null,}) {
  return _then(_RelationshipDto(
isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,followsYou: null == followsYou ? _self.followsYou : followsYou // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,canFollow: null == canFollow ? _self.canFollow : canFollow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProfileStatsDto {

 int get followers; int get following;
/// Create a copy of ProfileStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStatsDtoCopyWith<ProfileStatsDto> get copyWith => _$ProfileStatsDtoCopyWithImpl<ProfileStatsDto>(this as ProfileStatsDto, _$identity);

  /// Serializes this ProfileStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStatsDto&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.following, following) || other.following == following));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followers,following);

@override
String toString() {
  return 'ProfileStatsDto(followers: $followers, following: $following)';
}


}

/// @nodoc
abstract mixin class $ProfileStatsDtoCopyWith<$Res>  {
  factory $ProfileStatsDtoCopyWith(ProfileStatsDto value, $Res Function(ProfileStatsDto) _then) = _$ProfileStatsDtoCopyWithImpl;
@useResult
$Res call({
 int followers, int following
});




}
/// @nodoc
class _$ProfileStatsDtoCopyWithImpl<$Res>
    implements $ProfileStatsDtoCopyWith<$Res> {
  _$ProfileStatsDtoCopyWithImpl(this._self, this._then);

  final ProfileStatsDto _self;
  final $Res Function(ProfileStatsDto) _then;

/// Create a copy of ProfileStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followers = null,Object? following = null,}) {
  return _then(_self.copyWith(
followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileStatsDto].
extension ProfileStatsDtoPatterns on ProfileStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int followers,  int following)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileStatsDto() when $default != null:
return $default(_that.followers,_that.following);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int followers,  int following)  $default,) {final _that = this;
switch (_that) {
case _ProfileStatsDto():
return $default(_that.followers,_that.following);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int followers,  int following)?  $default,) {final _that = this;
switch (_that) {
case _ProfileStatsDto() when $default != null:
return $default(_that.followers,_that.following);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileStatsDto implements ProfileStatsDto {
  const _ProfileStatsDto({this.followers = 0, this.following = 0});
  factory _ProfileStatsDto.fromJson(Map<String, dynamic> json) => _$ProfileStatsDtoFromJson(json);

@override@JsonKey() final  int followers;
@override@JsonKey() final  int following;

/// Create a copy of ProfileStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStatsDtoCopyWith<_ProfileStatsDto> get copyWith => __$ProfileStatsDtoCopyWithImpl<_ProfileStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileStatsDto&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.following, following) || other.following == following));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followers,following);

@override
String toString() {
  return 'ProfileStatsDto(followers: $followers, following: $following)';
}


}

/// @nodoc
abstract mixin class _$ProfileStatsDtoCopyWith<$Res> implements $ProfileStatsDtoCopyWith<$Res> {
  factory _$ProfileStatsDtoCopyWith(_ProfileStatsDto value, $Res Function(_ProfileStatsDto) _then) = __$ProfileStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int followers, int following
});




}
/// @nodoc
class __$ProfileStatsDtoCopyWithImpl<$Res>
    implements _$ProfileStatsDtoCopyWith<$Res> {
  __$ProfileStatsDtoCopyWithImpl(this._self, this._then);

  final _ProfileStatsDto _self;
  final $Res Function(_ProfileStatsDto) _then;

/// Create a copy of ProfileStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followers = null,Object? following = null,}) {
  return _then(_ProfileStatsDto(
followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PublicProfileDto {

 String get id; String get username; String get avatar; DateTime get joinedOn; String? get bio; bool get isPrivate; ProfileStatsDto get stats; RelationshipDto get relationship;
/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicProfileDtoCopyWith<PublicProfileDto> get copyWith => _$PublicProfileDtoCopyWithImpl<PublicProfileDto>(this as PublicProfileDto, _$identity);

  /// Serializes this PublicProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.joinedOn, joinedOn) || other.joinedOn == joinedOn)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,joinedOn,bio,isPrivate,stats,relationship);

@override
String toString() {
  return 'PublicProfileDto(id: $id, username: $username, avatar: $avatar, joinedOn: $joinedOn, bio: $bio, isPrivate: $isPrivate, stats: $stats, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class $PublicProfileDtoCopyWith<$Res>  {
  factory $PublicProfileDtoCopyWith(PublicProfileDto value, $Res Function(PublicProfileDto) _then) = _$PublicProfileDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String avatar, DateTime joinedOn, String? bio, bool isPrivate, ProfileStatsDto stats, RelationshipDto relationship
});


$ProfileStatsDtoCopyWith<$Res> get stats;$RelationshipDtoCopyWith<$Res> get relationship;

}
/// @nodoc
class _$PublicProfileDtoCopyWithImpl<$Res>
    implements $PublicProfileDtoCopyWith<$Res> {
  _$PublicProfileDtoCopyWithImpl(this._self, this._then);

  final PublicProfileDto _self;
  final $Res Function(PublicProfileDto) _then;

/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? joinedOn = null,Object? bio = freezed,Object? isPrivate = null,Object? stats = null,Object? relationship = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,joinedOn: null == joinedOn ? _self.joinedOn : joinedOn // ignore: cast_nullable_to_non_nullable
as DateTime,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ProfileStatsDto,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as RelationshipDto,
  ));
}
/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileStatsDtoCopyWith<$Res> get stats {
  
  return $ProfileStatsDtoCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipDtoCopyWith<$Res> get relationship {
  
  return $RelationshipDtoCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicProfileDto].
extension PublicProfileDtoPatterns on PublicProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _PublicProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _PublicProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  DateTime joinedOn,  String? bio,  bool isPrivate,  ProfileStatsDto stats,  RelationshipDto relationship)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicProfileDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.joinedOn,_that.bio,_that.isPrivate,_that.stats,_that.relationship);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  DateTime joinedOn,  String? bio,  bool isPrivate,  ProfileStatsDto stats,  RelationshipDto relationship)  $default,) {final _that = this;
switch (_that) {
case _PublicProfileDto():
return $default(_that.id,_that.username,_that.avatar,_that.joinedOn,_that.bio,_that.isPrivate,_that.stats,_that.relationship);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String avatar,  DateTime joinedOn,  String? bio,  bool isPrivate,  ProfileStatsDto stats,  RelationshipDto relationship)?  $default,) {final _that = this;
switch (_that) {
case _PublicProfileDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.joinedOn,_that.bio,_that.isPrivate,_that.stats,_that.relationship);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicProfileDto extends PublicProfileDto {
  const _PublicProfileDto({required this.id, required this.username, required this.avatar, required this.joinedOn, this.bio, this.isPrivate = false, this.stats = const ProfileStatsDto(), this.relationship = const RelationshipDto()}): super._();
  factory _PublicProfileDto.fromJson(Map<String, dynamic> json) => _$PublicProfileDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String avatar;
@override final  DateTime joinedOn;
@override final  String? bio;
@override@JsonKey() final  bool isPrivate;
@override@JsonKey() final  ProfileStatsDto stats;
@override@JsonKey() final  RelationshipDto relationship;

/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicProfileDtoCopyWith<_PublicProfileDto> get copyWith => __$PublicProfileDtoCopyWithImpl<_PublicProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.joinedOn, joinedOn) || other.joinedOn == joinedOn)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,joinedOn,bio,isPrivate,stats,relationship);

@override
String toString() {
  return 'PublicProfileDto(id: $id, username: $username, avatar: $avatar, joinedOn: $joinedOn, bio: $bio, isPrivate: $isPrivate, stats: $stats, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class _$PublicProfileDtoCopyWith<$Res> implements $PublicProfileDtoCopyWith<$Res> {
  factory _$PublicProfileDtoCopyWith(_PublicProfileDto value, $Res Function(_PublicProfileDto) _then) = __$PublicProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String avatar, DateTime joinedOn, String? bio, bool isPrivate, ProfileStatsDto stats, RelationshipDto relationship
});


@override $ProfileStatsDtoCopyWith<$Res> get stats;@override $RelationshipDtoCopyWith<$Res> get relationship;

}
/// @nodoc
class __$PublicProfileDtoCopyWithImpl<$Res>
    implements _$PublicProfileDtoCopyWith<$Res> {
  __$PublicProfileDtoCopyWithImpl(this._self, this._then);

  final _PublicProfileDto _self;
  final $Res Function(_PublicProfileDto) _then;

/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? joinedOn = null,Object? bio = freezed,Object? isPrivate = null,Object? stats = null,Object? relationship = null,}) {
  return _then(_PublicProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,joinedOn: null == joinedOn ? _self.joinedOn : joinedOn // ignore: cast_nullable_to_non_nullable
as DateTime,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ProfileStatsDto,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as RelationshipDto,
  ));
}

/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileStatsDtoCopyWith<$Res> get stats {
  
  return $ProfileStatsDtoCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of PublicProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipDtoCopyWith<$Res> get relationship {
  
  return $RelationshipDtoCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// @nodoc
mixin _$MemberCardDto {

 String get id; String get username; String get avatar; bool? get isFollowing;
/// Create a copy of MemberCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCardDtoCopyWith<MemberCardDto> get copyWith => _$MemberCardDtoCopyWithImpl<MemberCardDto>(this as MemberCardDto, _$identity);

  /// Serializes this MemberCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberCardDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,isFollowing);

@override
String toString() {
  return 'MemberCardDto(id: $id, username: $username, avatar: $avatar, isFollowing: $isFollowing)';
}


}

/// @nodoc
abstract mixin class $MemberCardDtoCopyWith<$Res>  {
  factory $MemberCardDtoCopyWith(MemberCardDto value, $Res Function(MemberCardDto) _then) = _$MemberCardDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String avatar, bool? isFollowing
});




}
/// @nodoc
class _$MemberCardDtoCopyWithImpl<$Res>
    implements $MemberCardDtoCopyWith<$Res> {
  _$MemberCardDtoCopyWithImpl(this._self, this._then);

  final MemberCardDto _self;
  final $Res Function(MemberCardDto) _then;

/// Create a copy of MemberCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? isFollowing = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,isFollowing: freezed == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberCardDto].
extension MemberCardDtoPatterns on MemberCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberCardDto value)  $default,){
final _that = this;
switch (_that) {
case _MemberCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemberCardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  bool? isFollowing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberCardDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.isFollowing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String avatar,  bool? isFollowing)  $default,) {final _that = this;
switch (_that) {
case _MemberCardDto():
return $default(_that.id,_that.username,_that.avatar,_that.isFollowing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String avatar,  bool? isFollowing)?  $default,) {final _that = this;
switch (_that) {
case _MemberCardDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.isFollowing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberCardDto extends MemberCardDto {
  const _MemberCardDto({required this.id, required this.username, required this.avatar, this.isFollowing}): super._();
  factory _MemberCardDto.fromJson(Map<String, dynamic> json) => _$MemberCardDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String avatar;
@override final  bool? isFollowing;

/// Create a copy of MemberCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCardDtoCopyWith<_MemberCardDto> get copyWith => __$MemberCardDtoCopyWithImpl<_MemberCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberCardDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,isFollowing);

@override
String toString() {
  return 'MemberCardDto(id: $id, username: $username, avatar: $avatar, isFollowing: $isFollowing)';
}


}

/// @nodoc
abstract mixin class _$MemberCardDtoCopyWith<$Res> implements $MemberCardDtoCopyWith<$Res> {
  factory _$MemberCardDtoCopyWith(_MemberCardDto value, $Res Function(_MemberCardDto) _then) = __$MemberCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String avatar, bool? isFollowing
});




}
/// @nodoc
class __$MemberCardDtoCopyWithImpl<$Res>
    implements _$MemberCardDtoCopyWith<$Res> {
  __$MemberCardDtoCopyWithImpl(this._self, this._then);

  final _MemberCardDto _self;
  final $Res Function(_MemberCardDto) _then;

/// Create a copy of MemberCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = null,Object? isFollowing = freezed,}) {
  return _then(_MemberCardDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,isFollowing: freezed == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$HashtagDto {

 String get name; int get postsCount;
/// Create a copy of HashtagDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HashtagDtoCopyWith<HashtagDto> get copyWith => _$HashtagDtoCopyWithImpl<HashtagDto>(this as HashtagDto, _$identity);

  /// Serializes this HashtagDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HashtagDto&&(identical(other.name, name) || other.name == name)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,postsCount);

@override
String toString() {
  return 'HashtagDto(name: $name, postsCount: $postsCount)';
}


}

/// @nodoc
abstract mixin class $HashtagDtoCopyWith<$Res>  {
  factory $HashtagDtoCopyWith(HashtagDto value, $Res Function(HashtagDto) _then) = _$HashtagDtoCopyWithImpl;
@useResult
$Res call({
 String name, int postsCount
});




}
/// @nodoc
class _$HashtagDtoCopyWithImpl<$Res>
    implements $HashtagDtoCopyWith<$Res> {
  _$HashtagDtoCopyWithImpl(this._self, this._then);

  final HashtagDto _self;
  final $Res Function(HashtagDto) _then;

/// Create a copy of HashtagDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? postsCount = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HashtagDto].
extension HashtagDtoPatterns on HashtagDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HashtagDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HashtagDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HashtagDto value)  $default,){
final _that = this;
switch (_that) {
case _HashtagDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HashtagDto value)?  $default,){
final _that = this;
switch (_that) {
case _HashtagDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int postsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HashtagDto() when $default != null:
return $default(_that.name,_that.postsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int postsCount)  $default,) {final _that = this;
switch (_that) {
case _HashtagDto():
return $default(_that.name,_that.postsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int postsCount)?  $default,) {final _that = this;
switch (_that) {
case _HashtagDto() when $default != null:
return $default(_that.name,_that.postsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HashtagDto extends HashtagDto {
  const _HashtagDto({required this.name, this.postsCount = 0}): super._();
  factory _HashtagDto.fromJson(Map<String, dynamic> json) => _$HashtagDtoFromJson(json);

@override final  String name;
@override@JsonKey() final  int postsCount;

/// Create a copy of HashtagDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HashtagDtoCopyWith<_HashtagDto> get copyWith => __$HashtagDtoCopyWithImpl<_HashtagDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HashtagDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HashtagDto&&(identical(other.name, name) || other.name == name)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,postsCount);

@override
String toString() {
  return 'HashtagDto(name: $name, postsCount: $postsCount)';
}


}

/// @nodoc
abstract mixin class _$HashtagDtoCopyWith<$Res> implements $HashtagDtoCopyWith<$Res> {
  factory _$HashtagDtoCopyWith(_HashtagDto value, $Res Function(_HashtagDto) _then) = __$HashtagDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, int postsCount
});




}
/// @nodoc
class __$HashtagDtoCopyWithImpl<$Res>
    implements _$HashtagDtoCopyWith<$Res> {
  __$HashtagDtoCopyWithImpl(this._self, this._then);

  final _HashtagDto _self;
  final $Res Function(_HashtagDto) _then;

/// Create a copy of HashtagDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? postsCount = null,}) {
  return _then(_HashtagDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
