// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClassModel {

 String get studentName; String get subject; String get time; String get notes; bool get isMuted; bool get isVideoOn; bool get isScreenSharing;
/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassModelCopyWith<ClassModel> get copyWith => _$ClassModelCopyWithImpl<ClassModel>(this as ClassModel, _$identity);

  /// Serializes this ClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassModel&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.time, time) || other.time == time)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isVideoOn, isVideoOn) || other.isVideoOn == isVideoOn)&&(identical(other.isScreenSharing, isScreenSharing) || other.isScreenSharing == isScreenSharing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentName,subject,time,notes,isMuted,isVideoOn,isScreenSharing);

@override
String toString() {
  return 'ClassModel(studentName: $studentName, subject: $subject, time: $time, notes: $notes, isMuted: $isMuted, isVideoOn: $isVideoOn, isScreenSharing: $isScreenSharing)';
}


}

/// @nodoc
abstract mixin class $ClassModelCopyWith<$Res>  {
  factory $ClassModelCopyWith(ClassModel value, $Res Function(ClassModel) _then) = _$ClassModelCopyWithImpl;
@useResult
$Res call({
 String studentName, String subject, String time, String notes, bool isMuted, bool isVideoOn, bool isScreenSharing
});




}
/// @nodoc
class _$ClassModelCopyWithImpl<$Res>
    implements $ClassModelCopyWith<$Res> {
  _$ClassModelCopyWithImpl(this._self, this._then);

  final ClassModel _self;
  final $Res Function(ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentName = null,Object? subject = null,Object? time = null,Object? notes = null,Object? isMuted = null,Object? isVideoOn = null,Object? isScreenSharing = null,}) {
  return _then(_self.copyWith(
studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoOn: null == isVideoOn ? _self.isVideoOn : isVideoOn // ignore: cast_nullable_to_non_nullable
as bool,isScreenSharing: null == isScreenSharing ? _self.isScreenSharing : isScreenSharing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassModel].
extension ClassModelPatterns on ClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassModel value)  $default,){
final _that = this;
switch (_that) {
case _ClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentName,  String subject,  String time,  String notes,  bool isMuted,  bool isVideoOn,  bool isScreenSharing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.studentName,_that.subject,_that.time,_that.notes,_that.isMuted,_that.isVideoOn,_that.isScreenSharing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentName,  String subject,  String time,  String notes,  bool isMuted,  bool isVideoOn,  bool isScreenSharing)  $default,) {final _that = this;
switch (_that) {
case _ClassModel():
return $default(_that.studentName,_that.subject,_that.time,_that.notes,_that.isMuted,_that.isVideoOn,_that.isScreenSharing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentName,  String subject,  String time,  String notes,  bool isMuted,  bool isVideoOn,  bool isScreenSharing)?  $default,) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.studentName,_that.subject,_that.time,_that.notes,_that.isMuted,_that.isVideoOn,_that.isScreenSharing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassModel implements ClassModel {
  const _ClassModel({required this.studentName, required this.subject, required this.time, this.notes = '', this.isMuted = false, this.isVideoOn = true, this.isScreenSharing = false});
  factory _ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);

@override final  String studentName;
@override final  String subject;
@override final  String time;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isVideoOn;
@override@JsonKey() final  bool isScreenSharing;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassModelCopyWith<_ClassModel> get copyWith => __$ClassModelCopyWithImpl<_ClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassModel&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.time, time) || other.time == time)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isVideoOn, isVideoOn) || other.isVideoOn == isVideoOn)&&(identical(other.isScreenSharing, isScreenSharing) || other.isScreenSharing == isScreenSharing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentName,subject,time,notes,isMuted,isVideoOn,isScreenSharing);

@override
String toString() {
  return 'ClassModel(studentName: $studentName, subject: $subject, time: $time, notes: $notes, isMuted: $isMuted, isVideoOn: $isVideoOn, isScreenSharing: $isScreenSharing)';
}


}

/// @nodoc
abstract mixin class _$ClassModelCopyWith<$Res> implements $ClassModelCopyWith<$Res> {
  factory _$ClassModelCopyWith(_ClassModel value, $Res Function(_ClassModel) _then) = __$ClassModelCopyWithImpl;
@override @useResult
$Res call({
 String studentName, String subject, String time, String notes, bool isMuted, bool isVideoOn, bool isScreenSharing
});




}
/// @nodoc
class __$ClassModelCopyWithImpl<$Res>
    implements _$ClassModelCopyWith<$Res> {
  __$ClassModelCopyWithImpl(this._self, this._then);

  final _ClassModel _self;
  final $Res Function(_ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentName = null,Object? subject = null,Object? time = null,Object? notes = null,Object? isMuted = null,Object? isVideoOn = null,Object? isScreenSharing = null,}) {
  return _then(_ClassModel(
studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoOn: null == isVideoOn ? _self.isVideoOn : isVideoOn // ignore: cast_nullable_to_non_nullable
as bool,isScreenSharing: null == isScreenSharing ? _self.isScreenSharing : isScreenSharing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
