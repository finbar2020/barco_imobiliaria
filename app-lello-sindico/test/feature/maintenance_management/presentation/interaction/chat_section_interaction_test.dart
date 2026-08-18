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

ChatChannelEntity _channel(String id) {
  return ChatChannelEntity(
    id: id,
    typeTask: 'ROTINA',
    status: 'DRAFT',
    task: ChannelTaskEntity(id: 't$id', name: 'Tarefa $id'),
  );
}

void main() {
  testWidgets('lista vazia não renderiza a seção', (tester) async {
    final bloc = ChatConversationsBloc(
      _FakeChannels(const Right(ChatChannelsResponseEntity(channels: []))),
      _FakeSubscribe(),
      _FakeUnsubscribe(),
      _FakeFilters(),
      _FakeRepo(),
    );
    addTearDown(bloc.close);

    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const ChatSectionWidget(taskId: 't1'),
      ),
    );

    expect(find.text('Conversas'), findsNothing);
    expect(find.text('Erro ao carregar conversas'), findsNothing);
  });

  testWidgets('Ver todas dispara o callback', (tester) async {
    var viewed = false;
    final bloc = ChatConversationsBloc(
      _FakeChannels(
        Right(
          ChatChannelsResponseEntity(
            channels: [_channel('1'), _channel('2'), _channel('3')],
          ),
        ),
      ),
      _FakeSubscribe(),
      _FakeUnsubscribe(),
      _FakeFilters(),
      _FakeRepo(),
    );
    addTearDown(bloc.close);

    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: ChatSectionWidget(
          taskId: 't1',
          onViewAllConversations: () => viewed = true,
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 360),
    );

    await tester.tap(find.text('Ver todas'));
    await tester.pump();
    expect(viewed, isTrue);
    expect(find.text('Conversas'), findsOneWidget);
    expect(find.text('Tarefa 3'), findsNothing);
  });
}
