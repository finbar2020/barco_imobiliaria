import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_message_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_messages_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/chat_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/connect_websocket_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/create_chat_channel_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/get_chat_channels_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/get_chat_messages_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/send_chat_message_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/subscribe_to_channel_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/unsubscribe_from_channel_use_case.dart';

const _channel = ChatChannelEntity(
  id: 'ch1',
  typeTask: 'ROTINA',
  status: 'PENDING',
  task: ChannelTaskEntity(id: 't1', name: 'Bomba'),
);

final _message = ChatMessageEntity(
  id: 'm1',
  content: 'olá',
  channelId: 'ch1',
  authorId: 'u1',
  messageType: 'TEXT',
  createdAt: DateTime(2026, 1, 15),
  author: const ChatAuthorEntity(id: 'u1', name: 'João', email: 'a@b.c'),
);

class _FakeChatRepo extends Fake implements ChatRepository {
  Object? last;

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
    this.last = dtStart;
    return const Right(ChatChannelsResponseEntity(channels: [_channel]));
  }

  @override
  Future<Either<Failure, ChatMessagesResponseEntity>> getMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  }) async {
    last = channelId;
    return Right(ChatMessagesResponseEntity(messages: [_message]));
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String channelId,
    required String content,
    String? attachmentId,
  }) async {
    last = content;
    return Right(_message);
  }

  @override
  Future<Either<Failure, ChatChannelEntity>> createChannel({
    required String taskId,
    String? name,
  }) async {
    last = taskId;
    return const Right(_channel);
  }

  @override
  Future<Either<Failure, void>> connectWebSocket({
    required String jwtToken,
    required String userId,
  }) async {
    last = jwtToken;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> subscribeToChannel({
    required String channelId,
    required String jwtToken,
  }) async {
    last = channelId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromChannel({
    required String channelId,
  }) async {
    last = channelId;
    return const Right(null);
  }
}

void main() {
  late _FakeChatRepo repo;

  setUp(() => repo = _FakeChatRepo());

  test('GetChatChannels encaminha o intervalo', () async {
    final result = await GetChatChannelsUseCaseImpl(repo)(
      const GetChatChannelsRequest(dtStart: '01/01/2026'),
    );
    expect(result.isRight(), isTrue);
    expect(repo.last, '01/01/2026');
  });

  test('GetChatMessages encaminha o channelId', () async {
    final result = await GetChatMessagesUseCaseImpl(repo)(
      const GetChatMessagesRequest(channelId: 'ch1'),
    );
    expect(result.isRight(), isTrue);
    expect(repo.last, 'ch1');
  });

  test('SendChatMessage encaminha o conteúdo', () async {
    final result = await SendChatMessageUseCaseImpl(repo)(
      const SendChatMessageRequest(channelId: 'ch1', content: 'olá'),
    );
    expect(result.isRight(), isTrue);
    expect(repo.last, 'olá');
  });

  test('CreateChatChannel encaminha o taskId', () async {
    final result = await CreateChatChannelUseCaseImpl(repo)(
      const CreateChatChannelRequest(taskId: 't1'),
    );
    expect(result.isRight(), isTrue);
    expect(repo.last, 't1');
  });

  test('Connect / subscribe / unsubscribe encaminham params', () async {
    expect(
      (await ConnectWebSocketUseCaseImpl(repo)(
        const ConnectWebSocketRequest(jwtToken: 'jwt', userId: 'u1'),
      ))
          .isRight(),
      isTrue,
    );
    expect(repo.last, 'jwt');

    expect(
      (await SubscribeToChannelUseCaseImpl(repo)(
        const SubscribeToChannelRequest(channelId: 'ch1', jwtToken: 'jwt'),
      ))
          .isRight(),
      isTrue,
    );
    expect(repo.last, 'ch1');

    expect(
      (await UnsubscribeFromChannelUseCaseImpl(repo)(
        const UnsubscribeFromChannelRequest(channelId: 'ch2'),
      ))
          .isRight(),
      isTrue,
    );
    expect(repo.last, 'ch2');
  });

  test('ChatChannelEntity isDone e copyWith', () {
    expect(_channel.isDone, isFalse);
    expect(_channel.copyWith(status: 'DONE').isDone, isTrue);
    expect(_channel.hasUnread, isFalse);
  });
}
