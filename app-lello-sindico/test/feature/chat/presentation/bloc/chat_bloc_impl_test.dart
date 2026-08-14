import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/chat/domain/entity/chat.dart';
import 'package:lello/feature/chat/domain/use_case/observe_chat/observe_chat.dart';
import 'package:lello/feature/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:lello/feature/chat/presentation/bloc/chat/chat_bloc_impl.dart';
import 'package:lello/feature/chat/presentation/bloc/chat/chat_state.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc_impl.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_state.dart';
import 'package:lello/feature/resident/presentation/page/residents_page.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ObserveChat observeChat;
  SessionBloc sessionBloc;
  ChatBloc bloc;
  final chat = Chat();

  setUp(() {
    observeChat = ObserveChatMock();
    sessionBloc = SessionBlocMock();
    bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
          Success([chat])
        ]));

    bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<ChatLoadingState>(),
          isA<ChatLoadingState>(),
          isA<ChatLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat])
          ]));

      bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadingState>() //default state
          ]));
    });

    test(
        'Should call observe chats use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat])
          ]));

      bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
      await expectLater(bloc,
          emitsInOrder([isA<ChatLoadingState>(), isA<ChatLoadingState>()]));

      verify(observeChat.call(any));
    });

    test('Should emit failure when observe chats fails', () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat]),
            Rejection(UnknownFailure(null))
          ]));

      bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadingState>(),
            isA<ChatLoadingState>(),
            isA<ChatLoadedState>(),
            isA<ChatLoadFailedState>(),
          ]));
    });

    test('Should emit loaded when observe chats succeeds', () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat])
          ]));

      bloc = ChatBlocImpl(sessionBloc: sessionBloc, observeChat: observeChat);
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadingState>(),
            isA<ChatLoadingState>(),
            isA<ChatLoadedState>(),
          ]));
    });
  });

  group('begin load', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat])
          ]));

      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadingState>() //default state
          ]));
    });

    test('Should emit failure when observe chats fails', () async {
      await setLoaded();

      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat]),
            Rejection(UnknownFailure(null))
          ]));
      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadedState>(),
            isA<ChatLoadingState>(),
            isA<ChatLoadedState>(),
            isA<ChatLoadFailedState>(),
          ]));
    });

    test('Should emit loaded when observe chats succeeds', () async {
      await setLoaded();

      when(observeChat.call(any)).thenAnswer((_) => Stream.fromIterable([
            Success([chat])
          ]));

      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<ChatLoadedState>(),
            isA<ChatLoadingState>(),
            isA<ChatLoadedState>(),
          ]));
    });
  });
}

class ObserveChatMock extends Mock implements ObserveChat {}
