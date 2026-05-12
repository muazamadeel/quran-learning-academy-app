

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_class_model.freezed.dart';
part 'teacher_class_model.g.dart';

@freezed
abstract class TeacherClassModel with _$TeacherClassModel {
  const factory TeacherClassModel({
    required String id,
    required String studentName,
    required String subject,
    required DateTime scheduledAt,
    @Default('confirmed') String status,
    String? studentAvatarUrl,
    double? studentRating,
    String? studentReview,
    int? durationMinutes,
    String? meetingLink,
    String? studentId,
    String? teacherId,
  }) = _TeacherClassModel;

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherClassModelFromJson(json);
}

extension TeacherClassModelX on TeacherClassModel {
  /// Original — 'classes' collection ke liye (agar future mein use ho)
  static TeacherClassModel fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TeacherClassModel(
      id: doc.id,
      studentName: d['studentName'] ?? '',
      subject: d['subject'] ?? '',
      scheduledAt: (d['scheduledAt'] as Timestamp).toDate(),
      status: d['status'] ?? 'confirmed',
      studentAvatarUrl: d['studentAvatarUrl'],
      studentRating: (d['studentRating'] as num?)?.toDouble(),
      studentReview: d['studentReview'],
      durationMinutes: (d['durationMinutes'] as num?)?.toInt(),
      meetingLink: d['meetingLink'],
      studentId: d['studentId'],
      teacherId: d['teacherId'],
    );
  }

  /// NEW — 'bookings' collection ke liye
  /// Firestore mein 'dateTime' field hai, 'scheduledAt' nahi
  static TeacherClassModel fromBooking(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    // dateTime field se scheduledAt banao
    DateTime scheduledAt;
    if (d['dateTime'] != null) {
      scheduledAt = (d['dateTime'] as Timestamp).toDate();
    } else if (d['scheduledAt'] != null) {
      scheduledAt = (d['scheduledAt'] as Timestamp).toDate();
    } else {
      scheduledAt = DateTime.now();
    }

    return TeacherClassModel(
      id: doc.id,
      studentName: d['studentName'] ?? '',
      subject: d['subject'] ?? '',
      scheduledAt: scheduledAt,
      status: d['status'] ?? 'confirmed',
      studentAvatarUrl: d['studentAvatarUrl'] ?? d['studentImage'] ?? '',
      studentRating: (d['studentRating'] as num?)?.toDouble(),
      studentReview: d['studentReview'],
      durationMinutes: (d['durationMinutes'] as num?)?.toInt(),
      meetingLink: d['meetingLink'],
      studentId: d['studentId'],
      teacherId: d['teacherId'],
    );
  }
}
