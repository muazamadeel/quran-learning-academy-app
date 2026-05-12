// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_class_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherClassModel {

 String get id; String get studentName; String get subject; DateTime get scheduledAt; String get status; String? get studentAvatarUrl; double? get studentRating; String? get studentReview; int? get durationMinutes; String? get meetingLink; String? get studentId; String? get teacherId;
/// Create a copy of TeacherClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherClassModelCopyWith<TeacherClassModel> get copyWith => _$TeacherClassModelCopyWithImpl<TeacherClassModel>(this as TeacherClassModel, _$identity);

  /// Serializes this TeacherClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentAvatarUrl, studentAvatarUrl) || other.studentAvatarUrl == studentAvatarUrl)&&(identical(other.studentRating, studentRating) || other.studentRating == studentRating)&&(identical(other.studentReview, studentReview) || other.studentReview == studentReview)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentName,subject,scheduledAt,status,studentAvatarUrl,studentRating,studentReview,durationMinutes,meetingLink,studentId,teacherId);

@override
String toString() {
  return 'TeacherClassModel(id: $id, studentName: $studentName, subject: $subject, scheduledAt: $scheduledAt, status: $status, studentAvatarUrl: $studentAvatarUrl, studentRating: $studentRating, studentReview: $studentReview, durationMinutes: $durationMinutes, meetingLink: $meetingLink, studentId: $studentId, teacherId: $teacherId)';
}


}

