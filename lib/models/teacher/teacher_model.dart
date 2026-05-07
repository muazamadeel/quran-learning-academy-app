// lib/models/teacher/teacher_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_model.freezed.dart';
part 'teacher_model.g.dart';

@freezed
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

extension TeacherModelX on TeacherModel {
  static TeacherModel fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TeacherModel(
      id: doc.id,
      name: d['name'] ?? '',
      email: d['email'] ?? '',
      experience: d['experience'] ?? '',
      languages: List<String>.from(d['languages'] ?? []),
      rating: (d['rating'] as num?)?.toDouble() ?? 0.0,
      totalStudents: (d['totalStudents'] as num?)?.toInt() ?? 0,
      todayClasses: (d['todayClasses'] as num?)?.toInt() ?? 0,
      monthEarnings: (d['monthEarnings'] as num?)?.toDouble() ?? 0.0,
      profileImage: d['profileImage'] ?? '',
      isAvailable: d['isAvailable'] ?? true,
    );
  }
}
