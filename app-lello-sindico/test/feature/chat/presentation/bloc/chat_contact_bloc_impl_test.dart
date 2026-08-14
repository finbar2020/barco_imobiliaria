import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/chat/domain/entity/chat_contact.dart';
import 'package:lello/feature/chat/domain/use_case/create_chat/create_chat.dart';
import 'package:lello/feature/chat/domain/use_case/list_chat_contact/list_chat_contact.dart';
import 'package:lello/feature/chat/presentation/bloc/chat_contact/chat_contact_bloc.dart';
import 'package:lello/feature/chat/presentation/bloc/chat_contact/chat_contact_bloc_impl.dart';
import 'package:lello/feature/chat/presentation/bloc/chat_contact/chat_contact_state.dart';
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
  ListChatContact listChatContact;
  CreateChat createChat;
  SessionBloc sessionBloc;
  ChatContactBloc bloc;

  var _chatContact = ChatContact()..id = "1";

  setUp(() {
    listChatContact = ListChatContactMock();
    createChat = CreateChatMock();
    sessionBloc = SessionBlocMock();
    bloc = ChatContactBlocImpl(
        sessionBloc: sessionBloc,
        listChatContact: listChatContact,
        createChat: createChat);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(listChatContact.call(any))
        .thenAnswer((_) async => Success([_chatContact]));
    bloc = ChatContactBlocImpl(
        sessionBloc: sessionBloc,
        listChatContact: listChatContact,
        createChat: createChat);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<ChatContactLoadingState>(),
          IsAnd<ChatContactLoadingState>((it) => it.data.length == 1),
          isA<ChatContactLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = ChatContactBlocImpl(
          sessionBloc: sessionBloc,
          listChatContact: listChatContact,
          createChat: createChat);

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadingState>() //default state
          ]));
    });

    test(
        'Should call load residents use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));

      bloc = ChatContactBlocImpl(
          sessionBloc: sessionBloc,
          listChatContact: listChatContact,
          createChat: createChat);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadingState>(),
            IsAnd<ChatContactLoadingState>((it) => it.data.length == 1)
          ]));

      verify(listChatContact.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      await setLoaded();
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            isA<ChatContactLoadingState>(),
            isA<ChatContactLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listChatContact.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            isA<ChatContactLoadingState>(),
            isA<ChatContactLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadingState>(),
          ]));
    });
  });

  group('begin load next page', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      await setLoaded();
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            isA<ChatContactPagingState>(),
            isA<ChatContactLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listChatContact.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            isA<ChatContactPagingState>(),
            isA<ChatContactPageFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadingState>(),
          ]));
    });
  });

  group('begin search', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      await setLoaded();
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            isA<ChatContactSearchingState>(),
            isA<ChatContactLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listChatContact.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadedState>(),
            IsAnd<ChatContactSearchingState>((it) => it.query == "1"),
            isA<ChatContactLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listChatContact.call(any))
          .thenAnswer((_) async => Success([_chatContact]));
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ChatContactLoadingState>(),
          ]));
    });
  });

//	group('begin create chat', () {
//		test('Should call create chat use case', () async {
//			bloc.beginCreateChat(_chatContact);
//			await expectLater(bloc, emitsInOrder([
//				isA<ChatContactLoadingState>(),
//			]));
//
//			verify(createChat.call(any));
//		});
//	});
}

class ListChatContactMock extends Mock implements ListChatContact {}

class CreateChatMock extends Mock implements CreateChat {}
