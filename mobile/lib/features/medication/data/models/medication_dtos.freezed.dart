// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleDto {

 String get type; List<String> get times; List<int>? get daysOfWeek; int? get intervalDays;
/// Create a copy of ScheduleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDtoCopyWith<ScheduleDto> get copyWith => _$ScheduleDtoCopyWithImpl<ScheduleDto>(this as ScheduleDto, _$identity);

  /// Serializes this ScheduleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDto&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.times, times)&&const DeepCollectionEquality().equals(other.daysOfWeek, daysOfWeek)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(times),const DeepCollectionEquality().hash(daysOfWeek),intervalDays);

@override
String toString() {
  return 'ScheduleDto(type: $type, times: $times, daysOfWeek: $daysOfWeek, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class $ScheduleDtoCopyWith<$Res>  {
  factory $ScheduleDtoCopyWith(ScheduleDto value, $Res Function(ScheduleDto) _then) = _$ScheduleDtoCopyWithImpl;
@useResult
$Res call({
 String type, List<String> times, List<int>? daysOfWeek, int? intervalDays
});




}
/// @nodoc
class _$ScheduleDtoCopyWithImpl<$Res>
    implements $ScheduleDtoCopyWith<$Res> {
  _$ScheduleDtoCopyWithImpl(this._self, this._then);

  final ScheduleDto _self;
  final $Res Function(ScheduleDto) _then;

/// Create a copy of ScheduleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? times = null,Object? daysOfWeek = freezed,Object? intervalDays = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<String>,daysOfWeek: freezed == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>?,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDto].
extension ScheduleDtoPatterns on ScheduleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDto value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDto value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<String> times,  List<int>? daysOfWeek,  int? intervalDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDto() when $default != null:
return $default(_that.type,_that.times,_that.daysOfWeek,_that.intervalDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<String> times,  List<int>? daysOfWeek,  int? intervalDays)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDto():
return $default(_that.type,_that.times,_that.daysOfWeek,_that.intervalDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<String> times,  List<int>? daysOfWeek,  int? intervalDays)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDto() when $default != null:
return $default(_that.type,_that.times,_that.daysOfWeek,_that.intervalDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDto extends ScheduleDto {
  const _ScheduleDto({required this.type, final  List<String> times = const <String>[], final  List<int>? daysOfWeek, this.intervalDays}): _times = times,_daysOfWeek = daysOfWeek,super._();
  factory _ScheduleDto.fromJson(Map<String, dynamic> json) => _$ScheduleDtoFromJson(json);

@override final  String type;
 final  List<String> _times;
@override@JsonKey() List<String> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

 final  List<int>? _daysOfWeek;
@override List<int>? get daysOfWeek {
  final value = _daysOfWeek;
  if (value == null) return null;
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? intervalDays;

/// Create a copy of ScheduleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDtoCopyWith<_ScheduleDto> get copyWith => __$ScheduleDtoCopyWithImpl<_ScheduleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDto&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._times, _times)&&const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_times),const DeepCollectionEquality().hash(_daysOfWeek),intervalDays);

@override
String toString() {
  return 'ScheduleDto(type: $type, times: $times, daysOfWeek: $daysOfWeek, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDtoCopyWith<$Res> implements $ScheduleDtoCopyWith<$Res> {
  factory _$ScheduleDtoCopyWith(_ScheduleDto value, $Res Function(_ScheduleDto) _then) = __$ScheduleDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, List<String> times, List<int>? daysOfWeek, int? intervalDays
});




}
/// @nodoc
class __$ScheduleDtoCopyWithImpl<$Res>
    implements _$ScheduleDtoCopyWith<$Res> {
  __$ScheduleDtoCopyWithImpl(this._self, this._then);

  final _ScheduleDto _self;
  final $Res Function(_ScheduleDto) _then;

/// Create a copy of ScheduleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? times = null,Object? daysOfWeek = freezed,Object? intervalDays = freezed,}) {
  return _then(_ScheduleDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<String>,daysOfWeek: freezed == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>?,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MedicationDto {

 String get id; String get name; String get dosage; String get unit; String get startDate; String get status; String? get endDate; String? get instructions; String? get clinician; String? get notes; bool get remindersEnabled; bool get isCurrent; ScheduleDto? get schedule;
/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDtoCopyWith<MedicationDto> get copyWith => _$MedicationDtoCopyWithImpl<MedicationDto>(this as MedicationDto, _$identity);

  /// Serializes this MedicationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.clinician, clinician) || other.clinician == clinician)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,unit,startDate,status,endDate,instructions,clinician,notes,remindersEnabled,isCurrent,schedule);

@override
String toString() {
  return 'MedicationDto(id: $id, name: $name, dosage: $dosage, unit: $unit, startDate: $startDate, status: $status, endDate: $endDate, instructions: $instructions, clinician: $clinician, notes: $notes, remindersEnabled: $remindersEnabled, isCurrent: $isCurrent, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $MedicationDtoCopyWith<$Res>  {
  factory $MedicationDtoCopyWith(MedicationDto value, $Res Function(MedicationDto) _then) = _$MedicationDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String dosage, String unit, String startDate, String status, String? endDate, String? instructions, String? clinician, String? notes, bool remindersEnabled, bool isCurrent, ScheduleDto? schedule
});


$ScheduleDtoCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$MedicationDtoCopyWithImpl<$Res>
    implements $MedicationDtoCopyWith<$Res> {
  _$MedicationDtoCopyWithImpl(this._self, this._then);

  final MedicationDto _self;
  final $Res Function(MedicationDto) _then;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dosage = null,Object? unit = null,Object? startDate = null,Object? status = null,Object? endDate = freezed,Object? instructions = freezed,Object? clinician = freezed,Object? notes = freezed,Object? remindersEnabled = null,Object? isCurrent = null,Object? schedule = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,clinician: freezed == clinician ? _self.clinician : clinician // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleDto?,
  ));
}
/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleDtoCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleDtoCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationDto].
extension MedicationDtoPatterns on MedicationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationDto value)  $default,){
final _that = this;
switch (_that) {
case _MedicationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationDto value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String dosage,  String unit,  String startDate,  String status,  String? endDate,  String? instructions,  String? clinician,  String? notes,  bool remindersEnabled,  bool isCurrent,  ScheduleDto? schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationDto() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.unit,_that.startDate,_that.status,_that.endDate,_that.instructions,_that.clinician,_that.notes,_that.remindersEnabled,_that.isCurrent,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String dosage,  String unit,  String startDate,  String status,  String? endDate,  String? instructions,  String? clinician,  String? notes,  bool remindersEnabled,  bool isCurrent,  ScheduleDto? schedule)  $default,) {final _that = this;
switch (_that) {
case _MedicationDto():
return $default(_that.id,_that.name,_that.dosage,_that.unit,_that.startDate,_that.status,_that.endDate,_that.instructions,_that.clinician,_that.notes,_that.remindersEnabled,_that.isCurrent,_that.schedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String dosage,  String unit,  String startDate,  String status,  String? endDate,  String? instructions,  String? clinician,  String? notes,  bool remindersEnabled,  bool isCurrent,  ScheduleDto? schedule)?  $default,) {final _that = this;
switch (_that) {
case _MedicationDto() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.unit,_that.startDate,_that.status,_that.endDate,_that.instructions,_that.clinician,_that.notes,_that.remindersEnabled,_that.isCurrent,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationDto extends MedicationDto {
  const _MedicationDto({required this.id, required this.name, required this.dosage, required this.unit, required this.startDate, required this.status, this.endDate, this.instructions, this.clinician, this.notes, this.remindersEnabled = true, this.isCurrent = true, this.schedule}): super._();
  factory _MedicationDto.fromJson(Map<String, dynamic> json) => _$MedicationDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String dosage;
@override final  String unit;
@override final  String startDate;
@override final  String status;
@override final  String? endDate;
@override final  String? instructions;
@override final  String? clinician;
@override final  String? notes;
@override@JsonKey() final  bool remindersEnabled;
@override@JsonKey() final  bool isCurrent;
@override final  ScheduleDto? schedule;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDtoCopyWith<_MedicationDto> get copyWith => __$MedicationDtoCopyWithImpl<_MedicationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.clinician, clinician) || other.clinician == clinician)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,unit,startDate,status,endDate,instructions,clinician,notes,remindersEnabled,isCurrent,schedule);

@override
String toString() {
  return 'MedicationDto(id: $id, name: $name, dosage: $dosage, unit: $unit, startDate: $startDate, status: $status, endDate: $endDate, instructions: $instructions, clinician: $clinician, notes: $notes, remindersEnabled: $remindersEnabled, isCurrent: $isCurrent, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$MedicationDtoCopyWith<$Res> implements $MedicationDtoCopyWith<$Res> {
  factory _$MedicationDtoCopyWith(_MedicationDto value, $Res Function(_MedicationDto) _then) = __$MedicationDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String dosage, String unit, String startDate, String status, String? endDate, String? instructions, String? clinician, String? notes, bool remindersEnabled, bool isCurrent, ScheduleDto? schedule
});


