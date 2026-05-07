// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherModel {

 String get id; String get name; String get email; String get experience; List<String> get languages; double get rating; int get totalStudents; int get todayClasses; double get monthEarnings; String get profileImage; bool get isAvailable;
/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherModelCopyWith<TeacherModel> get copyWith => _$TeacherModelCopyWithImpl<TeacherModel>(this as TeacherModel, _$identity);

  /// Serializes this TeacherModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.todayClasses, todayClasses) || other.todayClasses == todayClasses)&&(identical(other.monthEarnings, monthEarnings) || other.monthEarnings == monthEarnings)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,experience,const DeepCollectionEquality().hash(languages),rating,totalStudents,todayClasses,monthEarnings,profileImage,isAvailable);

@override
String toString() {
  return 'TeacherModel(id: $id, name: $name, email: $email, experience: $experience, languages: $languages, rating: $rating, totalStudents: $totalStudents, todayClasses: $todayClasses, monthEarnings: $monthEarnings, profileImage: $profileImage, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $TeacherModelCopyWith<$Res>  {
  factory $TeacherModelCopyWith(TeacherModel value, $Res Function(TeacherModel) _then) = _$TeacherModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String experience, List<String> languages, double rating, int totalStudents, int todayClasses, double monthEarnings, String profileImage, bool isAvailable
});




}
/// @nodoc
class _$TeacherModelCopyWithImpl<$Res>
    implements $TeacherModelCopyWith<$Res> {
  _$TeacherModelCopyWithImpl(this._self, this._then);

  final TeacherModel _self;
  final $Res Function(TeacherModel) _then;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? experience = null,Object? languages = null,Object? rating = null,Object? totalStudents = null,Object? todayClasses = null,Object? monthEarnings = null,Object? profileImage = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,todayClasses: null == todayClasses ? _self.todayClasses : todayClasses // ignore: cast_nullable_to_non_nullable
as int,monthEarnings: null == monthEarnings ? _self.monthEarnings : monthEarnings // ignore: cast_nullable_to_non_nullable
as double,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherModel].
extension TeacherModelPatterns on TeacherModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String experience,  List<String> languages,  double rating,  int totalStudents,  int todayClasses,  double monthEarnings,  String profileImage,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.todayClasses,_that.monthEarnings,_that.profileImage,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String experience,  List<String> languages,  double rating,  int totalStudents,  int todayClasses,  double monthEarnings,  String profileImage,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _TeacherModel():
return $default(_that.id,_that.name,_that.email,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.todayClasses,_that.monthEarnings,_that.profileImage,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String experience,  List<String> languages,  double rating,  int totalStudents,  int todayClasses,  double monthEarnings,  String profileImage,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.todayClasses,_that.monthEarnings,_that.profileImage,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherModel implements TeacherModel {
  const _TeacherModel({required this.id, required this.name, required this.email, required this.experience, required final  List<String> languages, required this.rating, required this.totalStudents, required this.todayClasses, required this.monthEarnings, this.profileImage = '', this.isAvailable = true}): _languages = languages;
  factory _TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String experience;
 final  List<String> _languages;
@override List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  double rating;
@override final  int totalStudents;
@override final  int todayClasses;
@override final  double monthEarnings;
@override@JsonKey() final  String profileImage;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherModelCopyWith<_TeacherModel> get copyWith => __$TeacherModelCopyWithImpl<_TeacherModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.todayClasses, todayClasses) || other.todayClasses == todayClasses)&&(identical(other.monthEarnings, monthEarnings) || other.monthEarnings == monthEarnings)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,experience,const DeepCollectionEquality().hash(_languages),rating,totalStudents,todayClasses,monthEarnings,profileImage,isAvailable);

@override
String toString() {
  return 'TeacherModel(id: $id, name: $name, email: $email, experience: $experience, languages: $languages, rating: $rating, totalStudents: $totalStudents, todayClasses: $todayClasses, monthEarnings: $monthEarnings, profileImage: $profileImage, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$TeacherModelCopyWith<$Res> implements $TeacherModelCopyWith<$Res> {
  factory _$TeacherModelCopyWith(_TeacherModel value, $Res Function(_TeacherModel) _then) = __$TeacherModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String experience, List<String> languages, double rating, int totalStudents, int todayClasses, double monthEarnings, String profileImage, bool isAvailable
});




}
/// @nodoc
class __$TeacherModelCopyWithImpl<$Res>
    implements _$TeacherModelCopyWith<$Res> {
  __$TeacherModelCopyWithImpl(this._self, this._then);

  final _TeacherModel _self;
  final $Res Function(_TeacherModel) _then;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? experience = null,Object? languages = null,Object? rating = null,Object? totalStudents = null,Object? todayClasses = null,Object? monthEarnings = null,Object? profileImage = null,Object? isAvailable = null,}) {
  return _then(_TeacherModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,todayClasses: null == todayClasses ? _self.todayClasses : todayClasses // ignore: cast_nullable_to_non_nullable
as int,monthEarnings: null == monthEarnings ? _self.monthEarnings : monthEarnings // ignore: cast_nullable_to_non_nullable
as double,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
