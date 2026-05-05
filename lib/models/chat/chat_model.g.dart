// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      message: json['message'] as String,
      time: json['time'] as String,
      isSentByMe: json['isSentByMe'] as bool,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'time': instance.time,
      'isSentByMe': instance.isSentByMe,
    };

_ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    _ChatUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      time: json['time'] as String,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? true,
    );

Map<String, dynamic> _$ChatUserModelToJson(_ChatUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'time': instance.time,
      'unreadCount': instance.unreadCount,
      'isOnline': instance.isOnline,
    };