/// @nodoc
abstract mixin class $TeacherClassModelCopyWith<$Res>  {
  factory $TeacherClassModelCopyWith(TeacherClassModel value, $Res Function(TeacherClassModel) _then) = _$TeacherClassModelCopyWithImpl;
@useResult
$Res call({
 String id, String studentName, String subject, DateTime scheduledAt, String status, String? studentAvatarUrl, double? studentRating, String? studentReview, int? durationMinutes, String? meetingLink, String? studentId, String? teacherId
});




}
/// @nodoc
class _$TeacherClassModelCopyWithImpl<$Res>
    implements $TeacherClassModelCopyWith<$Res> {
  _$TeacherClassModelCopyWithImpl(this._self, this._then);

  final TeacherClassModel _self;
  final $Res Function(TeacherClassModel) _then;

/// Create a copy of TeacherClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentName = null,Object? subject = null,Object? scheduledAt = null,Object? status = null,Object? studentAvatarUrl = freezed,Object? studentRating = freezed,Object? studentReview = freezed,Object? durationMinutes = freezed,Object? meetingLink = freezed,Object? studentId = freezed,Object? teacherId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,studentAvatarUrl: freezed == studentAvatarUrl ? _self.studentAvatarUrl : studentAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,studentRating: freezed == studentRating ? _self.studentRating : studentRating // ignore: cast_nullable_to_non_nullable
as double?,studentReview: freezed == studentReview ? _self.studentReview : studentReview // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherClassModel].
extension TeacherClassModelPatterns on TeacherClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherClassModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentName,  String subject,  DateTime scheduledAt,  String status,  String? studentAvatarUrl,  double? studentRating,  String? studentReview,  int? durationMinutes,  String? meetingLink,  String? studentId,  String? teacherId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherClassModel() when $default != null:
return $default(_that.id,_that.studentName,_that.subject,_that.scheduledAt,_that.status,_that.studentAvatarUrl,_that.studentRating,_that.studentReview,_that.durationMinutes,_that.meetingLink,_that.studentId,_that.teacherId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentName,  String subject,  DateTime scheduledAt,  String status,  String? studentAvatarUrl,  double? studentRating,  String? studentReview,  int? durationMinutes,  String? meetingLink,  String? studentId,  String? teacherId)  $default,) {final _that = this;
switch (_that) {
case _TeacherClassModel():
return $default(_that.id,_that.studentName,_that.subject,_that.scheduledAt,_that.status,_that.studentAvatarUrl,_that.studentRating,_that.studentReview,_that.durationMinutes,_that.meetingLink,_that.studentId,_that.teacherId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentName,  String subject,  DateTime scheduledAt,  String status,  String? studentAvatarUrl,  double? studentRating,  String? studentReview,  int? durationMinutes,  String? meetingLink,  String? studentId,  String? teacherId)?  $default,) {final _that = this;
switch (_that) {
case _TeacherClassModel() when $default != null:
return $default(_that.id,_that.studentName,_that.subject,_that.scheduledAt,_that.status,_that.studentAvatarUrl,_that.studentRating,_that.studentReview,_that.durationMinutes,_that.meetingLink,_that.studentId,_that.teacherId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherClassModel implements TeacherClassModel {
  const _TeacherClassModel({required this.id, required this.studentName, required this.subject, required this.scheduledAt, this.status = 'confirmed', this.studentAvatarUrl, this.studentRating, this.studentReview, this.durationMinutes, this.meetingLink, this.studentId, this.teacherId});
  factory _TeacherClassModel.fromJson(Map<String, dynamic> json) => _$TeacherClassModelFromJson(json);

@override final  String id;
@override final  String studentName;
@override final  String subject;
@override final  DateTime scheduledAt;
@override@JsonKey() final  String status;
@override final  String? studentAvatarUrl;
@override final  double? studentRating;
@override final  String? studentReview;
@override final  int? durationMinutes;
@override final  String? meetingLink;
@override final  String? studentId;
@override final  String? teacherId;

/// Create a copy of TeacherClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherClassModelCopyWith<_TeacherClassModel> get copyWith => __$TeacherClassModelCopyWithImpl<_TeacherClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentAvatarUrl, studentAvatarUrl) || other.studentAvatarUrl == studentAvatarUrl)&&(identical(other.studentRating, studentRating) || other.studentRating == studentRating)&&(identical(other.studentReview, studentReview) || other.studentReview == studentReview)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentName,subject,scheduledAt,status,studentAvatarUrl,studentRating,studentReview,durationMinutes,meetingLink,studentId,teacherId);

@override
String toString() {
  return 'TeacherClassModel(id: $id, studentName: $studentName, subject: $subject, scheduledAt: $scheduledAt, status: $status, studentAvatarUrl: $studentAvatarUrl, studentRating: $studentRating, studentReview: $studentReview, durationMinutes: $durationMinutes, meetingLink: $meetingLink, studentId: $studentId, teacherId: $teacherId)';
}


}

/// @nodoc
abstract mixin class _$TeacherClassModelCopyWith<$Res> implements $TeacherClassModelCopyWith<$Res> {
  factory _$TeacherClassModelCopyWith(_TeacherClassModel value, $Res Function(_TeacherClassModel) _then) = __$TeacherClassModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentName, String subject, DateTime scheduledAt, String status, String? studentAvatarUrl, double? studentRating, String? studentReview, int? durationMinutes, String? meetingLink, String? studentId, String? teacherId
});




}
/// @nodoc
class __$TeacherClassModelCopyWithImpl<$Res>
    implements _$TeacherClassModelCopyWith<$Res> {
  __$TeacherClassModelCopyWithImpl(this._self, this._then);

  final _TeacherClassModel _self;
  final $Res Function(_TeacherClassModel) _then;

/// Create a copy of TeacherClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentName = null,Object? subject = null,Object? scheduledAt = null,Object? status = null,Object? studentAvatarUrl = freezed,Object? studentRating = freezed,Object? studentReview = freezed,Object? durationMinutes = freezed,Object? meetingLink = freezed,Object? studentId = freezed,Object? teacherId = freezed,}) {
  return _then(_TeacherClassModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,studentAvatarUrl: freezed == studentAvatarUrl ? _self.studentAvatarUrl : studentAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,studentRating: freezed == studentRating ? _self.studentRating : studentRating // ignore: cast_nullable_to_non_nullable
as double?,studentReview: freezed == studentReview ? _self.studentReview : studentReview // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
