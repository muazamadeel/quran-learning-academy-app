// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) =>
    _TeacherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      experience: json['experience'] as String,
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      totalStudents: (json['totalStudents'] as num).toInt(),
      todayClasses: (json['todayClasses'] as num).toInt(),
      monthEarnings: (json['monthEarnings'] as num).toDouble(),
      profileImage: json['profileImage'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$TeacherModelToJson(_TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'experience': instance.experience,
      'languages': instance.languages,
      'rating': instance.rating,
      'totalStudents': instance.totalStudents,
      'todayClasses': instance.todayClasses,
      'monthEarnings': instance.monthEarnings,
      'profileImage': instance.profileImage,
      'isAvailable': instance.isAvailable,
    };
