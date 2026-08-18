import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_message_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_messages_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/chat_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/get_chat_messages_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/chat/send_chat_message_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_messages_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_messages_event.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_messages_state.dart';

class _FakeGet extends Fake implements GetChatMessagesUseCase {
  _FakeGet(this.result);
  Either<Failure, ChatMessagesResponseEntity> result;

  @override
  Future<Either<Failure, ChatMessagesResponseEntity>> call(
    GetChatMessagesRequest request,
  ) async =>
      result;
}

class _FakeSend extends Fake implements SendChatMessageUseCase {
  _FakeSend(this.result);
  Either<Failure, ChatMessageEntity> result;

  @override
  Future<Either<Failure, ChatMessageEntity>> call(
    SendChatMessageRequest request,
  ) async =>
      result;
}

class _FakeRepo extends Fake implements ChatRepository {
  final controller = StreamController<ChatMessageEntity>.broadcast();

  @override
  Stream<ChatMessageEntity> get messagesStream => controller.stream;
}

ChatMessageEntity _msg({
  String id = 'm1',
  String channelId = 'c1',
  String content = 'oi',
  bool isFailed = false,
  bool isSending = false,
}) {
  return ChatMessageEntity(
    id: id,
    content: content,
    channelId: channelId,
    authorId: 'u1',
    messageType: 'text',
    createdAt: DateTime(2026, 1, 10, 8),
    author: const ChatAuthorEntity(id: 'u1', name: 'Ana', email: 'a@a.com'),
    isFailed: isFailed,
    isSending: isSending,
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 40));

  test('carrega, vazio, erro, envia, recebe e reenvia', () async {
    final get = _FakeGet(
      Right(ChatMessagesResponseEntity(messages: [_msg()], currentUserId: 'u1')),
    );
    final send = _FakeSend(Right(_msg(id: 'real', content: 'nova')));
    final repo = _FakeRepo();
    final bloc = ChatMessagesBloc(get, send, repo);
    addTearDown(() async {
      await bloc.close();
      await repo.controller.close();
    });

    bloc.add(const LoadChatMessagesEvent(channelId: 'c1'));
    await wait();
    expect(bloc.state, isA<ChatMessagesLoadedState>());

    get.result = const Right(ChatMessagesResponseEntity(messages: [], currentUserId: 'u1'));
    bloc.add(const LoadChatMessagesEvent(channelId: 'c1', limit: 10));
    await wait();
    expect(bloc.state, isA<ChatMessagesEmptyState>());

    get.result = Left(UnknownFailure('boom'));
    bloc.add(const RefreshChatMessagesEvent('c1'));
    await wait();
    expect(bloc.state, isA<ChatMessagesErrorState>());

    get.result = Right(
      ChatMessagesResponseEntity(messages: [_msg()], currentUserId: 'u1'),
    );
    bloc.add(const LoadChatMessagesEvent(channelId: 'c1'));
    await wait();

    bloc.add(const SendChatMessageEvent(channelId: 'c1', content: 'nova'));
    await wait();
    expect(
      (bloc.state as ChatMessagesLoadedState)
          .messages
          .any((m) => m.id.startsWith('temp_') || m.content == 'nova'),
      isTrue,
    );

    bloc.add(NewMessageReceivedInChannelEvent(_msg(id: 'ws', content: 'nova')));
    await wait();
    expect(
      (bloc.state as ChatMessagesLoadedState).messages.any((m) => m.id == 'ws'),
      isTrue,
    );

    bloc.add(NewMessageReceivedInChannelEvent(_msg(id: 'ws', content: 'nova')));
    await wait();
    bloc.add(NewMessageReceivedInChannelEvent(_msg(id: 'other', channelId: 'x')));
    await wait();

    send.result = Left(UnknownFailure('nope'));
    bloc.add(const SendChatMessageEvent(channelId: 'c1', content: 'falha'));
    await wait();
    final failedId = (bloc.state as ChatMessagesLoadedState)
        .messages
        .firstWhere((m) => m.isFailed)
        .id;

    send.result = Right(_msg(id: 'retry', content: 'falha'));
    bloc.add(
      RetrySendMessageEvent(
        messageId: failedId,
        channelId: 'c1',
        content: 'falha',
      ),
    );
    await wait();
    expect(
      (bloc.state as ChatMessagesLoadedState).messages.any((m) => m.id == 'retry'),
      isTrue,
    );
  });
}
