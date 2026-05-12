// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentModel {

 String get id; String get name; String get email; String get dob; String get profileImage; String get subscriptionPlan; int get totalClassesCompleted; int get upcomingClassesCount; bool get isSubscribed;
/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentModelCopyWith<StudentModel> get copyWith => _$StudentModelCopyWithImpl<StudentModel>(this as StudentModel, _$identity);

  /// Serializes this StudentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.subscriptionPlan, subscriptionPlan) || other.subscriptionPlan == subscriptionPlan)&&(identical(other.totalClassesCompleted, totalClassesCompleted) || other.totalClassesCompleted == totalClassesCompleted)&&(identical(other.upcomingClassesCount, upcomingClassesCount) || other.upcomingClassesCount == upcomingClassesCount)&&(identical(other.isSubscribed, isSubscribed) || other.isSubscribed == isSubscribed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,dob,profileImage,subscriptionPlan,totalClassesCompleted,upcomingClassesCount,isSubscribed);

@override
String toString() {
  return 'StudentModel(id: $id, name: $name, email: $email, dob: $dob, profileImage: $profileImage, subscriptionPlan: $subscriptionPlan, totalClassesCompleted: $totalClassesCompleted, upcomingClassesCount: $upcomingClassesCount, isSubscribed: $isSubscribed)';
}


}

/// @nodoc
abstract mixin class $StudentModelCopyWith<$Res>  {
  factory $StudentModelCopyWith(StudentModel value, $Res Function(StudentModel) _then) = _$StudentModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String dob, String profileImage, String subscriptionPlan, int totalClassesCompleted, int upcomingClassesCount, bool isSubscribed
});




}
/// @nodoc
class _$StudentModelCopyWithImpl<$Res>
    implements $StudentModelCopyWith<$Res> {
  _$StudentModelCopyWithImpl(this._self, this._then);

  final StudentModel _self;
  final $Res Function(StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? dob = null,Object? profileImage = null,Object? subscriptionPlan = null,Object? totalClassesCompleted = null,Object? upcomingClassesCount = null,Object? isSubscribed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,subscriptionPlan: null == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String,totalClassesCompleted: null == totalClassesCompleted ? _self.totalClassesCompleted : totalClassesCompleted // ignore: cast_nullable_to_non_nullable
as int,upcomingClassesCount: null == upcomingClassesCount ? _self.upcomingClassesCount : upcomingClassesCount // ignore: cast_nullable_to_non_nullable
as int,isSubscribed: null == isSubscribed ? _self.isSubscribed : isSubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentModel].
extension StudentModelPatterns on StudentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String dob,  String profileImage,  String subscriptionPlan,  int totalClassesCompleted,  int upcomingClassesCount,  bool isSubscribed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.dob,_that.profileImage,_that.subscriptionPlan,_that.totalClassesCompleted,_that.upcomingClassesCount,_that.isSubscribed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String dob,  String profileImage,  String subscriptionPlan,  int totalClassesCompleted,  int upcomingClassesCount,  bool isSubscribed)  $default,) {final _that = this;
switch (_that) {
case _StudentModel():
return $default(_that.id,_that.name,_that.email,_that.dob,_that.profileImage,_that.subscriptionPlan,_that.totalClassesCompleted,_that.upcomingClassesCount,_that.isSubscribed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String dob,  String profileImage,  String subscriptionPlan,  int totalClassesCompleted,  int upcomingClassesCount,  bool isSubscribed)?  $default,) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.dob,_that.profileImage,_that.subscriptionPlan,_that.totalClassesCompleted,_that.upcomingClassesCount,_that.isSubscribed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentModel implements StudentModel {
  const _StudentModel({required this.id, required this.name, required this.email, required this.dob, this.profileImage = '', this.subscriptionPlan = '', this.totalClassesCompleted = 0, this.upcomingClassesCount = 0, this.isSubscribed = false});
  factory _StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String dob;
@override@JsonKey() final  String profileImage;
@override@JsonKey() final  String subscriptionPlan;
@override@JsonKey() final  int totalClassesCompleted;
@override@JsonKey() final  int upcomingClassesCount;
@override@JsonKey() final  bool isSubscribed;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentModelCopyWith<_StudentModel> get copyWith => __$StudentModelCopyWithImpl<_StudentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.subscriptionPlan, subscriptionPlan) || other.subscriptionPlan == subscriptionPlan)&&(identical(other.totalClassesCompleted, totalClassesCompleted) || other.totalClassesCompleted == totalClassesCompleted)&&(identical(other.upcomingClassesCount, upcomingClassesCount) || other.upcomingClassesCount == upcomingClassesCount)&&(identical(other.isSubscribed, isSubscribed) || other.isSubscribed == isSubscribed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,dob,profileImage,subscriptionPlan,totalClassesCompleted,upcomingClassesCount,isSubscribed);

