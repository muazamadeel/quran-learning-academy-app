// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherClassModel _$TeacherClassModelFromJson(Map<String, dynamic> json) =>
    _TeacherClassModel(
      id: json['id'] as String,
      studentName: json['studentName'] as String,
      subject: json['subject'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      status: json['status'] as String? ?? 'confirmed',
      studentAvatarUrl: json['studentAvatarUrl'] as String?,
      studentRating: (json['studentRating'] as num?)?.toDouble(),
      studentReview: json['studentReview'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      meetingLink: json['meetingLink'] as String?,
      studentId: json['studentId'] as String?,
      teacherId: json['teacherId'] as String?,
    );

Map<String, dynamic> _$TeacherClassModelToJson(_TeacherClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentName': instance.studentName,
      'subject': instance.subject,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'status': instance.status,
      'studentAvatarUrl': instance.studentAvatarUrl,
      'studentRating': instance.studentRating,
      'studentReview': instance.studentReview,
      'durationMinutes': instance.durationMinutes,
      'meetingLink': instance.meetingLink,
      'studentId': instance.studentId,
      'teacherId': instance.teacherId,
    };
