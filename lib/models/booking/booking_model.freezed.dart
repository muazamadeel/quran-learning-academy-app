// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {

 String get id; String get studentName; String get studentImage; String get date; String get time;// Display time (viewer ke timezone mein)
 String get status; String? get studentId; String? get teacherId; DateTime? get scheduledAt; int? get durationMinutes; String? get meetingLink; double? get studentRating; String? get studentReview;// ── Timezone fields ──────────────────────────────────────────────────────
 String get teacherTimezone;// Teacher ka timezone
 String get studentTimezone;// Student ka timezone
 String get teacherSlotTime;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.studentImage, studentImage) || other.studentImage == studentImage)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.studentRating, studentRating) || other.studentRating == studentRating)&&(identical(other.studentReview, studentReview) || other.studentReview == studentReview)&&(identical(other.teacherTimezone, teacherTimezone) || other.teacherTimezone == teacherTimezone)&&(identical(other.studentTimezone, studentTimezone) || other.studentTimezone == studentTimezone)&&(identical(other.teacherSlotTime, teacherSlotTime) || other.teacherSlotTime == teacherSlotTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentName,studentImage,date,time,status,studentId,teacherId,scheduledAt,durationMinutes,meetingLink,studentRating,studentReview,teacherTimezone,studentTimezone,teacherSlotTime);

@override
String toString() {
  return 'BookingModel(id: $id, studentName: $studentName, studentImage: $studentImage, date: $date, time: $time, status: $status, studentId: $studentId, teacherId: $teacherId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, meetingLink: $meetingLink, studentRating: $studentRating, studentReview: $studentReview, teacherTimezone: $teacherTimezone, studentTimezone: $studentTimezone, teacherSlotTime: $teacherSlotTime)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String id, String studentName, String studentImage, String date, String time, String status, String? studentId, String? teacherId, DateTime? scheduledAt, int? durationMinutes, String? meetingLink, double? studentRating, String? studentReview, String teacherTimezone, String studentTimezone, String teacherSlotTime
});




}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentName = null,Object? studentImage = null,Object? date = null,Object? time = null,Object? status = null,Object? studentId = freezed,Object? teacherId = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,Object? meetingLink = freezed,Object? studentRating = freezed,Object? studentReview = freezed,Object? teacherTimezone = null,Object? studentTimezone = null,Object? teacherSlotTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,studentImage: null == studentImage ? _self.studentImage : studentImage // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,studentRating: freezed == studentRating ? _self.studentRating : studentRating // ignore: cast_nullable_to_non_nullable
as double?,studentReview: freezed == studentReview ? _self.studentReview : studentReview // ignore: cast_nullable_to_non_nullable
as String?,teacherTimezone: null == teacherTimezone ? _self.teacherTimezone : teacherTimezone // ignore: cast_nullable_to_non_nullable
as String,studentTimezone: null == studentTimezone ? _self.studentTimezone : studentTimezone // ignore: cast_nullable_to_non_nullable
as String,teacherSlotTime: null == teacherSlotTime ? _self.teacherSlotTime : teacherSlotTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentName,  String studentImage,  String date,  String time,  String status,  String? studentId,  String? teacherId,  DateTime? scheduledAt,  int? durationMinutes,  String? meetingLink,  double? studentRating,  String? studentReview,  String teacherTimezone,  String studentTimezone,  String teacherSlotTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.studentName,_that.studentImage,_that.date,_that.time,_that.status,_that.studentId,_that.teacherId,_that.scheduledAt,_that.durationMinutes,_that.meetingLink,_that.studentRating,_that.studentReview,_that.teacherTimezone,_that.studentTimezone,_that.teacherSlotTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentName,  String studentImage,  String date,  String time,  String status,  String? studentId,  String? teacherId,  DateTime? scheduledAt,  int? durationMinutes,  String? meetingLink,  double? studentRating,  String? studentReview,  String teacherTimezone,  String studentTimezone,  String teacherSlotTime)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that.id,_that.studentName,_that.studentImage,_that.date,_that.time,_that.status,_that.studentId,_that.teacherId,_that.scheduledAt,_that.durationMinutes,_that.meetingLink,_that.studentRating,_that.studentReview,_that.teacherTimezone,_that.studentTimezone,_that.teacherSlotTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentName,  String studentImage,  String date,  String time,  String status,  String? studentId,  String? teacherId,  DateTime? scheduledAt,  int? durationMinutes,  String? meetingLink,  double? studentRating,  String? studentReview,  String teacherTimezone,  String studentTimezone,  String teacherSlotTime)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.studentName,_that.studentImage,_that.date,_that.time,_that.status,_that.studentId,_that.teacherId,_that.scheduledAt,_that.durationMinutes,_that.meetingLink,_that.studentRating,_that.studentReview,_that.teacherTimezone,_that.studentTimezone,_that.teacherSlotTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingModel extends BookingModel {
  const _BookingModel({required this.id, required this.studentName, required this.studentImage, required this.date, required this.time, this.status = 'pending', this.studentId, this.teacherId, this.scheduledAt, this.durationMinutes, this.meetingLink, this.studentRating, this.studentReview, this.teacherTimezone = '', this.studentTimezone = '', this.teacherSlotTime = ''}): super._();
  factory _BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

@override final  String id;
@override final  String studentName;
@override final  String studentImage;
@override final  String date;
@override final  String time;
// Display time (viewer ke timezone mein)
@override@JsonKey() final  String status;
@override final  String? studentId;
@override final  String? teacherId;
@override final  DateTime? scheduledAt;
@override final  int? durationMinutes;
@override final  String? meetingLink;
@override final  double? studentRating;
@override final  String? studentReview;
// ── Timezone fields ──────────────────────────────────────────────────────
@override@JsonKey() final  String teacherTimezone;
// Teacher ka timezone
@override@JsonKey() final  String studentTimezone;
// Student ka timezone
@override@JsonKey() final  String teacherSlotTime;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.studentImage, studentImage) || other.studentImage == studentImage)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.studentRating, studentRating) || other.studentRating == studentRating)&&(identical(other.studentReview, studentReview) || other.studentReview == studentReview)&&(identical(other.teacherTimezone, teacherTimezone) || other.teacherTimezone == teacherTimezone)&&(identical(other.studentTimezone, studentTimezone) || other.studentTimezone == studentTimezone)&&(identical(other.teacherSlotTime, teacherSlotTime) || other.teacherSlotTime == teacherSlotTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentName,studentImage,date,time,status,studentId,teacherId,scheduledAt,durationMinutes,meetingLink,studentRating,studentReview,teacherTimezone,studentTimezone,teacherSlotTime);

