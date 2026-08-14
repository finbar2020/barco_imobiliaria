import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../entity/chat/chat_channel_entity.dart';
import '../entity/chat/chat_message_entity.dart';
import '../entity/chat/chat_messages_response_entity.dart';

/// Repository interface para chat de manutenção
abstract class ChatRepository {
  /// Busca lista de canais de chat com paginação
  Future<Either<Failure, ChatChannelsResponseEntity>> getChannels({
    String? dtStart,
    String? untilDate,
    String? display,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? status,
    List<String>? typeTask,
    int? first,
    String? after,
    String? before,
    int? last,
  });

  /// Busca mensagens de um canal
  Future<Either<Failure, ChatMessagesResponseEntity>> getMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  });

  /// Envia uma mensagem
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String channelId,
    required String content,
    String? attachmentId,
  });

  /// Cria um novo canal de chat
  Future<Either<Failure, ChatChannelEntity>> createChannel({
    required String taskId,
    String? name,
  });

  /// Conecta ao WebSocket
  Future<Either<Failure, void>> connectWebSocket({
    required String jwtToken,
    required String userId,
  });

  /// Desconecta do WebSocket
  Future<Either<Failure, void>> disconnectWebSocket();

  /// Inscreve em um canal para receber mensagens em tempo real
  Future<Either<Failure, void>> subscribeToChannel({
    required String channelId,
    required String jwtToken,
  });

  /// Cancela inscrição de um canal
  Future<Either<Failure, void>> unsubscribeFromChannel({
    required String channelId,
  });

  /// Envia mensagem via WebSocket
  Future<Either<Failure, void>> sendMessageViaWebSocket({
    required String channelId,
    required String content,
    required String jwtToken,
  });

  /// Stream de mensagens recebidas em tempo real
  Stream<ChatMessageEntity> get messagesStream;

  /// Stream de status da conexão WebSocket
  Stream<WebSocketConnectionStatus> get connectionStatusStream;
}

/// Status da conexão WebSocket
enum WebSocketConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}
