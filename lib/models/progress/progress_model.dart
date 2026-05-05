import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_model.freezed.dart';
part 'progress_model.g.dart';

@Freezed()
abstract class ProgressModel with _$ProgressModel {
  const factory ProgressModel({
    required String studentId,
    required String studentName,
    @Default('') String progressNote,
    @Default('') String whatWasCovered,
    @Default('') String homework,
    @Default('Good') String rating,
  }) = _ProgressModel;

  factory ProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressModelFromJson(json);
}
