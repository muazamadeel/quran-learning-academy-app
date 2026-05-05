// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressModel _$ProgressModelFromJson(Map<String, dynamic> json) =>
    _ProgressModel(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      progressNote: json['progressNote'] as String? ?? '',
      whatWasCovered: json['whatWasCovered'] as String? ?? '',
      homework: json['homework'] as String? ?? '',
      rating: json['rating'] as String? ?? 'Good',
    );

Map<String, dynamic> _$ProgressModelToJson(_ProgressModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'progressNote': instance.progressNote,
      'whatWasCovered': instance.whatWasCovered,
      'homework': instance.homework,
      'rating': instance.rating,
    };
