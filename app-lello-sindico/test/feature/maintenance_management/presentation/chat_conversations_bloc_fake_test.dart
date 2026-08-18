import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_message_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/chat_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/get_chat_channels_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/subscribe_to_channel_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/unsubscribe_from_channel_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_conversations_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_conversations_event.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_conversations_state.dart';

class _FakeChannels extends Fake implements GetChatChannelsUseCase {
  _FakeChannels();

  Either<Failure, ChatChannelsResponseEntity> first = Right(
    ChatChannelsResponseEntity(
      channels: [_channel('1')],
      pageInfo: const PageInfoEntity(
        hasNextPage: true,
        hasPreviousPage: false,
        endCursor: 'c1',
      ),
    ),
  );
  Either<Failure, ChatChannelsResponseEntity> more = Right(
    ChatChannelsResponseEntity(channels: [_channel('2')]),
  );

  @override
  Future<Either<Failure, ChatChannelsResponseEntity>> call(
    GetChatChannelsRequest request,
  ) async {
    if (request.after != null) return more;
    return first;
  }
}

class _FakeSubscribe extends Fake implements SubscribeToChannelUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, void>> call(SubscribeToChannelRequest request) async {
    calls++;
    return const Right(null);
  }
}

class _FakeUnsubscribe extends Fake implements UnsubscribeFromChannelUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, void>> call(
    UnsubscribeFromChannelRequest request,
  ) async {
    calls++;
    return const Right(null);
  }
}

class _FakeFilters extends Fake
    implements GetMaintenanceTasksFilterOptionsUseCase {
  @override
  Future<Try<FilterOptionsEntity>> call() async => Success(
        FilterOptionsEntity(
          locals: const [],
          assets: const [],
          responsibles: const [],
          employeeGroup: const [],
          taskType: const [],
          taskStatus: const [],
        ),
      );
}

class _FakeRepo extends Fake implements ChatRepository {
  final controller = StreamController<ChatMessageEntity>.broadcast();
  String? connectedUser;

  @override
  Stream<ChatMessageEntity> get messagesStream => controller.stream;

  @override
  Future<Either<Failure, void>> connectWebSocket({
    required String jwtToken,
    required String userId,
  }) async {
    connectedUser = userId;
    return const Right(null);
  }
}

ChatChannelEntity _channel(String id) {
  return ChatChannelEntity(
    id: id,
    typeTask: 'ROTINA',
    status: 'DRAFT',
    task: ChannelTaskEntity(id: 't$id', name: 'Tarefa $id'),
  );
}

String get _validJwt {
  String b64(String s) =>
      base64Url.encode(utf8.encode(s)).replaceAll('=', '');
  return '${b64('{"alg":"none"}')}.${b64('{"user":"u1"}')}.sig';
}