@override $ScheduleDtoCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$MedicationDtoCopyWithImpl<$Res>
    implements _$MedicationDtoCopyWith<$Res> {
  __$MedicationDtoCopyWithImpl(this._self, this._then);

  final _MedicationDto _self;
  final $Res Function(_MedicationDto) _then;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dosage = null,Object? unit = null,Object? startDate = null,Object? status = null,Object? endDate = freezed,Object? instructions = freezed,Object? clinician = freezed,Object? notes = freezed,Object? remindersEnabled = null,Object? isCurrent = null,Object? schedule = freezed,}) {
  return _then(_MedicationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,clinician: freezed == clinician ? _self.clinician : clinician // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleDto?,
  ));
}

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleDtoCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleDtoCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// @nodoc
mixin _$IntakeLogDto {

 String get id; String get medicationId; String get status; DateTime? get scheduledAt; DateTime? get takenAt; String? get notes;
/// Create a copy of IntakeLogDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntakeLogDtoCopyWith<IntakeLogDto> get copyWith => _$IntakeLogDtoCopyWithImpl<IntakeLogDto>(this as IntakeLogDto, _$identity);

  /// Serializes this IntakeLogDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntakeLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,status,scheduledAt,takenAt,notes);

@override
String toString() {
  return 'IntakeLogDto(id: $id, medicationId: $medicationId, status: $status, scheduledAt: $scheduledAt, takenAt: $takenAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $IntakeLogDtoCopyWith<$Res>  {
  factory $IntakeLogDtoCopyWith(IntakeLogDto value, $Res Function(IntakeLogDto) _then) = _$IntakeLogDtoCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, String status, DateTime? scheduledAt, DateTime? takenAt, String? notes
});




}
/// @nodoc
class _$IntakeLogDtoCopyWithImpl<$Res>
    implements $IntakeLogDtoCopyWith<$Res> {
  _$IntakeLogDtoCopyWithImpl(this._self, this._then);

  final IntakeLogDto _self;
  final $Res Function(IntakeLogDto) _then;

/// Create a copy of IntakeLogDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? status = null,Object? scheduledAt = freezed,Object? takenAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IntakeLogDto].
extension IntakeLogDtoPatterns on IntakeLogDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntakeLogDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntakeLogDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntakeLogDto value)  $default,){
final _that = this;
switch (_that) {
case _IntakeLogDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntakeLogDto value)?  $default,){
final _that = this;
switch (_that) {
case _IntakeLogDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  String status,  DateTime? scheduledAt,  DateTime? takenAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntakeLogDto() when $default != null:
return $default(_that.id,_that.medicationId,_that.status,_that.scheduledAt,_that.takenAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  String status,  DateTime? scheduledAt,  DateTime? takenAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _IntakeLogDto():
return $default(_that.id,_that.medicationId,_that.status,_that.scheduledAt,_that.takenAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  String status,  DateTime? scheduledAt,  DateTime? takenAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _IntakeLogDto() when $default != null:
return $default(_that.id,_that.medicationId,_that.status,_that.scheduledAt,_that.takenAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntakeLogDto extends IntakeLogDto {
  const _IntakeLogDto({required this.id, required this.medicationId, required this.status, this.scheduledAt, this.takenAt, this.notes}): super._();
  factory _IntakeLogDto.fromJson(Map<String, dynamic> json) => _$IntakeLogDtoFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  String status;
@override final  DateTime? scheduledAt;
@override final  DateTime? takenAt;
@override final  String? notes;

/// Create a copy of IntakeLogDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntakeLogDtoCopyWith<_IntakeLogDto> get copyWith => __$IntakeLogDtoCopyWithImpl<_IntakeLogDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntakeLogDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntakeLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,status,scheduledAt,takenAt,notes);

@override
String toString() {
  return 'IntakeLogDto(id: $id, medicationId: $medicationId, status: $status, scheduledAt: $scheduledAt, takenAt: $takenAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$IntakeLogDtoCopyWith<$Res> implements $IntakeLogDtoCopyWith<$Res> {
  factory _$IntakeLogDtoCopyWith(_IntakeLogDto value, $Res Function(_IntakeLogDto) _then) = __$IntakeLogDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, String status, DateTime? scheduledAt, DateTime? takenAt, String? notes
});




}
/// @nodoc
class __$IntakeLogDtoCopyWithImpl<$Res>
    implements _$IntakeLogDtoCopyWith<$Res> {
  __$IntakeLogDtoCopyWithImpl(this._self, this._then);

  final _IntakeLogDto _self;
  final $Res Function(_IntakeLogDto) _then;

/// Create a copy of IntakeLogDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? status = null,Object? scheduledAt = freezed,Object? takenAt = freezed,Object? notes = freezed,}) {
  return _then(_IntakeLogDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DoseDto {

 String get medicationId; DateTime get scheduledAt; bool get reminder; IntakeLogDto? get log;
/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseDtoCopyWith<DoseDto> get copyWith => _$DoseDtoCopyWithImpl<DoseDto>(this as DoseDto, _$identity);

  /// Serializes this DoseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseDto&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.log, log) || other.log == log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduledAt,reminder,log);

@override
String toString() {
  return 'DoseDto(medicationId: $medicationId, scheduledAt: $scheduledAt, reminder: $reminder, log: $log)';
}


}

/// @nodoc
abstract mixin class $DoseDtoCopyWith<$Res>  {
  factory $DoseDtoCopyWith(DoseDto value, $Res Function(DoseDto) _then) = _$DoseDtoCopyWithImpl;
@useResult
$Res call({
 String medicationId, DateTime scheduledAt, bool reminder, IntakeLogDto? log
});


$IntakeLogDtoCopyWith<$Res>? get log;

}
/// @nodoc
class _$DoseDtoCopyWithImpl<$Res>
    implements $DoseDtoCopyWith<$Res> {
  _$DoseDtoCopyWithImpl(this._self, this._then);

  final DoseDto _self;
  final $Res Function(DoseDto) _then;

/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? scheduledAt = null,Object? reminder = null,Object? log = freezed,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as bool,log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as IntakeLogDto?,
  ));
}
/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntakeLogDtoCopyWith<$Res>? get log {
    if (_self.log == null) {
    return null;
  }

  return $IntakeLogDtoCopyWith<$Res>(_self.log!, (value) {
    return _then(_self.copyWith(log: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoseDto].
extension DoseDtoPatterns on DoseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseDto value)  $default,){
final _that = this;
switch (_that) {
case _DoseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DoseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  DateTime scheduledAt,  bool reminder,  IntakeLogDto? log)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseDto() when $default != null:
return $default(_that.medicationId,_that.scheduledAt,_that.reminder,_that.log);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  DateTime scheduledAt,  bool reminder,  IntakeLogDto? log)  $default,) {final _that = this;
switch (_that) {
case _DoseDto():
return $default(_that.medicationId,_that.scheduledAt,_that.reminder,_that.log);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  DateTime scheduledAt,  bool reminder,  IntakeLogDto? log)?  $default,) {final _that = this;
switch (_that) {
case _DoseDto() when $default != null:
return $default(_that.medicationId,_that.scheduledAt,_that.reminder,_that.log);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoseDto extends DoseDto {
  const _DoseDto({required this.medicationId, required this.scheduledAt, this.reminder = false, this.log}): super._();
  factory _DoseDto.fromJson(Map<String, dynamic> json) => _$DoseDtoFromJson(json);

@override final  String medicationId;
@override final  DateTime scheduledAt;
@override@JsonKey() final  bool reminder;
@override final  IntakeLogDto? log;

/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseDtoCopyWith<_DoseDto> get copyWith => __$DoseDtoCopyWithImpl<_DoseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseDto&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.log, log) || other.log == log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduledAt,reminder,log);

@override
String toString() {
  return 'DoseDto(medicationId: $medicationId, scheduledAt: $scheduledAt, reminder: $reminder, log: $log)';
}


}

/// @nodoc
abstract mixin class _$DoseDtoCopyWith<$Res> implements $DoseDtoCopyWith<$Res> {
  factory _$DoseDtoCopyWith(_DoseDto value, $Res Function(_DoseDto) _then) = __$DoseDtoCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, DateTime scheduledAt, bool reminder, IntakeLogDto? log
});


@override $IntakeLogDtoCopyWith<$Res>? get log;

}
/// @nodoc
class __$DoseDtoCopyWithImpl<$Res>
    implements _$DoseDtoCopyWith<$Res> {
  __$DoseDtoCopyWithImpl(this._self, this._then);

  final _DoseDto _self;
  final $Res Function(_DoseDto) _then;

/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? scheduledAt = null,Object? reminder = null,Object? log = freezed,}) {
  return _then(_DoseDto(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as bool,log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as IntakeLogDto?,
  ));
}

/// Create a copy of DoseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntakeLogDtoCopyWith<$Res>? get log {
    if (_self.log == null) {
    return null;
  }

  return $IntakeLogDtoCopyWith<$Res>(_self.log!, (value) {
    return _then(_self.copyWith(log: value));
  });
}
}


