// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoodEntryDto {

 String get id; String get mood; DateTime get recordedAt; int? get score; int? get anxiety; int? get stress; int? get energy; String? get notes;
/// Create a copy of MoodEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoodEntryDtoCopyWith<MoodEntryDto> get copyWith => _$MoodEntryDtoCopyWithImpl<MoodEntryDto>(this as MoodEntryDto, _$identity);

  /// Serializes this MoodEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoodEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.anxiety, anxiety) || other.anxiety == anxiety)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mood,recordedAt,score,anxiety,stress,energy,notes);

@override
String toString() {
  return 'MoodEntryDto(id: $id, mood: $mood, recordedAt: $recordedAt, score: $score, anxiety: $anxiety, stress: $stress, energy: $energy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $MoodEntryDtoCopyWith<$Res>  {
  factory $MoodEntryDtoCopyWith(MoodEntryDto value, $Res Function(MoodEntryDto) _then) = _$MoodEntryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String mood, DateTime recordedAt, int? score, int? anxiety, int? stress, int? energy, String? notes
});




}
/// @nodoc
class _$MoodEntryDtoCopyWithImpl<$Res>
    implements $MoodEntryDtoCopyWith<$Res> {
  _$MoodEntryDtoCopyWithImpl(this._self, this._then);

  final MoodEntryDto _self;
  final $Res Function(MoodEntryDto) _then;

/// Create a copy of MoodEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mood = null,Object? recordedAt = null,Object? score = freezed,Object? anxiety = freezed,Object? stress = freezed,Object? energy = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,anxiety: freezed == anxiety ? _self.anxiety : anxiety // ignore: cast_nullable_to_non_nullable
as int?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoodEntryDto].
extension MoodEntryDtoPatterns on MoodEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoodEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoodEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoodEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _MoodEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoodEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _MoodEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mood,  DateTime recordedAt,  int? score,  int? anxiety,  int? stress,  int? energy,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoodEntryDto() when $default != null:
return $default(_that.id,_that.mood,_that.recordedAt,_that.score,_that.anxiety,_that.stress,_that.energy,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mood,  DateTime recordedAt,  int? score,  int? anxiety,  int? stress,  int? energy,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MoodEntryDto():
return $default(_that.id,_that.mood,_that.recordedAt,_that.score,_that.anxiety,_that.stress,_that.energy,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mood,  DateTime recordedAt,  int? score,  int? anxiety,  int? stress,  int? energy,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MoodEntryDto() when $default != null:
return $default(_that.id,_that.mood,_that.recordedAt,_that.score,_that.anxiety,_that.stress,_that.energy,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoodEntryDto extends MoodEntryDto {
  const _MoodEntryDto({required this.id, required this.mood, required this.recordedAt, this.score, this.anxiety, this.stress, this.energy, this.notes}): super._();
  factory _MoodEntryDto.fromJson(Map<String, dynamic> json) => _$MoodEntryDtoFromJson(json);

@override final  String id;
@override final  String mood;
@override final  DateTime recordedAt;
@override final  int? score;
@override final  int? anxiety;
@override final  int? stress;
@override final  int? energy;
@override final  String? notes;

/// Create a copy of MoodEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoodEntryDtoCopyWith<_MoodEntryDto> get copyWith => __$MoodEntryDtoCopyWithImpl<_MoodEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoodEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoodEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.anxiety, anxiety) || other.anxiety == anxiety)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mood,recordedAt,score,anxiety,stress,energy,notes);

@override
String toString() {
  return 'MoodEntryDto(id: $id, mood: $mood, recordedAt: $recordedAt, score: $score, anxiety: $anxiety, stress: $stress, energy: $energy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MoodEntryDtoCopyWith<$Res> implements $MoodEntryDtoCopyWith<$Res> {
  factory _$MoodEntryDtoCopyWith(_MoodEntryDto value, $Res Function(_MoodEntryDto) _then) = __$MoodEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String mood, DateTime recordedAt, int? score, int? anxiety, int? stress, int? energy, String? notes
});




}
/// @nodoc
class __$MoodEntryDtoCopyWithImpl<$Res>
    implements _$MoodEntryDtoCopyWith<$Res> {
  __$MoodEntryDtoCopyWithImpl(this._self, this._then);

  final _MoodEntryDto _self;
  final $Res Function(_MoodEntryDto) _then;

/// Create a copy of MoodEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mood = null,Object? recordedAt = null,Object? score = freezed,Object? anxiety = freezed,Object? stress = freezed,Object? energy = freezed,Object? notes = freezed,}) {
  return _then(_MoodEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,anxiety: freezed == anxiety ? _self.anxiety : anxiety // ignore: cast_nullable_to_non_nullable
as int?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SymptomCategoryDto {

 String get slug; String get name; String get icon;
/// Create a copy of SymptomCategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SymptomCategoryDtoCopyWith<SymptomCategoryDto> get copyWith => _$SymptomCategoryDtoCopyWithImpl<SymptomCategoryDto>(this as SymptomCategoryDto, _$identity);

  /// Serializes this SymptomCategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SymptomCategoryDto&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,icon);

@override
String toString() {
  return 'SymptomCategoryDto(slug: $slug, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $SymptomCategoryDtoCopyWith<$Res>  {
  factory $SymptomCategoryDtoCopyWith(SymptomCategoryDto value, $Res Function(SymptomCategoryDto) _then) = _$SymptomCategoryDtoCopyWithImpl;
@useResult
$Res call({
 String slug, String name, String icon
});




}
/// @nodoc
class _$SymptomCategoryDtoCopyWithImpl<$Res>
    implements $SymptomCategoryDtoCopyWith<$Res> {
  _$SymptomCategoryDtoCopyWithImpl(this._self, this._then);

  final SymptomCategoryDto _self;
  final $Res Function(SymptomCategoryDto) _then;

/// Create a copy of SymptomCategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,Object? icon = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SymptomCategoryDto].
extension SymptomCategoryDtoPatterns on SymptomCategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SymptomCategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SymptomCategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SymptomCategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _SymptomCategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SymptomCategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SymptomCategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SymptomCategoryDto() when $default != null:
return $default(_that.slug,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name,  String icon)  $default,) {final _that = this;
switch (_that) {
case _SymptomCategoryDto():
return $default(_that.slug,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _SymptomCategoryDto() when $default != null:
return $default(_that.slug,_that.name,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SymptomCategoryDto extends SymptomCategoryDto {
  const _SymptomCategoryDto({required this.slug, required this.name, this.icon = ''}): super._();
  factory _SymptomCategoryDto.fromJson(Map<String, dynamic> json) => _$SymptomCategoryDtoFromJson(json);

@override final  String slug;
@override final  String name;
@override@JsonKey() final  String icon;

/// Create a copy of SymptomCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SymptomCategoryDtoCopyWith<_SymptomCategoryDto> get copyWith => __$SymptomCategoryDtoCopyWithImpl<_SymptomCategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SymptomCategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SymptomCategoryDto&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,icon);

@override
String toString() {
  return 'SymptomCategoryDto(slug: $slug, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$SymptomCategoryDtoCopyWith<$Res> implements $SymptomCategoryDtoCopyWith<$Res> {
  factory _$SymptomCategoryDtoCopyWith(_SymptomCategoryDto value, $Res Function(_SymptomCategoryDto) _then) = __$SymptomCategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name, String icon
});




}
/// @nodoc
class __$SymptomCategoryDtoCopyWithImpl<$Res>
    implements _$SymptomCategoryDtoCopyWith<$Res> {
  __$SymptomCategoryDtoCopyWithImpl(this._self, this._then);

  final _SymptomCategoryDto _self;
  final $Res Function(_SymptomCategoryDto) _then;

/// Create a copy of SymptomCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,Object? icon = null,}) {
  return _then(_SymptomCategoryDto(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SymptomEntryDto {

 String get id; SymptomCategoryDto get category; int get severity; DateTime get recordedAt; int? get durationMinutes; String? get notes;
/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SymptomEntryDtoCopyWith<SymptomEntryDto> get copyWith => _$SymptomEntryDtoCopyWithImpl<SymptomEntryDto>(this as SymptomEntryDto, _$identity);

  /// Serializes this SymptomEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SymptomEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,severity,recordedAt,durationMinutes,notes);

@override
String toString() {
  return 'SymptomEntryDto(id: $id, category: $category, severity: $severity, recordedAt: $recordedAt, durationMinutes: $durationMinutes, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $SymptomEntryDtoCopyWith<$Res>  {
  factory $SymptomEntryDtoCopyWith(SymptomEntryDto value, $Res Function(SymptomEntryDto) _then) = _$SymptomEntryDtoCopyWithImpl;
@useResult
$Res call({
 String id, SymptomCategoryDto category, int severity, DateTime recordedAt, int? durationMinutes, String? notes
});


$SymptomCategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class _$SymptomEntryDtoCopyWithImpl<$Res>
    implements $SymptomEntryDtoCopyWith<$Res> {
  _$SymptomEntryDtoCopyWithImpl(this._self, this._then);

  final SymptomEntryDto _self;
  final $Res Function(SymptomEntryDto) _then;

/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? severity = null,Object? recordedAt = null,Object? durationMinutes = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategoryDto,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SymptomCategoryDtoCopyWith<$Res> get category {
  
  return $SymptomCategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [SymptomEntryDto].
extension SymptomEntryDtoPatterns on SymptomEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SymptomEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SymptomEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SymptomEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _SymptomEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SymptomEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SymptomEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SymptomCategoryDto category,  int severity,  DateTime recordedAt,  int? durationMinutes,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SymptomEntryDto() when $default != null:
return $default(_that.id,_that.category,_that.severity,_that.recordedAt,_that.durationMinutes,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SymptomCategoryDto category,  int severity,  DateTime recordedAt,  int? durationMinutes,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _SymptomEntryDto():
return $default(_that.id,_that.category,_that.severity,_that.recordedAt,_that.durationMinutes,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SymptomCategoryDto category,  int severity,  DateTime recordedAt,  int? durationMinutes,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _SymptomEntryDto() when $default != null:
return $default(_that.id,_that.category,_that.severity,_that.recordedAt,_that.durationMinutes,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SymptomEntryDto extends SymptomEntryDto {
  const _SymptomEntryDto({required this.id, required this.category, required this.severity, required this.recordedAt, this.durationMinutes, this.notes}): super._();
  factory _SymptomEntryDto.fromJson(Map<String, dynamic> json) => _$SymptomEntryDtoFromJson(json);

@override final  String id;
@override final  SymptomCategoryDto category;
@override final  int severity;
@override final  DateTime recordedAt;
@override final  int? durationMinutes;
@override final  String? notes;

/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SymptomEntryDtoCopyWith<_SymptomEntryDto> get copyWith => __$SymptomEntryDtoCopyWithImpl<_SymptomEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SymptomEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SymptomEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,severity,recordedAt,durationMinutes,notes);

@override
String toString() {
  return 'SymptomEntryDto(id: $id, category: $category, severity: $severity, recordedAt: $recordedAt, durationMinutes: $durationMinutes, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SymptomEntryDtoCopyWith<$Res> implements $SymptomEntryDtoCopyWith<$Res> {
  factory _$SymptomEntryDtoCopyWith(_SymptomEntryDto value, $Res Function(_SymptomEntryDto) _then) = __$SymptomEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, SymptomCategoryDto category, int severity, DateTime recordedAt, int? durationMinutes, String? notes
});


@override $SymptomCategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class __$SymptomEntryDtoCopyWithImpl<$Res>
    implements _$SymptomEntryDtoCopyWith<$Res> {
  __$SymptomEntryDtoCopyWithImpl(this._self, this._then);

  final _SymptomEntryDto _self;
  final $Res Function(_SymptomEntryDto) _then;

/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? severity = null,Object? recordedAt = null,Object? durationMinutes = freezed,Object? notes = freezed,}) {
  return _then(_SymptomEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategoryDto,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SymptomEntryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SymptomCategoryDtoCopyWith<$Res> get category {
  
  return $SymptomCategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$SleepEntryDto {

 String get id; int get durationMinutes; DateTime get recordedAt; int? get quality;
/// Create a copy of SleepEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepEntryDtoCopyWith<SleepEntryDto> get copyWith => _$SleepEntryDtoCopyWithImpl<SleepEntryDto>(this as SleepEntryDto, _$identity);

  /// Serializes this SleepEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,durationMinutes,recordedAt,quality);

@override
String toString() {
  return 'SleepEntryDto(id: $id, durationMinutes: $durationMinutes, recordedAt: $recordedAt, quality: $quality)';
}


}

/// @nodoc
abstract mixin class $SleepEntryDtoCopyWith<$Res>  {
  factory $SleepEntryDtoCopyWith(SleepEntryDto value, $Res Function(SleepEntryDto) _then) = _$SleepEntryDtoCopyWithImpl;
@useResult
$Res call({
 String id, int durationMinutes, DateTime recordedAt, int? quality
});




}
/// @nodoc
class _$SleepEntryDtoCopyWithImpl<$Res>
    implements $SleepEntryDtoCopyWith<$Res> {
  _$SleepEntryDtoCopyWithImpl(this._self, this._then);

  final SleepEntryDto _self;
  final $Res Function(SleepEntryDto) _then;

/// Create a copy of SleepEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? durationMinutes = null,Object? recordedAt = null,Object? quality = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepEntryDto].
extension SleepEntryDtoPatterns on SleepEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _SleepEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SleepEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int durationMinutes,  DateTime recordedAt,  int? quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepEntryDto() when $default != null:
return $default(_that.id,_that.durationMinutes,_that.recordedAt,_that.quality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int durationMinutes,  DateTime recordedAt,  int? quality)  $default,) {final _that = this;
switch (_that) {
case _SleepEntryDto():
return $default(_that.id,_that.durationMinutes,_that.recordedAt,_that.quality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int durationMinutes,  DateTime recordedAt,  int? quality)?  $default,) {final _that = this;
switch (_that) {
case _SleepEntryDto() when $default != null:
return $default(_that.id,_that.durationMinutes,_that.recordedAt,_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SleepEntryDto extends SleepEntryDto {
  const _SleepEntryDto({required this.id, required this.durationMinutes, required this.recordedAt, this.quality}): super._();
  factory _SleepEntryDto.fromJson(Map<String, dynamic> json) => _$SleepEntryDtoFromJson(json);

@override final  String id;
@override final  int durationMinutes;
@override final  DateTime recordedAt;
@override final  int? quality;

/// Create a copy of SleepEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepEntryDtoCopyWith<_SleepEntryDto> get copyWith => __$SleepEntryDtoCopyWithImpl<_SleepEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SleepEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,durationMinutes,recordedAt,quality);

@override
String toString() {
  return 'SleepEntryDto(id: $id, durationMinutes: $durationMinutes, recordedAt: $recordedAt, quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$SleepEntryDtoCopyWith<$Res> implements $SleepEntryDtoCopyWith<$Res> {
  factory _$SleepEntryDtoCopyWith(_SleepEntryDto value, $Res Function(_SleepEntryDto) _then) = __$SleepEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, int durationMinutes, DateTime recordedAt, int? quality
});




}
/// @nodoc
class __$SleepEntryDtoCopyWithImpl<$Res>
    implements _$SleepEntryDtoCopyWith<$Res> {
  __$SleepEntryDtoCopyWithImpl(this._self, this._then);

  final _SleepEntryDto _self;
  final $Res Function(_SleepEntryDto) _then;

/// Create a copy of SleepEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? durationMinutes = null,Object? recordedAt = null,Object? quality = freezed,}) {
  return _then(_SleepEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DaySummaryDto {

 String get date; String? get mood; double? get score;
/// Create a copy of DaySummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaySummaryDtoCopyWith<DaySummaryDto> get copyWith => _$DaySummaryDtoCopyWithImpl<DaySummaryDto>(this as DaySummaryDto, _$identity);

  /// Serializes this DaySummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySummaryDto&&(identical(other.date, date) || other.date == date)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,mood,score);

@override
String toString() {
  return 'DaySummaryDto(date: $date, mood: $mood, score: $score)';
}


}

/// @nodoc
abstract mixin class $DaySummaryDtoCopyWith<$Res>  {
  factory $DaySummaryDtoCopyWith(DaySummaryDto value, $Res Function(DaySummaryDto) _then) = _$DaySummaryDtoCopyWithImpl;
@useResult
$Res call({
 String date, String? mood, double? score
});




}
/// @nodoc
class _$DaySummaryDtoCopyWithImpl<$Res>
    implements $DaySummaryDtoCopyWith<$Res> {
  _$DaySummaryDtoCopyWithImpl(this._self, this._then);

  final DaySummaryDto _self;
  final $Res Function(DaySummaryDto) _then;

/// Create a copy of DaySummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? mood = freezed,Object? score = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DaySummaryDto].
extension DaySummaryDtoPatterns on DaySummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _DaySummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _DaySummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String? mood,  double? score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySummaryDto() when $default != null:
return $default(_that.date,_that.mood,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String? mood,  double? score)  $default,) {final _that = this;
switch (_that) {
case _DaySummaryDto():
return $default(_that.date,_that.mood,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String? mood,  double? score)?  $default,) {final _that = this;
switch (_that) {
case _DaySummaryDto() when $default != null:
return $default(_that.date,_that.mood,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DaySummaryDto extends DaySummaryDto {
  const _DaySummaryDto({required this.date, this.mood, this.score}): super._();
  factory _DaySummaryDto.fromJson(Map<String, dynamic> json) => _$DaySummaryDtoFromJson(json);

@override final  String date;
@override final  String? mood;
@override final  double? score;

/// Create a copy of DaySummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaySummaryDtoCopyWith<_DaySummaryDto> get copyWith => __$DaySummaryDtoCopyWithImpl<_DaySummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DaySummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySummaryDto&&(identical(other.date, date) || other.date == date)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,mood,score);

@override
String toString() {
  return 'DaySummaryDto(date: $date, mood: $mood, score: $score)';
}


}

/// @nodoc
abstract mixin class _$DaySummaryDtoCopyWith<$Res> implements $DaySummaryDtoCopyWith<$Res> {
  factory _$DaySummaryDtoCopyWith(_DaySummaryDto value, $Res Function(_DaySummaryDto) _then) = __$DaySummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, String? mood, double? score
});




}
/// @nodoc
class __$DaySummaryDtoCopyWithImpl<$Res>
    implements _$DaySummaryDtoCopyWith<$Res> {
  __$DaySummaryDtoCopyWithImpl(this._self, this._then);

  final _DaySummaryDto _self;
  final $Res Function(_DaySummaryDto) _then;

/// Create a copy of DaySummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? mood = freezed,Object? score = freezed,}) {
  return _then(_DaySummaryDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AveragesDto {

 double? get score; double? get anxiety; double? get stress; double? get energy; double? get sleepHours; double? get sleepQuality;
/// Create a copy of AveragesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AveragesDtoCopyWith<AveragesDto> get copyWith => _$AveragesDtoCopyWithImpl<AveragesDto>(this as AveragesDto, _$identity);

  /// Serializes this AveragesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AveragesDto&&(identical(other.score, score) || other.score == score)&&(identical(other.anxiety, anxiety) || other.anxiety == anxiety)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,anxiety,stress,energy,sleepHours,sleepQuality);

@override
String toString() {
  return 'AveragesDto(score: $score, anxiety: $anxiety, stress: $stress, energy: $energy, sleepHours: $sleepHours, sleepQuality: $sleepQuality)';
}


}

/// @nodoc
abstract mixin class $AveragesDtoCopyWith<$Res>  {
  factory $AveragesDtoCopyWith(AveragesDto value, $Res Function(AveragesDto) _then) = _$AveragesDtoCopyWithImpl;
@useResult
$Res call({
 double? score, double? anxiety, double? stress, double? energy, double? sleepHours, double? sleepQuality
});




}
/// @nodoc
class _$AveragesDtoCopyWithImpl<$Res>
    implements $AveragesDtoCopyWith<$Res> {
  _$AveragesDtoCopyWithImpl(this._self, this._then);

  final AveragesDto _self;
  final $Res Function(AveragesDto) _then;

/// Create a copy of AveragesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = freezed,Object? anxiety = freezed,Object? stress = freezed,Object? energy = freezed,Object? sleepHours = freezed,Object? sleepQuality = freezed,}) {
  return _then(_self.copyWith(
score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,anxiety: freezed == anxiety ? _self.anxiety : anxiety // ignore: cast_nullable_to_non_nullable
as double?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as double?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as double?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double?,sleepQuality: freezed == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AveragesDto].
extension AveragesDtoPatterns on AveragesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AveragesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AveragesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AveragesDto value)  $default,){
final _that = this;
switch (_that) {
case _AveragesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AveragesDto value)?  $default,){
final _that = this;
switch (_that) {
case _AveragesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? score,  double? anxiety,  double? stress,  double? energy,  double? sleepHours,  double? sleepQuality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AveragesDto() when $default != null:
return $default(_that.score,_that.anxiety,_that.stress,_that.energy,_that.sleepHours,_that.sleepQuality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? score,  double? anxiety,  double? stress,  double? energy,  double? sleepHours,  double? sleepQuality)  $default,) {final _that = this;
switch (_that) {
case _AveragesDto():
return $default(_that.score,_that.anxiety,_that.stress,_that.energy,_that.sleepHours,_that.sleepQuality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? score,  double? anxiety,  double? stress,  double? energy,  double? sleepHours,  double? sleepQuality)?  $default,) {final _that = this;
switch (_that) {
case _AveragesDto() when $default != null:
return $default(_that.score,_that.anxiety,_that.stress,_that.energy,_that.sleepHours,_that.sleepQuality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AveragesDto extends AveragesDto {
  const _AveragesDto({this.score, this.anxiety, this.stress, this.energy, this.sleepHours, this.sleepQuality}): super._();
  factory _AveragesDto.fromJson(Map<String, dynamic> json) => _$AveragesDtoFromJson(json);

@override final  double? score;
@override final  double? anxiety;
@override final  double? stress;
@override final  double? energy;
@override final  double? sleepHours;
@override final  double? sleepQuality;

/// Create a copy of AveragesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AveragesDtoCopyWith<_AveragesDto> get copyWith => __$AveragesDtoCopyWithImpl<_AveragesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AveragesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AveragesDto&&(identical(other.score, score) || other.score == score)&&(identical(other.anxiety, anxiety) || other.anxiety == anxiety)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,anxiety,stress,energy,sleepHours,sleepQuality);

@override
String toString() {
  return 'AveragesDto(score: $score, anxiety: $anxiety, stress: $stress, energy: $energy, sleepHours: $sleepHours, sleepQuality: $sleepQuality)';
}


}

/// @nodoc
abstract mixin class _$AveragesDtoCopyWith<$Res> implements $AveragesDtoCopyWith<$Res> {
  factory _$AveragesDtoCopyWith(_AveragesDto value, $Res Function(_AveragesDto) _then) = __$AveragesDtoCopyWithImpl;
@override @useResult
$Res call({
 double? score, double? anxiety, double? stress, double? energy, double? sleepHours, double? sleepQuality
});




}
/// @nodoc
class __$AveragesDtoCopyWithImpl<$Res>
    implements _$AveragesDtoCopyWith<$Res> {
  __$AveragesDtoCopyWithImpl(this._self, this._then);

  final _AveragesDto _self;
  final $Res Function(_AveragesDto) _then;

/// Create a copy of AveragesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = freezed,Object? anxiety = freezed,Object? stress = freezed,Object? energy = freezed,Object? sleepHours = freezed,Object? sleepQuality = freezed,}) {
  return _then(_AveragesDto(
score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,anxiety: freezed == anxiety ? _self.anxiety : anxiety // ignore: cast_nullable_to_non_nullable
as double?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as double?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as double?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double?,sleepQuality: freezed == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$TopSymptomDto {

 SymptomCategoryDto get category; int get count; double get averageSeverity;
/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopSymptomDtoCopyWith<TopSymptomDto> get copyWith => _$TopSymptomDtoCopyWithImpl<TopSymptomDto>(this as TopSymptomDto, _$identity);

  /// Serializes this TopSymptomDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopSymptomDto&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count)&&(identical(other.averageSeverity, averageSeverity) || other.averageSeverity == averageSeverity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,count,averageSeverity);

@override
String toString() {
  return 'TopSymptomDto(category: $category, count: $count, averageSeverity: $averageSeverity)';
}


}

/// @nodoc
abstract mixin class $TopSymptomDtoCopyWith<$Res>  {
  factory $TopSymptomDtoCopyWith(TopSymptomDto value, $Res Function(TopSymptomDto) _then) = _$TopSymptomDtoCopyWithImpl;
@useResult
$Res call({
 SymptomCategoryDto category, int count, double averageSeverity
});


$SymptomCategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class _$TopSymptomDtoCopyWithImpl<$Res>
    implements $TopSymptomDtoCopyWith<$Res> {
  _$TopSymptomDtoCopyWithImpl(this._self, this._then);

  final TopSymptomDto _self;
  final $Res Function(TopSymptomDto) _then;

/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? count = null,Object? averageSeverity = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategoryDto,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,averageSeverity: null == averageSeverity ? _self.averageSeverity : averageSeverity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SymptomCategoryDtoCopyWith<$Res> get category {
  
  return $SymptomCategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [TopSymptomDto].
extension TopSymptomDtoPatterns on TopSymptomDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopSymptomDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopSymptomDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopSymptomDto value)  $default,){
final _that = this;
switch (_that) {
case _TopSymptomDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopSymptomDto value)?  $default,){
final _that = this;
switch (_that) {
case _TopSymptomDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SymptomCategoryDto category,  int count,  double averageSeverity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopSymptomDto() when $default != null:
return $default(_that.category,_that.count,_that.averageSeverity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SymptomCategoryDto category,  int count,  double averageSeverity)  $default,) {final _that = this;
switch (_that) {
case _TopSymptomDto():
return $default(_that.category,_that.count,_that.averageSeverity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SymptomCategoryDto category,  int count,  double averageSeverity)?  $default,) {final _that = this;
switch (_that) {
case _TopSymptomDto() when $default != null:
return $default(_that.category,_that.count,_that.averageSeverity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopSymptomDto implements TopSymptomDto {
  const _TopSymptomDto({required this.category, required this.count, required this.averageSeverity});
  factory _TopSymptomDto.fromJson(Map<String, dynamic> json) => _$TopSymptomDtoFromJson(json);

@override final  SymptomCategoryDto category;
@override final  int count;
@override final  double averageSeverity;

/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopSymptomDtoCopyWith<_TopSymptomDto> get copyWith => __$TopSymptomDtoCopyWithImpl<_TopSymptomDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopSymptomDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopSymptomDto&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count)&&(identical(other.averageSeverity, averageSeverity) || other.averageSeverity == averageSeverity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,count,averageSeverity);

@override
String toString() {
  return 'TopSymptomDto(category: $category, count: $count, averageSeverity: $averageSeverity)';
}


}

/// @nodoc
abstract mixin class _$TopSymptomDtoCopyWith<$Res> implements $TopSymptomDtoCopyWith<$Res> {
  factory _$TopSymptomDtoCopyWith(_TopSymptomDto value, $Res Function(_TopSymptomDto) _then) = __$TopSymptomDtoCopyWithImpl;
@override @useResult
$Res call({
 SymptomCategoryDto category, int count, double averageSeverity
});


@override $SymptomCategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class __$TopSymptomDtoCopyWithImpl<$Res>
    implements _$TopSymptomDtoCopyWith<$Res> {
  __$TopSymptomDtoCopyWithImpl(this._self, this._then);

  final _TopSymptomDto _self;
  final $Res Function(_TopSymptomDto) _then;

/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? count = null,Object? averageSeverity = null,}) {
  return _then(_TopSymptomDto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategoryDto,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,averageSeverity: null == averageSeverity ? _self.averageSeverity : averageSeverity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of TopSymptomDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SymptomCategoryDtoCopyWith<$Res> get category {
  
  return $SymptomCategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$OverviewDto {

 MoodEntryDto? get latest; int get streakDays; int get totalCheckIns;@JsonKey(name: 'last_7_days') List<DaySummaryDto> get lastSevenDays; Map<String, AveragesDto> get averages; List<TopSymptomDto> get topSymptoms;
/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverviewDtoCopyWith<OverviewDto> get copyWith => _$OverviewDtoCopyWithImpl<OverviewDto>(this as OverviewDto, _$identity);

  /// Serializes this OverviewDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverviewDto&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.totalCheckIns, totalCheckIns) || other.totalCheckIns == totalCheckIns)&&const DeepCollectionEquality().equals(other.lastSevenDays, lastSevenDays)&&const DeepCollectionEquality().equals(other.averages, averages)&&const DeepCollectionEquality().equals(other.topSymptoms, topSymptoms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latest,streakDays,totalCheckIns,const DeepCollectionEquality().hash(lastSevenDays),const DeepCollectionEquality().hash(averages),const DeepCollectionEquality().hash(topSymptoms));

@override
String toString() {
  return 'OverviewDto(latest: $latest, streakDays: $streakDays, totalCheckIns: $totalCheckIns, lastSevenDays: $lastSevenDays, averages: $averages, topSymptoms: $topSymptoms)';
}


}

/// @nodoc
abstract mixin class $OverviewDtoCopyWith<$Res>  {
  factory $OverviewDtoCopyWith(OverviewDto value, $Res Function(OverviewDto) _then) = _$OverviewDtoCopyWithImpl;
@useResult
$Res call({
 MoodEntryDto? latest, int streakDays, int totalCheckIns,@JsonKey(name: 'last_7_days') List<DaySummaryDto> lastSevenDays, Map<String, AveragesDto> averages, List<TopSymptomDto> topSymptoms
});


$MoodEntryDtoCopyWith<$Res>? get latest;

}
/// @nodoc
class _$OverviewDtoCopyWithImpl<$Res>
    implements $OverviewDtoCopyWith<$Res> {
  _$OverviewDtoCopyWithImpl(this._self, this._then);

  final OverviewDto _self;
  final $Res Function(OverviewDto) _then;

/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latest = freezed,Object? streakDays = null,Object? totalCheckIns = null,Object? lastSevenDays = null,Object? averages = null,Object? topSymptoms = null,}) {
  return _then(_self.copyWith(
latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as MoodEntryDto?,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,totalCheckIns: null == totalCheckIns ? _self.totalCheckIns : totalCheckIns // ignore: cast_nullable_to_non_nullable
as int,lastSevenDays: null == lastSevenDays ? _self.lastSevenDays : lastSevenDays // ignore: cast_nullable_to_non_nullable
as List<DaySummaryDto>,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as Map<String, AveragesDto>,topSymptoms: null == topSymptoms ? _self.topSymptoms : topSymptoms // ignore: cast_nullable_to_non_nullable
as List<TopSymptomDto>,
  ));
}
/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoodEntryDtoCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $MoodEntryDtoCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [OverviewDto].
extension OverviewDtoPatterns on OverviewDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverviewDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverviewDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverviewDto value)  $default,){
final _that = this;
switch (_that) {
case _OverviewDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverviewDto value)?  $default,){
final _that = this;
switch (_that) {
case _OverviewDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MoodEntryDto? latest,  int streakDays,  int totalCheckIns, @JsonKey(name: 'last_7_days')  List<DaySummaryDto> lastSevenDays,  Map<String, AveragesDto> averages,  List<TopSymptomDto> topSymptoms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverviewDto() when $default != null:
return $default(_that.latest,_that.streakDays,_that.totalCheckIns,_that.lastSevenDays,_that.averages,_that.topSymptoms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MoodEntryDto? latest,  int streakDays,  int totalCheckIns, @JsonKey(name: 'last_7_days')  List<DaySummaryDto> lastSevenDays,  Map<String, AveragesDto> averages,  List<TopSymptomDto> topSymptoms)  $default,) {final _that = this;
switch (_that) {
case _OverviewDto():
return $default(_that.latest,_that.streakDays,_that.totalCheckIns,_that.lastSevenDays,_that.averages,_that.topSymptoms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MoodEntryDto? latest,  int streakDays,  int totalCheckIns, @JsonKey(name: 'last_7_days')  List<DaySummaryDto> lastSevenDays,  Map<String, AveragesDto> averages,  List<TopSymptomDto> topSymptoms)?  $default,) {final _that = this;
switch (_that) {
case _OverviewDto() when $default != null:
return $default(_that.latest,_that.streakDays,_that.totalCheckIns,_that.lastSevenDays,_that.averages,_that.topSymptoms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverviewDto extends OverviewDto {
  const _OverviewDto({this.latest, this.streakDays = 0, this.totalCheckIns = 0, @JsonKey(name: 'last_7_days') final  List<DaySummaryDto> lastSevenDays = const <DaySummaryDto>[], final  Map<String, AveragesDto> averages = const <String, AveragesDto>{}, final  List<TopSymptomDto> topSymptoms = const <TopSymptomDto>[]}): _lastSevenDays = lastSevenDays,_averages = averages,_topSymptoms = topSymptoms,super._();
  factory _OverviewDto.fromJson(Map<String, dynamic> json) => _$OverviewDtoFromJson(json);

@override final  MoodEntryDto? latest;
@override@JsonKey() final  int streakDays;
@override@JsonKey() final  int totalCheckIns;
 final  List<DaySummaryDto> _lastSevenDays;
@override@JsonKey(name: 'last_7_days') List<DaySummaryDto> get lastSevenDays {
  if (_lastSevenDays is EqualUnmodifiableListView) return _lastSevenDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastSevenDays);
}

 final  Map<String, AveragesDto> _averages;
@override@JsonKey() Map<String, AveragesDto> get averages {
  if (_averages is EqualUnmodifiableMapView) return _averages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_averages);
}

 final  List<TopSymptomDto> _topSymptoms;
@override@JsonKey() List<TopSymptomDto> get topSymptoms {
  if (_topSymptoms is EqualUnmodifiableListView) return _topSymptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topSymptoms);
}


/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewDtoCopyWith<_OverviewDto> get copyWith => __$OverviewDtoCopyWithImpl<_OverviewDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverviewDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverviewDto&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.totalCheckIns, totalCheckIns) || other.totalCheckIns == totalCheckIns)&&const DeepCollectionEquality().equals(other._lastSevenDays, _lastSevenDays)&&const DeepCollectionEquality().equals(other._averages, _averages)&&const DeepCollectionEquality().equals(other._topSymptoms, _topSymptoms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latest,streakDays,totalCheckIns,const DeepCollectionEquality().hash(_lastSevenDays),const DeepCollectionEquality().hash(_averages),const DeepCollectionEquality().hash(_topSymptoms));

@override
String toString() {
  return 'OverviewDto(latest: $latest, streakDays: $streakDays, totalCheckIns: $totalCheckIns, lastSevenDays: $lastSevenDays, averages: $averages, topSymptoms: $topSymptoms)';
}


}

/// @nodoc
abstract mixin class _$OverviewDtoCopyWith<$Res> implements $OverviewDtoCopyWith<$Res> {
  factory _$OverviewDtoCopyWith(_OverviewDto value, $Res Function(_OverviewDto) _then) = __$OverviewDtoCopyWithImpl;
@override @useResult
$Res call({
 MoodEntryDto? latest, int streakDays, int totalCheckIns,@JsonKey(name: 'last_7_days') List<DaySummaryDto> lastSevenDays, Map<String, AveragesDto> averages, List<TopSymptomDto> topSymptoms
});


@override $MoodEntryDtoCopyWith<$Res>? get latest;

}
/// @nodoc
class __$OverviewDtoCopyWithImpl<$Res>
    implements _$OverviewDtoCopyWith<$Res> {
  __$OverviewDtoCopyWithImpl(this._self, this._then);

  final _OverviewDto _self;
  final $Res Function(_OverviewDto) _then;

/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latest = freezed,Object? streakDays = null,Object? totalCheckIns = null,Object? lastSevenDays = null,Object? averages = null,Object? topSymptoms = null,}) {
  return _then(_OverviewDto(
latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as MoodEntryDto?,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,totalCheckIns: null == totalCheckIns ? _self.totalCheckIns : totalCheckIns // ignore: cast_nullable_to_non_nullable
as int,lastSevenDays: null == lastSevenDays ? _self._lastSevenDays : lastSevenDays // ignore: cast_nullable_to_non_nullable
as List<DaySummaryDto>,averages: null == averages ? _self._averages : averages // ignore: cast_nullable_to_non_nullable
as Map<String, AveragesDto>,topSymptoms: null == topSymptoms ? _self._topSymptoms : topSymptoms // ignore: cast_nullable_to_non_nullable
as List<TopSymptomDto>,
  ));
}

/// Create a copy of OverviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoodEntryDtoCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $MoodEntryDtoCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// @nodoc
mixin _$InsightDto {

 String get key; String get text; String get kind;
/// Create a copy of InsightDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightDtoCopyWith<InsightDto> get copyWith => _$InsightDtoCopyWithImpl<InsightDto>(this as InsightDto, _$identity);

  /// Serializes this InsightDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightDto&&(identical(other.key, key) || other.key == key)&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,text,kind);

@override
String toString() {
  return 'InsightDto(key: $key, text: $text, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $InsightDtoCopyWith<$Res>  {
  factory $InsightDtoCopyWith(InsightDto value, $Res Function(InsightDto) _then) = _$InsightDtoCopyWithImpl;
@useResult
$Res call({
 String key, String text, String kind
});




}
/// @nodoc
class _$InsightDtoCopyWithImpl<$Res>
    implements $InsightDtoCopyWith<$Res> {
  _$InsightDtoCopyWithImpl(this._self, this._then);

  final InsightDto _self;
  final $Res Function(InsightDto) _then;

/// Create a copy of InsightDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? text = null,Object? kind = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InsightDto].
extension InsightDtoPatterns on InsightDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightDto value)  $default,){
final _that = this;
switch (_that) {
case _InsightDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightDto value)?  $default,){
final _that = this;
switch (_that) {
case _InsightDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String text,  String kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightDto() when $default != null:
return $default(_that.key,_that.text,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String text,  String kind)  $default,) {final _that = this;
switch (_that) {
case _InsightDto():
return $default(_that.key,_that.text,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String text,  String kind)?  $default,) {final _that = this;
switch (_that) {
case _InsightDto() when $default != null:
return $default(_that.key,_that.text,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightDto implements InsightDto {
  const _InsightDto({required this.key, required this.text, this.kind = 'observation'});
  factory _InsightDto.fromJson(Map<String, dynamic> json) => _$InsightDtoFromJson(json);

@override final  String key;
@override final  String text;
@override@JsonKey() final  String kind;

/// Create a copy of InsightDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightDtoCopyWith<_InsightDto> get copyWith => __$InsightDtoCopyWithImpl<_InsightDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightDto&&(identical(other.key, key) || other.key == key)&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,text,kind);

@override
String toString() {
  return 'InsightDto(key: $key, text: $text, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$InsightDtoCopyWith<$Res> implements $InsightDtoCopyWith<$Res> {
  factory _$InsightDtoCopyWith(_InsightDto value, $Res Function(_InsightDto) _then) = __$InsightDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String text, String kind
});




}
/// @nodoc
class __$InsightDtoCopyWithImpl<$Res>
    implements _$InsightDtoCopyWith<$Res> {
  __$InsightDtoCopyWithImpl(this._self, this._then);

  final _InsightDto _self;
  final $Res Function(_InsightDto) _then;

/// Create a copy of InsightDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? text = null,Object? kind = null,}) {
  return _then(_InsightDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InsightsDto {

 List<InsightDto> get items; String get disclaimer; bool get refreshing;
/// Create a copy of InsightsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightsDtoCopyWith<InsightsDto> get copyWith => _$InsightsDtoCopyWithImpl<InsightsDto>(this as InsightsDto, _$identity);

  /// Serializes this InsightsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightsDto&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),disclaimer,refreshing);

@override
String toString() {
  return 'InsightsDto(items: $items, disclaimer: $disclaimer, refreshing: $refreshing)';
}


}

/// @nodoc
abstract mixin class $InsightsDtoCopyWith<$Res>  {
  factory $InsightsDtoCopyWith(InsightsDto value, $Res Function(InsightsDto) _then) = _$InsightsDtoCopyWithImpl;
@useResult
$Res call({
 List<InsightDto> items, String disclaimer, bool refreshing
});




}
/// @nodoc
class _$InsightsDtoCopyWithImpl<$Res>
    implements $InsightsDtoCopyWith<$Res> {
  _$InsightsDtoCopyWithImpl(this._self, this._then);

  final InsightsDto _self;
  final $Res Function(InsightsDto) _then;

/// Create a copy of InsightsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? disclaimer = null,Object? refreshing = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InsightDto>,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InsightsDto].
extension InsightsDtoPatterns on InsightsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightsDto value)  $default,){
final _that = this;
switch (_that) {
case _InsightsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightsDto value)?  $default,){
final _that = this;
switch (_that) {
case _InsightsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InsightDto> items,  String disclaimer,  bool refreshing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightsDto() when $default != null:
return $default(_that.items,_that.disclaimer,_that.refreshing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InsightDto> items,  String disclaimer,  bool refreshing)  $default,) {final _that = this;
switch (_that) {
case _InsightsDto():
return $default(_that.items,_that.disclaimer,_that.refreshing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InsightDto> items,  String disclaimer,  bool refreshing)?  $default,) {final _that = this;
switch (_that) {
case _InsightsDto() when $default != null:
return $default(_that.items,_that.disclaimer,_that.refreshing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightsDto extends InsightsDto {
  const _InsightsDto({final  List<InsightDto> items = const <InsightDto>[], this.disclaimer = '', this.refreshing = false}): _items = items,super._();
  factory _InsightsDto.fromJson(Map<String, dynamic> json) => _$InsightsDtoFromJson(json);

 final  List<InsightDto> _items;
@override@JsonKey() List<InsightDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String disclaimer;
@override@JsonKey() final  bool refreshing;

/// Create a copy of InsightsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightsDtoCopyWith<_InsightsDto> get copyWith => __$InsightsDtoCopyWithImpl<_InsightsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightsDto&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),disclaimer,refreshing);

@override
String toString() {
  return 'InsightsDto(items: $items, disclaimer: $disclaimer, refreshing: $refreshing)';
}


}

/// @nodoc
abstract mixin class _$InsightsDtoCopyWith<$Res> implements $InsightsDtoCopyWith<$Res> {
  factory _$InsightsDtoCopyWith(_InsightsDto value, $Res Function(_InsightsDto) _then) = __$InsightsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<InsightDto> items, String disclaimer, bool refreshing
});




}
/// @nodoc
class __$InsightsDtoCopyWithImpl<$Res>
    implements _$InsightsDtoCopyWith<$Res> {
  __$InsightsDtoCopyWithImpl(this._self, this._then);

  final _InsightsDto _self;
  final $Res Function(_InsightsDto) _then;

/// Create a copy of InsightsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? disclaimer = null,Object? refreshing = null,}) {
  return _then(_InsightsDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InsightDto>,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
