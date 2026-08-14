import 'package:equatable/equatable.dart';
import '../../../domain/entity/chat/chat_message_entity.dart';

/// Eventos do BLoC de mensagens de chat
abstract class ChatMessagesEvent extends Equatable {
  const ChatMessagesEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar mensagens de um canal
class LoadChatMessagesEvent extends ChatMessagesEvent {
  final String channelId;
  final String? before;
  final String? after;
  final int? limit;

  const LoadChatMessagesEvent({
    required this.channelId,
    this.before,
    this.after,
    this.limit,
  });

  @override
  List<Object?> get props => [channelId, before, after, limit];
}

/// Evento para enviar uma mensagem
class SendChatMessageEvent extends ChatMessagesEvent {
  final String channelId;
  final String content;
  final String? attachmentId;
  final String? jwtToken;

  const SendChatMessageEvent({
    required this.channelId,
    required this.content,
    this.attachmentId,
    this.jwtToken,
  });

  @override
  List<Object?> get props => [channelId, content, attachmentId, jwtToken];
}

/// Evento quando uma nova mensagem é recebida via WebSocket
class NewMessageReceivedInChannelEvent extends ChatMessagesEvent {
  final ChatMessageEntity message;

  const NewMessageReceivedInChannelEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Evento para atualizar mensagens
class RefreshChatMessagesEvent extends ChatMessagesEvent {
  final String channelId;

  const RefreshChatMessagesEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

/// Evento para reenviar uma mensagem que falhou
class RetrySendMessageEvent extends ChatMessagesEvent {
  final String messageId;
  final String channelId;
  final String content;
  final String? attachmentId;

  const RetrySendMessageEvent({
    required this.messageId,
    required this.channelId,
    required this.content,
    this.attachmentId,
  });

  @override
  List<Object?> get props => [messageId, channelId, content, attachmentId];
}
