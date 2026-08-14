import 'chat_message_entity.dart';

/// Entity que representa a resposta da API de mensagens
class ChatMessagesResponseEntity {
  final List<ChatMessageEntity> messages;
  final String? currentUserId;

  const ChatMessagesResponseEntity({
    required this.messages,
    this.currentUserId,
  });
}
