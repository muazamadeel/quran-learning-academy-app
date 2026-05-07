// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherDashboardState {

 TeacherModel? get teacher; List<TeacherClassModel> get upcomingClasses; List<TeacherClassModel> get completedClasses; List<TeacherClassModel> get filteredUpcoming; String get searchQuery; bool get isLoading; String? get error;
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDashboardStateCopyWith<TeacherDashboardState> get copyWith => _$TeacherDashboardStateCopyWithImpl<TeacherDashboardState>(this as TeacherDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDashboardState&&(identical(other.teacher, teacher) || other.teacher == teacher)&&const DeepCollectionEquality().equals(other.upcomingClasses, upcomingClasses)&&const DeepCollectionEquality().equals(other.completedClasses, completedClasses)&&const DeepCollectionEquality().equals(other.filteredUpcoming, filteredUpcoming)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,teacher,const DeepCollectionEquality().hash(upcomingClasses),const DeepCollectionEquality().hash(completedClasses),const DeepCollectionEquality().hash(filteredUpcoming),searchQuery,isLoading,error);

@override
String toString() {
  return 'TeacherDashboardState(teacher: $teacher, upcomingClasses: $upcomingClasses, completedClasses: $completedClasses, filteredUpcoming: $filteredUpcoming, searchQuery: $searchQuery, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $TeacherDashboardStateCopyWith<$Res>  {
  factory $TeacherDashboardStateCopyWith(TeacherDashboardState value, $Res Function(TeacherDashboardState) _then) = _$TeacherDashboardStateCopyWithImpl;
@useResult
$Res call({
 TeacherModel? teacher, List<TeacherClassModel> upcomingClasses, List<TeacherClassModel> completedClasses, List<TeacherClassModel> filteredUpcoming, String searchQuery, bool isLoading, String? error
});


$TeacherModelCopyWith<$Res>? get teacher;

}
/// @nodoc
class _$TeacherDashboardStateCopyWithImpl<$Res>
    implements $TeacherDashboardStateCopyWith<$Res> {
  _$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final TeacherDashboardState _self;
  final $Res Function(TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teacher = freezed,Object? upcomingClasses = null,Object? completedClasses = null,Object? filteredUpcoming = null,Object? searchQuery = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as TeacherModel?,upcomingClasses: null == upcomingClasses ? _self.upcomingClasses : upcomingClasses // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,completedClasses: null == completedClasses ? _self.completedClasses : completedClasses // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,filteredUpcoming: null == filteredUpcoming ? _self.filteredUpcoming : filteredUpcoming // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherModelCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
    return null;
  }

  return $TeacherModelCopyWith<$Res>(_self.teacher!, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeacherDashboardState].
extension TeacherDashboardStatePatterns on TeacherDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TeacherModel? teacher,  List<TeacherClassModel> upcomingClasses,  List<TeacherClassModel> completedClasses,  List<TeacherClassModel> filteredUpcoming,  String searchQuery,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.teacher,_that.upcomingClasses,_that.completedClasses,_that.filteredUpcoming,_that.searchQuery,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TeacherModel? teacher,  List<TeacherClassModel> upcomingClasses,  List<TeacherClassModel> completedClasses,  List<TeacherClassModel> filteredUpcoming,  String searchQuery,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState():
return $default(_that.teacher,_that.upcomingClasses,_that.completedClasses,_that.filteredUpcoming,_that.searchQuery,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TeacherModel? teacher,  List<TeacherClassModel> upcomingClasses,  List<TeacherClassModel> completedClasses,  List<TeacherClassModel> filteredUpcoming,  String searchQuery,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.teacher,_that.upcomingClasses,_that.completedClasses,_that.filteredUpcoming,_that.searchQuery,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherDashboardState implements TeacherDashboardState {
  const _TeacherDashboardState({this.teacher, final  List<TeacherClassModel> upcomingClasses = const [], final  List<TeacherClassModel> completedClasses = const [], final  List<TeacherClassModel> filteredUpcoming = const [], this.searchQuery = '', this.isLoading = false, this.error}): _upcomingClasses = upcomingClasses,_completedClasses = completedClasses,_filteredUpcoming = filteredUpcoming;
  

@override final  TeacherModel? teacher;
 final  List<TeacherClassModel> _upcomingClasses;
@override@JsonKey() List<TeacherClassModel> get upcomingClasses {
  if (_upcomingClasses is EqualUnmodifiableListView) return _upcomingClasses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingClasses);
}

 final  List<TeacherClassModel> _completedClasses;
@override@JsonKey() List<TeacherClassModel> get completedClasses {
  if (_completedClasses is EqualUnmodifiableListView) return _completedClasses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedClasses);
}

 final  List<TeacherClassModel> _filteredUpcoming;
@override@JsonKey() List<TeacherClassModel> get filteredUpcoming {
  if (_filteredUpcoming is EqualUnmodifiableListView) return _filteredUpcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredUpcoming);
}

@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDashboardStateCopyWith<_TeacherDashboardState> get copyWith => __$TeacherDashboardStateCopyWithImpl<_TeacherDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDashboardState&&(identical(other.teacher, teacher) || other.teacher == teacher)&&const DeepCollectionEquality().equals(other._upcomingClasses, _upcomingClasses)&&const DeepCollectionEquality().equals(other._completedClasses, _completedClasses)&&const DeepCollectionEquality().equals(other._filteredUpcoming, _filteredUpcoming)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,teacher,const DeepCollectionEquality().hash(_upcomingClasses),const DeepCollectionEquality().hash(_completedClasses),const DeepCollectionEquality().hash(_filteredUpcoming),searchQuery,isLoading,error);

@override
String toString() {
  return 'TeacherDashboardState(teacher: $teacher, upcomingClasses: $upcomingClasses, completedClasses: $completedClasses, filteredUpcoming: $filteredUpcoming, searchQuery: $searchQuery, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$TeacherDashboardStateCopyWith<$Res> implements $TeacherDashboardStateCopyWith<$Res> {
  factory _$TeacherDashboardStateCopyWith(_TeacherDashboardState value, $Res Function(_TeacherDashboardState) _then) = __$TeacherDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 TeacherModel? teacher, List<TeacherClassModel> upcomingClasses, List<TeacherClassModel> completedClasses, List<TeacherClassModel> filteredUpcoming, String searchQuery, bool isLoading, String? error
});


@override $TeacherModelCopyWith<$Res>? get teacher;

}
/// @nodoc
class __$TeacherDashboardStateCopyWithImpl<$Res>
    implements _$TeacherDashboardStateCopyWith<$Res> {
  __$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final _TeacherDashboardState _self;
  final $Res Function(_TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teacher = freezed,Object? upcomingClasses = null,Object? completedClasses = null,Object? filteredUpcoming = null,Object? searchQuery = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_TeacherDashboardState(
teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as TeacherModel?,upcomingClasses: null == upcomingClasses ? _self._upcomingClasses : upcomingClasses // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,completedClasses: null == completedClasses ? _self._completedClasses : completedClasses // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,filteredUpcoming: null == filteredUpcoming ? _self._filteredUpcoming : filteredUpcoming // ignore: cast_nullable_to_non_nullable
as List<TeacherClassModel>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherModelCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
    return null;
  }

  return $TeacherModelCopyWith<$Res>(_self.teacher!, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}

// dart format on
