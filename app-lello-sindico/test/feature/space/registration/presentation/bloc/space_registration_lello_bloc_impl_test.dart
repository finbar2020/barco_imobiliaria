import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  RequestSpaceRegistration requestSpaceRegistration;
  SessionBloc sessionBloc;
  SpaceRegistrationLelloBloc bloc;

  var _request = SpaceRegistrationRequest();
  setUp(() {
    requestSpaceRegistration = RequestSpaceRegistrationMock();
    sessionBloc = SessionBlocMock();
    bloc = SpaceRegistrationLelloBloc(
        sessionBloc: sessionBloc,
        requestSpaceRegistration: requestSpaceRegistration);
  });

  group('begin register', () {
    test('Should not emit any state if session is not loaded yet', () async {
      final session = Session();
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_request);

      expect(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationLelloInitialState>() //default state
          ]));
    });

    test('Should emit registering state if session is already loaded',
        () async {
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_request);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationLelloInitialState>(), //default state
            isA<SpaceRegistrationLelloRegisteringState>(),
          ]));
    });

    test('Should call register reservation use case', () async {
      when(requestSpaceRegistration.call(any))
          .thenAnswer((_) async => Success(_request));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_request);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationLelloInitialState>(), //default state
            isA<SpaceRegistrationLelloRegisteringState>(),
          ]));

      verify(requestSpaceRegistration.call(any));
    });

    test('Should emit loaded state if register succeeds', () async {
      when(requestSpaceRegistration.call(any))
          .thenAnswer((_) async => Success(_request));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_request);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationLelloInitialState>(), //default state
            isA<SpaceRegistrationLelloRegisteringState>(),
            isA<SpaceRegistrationLelloRegisteredState>(),
          ]));
    });

    test('Should emit failed state if register failes', () async {
      when(requestSpaceRegistration.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final session = Session()
        ..selectedCondominium = (Condominium()..id = "123");
      when(sessionBloc.state).thenReturn(SessionLoadedState(session));
      bloc.beginRegister(_request);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<SpaceRegistrationLelloInitialState>(), //default state
            isA<SpaceRegistrationLelloRegisteringState>(),
            isA<SpaceRegistrationLelloRegisterFailedState>(),
          ]));
    });
  });
}

class RequestSpaceRegistrationMock extends Mock
    implements RequestSpaceRegistration {}