/// @nodoc
mixin _$ExperienceDto {

 String get id; String get kind; String get description; String get observedOn;
/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceDtoCopyWith<ExperienceDto> get copyWith => _$ExperienceDtoCopyWithImpl<ExperienceDto>(this as ExperienceDto, _$identity);

  /// Serializes this ExperienceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.description, description) || other.description == description)&&(identical(other.observedOn, observedOn) || other.observedOn == observedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,description,observedOn);

@override
String toString() {
  return 'ExperienceDto(id: $id, kind: $kind, description: $description, observedOn: $observedOn)';
}


}

/// @nodoc
abstract mixin class $ExperienceDtoCopyWith<$Res>  {
  factory $ExperienceDtoCopyWith(ExperienceDto value, $Res Function(ExperienceDto) _then) = _$ExperienceDtoCopyWithImpl;
@useResult
$Res call({
 String id, String kind, String description, String observedOn
});




}
/// @nodoc
class _$ExperienceDtoCopyWithImpl<$Res>
    implements $ExperienceDtoCopyWith<$Res> {
  _$ExperienceDtoCopyWithImpl(this._self, this._then);

  final ExperienceDto _self;
  final $Res Function(ExperienceDto) _then;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? description = null,Object? observedOn = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,observedOn: null == observedOn ? _self.observedOn : observedOn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceDto].
