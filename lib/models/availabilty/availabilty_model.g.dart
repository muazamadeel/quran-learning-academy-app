// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availabilty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    _TimeSlotModel(
      id: json['id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$TimeSlotModelToJson(_TimeSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isAvailable': instance.isAvailable,
    };

_DayAvailabilityModel _$DayAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => _DayAvailabilityModel(
  day: json['day'] as String,
  timeRange: json['timeRange'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$DayAvailabilityModelToJson(
  _DayAvailabilityModel instance,
) => <String, dynamic>{
  'day': instance.day,
  'timeRange': instance.timeRange,
  'isEnabled': instance.isEnabled,
};

_AvailabilityModel _$AvailabilityModelFromJson(Map<String, dynamic> json) =>
    _AvailabilityModel(
      teacherId: json['teacherId'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DayAvailabilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSaved: json['isSaved'] as bool? ?? false,
    );

Map<String, dynamic> _$AvailabilityModelToJson(_AvailabilityModel instance) =>
    <String, dynamic>{
      'teacherId': instance.teacherId,
      'days': instance.days,
      'isSaved': instance.isSaved,
    };