void main() {
  test('carrega, pagina, filtra, marca lido e recebe mensagem', () async {
    final channels = _FakeChannels();
    channels.first = Right(
      ChatChannelsResponseEntity(
        channels: [_channel('1')],
        pageInfo: const PageInfoEntity(
          hasNextPage: true,
          hasPreviousPage: false,
          endCursor: 'c1',
        ),
      ),
    );
    final repo = _FakeRepo();
    final subscribe = _FakeSubscribe();
    final unsubscribe = _FakeUnsubscribe();
    final bloc = ChatConversationsBloc(
      channels,
      subscribe,
      unsubscribe,
      _FakeFilters(),
      repo,
    );

    bloc.add(const LoadChatConversationsEvent(dayCurrent: '10/01/2026'));
    var loaded = await bloc.stream
            .firstWhere((s) => s is ChatConversationsLoadedState)
        as ChatConversationsLoadedState;
    expect(loaded.conversations, hasLength(1));

    bloc.add(const LoadMoreConversationsEvent(endCursor: 'c1'));
    loaded = await bloc.stream
            .firstWhere((s) =>
                s is ChatConversationsLoadedState &&
                (s as ChatConversationsLoadedState).conversations.length == 2)
        as ChatConversationsLoadedState;
    expect(loaded.conversations.map((c) => c.id), ['1', '2']);

    bloc.add(const FilterChatConversationsEvent(status: ['DONE']));
    loaded = await bloc.stream
            .firstWhere((s) => s is ChatConversationsLoadedState)
        as ChatConversationsLoadedState;
    expect(loaded.conversations, isNotEmpty);

    bloc.add(const RefreshChatConversationsEvent());
    loaded = await bloc.stream
            .firstWhere((s) => s is ChatConversationsLoadedState)
        as ChatConversationsLoadedState;

    bloc.add(const MarkChannelAsReadEvent('1'));
    loaded = await bloc.stream
            .firstWhere((s) => s is ChatConversationsLoadedState)
        as ChatConversationsLoadedState;
    expect(loaded.conversations.first.hasUnreadMessages, isFalse);

    repo.controller.add(
      ChatMessageEntity(
        id: 'm9',
        content: 'oi',
        channelId: '1',
        authorId: 'u1',
        messageType: 'TEXT',
        createdAt: DateTime(2026, 1, 10),
        author: const ChatAuthorEntity(id: 'u1', name: 'Ana', email: 'a@b.c'),
      ),
    );
    loaded = await bloc.stream
            .firstWhere((s) =>
                s is ChatConversationsLoadedState &&
                (s as ChatConversationsLoadedState)
                    .conversations
                    .first
                    .hasUnreadMessages)
        as ChatConversationsLoadedState;
    expect(loaded.conversations.first.lastMessage?.content, 'oi');
    expect(loaded.conversations.first.hasUnread, isTrue);

    bloc.add(const LoadMoreConversationsEvent(endCursor: 'x'));
    await Future<void>.delayed(Duration.zero);

    await repo.controller.close();
    await bloc.close();
  });

  test('inscreve com jwt válido, ignora token ruim e cancela inscrição',
      () async {
    final channels = _FakeChannels();
    channels.first = Right(
      ChatChannelsResponseEntity(
        channels: [_channel('1')],
        ttJwtToken: _validJwt,
      ),
    );
    final repo = _FakeRepo();
    final subscribe = _FakeSubscribe();
    final unsubscribe = _FakeUnsubscribe();
    final bloc = ChatConversationsBloc(
      channels,
      subscribe,
      unsubscribe,
      _FakeFilters(),
      repo,
    );

    bloc.add(const LoadChatConversationsEvent());
    await bloc.stream.firstWhere((s) => s is ChatConversationsLoadedState);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(repo.connectedUser, 'u1');
    expect(subscribe.calls, greaterThan(0));

    bloc.add(const SubscribeToChannelsEvent(channelIds: ['1'], jwtToken: 'bad'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    bloc.add(const UnsubscribeFromChannelsEvent(channelIds: ['1', 'missing']));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(unsubscribe.calls, greaterThan(0));

    await repo.controller.close();
    await bloc.close();
  });

  test('erro, vazio e load more sem estado carregado', () async {
    final channels = _FakeChannels();
    channels.first = Left(UnknownFailure('x'));
    final repo = _FakeRepo();
    final bloc = ChatConversationsBloc(
      channels,
      _FakeSubscribe(),
      _FakeUnsubscribe(),
      _FakeFilters(),
      repo,
    );

    bloc.add(const LoadChatConversationsEvent());
    expect(
      await bloc.stream.firstWhere((s) => s is ChatConversationsErrorState),
      isA<ChatConversationsErrorState>(),
    );

    channels.first = const Right(ChatChannelsResponseEntity(channels: []));
    bloc.add(const LoadChatConversationsEvent());
    expect(
      await bloc.stream.firstWhere((s) => s is ChatConversationsEmptyState),
      isA<ChatConversationsEmptyState>(),
    );

    bloc.add(const LoadMoreConversationsEvent(endCursor: 'c'));
    bloc.add(const MarkChannelAsReadEvent('1'));
    bloc.add(
      NewMessageReceivedEvent(
        ChatMessageEntity(
          id: 'm',
          channelId: '1',
          authorId: 'u',
          messageType: 'TEXT',
          createdAt: DateTime(2026, 1, 1),
          author: const ChatAuthorEntity(id: 'u', name: 'A', email: 'a@b.c'),
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    await repo.controller.close();
    await bloc.close();
  });
}