@override
String toString() {
  return 'BookingModel(id: $id, studentName: $studentName, studentImage: $studentImage, date: $date, time: $time, status: $status, studentId: $studentId, teacherId: $teacherId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, meetingLink: $meetingLink, studentRating: $studentRating, studentReview: $studentReview, teacherTimezone: $teacherTimezone, studentTimezone: $studentTimezone, teacherSlotTime: $teacherSlotTime)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentName, String studentImage, String date, String time, String status, String? studentId, String? teacherId, DateTime? scheduledAt, int? durationMinutes, String? meetingLink, double? studentRating, String? studentReview, String teacherTimezone, String studentTimezone, String teacherSlotTime
});




}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentName = null,Object? studentImage = null,Object? date = null,Object? time = null,Object? status = null,Object? studentId = freezed,Object? teacherId = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,Object? meetingLink = freezed,Object? studentRating = freezed,Object? studentReview = freezed,Object? teacherTimezone = null,Object? studentTimezone = null,Object? teacherSlotTime = null,}) {
  return _then(_BookingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,studentImage: null == studentImage ? _self.studentImage : studentImage // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,studentRating: freezed == studentRating ? _self.studentRating : studentRating // ignore: cast_nullable_to_non_nullable
as double?,studentReview: freezed == studentReview ? _self.studentReview : studentReview // ignore: cast_nullable_to_non_nullable
as String?,teacherTimezone: null == teacherTimezone ? _self.teacherTimezone : teacherTimezone // ignore: cast_nullable_to_non_nullable
as String,studentTimezone: null == studentTimezone ? _self.studentTimezone : studentTimezone // ignore: cast_nullable_to_non_nullable
as String,teacherSlotTime: null == teacherSlotTime ? _self.teacherSlotTime : teacherSlotTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
