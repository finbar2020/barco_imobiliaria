import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
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
import 'package:lello/feature/maintenance_management/presentation/chat/widgets/chat_section_widget.dart';

import '../../../../helpers/pump_app.dart';

class _FakeChannels extends Fake implements GetChatChannelsUseCase {
  _FakeChannels(this.response);
  final Either<Failure, ChatChannelsResponseEntity> response;

  @override
  Future<Either<Failure, ChatChannelsResponseEntity>> call(
    GetChatChannelsRequest request,
  ) async =>
      response;
}

class _FakeSubscribe extends Fake implements SubscribeToChannelUseCase {
  @override
  Future<Either<Failure, void>> call(SubscribeToChannelRequest request) async =>
      const Right(null);
}

class _FakeUnsubscribe extends Fake implements UnsubscribeFromChannelUseCase {
  @override
  Future<Either<Failure, void>> call(
    UnsubscribeFromChannelRequest request,
  ) async =>
      const Right(null);
}

class _FakeFilters extends Fake
    implements GetMaintenanceTasksFilterOptionsUseCase {
  @override
  Future<Try<FilterOptionsEntity>> call() async =>
      Rejection(UnknownFailure('skip'));
}

class _FakeRepo extends Fake implements ChatRepository {
  @override
  Stream<ChatMessageEntity> get messagesStream => const Stream.empty();
}

ChatChannelEntity _channel(String id, {String type = 'ROTINA'}) {
  return ChatChannelEntity(
    id: id,
    typeTask: type,
    status: 'DRAFT',
    task: ChannelTaskEntity(id: 't$id', name: 'Tarefa $id'),
    lastMessage: ChannelLastMessageEntity(
      id: 'm$id',
      content: 'Última $id',
      createdAt: DateTime(2026, 1, 10),
      author: const MessageAuthorEntity(id: 'u1', name: 'Ana', email: 'a@b.c'),
    ),
  );
}

ChatConversationsBloc _bloc(
  Either<Failure, ChatChannelsResponseEntity> response,
) {
  return ChatConversationsBloc(
    _FakeChannels(response),
    _FakeSubscribe(),
    _FakeUnsubscribe(),
    _FakeFilters(),
    _FakeRepo(),
  );
}

void main() {
  testWidgets('golden — erro ao carregar conversas', (tester) async {
    final bloc = _bloc(Left(UnknownFailure('falhou')));
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const ChatSectionWidget(taskId: 't1'),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_section_error.png'),
    );
  });

  testWidgets('golden — duas conversas visíveis e ver todas', (tester) async {
    final bloc = _bloc(
      Right(
        ChatChannelsResponseEntity(
          channels: [
            _channel('1'),
            _channel('2', type: 'OS'),
            _channel('3'),
          ],
        ),
      ),
    );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: ChatSectionWidget(
          taskId: 't1',
          onViewAllConversations: () {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_section_loaded.png'),
    );
  });
}
