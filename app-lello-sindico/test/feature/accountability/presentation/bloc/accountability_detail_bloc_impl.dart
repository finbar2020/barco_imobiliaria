import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:lello/feature/accountability/presentation/bloc/detail/accountability_detail_bloc.dart';
import 'package:lello/feature/accountability/presentation/bloc/detail/accountability_detail_bloc_impl.dart';
import 'package:lello/feature/accountability/presentation/bloc/detail/accountability_detail_state.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  GetAccountability getAccountability;
  SessionBloc sessionBloc;
  AccountabilityDetailBloc bloc;

  var _data = Accountability();
  setUp(() {
    getAccountability = GetAccountabilityMock();
    sessionBloc = SessionBlocMock();
    bloc = AccountabilityDetailBlocImpl(
        sessionBloc: sessionBloc, getAccountability: getAccountability);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    when(sessionBloc.state).thenReturn(SessionLoadedState(session));
  }

  group('begin load', () {
    test('Should not emit any other events if session is not loaded yet',
        () async {
      when(sessionBloc.state).thenReturn(SessionLoadingState(null));
      when(getAccountability.call(any)).thenAnswer((_) async => Success(_data));
      bloc.beginLoad(DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<AccountabilityDetailLoadingState>(),
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      when(getAccountability.call(any)).thenAnswer((_) async => Success(_data));
      await setLoaded();
      bloc.beginLoad(DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<AccountabilityDetailLoadingState>(),
            isA<AccountabilityDetailLoadingState>(),
            isA<AccountabilityDetailLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(getAccountability.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoad(DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<AccountabilityDetailLoadingState>(),
            isA<AccountabilityDetailLoadingState>(),
            isA<AccountabilityDetailLoadFailedState>()
          ]));
    });
  });
}

class GetAccountabilityMock extends Mock implements GetAccountability {}
