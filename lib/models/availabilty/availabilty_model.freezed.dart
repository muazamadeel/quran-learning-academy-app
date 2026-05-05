// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availabilty_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeSlotModel {

 String get id; String get startTime; String get endTime; bool get isAvailable;
/// Create a copy of TimeSlotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotModelCopyWith<TimeSlotModel> get copyWith => _$TimeSlotModelCopyWithImpl<TimeSlotModel>(this as TimeSlotModel, _$identity);

  /// Serializes this TimeSlotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startTime,endTime,isAvailable);

@override
String toString() {
  return 'TimeSlotModel(id: $id, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $TimeSlotModelCopyWith<$Res>  {
  factory $TimeSlotModelCopyWith(TimeSlotModel value, $Res Function(TimeSlotModel) _then) = _$TimeSlotModelCopyWithImpl;
@useResult
$Res call({
 String id, String startTime, String endTime, bool isAvailable
});




}
/// @nodoc
class _$TimeSlotModelCopyWithImpl<$Res>
    implements $TimeSlotModelCopyWith<$Res> {
  _$TimeSlotModelCopyWithImpl(this._self, this._then);

  final TimeSlotModel _self;
  final $Res Function(TimeSlotModel) _then;

/// Create a copy of TimeSlotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startTime = null,Object? endTime = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSlotModel].
extension TimeSlotModelPatterns on TimeSlotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlotModel value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlotModel value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String startTime,  String endTime,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlotModel() when $default != null:
return $default(_that.id,_that.startTime,_that.endTime,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String startTime,  String endTime,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _TimeSlotModel():
return $default(_that.id,_that.startTime,_that.endTime,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String startTime,  String endTime,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlotModel() when $default != null:
return $default(_that.id,_that.startTime,_that.endTime,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSlotModel implements TimeSlotModel {
  const _TimeSlotModel({required this.id, required this.startTime, required this.endTime, this.isAvailable = true});
  factory _TimeSlotModel.fromJson(Map<String, dynamic> json) => _$TimeSlotModelFromJson(json);

@override final  String id;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of TimeSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotModelCopyWith<_TimeSlotModel> get copyWith => __$TimeSlotModelCopyWithImpl<_TimeSlotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSlotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startTime,endTime,isAvailable);

@override
String toString() {
  return 'TimeSlotModel(id: $id, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotModelCopyWith<$Res> implements $TimeSlotModelCopyWith<$Res> {
  factory _$TimeSlotModelCopyWith(_TimeSlotModel value, $Res Function(_TimeSlotModel) _then) = __$TimeSlotModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String startTime, String endTime, bool isAvailable
});




}
/// @nodoc
class __$TimeSlotModelCopyWithImpl<$Res>
    implements _$TimeSlotModelCopyWith<$Res> {
  __$TimeSlotModelCopyWithImpl(this._self, this._then);

  final _TimeSlotModel _self;
  final $Res Function(_TimeSlotModel) _then;

/// Create a copy of TimeSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startTime = null,Object? endTime = null,Object? isAvailable = null,}) {
  return _then(_TimeSlotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DayAvailabilityModel {

 String get day; String get timeRange; bool get isEnabled;
/// Create a copy of DayAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayAvailabilityModelCopyWith<DayAvailabilityModel> get copyWith => _$DayAvailabilityModelCopyWithImpl<DayAvailabilityModel>(this as DayAvailabilityModel, _$identity);

  /// Serializes this DayAvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayAvailabilityModel&&(identical(other.day, day) || other.day == day)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,timeRange,isEnabled);

@override
String toString() {
  return 'DayAvailabilityModel(day: $day, timeRange: $timeRange, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $DayAvailabilityModelCopyWith<$Res>  {
  factory $DayAvailabilityModelCopyWith(DayAvailabilityModel value, $Res Function(DayAvailabilityModel) _then) = _$DayAvailabilityModelCopyWithImpl;
@useResult
$Res call({
 String day, String timeRange, bool isEnabled
});




}
/// @nodoc
class _$DayAvailabilityModelCopyWithImpl<$Res>
    implements $DayAvailabilityModelCopyWith<$Res> {
  _$DayAvailabilityModelCopyWithImpl(this._self, this._then);

  final DayAvailabilityModel _self;
  final $Res Function(DayAvailabilityModel) _then;

/// Create a copy of DayAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? timeRange = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DayAvailabilityModel].
extension DayAvailabilityModelPatterns on DayAvailabilityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayAvailabilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayAvailabilityModel value)  $default,){
final _that = this;
switch (_that) {
case _DayAvailabilityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayAvailabilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _DayAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String day,  String timeRange,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayAvailabilityModel() when $default != null:
return $default(_that.day,_that.timeRange,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String day,  String timeRange,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _DayAvailabilityModel():
return $default(_that.day,_that.timeRange,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String day,  String timeRange,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _DayAvailabilityModel() when $default != null:
return $default(_that.day,_that.timeRange,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayAvailabilityModel implements DayAvailabilityModel {
  const _DayAvailabilityModel({required this.day, required this.timeRange, this.isEnabled = true});
  factory _DayAvailabilityModel.fromJson(Map<String, dynamic> json) => _$DayAvailabilityModelFromJson(json);

@override final  String day;
@override final  String timeRange;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of DayAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayAvailabilityModelCopyWith<_DayAvailabilityModel> get copyWith => __$DayAvailabilityModelCopyWithImpl<_DayAvailabilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayAvailabilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayAvailabilityModel&&(identical(other.day, day) || other.day == day)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,timeRange,isEnabled);

@override
String toString() {
  return 'DayAvailabilityModel(day: $day, timeRange: $timeRange, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$DayAvailabilityModelCopyWith<$Res> implements $DayAvailabilityModelCopyWith<$Res> {
  factory _$DayAvailabilityModelCopyWith(_DayAvailabilityModel value, $Res Function(_DayAvailabilityModel) _then) = __$DayAvailabilityModelCopyWithImpl;
@override @useResult
$Res call({
 String day, String timeRange, bool isEnabled
});




}
/// @nodoc
class __$DayAvailabilityModelCopyWithImpl<$Res>
    implements _$DayAvailabilityModelCopyWith<$Res> {
  __$DayAvailabilityModelCopyWithImpl(this._self, this._then);

  final _DayAvailabilityModel _self;
  final $Res Function(_DayAvailabilityModel) _then;

/// Create a copy of DayAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? timeRange = null,Object? isEnabled = null,}) {
  return _then(_DayAvailabilityModel(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AvailabilityModel {

 String get teacherId; List<DayAvailabilityModel> get days; bool get isSaved;
/// Create a copy of AvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityModelCopyWith<AvailabilityModel> get copyWith => _$AvailabilityModelCopyWithImpl<AvailabilityModel>(this as AvailabilityModel, _$identity);

  /// Serializes this AvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityModel&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teacherId,const DeepCollectionEquality().hash(days),isSaved);

@override
String toString() {
  return 'AvailabilityModel(teacherId: $teacherId, days: $days, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $AvailabilityModelCopyWith<$Res>  {
  factory $AvailabilityModelCopyWith(AvailabilityModel value, $Res Function(AvailabilityModel) _then) = _$AvailabilityModelCopyWithImpl;
@useResult
$Res call({
 String teacherId, List<DayAvailabilityModel> days, bool isSaved
});




}
/// @nodoc
class _$AvailabilityModelCopyWithImpl<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  _$AvailabilityModelCopyWithImpl(this._self, this._then);

  final AvailabilityModel _self;
  final $Res Function(AvailabilityModel) _then;

/// Create a copy of AvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teacherId = null,Object? days = null,Object? isSaved = null,}) {
  return _then(_self.copyWith(
teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DayAvailabilityModel>,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityModel].
extension AvailabilityModelPatterns on AvailabilityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityModel value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teacherId,  List<DayAvailabilityModel> days,  bool isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityModel() when $default != null:
return $default(_that.teacherId,_that.days,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teacherId,  List<DayAvailabilityModel> days,  bool isSaved)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityModel():
return $default(_that.teacherId,_that.days,_that.isSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teacherId,  List<DayAvailabilityModel> days,  bool isSaved)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityModel() when $default != null:
return $default(_that.teacherId,_that.days,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityModel implements AvailabilityModel {
  const _AvailabilityModel({required this.teacherId, required final  List<DayAvailabilityModel> days, this.isSaved = false}): _days = days;
  factory _AvailabilityModel.fromJson(Map<String, dynamic> json) => _$AvailabilityModelFromJson(json);

@override final  String teacherId;
 final  List<DayAvailabilityModel> _days;
@override List<DayAvailabilityModel> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override@JsonKey() final  bool isSaved;

/// Create a copy of AvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityModelCopyWith<_AvailabilityModel> get copyWith => __$AvailabilityModelCopyWithImpl<_AvailabilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityModel&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teacherId,const DeepCollectionEquality().hash(_days),isSaved);

@override
String toString() {
  return 'AvailabilityModel(teacherId: $teacherId, days: $days, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityModelCopyWith<$Res> implements $AvailabilityModelCopyWith<$Res> {
  factory _$AvailabilityModelCopyWith(_AvailabilityModel value, $Res Function(_AvailabilityModel) _then) = __$AvailabilityModelCopyWithImpl;
@override @useResult
$Res call({
 String teacherId, List<DayAvailabilityModel> days, bool isSaved
});




}
/// @nodoc
class __$AvailabilityModelCopyWithImpl<$Res>
    implements _$AvailabilityModelCopyWith<$Res> {
  __$AvailabilityModelCopyWithImpl(this._self, this._then);

  final _AvailabilityModel _self;
  final $Res Function(_AvailabilityModel) _then;

/// Create a copy of AvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teacherId = null,Object? days = null,Object? isSaved = null,}) {
  return _then(_AvailabilityModel(
teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DayAvailabilityModel>,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
