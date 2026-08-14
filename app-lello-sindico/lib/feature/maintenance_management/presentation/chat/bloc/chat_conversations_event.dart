import 'package:equatable/equatable.dart';
import '../../../domain/entity/chat/chat_message_entity.dart';

/// Eventos do BLoC de conversas de chat
abstract class ChatConversationsEvent extends Equatable {
  const ChatConversationsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar conversas
class LoadChatConversationsEvent extends ChatConversationsEvent {
  final String? taskId;
  final List<String>? status;
  final String? dayCurrent;
  final List<String>? typeTask;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;

  const LoadChatConversationsEvent({
    this.taskId,
    this.status,
    this.dayCurrent,
    this.typeTask,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
  });

  @override
  List<Object?> get props =>
      [taskId, status, dayCurrent, typeTask, assetIds, localIds, responsibleIds];
}

/// Evento para atualizar conversas
class RefreshChatConversationsEvent extends ChatConversationsEvent {
  const RefreshChatConversationsEvent();
}

/// Evento para filtrar conversas
class FilterChatConversationsEvent extends ChatConversationsEvent {
  final String? taskId;
  final List<String>? status;
  final List<String>? typeTask;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;

  const FilterChatConversationsEvent({
    this.taskId,
    this.status,
    this.typeTask,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
  });

  @override
  List<Object?> get props =>
      [taskId, status, typeTask, assetIds, localIds, responsibleIds];
}

/// Evento para carregar mais conversas (paginação)
class LoadMoreConversationsEvent extends ChatConversationsEvent {
  final String? dayCurrent;
  final List<String>? status;
  final List<String>? typeTask;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;
  final String endCursor;

  const LoadMoreConversationsEvent({
    this.dayCurrent,
    this.status,
    this.typeTask,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
    required this.endCursor,
  });

  @override
  List<Object?> get props => [
        dayCurrent,
        status,
        typeTask,
        assetIds,
        localIds,
        responsibleIds,
        endCursor,
      ];
}

/// Evento para inscrever em canais
class SubscribeToChannelsEvent extends ChatConversationsEvent {
  final List<String> channelIds;
  final String jwtToken;

  const SubscribeToChannelsEvent({
    required this.channelIds,
    required this.jwtToken,
  });

  @override
  List<Object?> get props => [channelIds, jwtToken];
}

/// Evento para cancelar inscrição de canais
class UnsubscribeFromChannelsEvent extends ChatConversationsEvent {
  final List<String> channelIds;

  const UnsubscribeFromChannelsEvent({
    required this.channelIds,
  });

  @override
  List<Object?> get props => [channelIds];
}

/// Evento quando uma nova mensagem é recebida via WebSocket
class NewMessageReceivedEvent extends ChatConversationsEvent {
  final ChatMessageEntity message;

  const NewMessageReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Evento para marcar canal como lido
class MarkChannelAsReadEvent extends ChatConversationsEvent {
  final String channelId;

  const MarkChannelAsReadEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}