extension ExperienceDtoPatterns on ExperienceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceDto value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceDto value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  String description,  String observedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
return $default(_that.id,_that.kind,_that.description,_that.observedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  String description,  String observedOn)  $default,) {final _that = this;
switch (_that) {
case _ExperienceDto():
return $default(_that.id,_that.kind,_that.description,_that.observedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  String description,  String observedOn)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
return $default(_that.id,_that.kind,_that.description,_that.observedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceDto extends ExperienceDto {
  const _ExperienceDto({required this.id, required this.kind, required this.description, required this.observedOn}): super._();
  factory _ExperienceDto.fromJson(Map<String, dynamic> json) => _$ExperienceDtoFromJson(json);

@override final  String id;
@override final  String kind;
@override final  String description;
@override final  String observedOn;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceDtoCopyWith<_ExperienceDto> get copyWith => __$ExperienceDtoCopyWithImpl<_ExperienceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.description, description) || other.description == description)&&(identical(other.observedOn, observedOn) || other.observedOn == observedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,description,observedOn);

@override
String toString() {
  return 'ExperienceDto(id: $id, kind: $kind, description: $description, observedOn: $observedOn)';
}


}

/// @nodoc
abstract mixin class _$ExperienceDtoCopyWith<$Res> implements $ExperienceDtoCopyWith<$Res> {
  factory _$ExperienceDtoCopyWith(_ExperienceDto value, $Res Function(_ExperienceDto) _then) = __$ExperienceDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, String description, String observedOn
});




}
/// @nodoc
class __$ExperienceDtoCopyWithImpl<$Res>
    implements _$ExperienceDtoCopyWith<$Res> {
  __$ExperienceDtoCopyWithImpl(this._self, this._then);

  final _ExperienceDto _self;
  final $Res Function(_ExperienceDto) _then;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? description = null,Object? observedOn = null,}) {
  return _then(_ExperienceDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,observedOn: null == observedOn ? _self.observedOn : observedOn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
