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
      subject: json['subject'] as String,
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentName': instance.studentName,
      'studentImage': instance.studentImage,
      'date': instance.date,
      'time': instance.time,
      'subject': instance.subject,
      'status': instance.status,
    };
