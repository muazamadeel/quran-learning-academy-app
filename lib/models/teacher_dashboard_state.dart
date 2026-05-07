import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_learning_app/models/teacher/teacher_model.dart';
import 'package:quran_learning_app/models/teacher_class_model.dart';

part 'teacher_dashboard_state.freezed.dart';

@freezed
abstract class TeacherDashboardState with _$TeacherDashboardState {
  const factory TeacherDashboardState({
    TeacherModel? teacher,
    @Default([]) List<TeacherClassModel> upcomingClasses,
    @Default([]) List<TeacherClassModel> completedClasses,
    @Default([]) List<TeacherClassModel> filteredUpcoming,
    @Default('') String searchQuery,
    @Default(false) bool isLoading,
    String? error,
  }) = _TeacherDashboardState;
}
