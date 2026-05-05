// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => _ClassModel(
  studentName: json['studentName'] as String,
  subject: json['subject'] as String,
  time: json['time'] as String,
  notes: json['notes'] as String? ?? '',
  isMuted: json['isMuted'] as bool? ?? false,
  isVideoOn: json['isVideoOn'] as bool? ?? true,
  isScreenSharing: json['isScreenSharing'] as bool? ?? false,
);

Map<String, dynamic> _$ClassModelToJson(_ClassModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'subject': instance.subject,
      'time': instance.time,
      'notes': instance.notes,
      'isMuted': instance.isMuted,
      'isVideoOn': instance.isVideoOn,
      'isScreenSharing': instance.isScreenSharing,
    };