@override
String toString() {
  return 'StudentModel(id: $id, name: $name, email: $email, dob: $dob, profileImage: $profileImage, subscriptionPlan: $subscriptionPlan, totalClassesCompleted: $totalClassesCompleted, upcomingClassesCount: $upcomingClassesCount, isSubscribed: $isSubscribed)';
}


}

/// @nodoc
abstract mixin class _$StudentModelCopyWith<$Res> implements $StudentModelCopyWith<$Res> {
  factory _$StudentModelCopyWith(_StudentModel value, $Res Function(_StudentModel) _then) = __$StudentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String dob, String profileImage, String subscriptionPlan, int totalClassesCompleted, int upcomingClassesCount, bool isSubscribed
});




}
/// @nodoc
class __$StudentModelCopyWithImpl<$Res>
    implements _$StudentModelCopyWith<$Res> {
  __$StudentModelCopyWithImpl(this._self, this._then);

  final _StudentModel _self;
  final $Res Function(_StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? dob = null,Object? profileImage = null,Object? subscriptionPlan = null,Object? totalClassesCompleted = null,Object? upcomingClassesCount = null,Object? isSubscribed = null,}) {
  return _then(_StudentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,subscriptionPlan: null == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String,totalClassesCompleted: null == totalClassesCompleted ? _self.totalClassesCompleted : totalClassesCompleted // ignore: cast_nullable_to_non_nullable
as int,upcomingClassesCount: null == upcomingClassesCount ? _self.upcomingClassesCount : upcomingClassesCount // ignore: cast_nullable_to_non_nullable
as int,isSubscribed: null == isSubscribed ? _self.isSubscribed : isSubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TeacherListModel {

 String get id; String get name; String get experience; List<String> get languages; double get rating; int get totalStudents; String get profileImage; bool get isAvailable; String get country; String get timezone; Map<String, dynamic> get availability;
/// Create a copy of TeacherListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherListModelCopyWith<TeacherListModel> get copyWith => _$TeacherListModelCopyWithImpl<TeacherListModel>(this as TeacherListModel, _$identity);

  /// Serializes this TeacherListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.country, country) || other.country == country)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.availability, availability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,experience,const DeepCollectionEquality().hash(languages),rating,totalStudents,profileImage,isAvailable,country,timezone,const DeepCollectionEquality().hash(availability));

@override
String toString() {
  return 'TeacherListModel(id: $id, name: $name, experience: $experience, languages: $languages, rating: $rating, totalStudents: $totalStudents, profileImage: $profileImage, isAvailable: $isAvailable, country: $country, timezone: $timezone, availability: $availability)';
}


}

/// @nodoc
abstract mixin class $TeacherListModelCopyWith<$Res>  {
  factory $TeacherListModelCopyWith(TeacherListModel value, $Res Function(TeacherListModel) _then) = _$TeacherListModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String experience, List<String> languages, double rating, int totalStudents, String profileImage, bool isAvailable, String country, String timezone, Map<String, dynamic> availability
});




}
/// @nodoc
class _$TeacherListModelCopyWithImpl<$Res>
    implements $TeacherListModelCopyWith<$Res> {
  _$TeacherListModelCopyWithImpl(this._self, this._then);

  final TeacherListModel _self;
  final $Res Function(TeacherListModel) _then;

/// Create a copy of TeacherListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? experience = null,Object? languages = null,Object? rating = null,Object? totalStudents = null,Object? profileImage = null,Object? isAvailable = null,Object? country = null,Object? timezone = null,Object? availability = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherListModel].
extension TeacherListModelPatterns on TeacherListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherListModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherListModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String experience,  List<String> languages,  double rating,  int totalStudents,  String profileImage,  bool isAvailable,  String country,  String timezone,  Map<String, dynamic> availability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherListModel() when $default != null:
return $default(_that.id,_that.name,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.profileImage,_that.isAvailable,_that.country,_that.timezone,_that.availability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String experience,  List<String> languages,  double rating,  int totalStudents,  String profileImage,  bool isAvailable,  String country,  String timezone,  Map<String, dynamic> availability)  $default,) {final _that = this;
switch (_that) {
case _TeacherListModel():
return $default(_that.id,_that.name,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.profileImage,_that.isAvailable,_that.country,_that.timezone,_that.availability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String experience,  List<String> languages,  double rating,  int totalStudents,  String profileImage,  bool isAvailable,  String country,  String timezone,  Map<String, dynamic> availability)?  $default,) {final _that = this;
switch (_that) {
case _TeacherListModel() when $default != null:
return $default(_that.id,_that.name,_that.experience,_that.languages,_that.rating,_that.totalStudents,_that.profileImage,_that.isAvailable,_that.country,_that.timezone,_that.availability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherListModel implements TeacherListModel {
  const _TeacherListModel({required this.id, required this.name, required this.experience, required final  List<String> languages, required this.rating, required this.totalStudents, this.profileImage = '', this.isAvailable = true, this.country = '', this.timezone = '', final  Map<String, dynamic> availability = const <String, dynamic>{}}): _languages = languages,_availability = availability;
  factory _TeacherListModel.fromJson(Map<String, dynamic> json) => _$TeacherListModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String experience;
 final  List<String> _languages;
@override List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  double rating;
@override final  int totalStudents;
@override@JsonKey() final  String profileImage;
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  String country;
@override@JsonKey() final  String timezone;
 final  Map<String, dynamic> _availability;
@override@JsonKey() Map<String, dynamic> get availability {
  if (_availability is EqualUnmodifiableMapView) return _availability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_availability);
}


/// Create a copy of TeacherListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherListModelCopyWith<_TeacherListModel> get copyWith => __$TeacherListModelCopyWithImpl<_TeacherListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.country, country) || other.country == country)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._availability, _availability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,experience,const DeepCollectionEquality().hash(_languages),rating,totalStudents,profileImage,isAvailable,country,timezone,const DeepCollectionEquality().hash(_availability));

@override
String toString() {
  return 'TeacherListModel(id: $id, name: $name, experience: $experience, languages: $languages, rating: $rating, totalStudents: $totalStudents, profileImage: $profileImage, isAvailable: $isAvailable, country: $country, timezone: $timezone, availability: $availability)';
}


}

/// @nodoc
abstract mixin class _$TeacherListModelCopyWith<$Res> implements $TeacherListModelCopyWith<$Res> {
  factory _$TeacherListModelCopyWith(_TeacherListModel value, $Res Function(_TeacherListModel) _then) = __$TeacherListModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String experience, List<String> languages, double rating, int totalStudents, String profileImage, bool isAvailable, String country, String timezone, Map<String, dynamic> availability
});




}
/// @nodoc
class __$TeacherListModelCopyWithImpl<$Res>
    implements _$TeacherListModelCopyWith<$Res> {
  __$TeacherListModelCopyWithImpl(this._self, this._then);

  final _TeacherListModel _self;
  final $Res Function(_TeacherListModel) _then;

/// Create a copy of TeacherListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? experience = null,Object? languages = null,Object? rating = null,Object? totalStudents = null,Object? profileImage = null,Object? isAvailable = null,Object? country = null,Object? timezone = null,Object? availability = null,}) {
  return _then(_TeacherListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,availability: null == availability ? _self._availability : availability // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$StudentUpcomingClassModel {

 String get id; String get teacherName; String get teacherImage; String get time; String get date; String get status; String? get teacherId; String? get studentId; DateTime? get scheduledAt; int? get durationMinutes;
/// Create a copy of StudentUpcomingClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentUpcomingClassModelCopyWith<StudentUpcomingClassModel> get copyWith => _$StudentUpcomingClassModelCopyWithImpl<StudentUpcomingClassModel>(this as StudentUpcomingClassModel, _$identity);

  /// Serializes this StudentUpcomingClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentUpcomingClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.teacherImage, teacherImage) || other.teacherImage == teacherImage)&&(identical(other.time, time) || other.time == time)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherName,teacherImage,time,date,status,teacherId,studentId,scheduledAt,durationMinutes);

@override
String toString() {
  return 'StudentUpcomingClassModel(id: $id, teacherName: $teacherName, teacherImage: $teacherImage, time: $time, date: $date, status: $status, teacherId: $teacherId, studentId: $studentId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $StudentUpcomingClassModelCopyWith<$Res>  {
  factory $StudentUpcomingClassModelCopyWith(StudentUpcomingClassModel value, $Res Function(StudentUpcomingClassModel) _then) = _$StudentUpcomingClassModelCopyWithImpl;
@useResult
$Res call({
 String id, String teacherName, String teacherImage, String time, String date, String status, String? teacherId, String? studentId, DateTime? scheduledAt, int? durationMinutes
});




}
/// @nodoc
class _$StudentUpcomingClassModelCopyWithImpl<$Res>
    implements $StudentUpcomingClassModelCopyWith<$Res> {
  _$StudentUpcomingClassModelCopyWithImpl(this._self, this._then);

  final StudentUpcomingClassModel _self;
  final $Res Function(StudentUpcomingClassModel) _then;

/// Create a copy of StudentUpcomingClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teacherName = null,Object? teacherImage = null,Object? time = null,Object? date = null,Object? status = null,Object? teacherId = freezed,Object? studentId = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,teacherImage: null == teacherImage ? _self.teacherImage : teacherImage // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentUpcomingClassModel].
extension StudentUpcomingClassModelPatterns on StudentUpcomingClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentUpcomingClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentUpcomingClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentUpcomingClassModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentUpcomingClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentUpcomingClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentUpcomingClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String teacherName,  String teacherImage,  String time,  String date,  String status,  String? teacherId,  String? studentId,  DateTime? scheduledAt,  int? durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentUpcomingClassModel() when $default != null:
return $default(_that.id,_that.teacherName,_that.teacherImage,_that.time,_that.date,_that.status,_that.teacherId,_that.studentId,_that.scheduledAt,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String teacherName,  String teacherImage,  String time,  String date,  String status,  String? teacherId,  String? studentId,  DateTime? scheduledAt,  int? durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _StudentUpcomingClassModel():
return $default(_that.id,_that.teacherName,_that.teacherImage,_that.time,_that.date,_that.status,_that.teacherId,_that.studentId,_that.scheduledAt,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String teacherName,  String teacherImage,  String time,  String date,  String status,  String? teacherId,  String? studentId,  DateTime? scheduledAt,  int? durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _StudentUpcomingClassModel() when $default != null:
return $default(_that.id,_that.teacherName,_that.teacherImage,_that.time,_that.date,_that.status,_that.teacherId,_that.studentId,_that.scheduledAt,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentUpcomingClassModel implements StudentUpcomingClassModel {
  const _StudentUpcomingClassModel({required this.id, required this.teacherName, required this.teacherImage, required this.time, required this.date, this.status = 'upcoming', this.teacherId, this.studentId, this.scheduledAt, this.durationMinutes});
  factory _StudentUpcomingClassModel.fromJson(Map<String, dynamic> json) => _$StudentUpcomingClassModelFromJson(json);

@override final  String id;
@override final  String teacherName;
@override final  String teacherImage;
@override final  String time;
@override final  String date;
@override@JsonKey() final  String status;
@override final  String? teacherId;
@override final  String? studentId;
@override final  DateTime? scheduledAt;
@override final  int? durationMinutes;

/// Create a copy of StudentUpcomingClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentUpcomingClassModelCopyWith<_StudentUpcomingClassModel> get copyWith => __$StudentUpcomingClassModelCopyWithImpl<_StudentUpcomingClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentUpcomingClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentUpcomingClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.teacherImage, teacherImage) || other.teacherImage == teacherImage)&&(identical(other.time, time) || other.time == time)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherName,teacherImage,time,date,status,teacherId,studentId,scheduledAt,durationMinutes);

@override
String toString() {
  return 'StudentUpcomingClassModel(id: $id, teacherName: $teacherName, teacherImage: $teacherImage, time: $time, date: $date, status: $status, teacherId: $teacherId, studentId: $studentId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$StudentUpcomingClassModelCopyWith<$Res> implements $StudentUpcomingClassModelCopyWith<$Res> {
  factory _$StudentUpcomingClassModelCopyWith(_StudentUpcomingClassModel value, $Res Function(_StudentUpcomingClassModel) _then) = __$StudentUpcomingClassModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String teacherName, String teacherImage, String time, String date, String status, String? teacherId, String? studentId, DateTime? scheduledAt, int? durationMinutes
});




}
/// @nodoc
class __$StudentUpcomingClassModelCopyWithImpl<$Res>
    implements _$StudentUpcomingClassModelCopyWith<$Res> {
  __$StudentUpcomingClassModelCopyWithImpl(this._self, this._then);

  final _StudentUpcomingClassModel _self;
  final $Res Function(_StudentUpcomingClassModel) _then;

/// Create a copy of StudentUpcomingClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teacherName = null,Object? teacherImage = null,Object? time = null,Object? date = null,Object? status = null,Object? teacherId = freezed,Object? studentId = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,}) {
  return _then(_StudentUpcomingClassModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,teacherImage: null == teacherImage ? _self.teacherImage : teacherImage // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$StudentProgressModel {

 String get id; String get teacherName; String get date; String get progressNote; String get whatWasCovered; String get homework; String get rating;
/// Create a copy of StudentProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProgressModelCopyWith<StudentProgressModel> get copyWith => _$StudentProgressModelCopyWithImpl<StudentProgressModel>(this as StudentProgressModel, _$identity);

  /// Serializes this StudentProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.date, date) || other.date == date)&&(identical(other.progressNote, progressNote) || other.progressNote == progressNote)&&(identical(other.whatWasCovered, whatWasCovered) || other.whatWasCovered == whatWasCovered)&&(identical(other.homework, homework) || other.homework == homework)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherName,date,progressNote,whatWasCovered,homework,rating);

@override
String toString() {
  return 'StudentProgressModel(id: $id, teacherName: $teacherName, date: $date, progressNote: $progressNote, whatWasCovered: $whatWasCovered, homework: $homework, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $StudentProgressModelCopyWith<$Res>  {
  factory $StudentProgressModelCopyWith(StudentProgressModel value, $Res Function(StudentProgressModel) _then) = _$StudentProgressModelCopyWithImpl;
@useResult
$Res call({
 String id, String teacherName, String date, String progressNote, String whatWasCovered, String homework, String rating
});




}
/// @nodoc
class _$StudentProgressModelCopyWithImpl<$Res>
    implements $StudentProgressModelCopyWith<$Res> {
  _$StudentProgressModelCopyWithImpl(this._self, this._then);

  final StudentProgressModel _self;
  final $Res Function(StudentProgressModel) _then;

/// Create a copy of StudentProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teacherName = null,Object? date = null,Object? progressNote = null,Object? whatWasCovered = null,Object? homework = null,Object? rating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,progressNote: null == progressNote ? _self.progressNote : progressNote // ignore: cast_nullable_to_non_nullable
as String,whatWasCovered: null == whatWasCovered ? _self.whatWasCovered : whatWasCovered // ignore: cast_nullable_to_non_nullable
as String,homework: null == homework ? _self.homework : homework // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentProgressModel].
extension StudentProgressModelPatterns on StudentProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String teacherName,  String date,  String progressNote,  String whatWasCovered,  String homework,  String rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProgressModel() when $default != null:
return $default(_that.id,_that.teacherName,_that.date,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String teacherName,  String date,  String progressNote,  String whatWasCovered,  String homework,  String rating)  $default,) {final _that = this;
switch (_that) {
case _StudentProgressModel():
return $default(_that.id,_that.teacherName,_that.date,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String teacherName,  String date,  String progressNote,  String whatWasCovered,  String homework,  String rating)?  $default,) {final _that = this;
switch (_that) {
case _StudentProgressModel() when $default != null:
return $default(_that.id,_that.teacherName,_that.date,_that.progressNote,_that.whatWasCovered,_that.homework,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProgressModel implements StudentProgressModel {
  const _StudentProgressModel({required this.id, required this.teacherName, required this.date, required this.progressNote, required this.whatWasCovered, required this.homework, required this.rating});
  factory _StudentProgressModel.fromJson(Map<String, dynamic> json) => _$StudentProgressModelFromJson(json);

@override final  String id;
@override final  String teacherName;
@override final  String date;
@override final  String progressNote;
@override final  String whatWasCovered;
@override final  String homework;
@override final  String rating;

/// Create a copy of StudentProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProgressModelCopyWith<_StudentProgressModel> get copyWith => __$StudentProgressModelCopyWithImpl<_StudentProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.date, date) || other.date == date)&&(identical(other.progressNote, progressNote) || other.progressNote == progressNote)&&(identical(other.whatWasCovered, whatWasCovered) || other.whatWasCovered == whatWasCovered)&&(identical(other.homework, homework) || other.homework == homework)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherName,date,progressNote,whatWasCovered,homework,rating);

@override
String toString() {
  return 'StudentProgressModel(id: $id, teacherName: $teacherName, date: $date, progressNote: $progressNote, whatWasCovered: $whatWasCovered, homework: $homework, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$StudentProgressModelCopyWith<$Res> implements $StudentProgressModelCopyWith<$Res> {
  factory _$StudentProgressModelCopyWith(_StudentProgressModel value, $Res Function(_StudentProgressModel) _then) = __$StudentProgressModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String teacherName, String date, String progressNote, String whatWasCovered, String homework, String rating
});




}
/// @nodoc
class __$StudentProgressModelCopyWithImpl<$Res>
    implements _$StudentProgressModelCopyWith<$Res> {
  __$StudentProgressModelCopyWithImpl(this._self, this._then);

  final _StudentProgressModel _self;
  final $Res Function(_StudentProgressModel) _then;

/// Create a copy of StudentProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teacherName = null,Object? date = null,Object? progressNote = null,Object? whatWasCovered = null,Object? homework = null,Object? rating = null,}) {
  return _then(_StudentProgressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,progressNote: null == progressNote ? _self.progressNote : progressNote // ignore: cast_nullable_to_non_nullable
as String,whatWasCovered: null == whatWasCovered ? _self.whatWasCovered : whatWasCovered // ignore: cast_nullable_to_non_nullable
as String,homework: null == homework ? _self.homework : homework // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SubscriptionPlanModel {

 String get id; String get title; double get price; int get classesPerWeek; int get studentsAllowed; List<String> get features; bool get isPopular;
/// Create a copy of SubscriptionPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionPlanModelCopyWith<SubscriptionPlanModel> get copyWith => _$SubscriptionPlanModelCopyWithImpl<SubscriptionPlanModel>(this as SubscriptionPlanModel, _$identity);

  /// Serializes this SubscriptionPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.classesPerWeek, classesPerWeek) || other.classesPerWeek == classesPerWeek)&&(identical(other.studentsAllowed, studentsAllowed) || other.studentsAllowed == studentsAllowed)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,classesPerWeek,studentsAllowed,const DeepCollectionEquality().hash(features),isPopular);

@override
String toString() {
  return 'SubscriptionPlanModel(id: $id, title: $title, price: $price, classesPerWeek: $classesPerWeek, studentsAllowed: $studentsAllowed, features: $features, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class $SubscriptionPlanModelCopyWith<$Res>  {
  factory $SubscriptionPlanModelCopyWith(SubscriptionPlanModel value, $Res Function(SubscriptionPlanModel) _then) = _$SubscriptionPlanModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, double price, int classesPerWeek, int studentsAllowed, List<String> features, bool isPopular
});




}
/// @nodoc
class _$SubscriptionPlanModelCopyWithImpl<$Res>
    implements $SubscriptionPlanModelCopyWith<$Res> {
  _$SubscriptionPlanModelCopyWithImpl(this._self, this._then);

  final SubscriptionPlanModel _self;
  final $Res Function(SubscriptionPlanModel) _then;

/// Create a copy of SubscriptionPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? price = null,Object? classesPerWeek = null,Object? studentsAllowed = null,Object? features = null,Object? isPopular = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,classesPerWeek: null == classesPerWeek ? _self.classesPerWeek : classesPerWeek // ignore: cast_nullable_to_non_nullable
as int,studentsAllowed: null == studentsAllowed ? _self.studentsAllowed : studentsAllowed // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionPlanModel].
extension SubscriptionPlanModelPatterns on SubscriptionPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  double price,  int classesPerWeek,  int studentsAllowed,  List<String> features,  bool isPopular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionPlanModel() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.classesPerWeek,_that.studentsAllowed,_that.features,_that.isPopular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  double price,  int classesPerWeek,  int studentsAllowed,  List<String> features,  bool isPopular)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlanModel():
return $default(_that.id,_that.title,_that.price,_that.classesPerWeek,_that.studentsAllowed,_that.features,_that.isPopular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  double price,  int classesPerWeek,  int studentsAllowed,  List<String> features,  bool isPopular)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlanModel() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.classesPerWeek,_that.studentsAllowed,_that.features,_that.isPopular);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionPlanModel implements SubscriptionPlanModel {
  const _SubscriptionPlanModel({required this.id, required this.title, required this.price, required this.classesPerWeek, required this.studentsAllowed, required final  List<String> features, this.isPopular = false}): _features = features;
  factory _SubscriptionPlanModel.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  double price;
@override final  int classesPerWeek;
@override final  int studentsAllowed;
 final  List<String> _features;
@override List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

@override@JsonKey() final  bool isPopular;

/// Create a copy of SubscriptionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionPlanModelCopyWith<_SubscriptionPlanModel> get copyWith => __$SubscriptionPlanModelCopyWithImpl<_SubscriptionPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.classesPerWeek, classesPerWeek) || other.classesPerWeek == classesPerWeek)&&(identical(other.studentsAllowed, studentsAllowed) || other.studentsAllowed == studentsAllowed)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,classesPerWeek,studentsAllowed,const DeepCollectionEquality().hash(_features),isPopular);

@override
String toString() {
  return 'SubscriptionPlanModel(id: $id, title: $title, price: $price, classesPerWeek: $classesPerWeek, studentsAllowed: $studentsAllowed, features: $features, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionPlanModelCopyWith<$Res> implements $SubscriptionPlanModelCopyWith<$Res> {
  factory _$SubscriptionPlanModelCopyWith(_SubscriptionPlanModel value, $Res Function(_SubscriptionPlanModel) _then) = __$SubscriptionPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double price, int classesPerWeek, int studentsAllowed, List<String> features, bool isPopular
});




}
/// @nodoc
class __$SubscriptionPlanModelCopyWithImpl<$Res>
    implements _$SubscriptionPlanModelCopyWith<$Res> {
  __$SubscriptionPlanModelCopyWithImpl(this._self, this._then);

  final _SubscriptionPlanModel _self;
  final $Res Function(_SubscriptionPlanModel) _then;

/// Create a copy of SubscriptionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? price = null,Object? classesPerWeek = null,Object? studentsAllowed = null,Object? features = null,Object? isPopular = null,}) {
  return _then(_SubscriptionPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,classesPerWeek: null == classesPerWeek ? _self.classesPerWeek : classesPerWeek // ignore: cast_nullable_to_non_nullable
as int,studentsAllowed: null == studentsAllowed ? _self.studentsAllowed : studentsAllowed // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SlotModel {

 String get id; String get time;// Student ke timezone mein display time
 String get teacherTime;// Teacher ka original time (Firestore ke liye)
 bool get isSelected; bool get isAvailable;
/// Create a copy of SlotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotModelCopyWith<SlotModel> get copyWith => _$SlotModelCopyWithImpl<SlotModel>(this as SlotModel, _$identity);

  /// Serializes this SlotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.teacherTime, teacherTime) || other.teacherTime == teacherTime)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,time,teacherTime,isSelected,isAvailable);

@override
String toString() {
  return 'SlotModel(id: $id, time: $time, teacherTime: $teacherTime, isSelected: $isSelected, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $SlotModelCopyWith<$Res>  {
  factory $SlotModelCopyWith(SlotModel value, $Res Function(SlotModel) _then) = _$SlotModelCopyWithImpl;
@useResult
$Res call({
 String id, String time, String teacherTime, bool isSelected, bool isAvailable
});




}
/// @nodoc
class _$SlotModelCopyWithImpl<$Res>
    implements $SlotModelCopyWith<$Res> {
  _$SlotModelCopyWithImpl(this._self, this._then);

  final SlotModel _self;
  final $Res Function(SlotModel) _then;

/// Create a copy of SlotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? time = null,Object? teacherTime = null,Object? isSelected = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,teacherTime: null == teacherTime ? _self.teacherTime : teacherTime // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotModel].
extension SlotModelPatterns on SlotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotModel value)  $default,){
final _that = this;
switch (_that) {
case _SlotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotModel value)?  $default,){
final _that = this;
switch (_that) {
case _SlotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String time,  String teacherTime,  bool isSelected,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotModel() when $default != null:
return $default(_that.id,_that.time,_that.teacherTime,_that.isSelected,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String time,  String teacherTime,  bool isSelected,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _SlotModel():
return $default(_that.id,_that.time,_that.teacherTime,_that.isSelected,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String time,  String teacherTime,  bool isSelected,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _SlotModel() when $default != null:
return $default(_that.id,_that.time,_that.teacherTime,_that.isSelected,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotModel implements SlotModel {
  const _SlotModel({required this.id, required this.time, this.teacherTime = '', this.isSelected = false, this.isAvailable = true});
  factory _SlotModel.fromJson(Map<String, dynamic> json) => _$SlotModelFromJson(json);

@override final  String id;
@override final  String time;
// Student ke timezone mein display time
@override@JsonKey() final  String teacherTime;
// Teacher ka original time (Firestore ke liye)
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of SlotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotModelCopyWith<_SlotModel> get copyWith => __$SlotModelCopyWithImpl<_SlotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.teacherTime, teacherTime) || other.teacherTime == teacherTime)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,time,teacherTime,isSelected,isAvailable);

@override
String toString() {
  return 'SlotModel(id: $id, time: $time, teacherTime: $teacherTime, isSelected: $isSelected, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$SlotModelCopyWith<$Res> implements $SlotModelCopyWith<$Res> {
  factory _$SlotModelCopyWith(_SlotModel value, $Res Function(_SlotModel) _then) = __$SlotModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String time, String teacherTime, bool isSelected, bool isAvailable
});




}
/// @nodoc
class __$SlotModelCopyWithImpl<$Res>
    implements _$SlotModelCopyWith<$Res> {
  __$SlotModelCopyWithImpl(this._self, this._then);

  final _SlotModel _self;
  final $Res Function(_SlotModel) _then;

/// Create a copy of SlotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? time = null,Object? teacherTime = null,Object? isSelected = null,Object? isAvailable = null,}) {
  return _then(_SlotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,teacherTime: null == teacherTime ? _self.teacherTime : teacherTime // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
