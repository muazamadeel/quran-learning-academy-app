import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@Freezed()
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String message,
    required String time,
    required bool isSentByMe,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

@Freezed()
abstract class ChatUserModel with _$ChatUserModel {
  const factory ChatUserModel({
    required String id,
    required String name,
    required String lastMessage,
    required String time,
    @Default(0) int unreadCount,
    @Default(true) bool isOnline,
  }) = _ChatUserModel;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUserModelFromJson(json);
}
