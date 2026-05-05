import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@Freezed()
abstract class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String studentName,
    required String studentImage,
    required String date,
    required String time,
    required String subject,
    @Default('pending') String status, // pending, confirmed, completed
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
