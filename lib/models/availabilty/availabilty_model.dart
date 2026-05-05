import 'package:freezed_annotation/freezed_annotation.dart';

part 'availabilty_model.freezed.dart';
part 'availabilty_model.g.dart';

@Freezed()
abstract class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required String id,
    required String startTime,
    required String endTime,
    @Default(true) bool isAvailable,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
}

@Freezed()
abstract class DayAvailabilityModel with _$DayAvailabilityModel {
  const factory DayAvailabilityModel({
    required String day,
    required String timeRange,
    @Default(true) bool isEnabled,
  }) = _DayAvailabilityModel;

  factory DayAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$DayAvailabilityModelFromJson(json);
}

@Freezed()
abstract class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    required String teacherId,
    required List<DayAvailabilityModel> days,
    @Default(false) bool isSaved,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);
}
