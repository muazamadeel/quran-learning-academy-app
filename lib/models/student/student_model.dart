import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_model.freezed.dart';
part 'student_model.g.dart';

@freezed
abstract class StudentModel with _$StudentModel {
  const factory StudentModel({
    required String id,
    required String name,
    required String email,
    required String dob,
    @Default('') String profileImage,
    @Default('') String subscriptionPlan,
    @Default(0) int totalClassesCompleted,
    @Default(0) int upcomingClassesCount,
    @Default(false) bool isSubscribed,
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);
}

@freezed
abstract class TeacherListModel with _$TeacherListModel {
  const factory TeacherListModel({
    required String id,
    required String name,
    required String experience,
    required List<String> languages,
    required double rating,
    required int totalStudents,
    @Default('') String profileImage,
    @Default(true) bool isAvailable,
    @Default([]) List<String> subjects,
    @Default('') String country,
    @Default('') String timezone,
    @Default(<String, dynamic>{}) Map<String, dynamic> availability,
  }) = _TeacherListModel;

  factory TeacherListModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherListModelFromJson(json);
}

@freezed
abstract class StudentUpcomingClassModel with _$StudentUpcomingClassModel {
  const factory StudentUpcomingClassModel({
    required String id,
    required String teacherName,
    required String teacherImage,
    required String time,
    required String date,
    required String subject,
    @Default('upcoming') String status,
  }) = _StudentUpcomingClassModel;

  factory StudentUpcomingClassModel.fromJson(Map<String, dynamic> json) =>
      _$StudentUpcomingClassModelFromJson(json);
}

@freezed
abstract class StudentProgressModel with _$StudentProgressModel {
  const factory StudentProgressModel({
    required String id,
    required String teacherName,
    required String subject,
    required String date,
    required String progressNote,
    required String whatWasCovered,
    required String homework,
    required String rating,
  }) = _StudentProgressModel;

  factory StudentProgressModel.fromJson(Map<String, dynamic> json) =>
      _$StudentProgressModelFromJson(json);
}

@freezed
abstract class SubscriptionPlanModel with _$SubscriptionPlanModel {
  const factory SubscriptionPlanModel({
    required String id,
    required String title,
    required double price,
    required int classesPerWeek,
    required int studentsAllowed,
    required List<String> features,
    @Default(false) bool isPopular,
  }) = _SubscriptionPlanModel;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);
}

@freezed
abstract class SlotModel with _$SlotModel {
  const factory SlotModel({
    required String id,
    required String time,
    @Default(false) bool isSelected,
    @Default(true) bool isAvailable,
  }) = _SlotModel;

  factory SlotModel.fromJson(Map<String, dynamic> json) =>
      _$SlotModelFromJson(json);
}
