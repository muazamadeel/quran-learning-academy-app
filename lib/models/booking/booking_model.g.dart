// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      id: json['id'] as String,
      studentName: json['studentName'] as String,
      studentImage: json['studentImage'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String? ?? 'pending',
      studentId: json['studentId'] as String?,
      teacherId: json['teacherId'] as String?,
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      meetingLink: json['meetingLink'] as String?,
      studentRating: (json['studentRating'] as num?)?.toDouble(),
      studentReview: json['studentReview'] as String?,
      teacherTimezone: json['teacherTimezone'] as String? ?? '',
      studentTimezone: json['studentTimezone'] as String? ?? '',
      teacherSlotTime: json['teacherSlotTime'] as String? ?? '',
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentName': instance.studentName,
      'studentImage': instance.studentImage,
      'date': instance.date,
      'time': instance.time,
      'status': instance.status,
      'studentId': instance.studentId,
      'teacherId': instance.teacherId,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'meetingLink': instance.meetingLink,
      'studentRating': instance.studentRating,
      'studentReview': instance.studentReview,
      'teacherTimezone': instance.teacherTimezone,
      'studentTimezone': instance.studentTimezone,
      'teacherSlotTime': instance.teacherSlotTime,
    };
