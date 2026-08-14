import 'package:essentials/essentials.dart';
import '../../adapters/chat/chat_channel_adapter.dart';
import '../../adapters/chat/chat_message_adapter.dart';
import '../../domain/entity/chat/chat_channel_entity.dart';
import '../../domain/entity/chat/chat_message_entity.dart';
import '../../domain/entity/chat/chat_messages_response_entity.dart';
import '../../domain/repository/chat_repository.dart';
import '../model/chat/send_chat_message_request_model.dart';
import '../model/chat/create_chat_channel_request_model.dart';
import '../model/chat/filter_chat_channels_request_model.dart';
import '../service/websocket_service.dart';
import '../data_source/maintenance_management_remote_data_source.dart';

/// Implementação do ChatRepository
class ChatRepositoryImpl implements ChatRepository {
  final MaintenanceManagementRemoteDataSource _dataSource;
  final WebSocketService _webSocketService;

  ChatRepositoryImpl(this._dataSource, this._webSocketService);

  @override
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
  }) async {
    try {
      final model = await _dataSource.getChannels(
        dayCurrent: dayCurrent,
        status: status,
        typeTask: typeTask,
        assetIds: assetIds,
        localIds: localIds,
        responsibleIds: responsibleIds,
        first: first,
        after: after,
        before: before,
        last: last,
      );

      final entity = model.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(KnownFailure('CHAT_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessagesResponseEntity>> getMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  }) async {
    try {
      final model = await _dataSource.getChatMessages(
        channelId: channelId,
        before: before,
        after: after,
        limit: limit,
      );

      final entities = model.data.toEntityList();
      final responseEntity = ChatMessagesResponseEntity(
        messages: entities,
        currentUserId: model.currentUserId,
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(KnownFailure('CHAT_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String channelId,
    required String content,
    String? attachmentId,
  }) async {
    try {
      // Formatar data no padrão brasileiro que a API espera: dd/MM/yyyy HH:mm:ss
      final now = DateTime.now();
      final sentAt =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final request = SendChatMessageRequestModel(
        channelId: channelId,
        content: content,
        messageType: 'TEXT',
        sentAt: sentAt,
      );

      final model = await _dataSource.sendChatMessage(request);
      final entity = model.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(KnownFailure('CHAT_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatChannelEntity>> createChannel({
    required String taskId,
    String? name,
  }) async {
    try {
      final request = CreateChatChannelRequestModel(taskId: taskId);
      final model = await _dataSource.createChatChannel(request);

      // Buscar o canal criado para ter todos os dados
      try {
        final channelsModel = await _dataSource.filterChatChannels(
          const FilterChatChannelsRequestModel(),
        );

        final channel = channelsModel.data.firstWhere(
          (c) => c.id == model.channelId,
          orElse: () => throw Exception('Canal não encontrado na lista'),
        );

        final entity = channel.toEntity();
        return Right(entity);
      } catch (searchError) {
        // Garantir que name nunca seja null
        final taskName = name?.isNotEmpty == true ? name! : 'Nova conversa';

        final minimalEntity = ChatChannelEntity(
          id: model.channelId,
          typeTask: 'ROUTINE', // Valor padrão, será atualizado ao carregar
          status: 'NOT_STARTED',
          task: ChannelTaskEntity(
            id: taskId,
            name: taskName,
          ),
        );

        return Right(minimalEntity);
      }
    } catch (e) {
      return Left(KnownFailure('CHAT_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> connectWebSocket({
    required String jwtToken,
    required String userId,
  }) async {
    try {
      await _webSocketService.connect(
        jwtToken: jwtToken,
        userId: userId,
        isProduction: false, // TODO: Configurar baseado no ambiente
      );
      return const Right(null);
    } catch (e) {
      return Left(KnownFailure('WEBSOCKET_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectWebSocket() async {
    try {
      await _webSocketService.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(KnownFailure('WEBSOCKET_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToChannel({
    required String channelId,
    required String jwtToken,
  }) async {
    try {
      await _webSocketService.subscribe(
        channelId: channelId,
        jwtToken: jwtToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(KnownFailure('WEBSOCKET_ERROR', e, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromChannel({
    required String channelId,
  }) async {
    try {
      await _webSocketService.unsubscribe(channelId);
      return const Right(null);
    } catch (e) {
      return Left(KnownFailure('WEBSOCKET_ERROR', e, message: e.toString()));
    }
  }

  @override
  Stream<ChatMessageEntity> get messagesStream =>
      _webSocketService.messagesStream;

  @override
  Future<Either<Failure, void>> sendMessageViaWebSocket({
    required String channelId,
    required String content,
    required String jwtToken,
  }) async {
    try {
      await _webSocketService.sendMessage(
        channelId: channelId,
        content: content,
        jwtToken: jwtToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(KnownFailure('WEBSOCKET_ERROR', e, message: e.toString()));
    }
  }

  @override
  Stream<WebSocketConnectionStatus> get connectionStatusStream =>
      _webSocketService.connectionStatusStream;
}
