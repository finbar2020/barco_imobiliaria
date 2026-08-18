import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_bloc_impl.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../../matcher/is_and_matcher.dart';
import '../../../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  final _session = Session()..selectedCondominium = Condominium(id: '123');
  final _vacation = Vacation();
  final _employeeId = '123';
  VacationBloc bloc;
  SessionBloc sessionBloc;
  GetVacation getVacation;

  setUp(() {
    getVacation = GetVacationMock();
    sessionBloc = SessionBlocMock();
    bloc = VacationBlocImpl(sessionBloc: sessionBloc, getVacation: getVacation);
  });

  group('beginLoad', () {
    test('Should emit loaded state if session is valid', () async {
      when(getVacation.call(any)).thenAnswer((_) async => Success(_vacation));
      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginLoad(_employeeId);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationLoadingState>(),
            isA<VacationLoadingState>(),
            IsAnd<VacationLoadedState>((state) => state.data == _vacation),
          ]));
    });

    test('Should emit load failed state if getVacation fails', () async {
      when(getVacation.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginLoad(_employeeId);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationLoadingState>(),
            isA<VacationLoadingState>(),
            IsAnd<VacationLoadFailedState>(
                (state) => state.error is UnknownFailure)
          ]));
    });

    test('Should not emit loaded state if session is invalid', () async {
      when(sessionBloc.state).thenReturn(SessionLoadingState(_session));
      bloc.beginLoad(_employeeId);

      expect(bloc, neverEmits([isA<VacationLoadedState>()]));

      bloc.close();
    });
  });
}

class GetVacationMock extends Mock implements GetVacation {}
