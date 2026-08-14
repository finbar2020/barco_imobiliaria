import 'package:json_annotation/json_annotation.dart';

part 'send_chat_message_request_model.g.dart';

/// Request para enviar mensagem no chat
@JsonSerializable()
class SendChatMessageRequestModel {
  final String channelId;
  final String content;
  final String messageType;
  final String sentAt;

  const SendChatMessageRequestModel({
    required this.channelId,
    required this.content,
    this.messageType = 'TEXT',
    required this.sentAt,
  });

  factory SendChatMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessageRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatMessageRequestModelToJson(this);
}
