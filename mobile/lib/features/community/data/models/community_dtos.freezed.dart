// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberDto {

 String get id; String get username; String get avatar;
/// Create a copy of MemberDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberDtoCopyWith<MemberDto> get copyWith => _$MemberDtoCopyWithImpl<MemberDto>(this as MemberDto, _$identity);

  /// Serializes this MemberDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'MemberDto(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $MemberDtoCopyWith<$Res>  {
  factory $MemberDtoCopyWith(MemberDto value, $Res Function(MemberDto) _then) = _$MemberDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String avatar
});




}
/// @nodoc
class _$MemberDtoCopyWithImpl<$Res>
    implements $MemberDtoCopyWith<$Res> {
  _$MemberDtoCopyWithImpl(this._self, this._then);

  final MemberDto _self;
  final $Res Function(MemberDto) _then;

/// Create a copy of MemberDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberDto].
extension MemberDtoPatterns on MemberDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberDto value)  $default,){
final _that = this;
switch (_that) {
case _MemberDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemberDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String avatar)  $default,) {final _that = this;
switch (_that) {
case _MemberDto():
return $default(_that.id,_that.username,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String avatar)?  $default,) {final _that = this;
switch (_that) {
case _MemberDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberDto extends MemberDto {
  const _MemberDto({required this.id, required this.username, required this.avatar}): super._();
  factory _MemberDto.fromJson(Map<String, dynamic> json) => _$MemberDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String avatar;

/// Create a copy of MemberDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberDtoCopyWith<_MemberDto> get copyWith => __$MemberDtoCopyWithImpl<_MemberDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'MemberDto(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$MemberDtoCopyWith<$Res> implements $MemberDtoCopyWith<$Res> {
  factory _$MemberDtoCopyWith(_MemberDto value, $Res Function(_MemberDto) _then) = __$MemberDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String avatar
});




}
/// @nodoc
class __$MemberDtoCopyWithImpl<$Res>
    implements _$MemberDtoCopyWith<$Res> {
  __$MemberDtoCopyWithImpl(this._self, this._then);

  final _MemberDto _self;
  final $Res Function(_MemberDto) _then;

/// Create a copy of MemberDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = null,}) {
  return _then(_MemberDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CategoryDto {

 String get slug; String get name; String get description; String get icon;
/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<CategoryDto> get copyWith => _$CategoryDtoCopyWithImpl<CategoryDto>(this as CategoryDto, _$identity);

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDto&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,description,icon);

@override
String toString() {
  return 'CategoryDto(slug: $slug, name: $name, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $CategoryDtoCopyWith<$Res>  {
  factory $CategoryDtoCopyWith(CategoryDto value, $Res Function(CategoryDto) _then) = _$CategoryDtoCopyWithImpl;
@useResult
$Res call({
 String slug, String name, String description, String icon
});




}
/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._self, this._then);

  final CategoryDto _self;
  final $Res Function(CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,Object? description = null,Object? icon = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDto].
extension CategoryDtoPatterns on CategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name,  String description,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.slug,_that.name,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name,  String description,  String icon)  $default,) {final _that = this;
switch (_that) {
case _CategoryDto():
return $default(_that.slug,_that.name,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name,  String description,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.slug,_that.name,_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDto extends CategoryDto {
  const _CategoryDto({required this.slug, required this.name, this.description = '', this.icon = ''}): super._();
  factory _CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

@override final  String slug;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String icon;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDtoCopyWith<_CategoryDto> get copyWith => __$CategoryDtoCopyWithImpl<_CategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDto&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,description,icon);

@override
String toString() {
  return 'CategoryDto(slug: $slug, name: $name, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$CategoryDtoCopyWith<$Res> implements $CategoryDtoCopyWith<$Res> {
  factory _$CategoryDtoCopyWith(_CategoryDto value, $Res Function(_CategoryDto) _then) = __$CategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name, String description, String icon
});




}
/// @nodoc
class __$CategoryDtoCopyWithImpl<$Res>
    implements _$CategoryDtoCopyWith<$Res> {
  __$CategoryDtoCopyWithImpl(this._self, this._then);

  final _CategoryDto _self;
  final $Res Function(_CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,Object? description = null,Object? icon = null,}) {
  return _then(_CategoryDto(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MediaDto {

 String get id; String get url; int get width; int get height;
/// Create a copy of MediaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaDtoCopyWith<MediaDto> get copyWith => _$MediaDtoCopyWithImpl<MediaDto>(this as MediaDto, _$identity);

  /// Serializes this MediaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,width,height);

@override
String toString() {
  return 'MediaDto(id: $id, url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $MediaDtoCopyWith<$Res>  {
  factory $MediaDtoCopyWith(MediaDto value, $Res Function(MediaDto) _then) = _$MediaDtoCopyWithImpl;
@useResult
$Res call({
 String id, String url, int width, int height
});




}
/// @nodoc
class _$MediaDtoCopyWithImpl<$Res>
    implements $MediaDtoCopyWith<$Res> {
  _$MediaDtoCopyWithImpl(this._self, this._then);

  final MediaDto _self;
  final $Res Function(MediaDto) _then;

/// Create a copy of MediaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaDto].
extension MediaDtoPatterns on MediaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaDto value)  $default,){
final _that = this;
switch (_that) {
case _MediaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaDto value)?  $default,){
final _that = this;
switch (_that) {
case _MediaDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaDto() when $default != null:
return $default(_that.id,_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _MediaDto():
return $default(_that.id,_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _MediaDto() when $default != null:
return $default(_that.id,_that.url,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaDto extends MediaDto {
  const _MediaDto({required this.id, required this.url, this.width = 0, this.height = 0}): super._();
  factory _MediaDto.fromJson(Map<String, dynamic> json) => _$MediaDtoFromJson(json);

@override final  String id;
@override final  String url;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;

/// Create a copy of MediaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaDtoCopyWith<_MediaDto> get copyWith => __$MediaDtoCopyWithImpl<_MediaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,width,height);

@override
String toString() {
  return 'MediaDto(id: $id, url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$MediaDtoCopyWith<$Res> implements $MediaDtoCopyWith<$Res> {
  factory _$MediaDtoCopyWith(_MediaDto value, $Res Function(_MediaDto) _then) = __$MediaDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, int width, int height
});




}
/// @nodoc
class __$MediaDtoCopyWithImpl<$Res>
    implements _$MediaDtoCopyWith<$Res> {
  __$MediaDtoCopyWithImpl(this._self, this._then);

  final _MediaDto _self;
  final $Res Function(_MediaDto) _then;

/// Create a copy of MediaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? width = null,Object? height = null,}) {
  return _then(_MediaDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReactionSummaryDto {

 Map<String, int> get counts; int get total; String? get mine;
/// Create a copy of ReactionSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionSummaryDtoCopyWith<ReactionSummaryDto> get copyWith => _$ReactionSummaryDtoCopyWithImpl<ReactionSummaryDto>(this as ReactionSummaryDto, _$identity);

  /// Serializes this ReactionSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReactionSummaryDto&&const DeepCollectionEquality().equals(other.counts, counts)&&(identical(other.total, total) || other.total == total)&&(identical(other.mine, mine) || other.mine == mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(counts),total,mine);

@override
String toString() {
  return 'ReactionSummaryDto(counts: $counts, total: $total, mine: $mine)';
}


}

/// @nodoc
abstract mixin class $ReactionSummaryDtoCopyWith<$Res>  {
  factory $ReactionSummaryDtoCopyWith(ReactionSummaryDto value, $Res Function(ReactionSummaryDto) _then) = _$ReactionSummaryDtoCopyWithImpl;
@useResult
$Res call({
 Map<String, int> counts, int total, String? mine
});




}
/// @nodoc
class _$ReactionSummaryDtoCopyWithImpl<$Res>
    implements $ReactionSummaryDtoCopyWith<$Res> {
  _$ReactionSummaryDtoCopyWithImpl(this._self, this._then);

  final ReactionSummaryDto _self;
  final $Res Function(ReactionSummaryDto) _then;

/// Create a copy of ReactionSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? counts = null,Object? total = null,Object? mine = freezed,}) {
  return _then(_self.copyWith(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReactionSummaryDto].
extension ReactionSummaryDtoPatterns on ReactionSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReactionSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReactionSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReactionSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _ReactionSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReactionSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReactionSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> counts,  int total,  String? mine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReactionSummaryDto() when $default != null:
return $default(_that.counts,_that.total,_that.mine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> counts,  int total,  String? mine)  $default,) {final _that = this;
switch (_that) {
case _ReactionSummaryDto():
return $default(_that.counts,_that.total,_that.mine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> counts,  int total,  String? mine)?  $default,) {final _that = this;
switch (_that) {
case _ReactionSummaryDto() when $default != null:
return $default(_that.counts,_that.total,_that.mine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReactionSummaryDto extends ReactionSummaryDto {
  const _ReactionSummaryDto({final  Map<String, int> counts = const <String, int>{}, this.total = 0, this.mine}): _counts = counts,super._();
  factory _ReactionSummaryDto.fromJson(Map<String, dynamic> json) => _$ReactionSummaryDtoFromJson(json);

 final  Map<String, int> _counts;
@override@JsonKey() Map<String, int> get counts {
  if (_counts is EqualUnmodifiableMapView) return _counts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_counts);
}

@override@JsonKey() final  int total;
@override final  String? mine;

/// Create a copy of ReactionSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionSummaryDtoCopyWith<_ReactionSummaryDto> get copyWith => __$ReactionSummaryDtoCopyWithImpl<_ReactionSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReactionSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReactionSummaryDto&&const DeepCollectionEquality().equals(other._counts, _counts)&&(identical(other.total, total) || other.total == total)&&(identical(other.mine, mine) || other.mine == mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_counts),total,mine);

@override
String toString() {
  return 'ReactionSummaryDto(counts: $counts, total: $total, mine: $mine)';
}


}

/// @nodoc
abstract mixin class _$ReactionSummaryDtoCopyWith<$Res> implements $ReactionSummaryDtoCopyWith<$Res> {
  factory _$ReactionSummaryDtoCopyWith(_ReactionSummaryDto value, $Res Function(_ReactionSummaryDto) _then) = __$ReactionSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> counts, int total, String? mine
});




}
/// @nodoc
class __$ReactionSummaryDtoCopyWithImpl<$Res>
    implements _$ReactionSummaryDtoCopyWith<$Res> {
  __$ReactionSummaryDtoCopyWithImpl(this._self, this._then);

  final _ReactionSummaryDto _self;
  final $Res Function(_ReactionSummaryDto) _then;

/// Create a copy of ReactionSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? counts = null,Object? total = null,Object? mine = freezed,}) {
  return _then(_ReactionSummaryDto(
counts: null == counts ? _self._counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PostDto {

 String get id; MemberDto get author; CategoryDto get category; String get content; DateTime get createdAt; List<String> get hashtags; String? get contentWarning; bool get allowComments; String get visibility; List<MediaDto> get media; ReactionSummaryDto? get reactions; int get commentsCount; bool get isSaved; bool get isOwn; String? get moderationStatus; bool get edited;
/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDtoCopyWith<PostDto> get copyWith => _$PostDtoCopyWithImpl<PostDto>(this as PostDto, _$identity);

  /// Serializes this PostDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDto&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&(identical(other.contentWarning, contentWarning) || other.contentWarning == contentWarning)&&(identical(other.allowComments, allowComments) || other.allowComments == allowComments)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.reactions, reactions) || other.reactions == reactions)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,category,content,createdAt,const DeepCollectionEquality().hash(hashtags),contentWarning,allowComments,visibility,const DeepCollectionEquality().hash(media),reactions,commentsCount,isSaved,isOwn,moderationStatus,edited);

@override
String toString() {
  return 'PostDto(id: $id, author: $author, category: $category, content: $content, createdAt: $createdAt, hashtags: $hashtags, contentWarning: $contentWarning, allowComments: $allowComments, visibility: $visibility, media: $media, reactions: $reactions, commentsCount: $commentsCount, isSaved: $isSaved, isOwn: $isOwn, moderationStatus: $moderationStatus, edited: $edited)';
}


}

/// @nodoc
abstract mixin class $PostDtoCopyWith<$Res>  {
  factory $PostDtoCopyWith(PostDto value, $Res Function(PostDto) _then) = _$PostDtoCopyWithImpl;
@useResult
$Res call({
 String id, MemberDto author, CategoryDto category, String content, DateTime createdAt, List<String> hashtags, String? contentWarning, bool allowComments, String visibility, List<MediaDto> media, ReactionSummaryDto? reactions, int commentsCount, bool isSaved, bool isOwn, String? moderationStatus, bool edited
});


$MemberDtoCopyWith<$Res> get author;$CategoryDtoCopyWith<$Res> get category;$ReactionSummaryDtoCopyWith<$Res>? get reactions;

}
/// @nodoc
class _$PostDtoCopyWithImpl<$Res>
    implements $PostDtoCopyWith<$Res> {
  _$PostDtoCopyWithImpl(this._self, this._then);

  final PostDto _self;
  final $Res Function(PostDto) _then;

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? category = null,Object? content = null,Object? createdAt = null,Object? hashtags = null,Object? contentWarning = freezed,Object? allowComments = null,Object? visibility = null,Object? media = null,Object? reactions = freezed,Object? commentsCount = null,Object? isSaved = null,Object? isOwn = null,Object? moderationStatus = freezed,Object? edited = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemberDto,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,contentWarning: freezed == contentWarning ? _self.contentWarning : contentWarning // ignore: cast_nullable_to_non_nullable
as String?,allowComments: null == allowComments ? _self.allowComments : allowComments // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MediaDto>,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as ReactionSummaryDto?,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,moderationStatus: freezed == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberDtoCopyWith<$Res> get author {
  
  return $MemberDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res> get category {
  
  return $CategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionSummaryDtoCopyWith<$Res>? get reactions {
    if (_self.reactions == null) {
    return null;
  }

  return $ReactionSummaryDtoCopyWith<$Res>(_self.reactions!, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDto].
extension PostDtoPatterns on PostDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDto value)  $default,){
final _that = this;
switch (_that) {
case _PostDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MemberDto author,  CategoryDto category,  String content,  DateTime createdAt,  List<String> hashtags,  String? contentWarning,  bool allowComments,  String visibility,  List<MediaDto> media,  ReactionSummaryDto? reactions,  int commentsCount,  bool isSaved,  bool isOwn,  String? moderationStatus,  bool edited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDto() when $default != null:
return $default(_that.id,_that.author,_that.category,_that.content,_that.createdAt,_that.hashtags,_that.contentWarning,_that.allowComments,_that.visibility,_that.media,_that.reactions,_that.commentsCount,_that.isSaved,_that.isOwn,_that.moderationStatus,_that.edited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MemberDto author,  CategoryDto category,  String content,  DateTime createdAt,  List<String> hashtags,  String? contentWarning,  bool allowComments,  String visibility,  List<MediaDto> media,  ReactionSummaryDto? reactions,  int commentsCount,  bool isSaved,  bool isOwn,  String? moderationStatus,  bool edited)  $default,) {final _that = this;
switch (_that) {
case _PostDto():
return $default(_that.id,_that.author,_that.category,_that.content,_that.createdAt,_that.hashtags,_that.contentWarning,_that.allowComments,_that.visibility,_that.media,_that.reactions,_that.commentsCount,_that.isSaved,_that.isOwn,_that.moderationStatus,_that.edited);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MemberDto author,  CategoryDto category,  String content,  DateTime createdAt,  List<String> hashtags,  String? contentWarning,  bool allowComments,  String visibility,  List<MediaDto> media,  ReactionSummaryDto? reactions,  int commentsCount,  bool isSaved,  bool isOwn,  String? moderationStatus,  bool edited)?  $default,) {final _that = this;
switch (_that) {
case _PostDto() when $default != null:
return $default(_that.id,_that.author,_that.category,_that.content,_that.createdAt,_that.hashtags,_that.contentWarning,_that.allowComments,_that.visibility,_that.media,_that.reactions,_that.commentsCount,_that.isSaved,_that.isOwn,_that.moderationStatus,_that.edited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostDto extends PostDto {
  const _PostDto({required this.id, required this.author, required this.category, required this.content, required this.createdAt, final  List<String> hashtags = const <String>[], this.contentWarning, this.allowComments = true, this.visibility = 'community', final  List<MediaDto> media = const <MediaDto>[], this.reactions, this.commentsCount = 0, this.isSaved = false, this.isOwn = false, this.moderationStatus, this.edited = false}): _hashtags = hashtags,_media = media,super._();
  factory _PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

@override final  String id;
@override final  MemberDto author;
@override final  CategoryDto category;
@override final  String content;
@override final  DateTime createdAt;
 final  List<String> _hashtags;
@override@JsonKey() List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

@override final  String? contentWarning;
@override@JsonKey() final  bool allowComments;
@override@JsonKey() final  String visibility;
 final  List<MediaDto> _media;
@override@JsonKey() List<MediaDto> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

@override final  ReactionSummaryDto? reactions;
@override@JsonKey() final  int commentsCount;
@override@JsonKey() final  bool isSaved;
@override@JsonKey() final  bool isOwn;
@override final  String? moderationStatus;
@override@JsonKey() final  bool edited;

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDtoCopyWith<_PostDto> get copyWith => __$PostDtoCopyWithImpl<_PostDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDto&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&(identical(other.contentWarning, contentWarning) || other.contentWarning == contentWarning)&&(identical(other.allowComments, allowComments) || other.allowComments == allowComments)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.reactions, reactions) || other.reactions == reactions)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,category,content,createdAt,const DeepCollectionEquality().hash(_hashtags),contentWarning,allowComments,visibility,const DeepCollectionEquality().hash(_media),reactions,commentsCount,isSaved,isOwn,moderationStatus,edited);

@override
String toString() {
  return 'PostDto(id: $id, author: $author, category: $category, content: $content, createdAt: $createdAt, hashtags: $hashtags, contentWarning: $contentWarning, allowComments: $allowComments, visibility: $visibility, media: $media, reactions: $reactions, commentsCount: $commentsCount, isSaved: $isSaved, isOwn: $isOwn, moderationStatus: $moderationStatus, edited: $edited)';
}


}

/// @nodoc
abstract mixin class _$PostDtoCopyWith<$Res> implements $PostDtoCopyWith<$Res> {
  factory _$PostDtoCopyWith(_PostDto value, $Res Function(_PostDto) _then) = __$PostDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, MemberDto author, CategoryDto category, String content, DateTime createdAt, List<String> hashtags, String? contentWarning, bool allowComments, String visibility, List<MediaDto> media, ReactionSummaryDto? reactions, int commentsCount, bool isSaved, bool isOwn, String? moderationStatus, bool edited
});


@override $MemberDtoCopyWith<$Res> get author;@override $CategoryDtoCopyWith<$Res> get category;@override $ReactionSummaryDtoCopyWith<$Res>? get reactions;

}
/// @nodoc
class __$PostDtoCopyWithImpl<$Res>
    implements _$PostDtoCopyWith<$Res> {
  __$PostDtoCopyWithImpl(this._self, this._then);

  final _PostDto _self;
  final $Res Function(_PostDto) _then;

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? category = null,Object? content = null,Object? createdAt = null,Object? hashtags = null,Object? contentWarning = freezed,Object? allowComments = null,Object? visibility = null,Object? media = null,Object? reactions = freezed,Object? commentsCount = null,Object? isSaved = null,Object? isOwn = null,Object? moderationStatus = freezed,Object? edited = null,}) {
  return _then(_PostDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemberDto,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,contentWarning: freezed == contentWarning ? _self.contentWarning : contentWarning // ignore: cast_nullable_to_non_nullable
as String?,allowComments: null == allowComments ? _self.allowComments : allowComments // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaDto>,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as ReactionSummaryDto?,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,moderationStatus: freezed == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberDtoCopyWith<$Res> get author {
  
  return $MemberDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res> get category {
  
  return $CategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionSummaryDtoCopyWith<$Res>? get reactions {
    if (_self.reactions == null) {
    return null;
  }

  return $ReactionSummaryDtoCopyWith<$Res>(_self.reactions!, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}


/// @nodoc
mixin _$CommentDto {

 String get id; String get postId; DateTime get createdAt; String? get parentId; bool get isRemoved; MemberDto? get author; String? get content; bool get isOwn; bool get isPostAuthor; String? get moderationStatus; int get repliesCount; bool get edited;
/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentDtoCopyWith<CommentDto> get copyWith => _$CommentDtoCopyWithImpl<CommentDto>(this as CommentDto, _$identity);

  /// Serializes this CommentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.isRemoved, isRemoved) || other.isRemoved == isRemoved)&&(identical(other.author, author) || other.author == author)&&(identical(other.content, content) || other.content == content)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.isPostAuthor, isPostAuthor) || other.isPostAuthor == isPostAuthor)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,createdAt,parentId,isRemoved,author,content,isOwn,isPostAuthor,moderationStatus,repliesCount,edited);

@override
String toString() {
  return 'CommentDto(id: $id, postId: $postId, createdAt: $createdAt, parentId: $parentId, isRemoved: $isRemoved, author: $author, content: $content, isOwn: $isOwn, isPostAuthor: $isPostAuthor, moderationStatus: $moderationStatus, repliesCount: $repliesCount, edited: $edited)';
}


}

/// @nodoc
abstract mixin class $CommentDtoCopyWith<$Res>  {
  factory $CommentDtoCopyWith(CommentDto value, $Res Function(CommentDto) _then) = _$CommentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String postId, DateTime createdAt, String? parentId, bool isRemoved, MemberDto? author, String? content, bool isOwn, bool isPostAuthor, String? moderationStatus, int repliesCount, bool edited
});


$MemberDtoCopyWith<$Res>? get author;

}
/// @nodoc
class _$CommentDtoCopyWithImpl<$Res>
    implements $CommentDtoCopyWith<$Res> {
  _$CommentDtoCopyWithImpl(this._self, this._then);

  final CommentDto _self;
  final $Res Function(CommentDto) _then;

/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? createdAt = null,Object? parentId = freezed,Object? isRemoved = null,Object? author = freezed,Object? content = freezed,Object? isOwn = null,Object? isPostAuthor = null,Object? moderationStatus = freezed,Object? repliesCount = null,Object? edited = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,isRemoved: null == isRemoved ? _self.isRemoved : isRemoved // ignore: cast_nullable_to_non_nullable
as bool,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemberDto?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,isPostAuthor: null == isPostAuthor ? _self.isPostAuthor : isPostAuthor // ignore: cast_nullable_to_non_nullable
as bool,moderationStatus: freezed == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String?,repliesCount: null == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberDtoCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $MemberDtoCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentDto].
extension CommentDtoPatterns on CommentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentDto value)  $default,){
final _that = this;
switch (_that) {
case _CommentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentDto value)?  $default,){
final _that = this;
switch (_that) {
case _CommentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postId,  DateTime createdAt,  String? parentId,  bool isRemoved,  MemberDto? author,  String? content,  bool isOwn,  bool isPostAuthor,  String? moderationStatus,  int repliesCount,  bool edited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentDto() when $default != null:
return $default(_that.id,_that.postId,_that.createdAt,_that.parentId,_that.isRemoved,_that.author,_that.content,_that.isOwn,_that.isPostAuthor,_that.moderationStatus,_that.repliesCount,_that.edited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postId,  DateTime createdAt,  String? parentId,  bool isRemoved,  MemberDto? author,  String? content,  bool isOwn,  bool isPostAuthor,  String? moderationStatus,  int repliesCount,  bool edited)  $default,) {final _that = this;
switch (_that) {
case _CommentDto():
return $default(_that.id,_that.postId,_that.createdAt,_that.parentId,_that.isRemoved,_that.author,_that.content,_that.isOwn,_that.isPostAuthor,_that.moderationStatus,_that.repliesCount,_that.edited);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postId,  DateTime createdAt,  String? parentId,  bool isRemoved,  MemberDto? author,  String? content,  bool isOwn,  bool isPostAuthor,  String? moderationStatus,  int repliesCount,  bool edited)?  $default,) {final _that = this;
switch (_that) {
case _CommentDto() when $default != null:
return $default(_that.id,_that.postId,_that.createdAt,_that.parentId,_that.isRemoved,_that.author,_that.content,_that.isOwn,_that.isPostAuthor,_that.moderationStatus,_that.repliesCount,_that.edited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentDto extends CommentDto {
  const _CommentDto({required this.id, required this.postId, required this.createdAt, this.parentId, this.isRemoved = false, this.author, this.content, this.isOwn = false, this.isPostAuthor = false, this.moderationStatus, this.repliesCount = 0, this.edited = false}): super._();
  factory _CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);

@override final  String id;
@override final  String postId;
@override final  DateTime createdAt;
@override final  String? parentId;
@override@JsonKey() final  bool isRemoved;
@override final  MemberDto? author;
@override final  String? content;
@override@JsonKey() final  bool isOwn;
@override@JsonKey() final  bool isPostAuthor;
@override final  String? moderationStatus;
@override@JsonKey() final  int repliesCount;
@override@JsonKey() final  bool edited;

/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentDtoCopyWith<_CommentDto> get copyWith => __$CommentDtoCopyWithImpl<_CommentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.isRemoved, isRemoved) || other.isRemoved == isRemoved)&&(identical(other.author, author) || other.author == author)&&(identical(other.content, content) || other.content == content)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.isPostAuthor, isPostAuthor) || other.isPostAuthor == isPostAuthor)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,createdAt,parentId,isRemoved,author,content,isOwn,isPostAuthor,moderationStatus,repliesCount,edited);

@override
String toString() {
  return 'CommentDto(id: $id, postId: $postId, createdAt: $createdAt, parentId: $parentId, isRemoved: $isRemoved, author: $author, content: $content, isOwn: $isOwn, isPostAuthor: $isPostAuthor, moderationStatus: $moderationStatus, repliesCount: $repliesCount, edited: $edited)';
}


}

/// @nodoc
abstract mixin class _$CommentDtoCopyWith<$Res> implements $CommentDtoCopyWith<$Res> {
  factory _$CommentDtoCopyWith(_CommentDto value, $Res Function(_CommentDto) _then) = __$CommentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, DateTime createdAt, String? parentId, bool isRemoved, MemberDto? author, String? content, bool isOwn, bool isPostAuthor, String? moderationStatus, int repliesCount, bool edited
});


@override $MemberDtoCopyWith<$Res>? get author;

}
/// @nodoc
class __$CommentDtoCopyWithImpl<$Res>
    implements _$CommentDtoCopyWith<$Res> {
  __$CommentDtoCopyWithImpl(this._self, this._then);

  final _CommentDto _self;
  final $Res Function(_CommentDto) _then;

/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? createdAt = null,Object? parentId = freezed,Object? isRemoved = null,Object? author = freezed,Object? content = freezed,Object? isOwn = null,Object? isPostAuthor = null,Object? moderationStatus = freezed,Object? repliesCount = null,Object? edited = null,}) {
  return _then(_CommentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,isRemoved: null == isRemoved ? _self.isRemoved : isRemoved // ignore: cast_nullable_to_non_nullable
as bool,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemberDto?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,isPostAuthor: null == isPostAuthor ? _self.isPostAuthor : isPostAuthor // ignore: cast_nullable_to_non_nullable
as bool,moderationStatus: freezed == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String?,repliesCount: null == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CommentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberDtoCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $MemberDtoCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
