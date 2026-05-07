// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  profileImage: json['profileImage'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  isApproved: json['isApproved'] as bool? ?? false,
  timezone: json['timezone'] as String? ?? '',
  country: json['country'] as String? ?? '',
  availability:
      json['availability'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'profileImage': instance.profileImage,
      'phone': instance.phone,
      'createdAt': instance.createdAt,
      'isApproved': instance.isApproved,
      'timezone': instance.timezone,
      'country': instance.country,
      'availability': instance.availability,
    };
