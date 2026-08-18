import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';
import '../../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  RegisterSpace registerSpace;
  UploadSpaceFile uploadSpaceFile;
  ListAccounts listAccounts;
  ListSpaceType listSpaceType;
  ListSpace listSpace;
  UpdateSpace updateSpace;
  SessionBloc sessionBloc;
  SpaceRegistrationBloc bloc;

  var _space = Space();
  setUp(() {
    registerSpace = RegisterSpaceMock();
    listAccounts = ListAccountsMock();
    listSpaceType = ListSpaceTypeMock();
    listSpace = ListSpaceMock();
    updateSpace = UpdateSpaceMock();
    uploadSpaceFile = UploadSpaceFileMock();
    sessionBloc = SessionBlocMock();
    bloc = SpaceRegistrationBlocImpl(
        sessionBloc: sessionBloc,
        registerSpace: registerSpace,
        uploadSpaceFile: uploadSpaceFile,
        listAccounts: listAccounts,
        listSpaceType: listSpaceType,
        listSpaces: listSpace,
        updateSpace: updateSpace);
  });

  group('when session changes', () {
//		test('Should emit load event if session is loaded', () async {
//			sessionBloc = SessionBlocMock();
//			final session = Session()..selectedCondominium = (Condominium()..id = "123");
//			final List<Account> accounts = [];
//			whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
//			when(listAccounts.call(any)).thenAnswer((_) async => Success(accounts));
//
//			bloc = SpaceRegistrationBlocImpl(sessionBloc: sessionBloc, registerSpace: registerSpace, uploadSpaceFile: uploadSpaceFile, listAccounts: listAccounts,
//					listSpaceType: listSpaceType, listSpaces: listSpace, updateSpace: updateSpace);
//
//			expect(bloc, emitsInOrder([
//				isA<SpaceRegistrationIdleState>(),//default state
//				isA<SpaceRegistrationLoadingState>(),
//				IsAnd<SpaceRegistrationIdleState>((it) => it.condominium?.id == "123" && it.accounts == accounts)
//			]));
//		});

    test('Should not load event if session is not yet loaded', () async {
      sessionBloc = SessionBlocMock();
      whenListen(sessionBloc, Stream.fromIterable([SessionLoadingState(null)]));

      bloc = SpaceRegistrationBlocImpl(
          sessionBloc: sessionBloc,
          registerSpace: registerSpace,
          uploadSpaceFile: uploadSpaceFile,
          listAccounts: listAccounts,
          listSpaceType: listSpaceType,
          listSpaces: listSpace,
          updateSpace: updateSpace);

      expect(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>(), //default state
          ]));
    });

//		test('Should emit load failed event if session is loaded and list accounts fails', () async {
//			sessionBloc = SessionBlocMock();
//			final session = Session()..selectedCondominium = (Condominium()..id = "123");
//			whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
//			when(listAccounts.call(any)).thenAnswer((_) async => Rejection(UnknownFailure(null)));
//
//			bloc = SpaceRegistrationBlocImpl(sessionBloc: sessionBloc, registerSpace: registerSpace, uploadSpaceFile: uploadSpaceFile, listAccounts: listAccounts,
//					listSpaceType: listSpaceType, listSpaces: listSpace, updateSpace: updateSpace);
//
//			expect(bloc, emitsInOrder([
//				isA<SpaceRegistrationIdleState>(),//default state
//				isA<SpaceRegistrationLoadingState>(),
//				isA<SpaceRegistrationLoadFailedState>()
//			]));
//		});
  });

  group('next step', () {
    test('Shoud emit form state with next step', () async {
      bloc.nextStep();
      expect(
          bloc,
          emitsInOrder([
            IsAnd<SpaceRegistrationIdleState>((it) =>
                it.step ==
                SpaceRegistrationBlocImpl.stepOrder.first), //default state
            IsAnd<SpaceRegistrationIdleState>(
                (it) => it.step == SpaceRegistrationBlocImpl.stepOrder[1])
          ]));
    });
  });

  group('go to step', () {
    test('Shoud emit form state with next step', () async {
      final step = SpaceRegistrationStep.rules;
      bloc.goToStep(step);
      expect(
          bloc,
          emitsInOrder([
            IsAnd<SpaceRegistrationIdleState>((it) =>
                it.step ==
                SpaceRegistrationBlocImpl.stepOrder.first), //default state
            IsAnd<SpaceRegistrationIdleState>((it) => it.step == step)
          ]));
    });
  });

  group('begin register', () {
    test('Should not emit any state if session is not loaded yet', () async {
      final session = Session();
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_space);

      expect(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>() //default state
          ]));
    });

    test('Should emit registering state if session is already loaded',
        () async {
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_space);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>(), //default state
            isA<SpaceRegistrationRegisteringState>(),
          ]));
    });

    test('Should call register reservation use case', () async {
      when(registerSpace.call(any)).thenAnswer((_) async => Success(_space));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_space);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>(), //default state
            isA<SpaceRegistrationRegisteringState>(),
          ]));

      verify(registerSpace.call(any));
    });

    test('Should emit loaded state if register succeeds', () async {
      when(registerSpace.call(any)).thenAnswer((_) async => Success(_space));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_space);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>(), //default state
            isA<SpaceRegistrationRegisteringState>(),
            isA<SpaceRegistrationRegisteredState>(),
          ]));
    });

    test('Should emit failed state if register failes', () async {
      when(registerSpace.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_space);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationIdleState>(), //default state
            isA<SpaceRegistrationRegisteringState>(),
            isA<SpaceRegistrationRegisterFailedState>(),
          ]));
    });
  });
}

class RegisterSpaceMock extends Mock implements RegisterSpace {}

class UploadSpaceFileMock extends Mock implements UploadSpaceFile {}

class ListAccountsMock extends Mock implements ListAccounts {}

class ListSpaceTypeMock extends Mock implements ListSpaceType {}

class ListSpaceMock extends Mock implements ListSpace {}

class UpdateSpaceMock extends Mock implements UpdateSpace {}
