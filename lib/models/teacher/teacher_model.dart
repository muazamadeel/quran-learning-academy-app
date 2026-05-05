import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_model.freezed.dart';
part 'teacher_model.g.dart';

@Freezed()
abstract class TeacherModel with _$TeacherModel {
  const factory TeacherModel({
    required String id,
    required String name,
    required String email,
    required String experience,
    required List<String> languages,
    required double rating,
    required int totalStudents,
    required int todayClasses,
    required double monthEarnings,
    @Default('') String profileImage,
    @Default(true) bool isAvailable,
  }) = _TeacherModel;

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);
}

// Upcoming Class Model
@Freezed()
abstract class UpcomingClassModel with _$UpcomingClassModel {
  const factory UpcomingClassModel({
    required String id,
    required String studentName,
    required String studentImage,
    required String time,
    required String subject,
    @Default('upcoming') String status,
  }) = _UpcomingClassModel;

  factory UpcomingClassModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingClassModelFromJson(json);
}
