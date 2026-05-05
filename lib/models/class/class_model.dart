import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_model.freezed.dart';
part 'class_model.g.dart';

@Freezed()
abstract class ClassModel with _$ClassModel {
  const factory ClassModel({
    required String studentName,
    required String subject,
    required String time,
    @Default('') String notes,
    @Default(false) bool isMuted,
    @Default(true) bool isVideoOn,
    @Default(false) bool isScreenSharing,
  }) = _ClassModel;

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);
}
