// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressModel {

 String get studentId; String get studentName; String get progressNote; String get whatWasCovered; String get homework; String get rating;
/// Create a copy of ProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressModelCopyWith<ProgressModel> get copyWith => _$ProgressModelCopyWithImpl<ProgressModel>(this as ProgressModel, _$identity);

  /// Serializes this ProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.progressNote, progressNote) || other.progressNote == progressNote)&&(identical(other.whatWasCovered, whatWasCovered) || other.whatWasCovered == whatWasCovered)&&(identical(other.homework, homework) || other.homework == homework)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,studentName,progressNote,whatWasCovered,homework,rating);

@override
String toString() {
  return 'ProgressModel(studentId: $studentId, studentName: $studentName, progressNote: $progressNote, whatWasCovered: $whatWasCovered, homework: $homework, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $ProgressModelCopyWith<$Res>  {
  factory $ProgressModelCopyWith(ProgressModel value, $Res Function(ProgressModel) _then) = _$ProgressModelCopyWithImpl;
@useResult
$Res call({
 String studentId, String studentName, String progressNote, String whatWasCovered, String homework, String rating
});




}
/// @nodoc
class _$ProgressModelCopyWithImpl<$Res>
    implements $ProgressModelCopyWith<$Res> {
  _$ProgressModelCopyWithImpl(this._self, this._then);

  final ProgressModel _self;
  final $Res Function(ProgressModel) _then;

/// Create a copy of ProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? studentName = null,Object? progressNote = null,Object? whatWasCovered = null,Object? homework = null,Object? rating = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,progressNote: null == progressNote ? _self.progressNote : progressNote // ignore: cast_nullable_to_non_nullable
as String,whatWasCovered: null == whatWasCovered ? _self.whatWasCovered : whatWasCovered // ignore: cast_nullable_to_non_nullable
as String,homework: null == homework ? _self.homework : homework // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressModel].
extension ProgressModelPatterns on ProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _ProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String studentName,  String progressNote,  String whatWasCovered,  String homework,  String rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressModel() when $default != null:
return $default(_that.studentId,_that.studentName,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String studentName,  String progressNote,  String whatWasCovered,  String homework,  String rating)  $default,) {final _that = this;
switch (_that) {
case _ProgressModel():
return $default(_that.studentId,_that.studentName,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String studentName,  String progressNote,  String whatWasCovered,  String homework,  String rating)?  $default,) {final _that = this;
switch (_that) {
case _ProgressModel() when $default != null:
return $default(_that.studentId,_that.studentName,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressModel implements ProgressModel {
  const _ProgressModel({required this.studentId, required this.studentName, this.progressNote = '', this.whatWasCovered = '', this.homework = '', this.rating = 'Good'});
  factory _ProgressModel.fromJson(Map<String, dynamic> json) => _$ProgressModelFromJson(json);

@override final  String studentId;
@override final  String studentName;
@override@JsonKey() final  String progressNote;
@override@JsonKey() final  String whatWasCovered;
@override@JsonKey() final  String homework;
@override@JsonKey() final  String rating;

/// Create a copy of ProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressModelCopyWith<_ProgressModel> get copyWith => __$ProgressModelCopyWithImpl<_ProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.progressNote, progressNote) || other.progressNote == progressNote)&&(identical(other.whatWasCovered, whatWasCovered) || other.whatWasCovered == whatWasCovered)&&(identical(other.homework, homework) || other.homework == homework)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,studentName,progressNote,whatWasCovered,homework,rating);

@override
String toString() {
  return 'ProgressModel(studentId: $studentId, studentName: $studentName, progressNote: $progressNote, whatWasCovered: $whatWasCovered, homework: $homework, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$ProgressModelCopyWith<$Res> implements $ProgressModelCopyWith<$Res> {
  factory _$ProgressModelCopyWith(_ProgressModel value, $Res Function(_ProgressModel) _then) = __$ProgressModelCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String studentName, String progressNote, String whatWasCovered, String homework, String rating
});




}
/// @nodoc
class __$ProgressModelCopyWithImpl<$Res>
    implements _$ProgressModelCopyWith<$Res> {
  __$ProgressModelCopyWithImpl(this._self, this._then);

  final _ProgressModel _self;
  final $Res Function(_ProgressModel) _then;

/// Create a copy of ProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? studentName = null,Object? progressNote = null,Object? whatWasCovered = null,Object? homework = null,Object? rating = null,}) {
  return _then(_ProgressModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,progressNote: null == progressNote ? _self.progressNote : progressNote // ignore: cast_nullable_to_non_nullable
as String,whatWasCovered: null == whatWasCovered ? _self.whatWasCovered : whatWasCovered // ignore: cast_nullable_to_non_nullable
as String,homework: null == homework ? _self.homework : homework // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
