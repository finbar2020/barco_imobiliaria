import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc_impl.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../matcher/is_and_matcher.dart';

void main() {
  const List<Employee> _emptyEmployees = [];
  final _session = Session()..selectedCondominium = Condominium(id: '123');
  SessionBloc sessionBloc;
  ListEmployee listEmployee;
  QuickFixBloc bloc;

  Future _setupLoaded(QuickFixBloc bloc, Session session,
      {List<Employee> items = _emptyEmployees}) async {
    when(listEmployee.call(any)).thenAnswer((_) async => Success(items));

    bloc.add(QuickFixLoadEvent(condominiumId: session.selectedCondominium.id));
    await expectLater(
        bloc,
        emitsInOrder([
          isA<QuickFixLoadingState>(),
          isA<QuickFixLoadingState>(),
          isA<QuickFixLoadedState>(),
        ]));
  }

  setUp(() {
    sessionBloc = SessionBlocMock();
    listEmployee = ListEmployeeMock();
    bloc =
        QuickFixBlocImpl(sessionBloc: sessionBloc, listEmployee: listEmployee);
  });

  group('beginLoad', () {
    test('Should emit loaded state when session is valid', () async {
      await _setupLoaded(bloc, _session);

      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginLoad();

      expect(
          bloc,
          emitsInOrder([
            isA<QuickFixLoadedState>(),
            isA<QuickFixLoadingState>(),
            isA<QuickFixLoadedState>()
          ]));
    });

    test('Should emit load failed state if listEmployees fails', () async {
      await _setupLoaded(bloc, _session);

      when(listEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoad();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<QuickFixLoadedState>(),
            isA<QuickFixLoadingState>(),
            IsAnd<QuickFixLoadFailedState>(
                (state) => state.error is UnknownFailure)
          ]));
    });

    test('Should not emit loading state when in loading state', () async {
      bloc.beginLoad();

      expect(bloc, emitsInOrder([isA<QuickFixLoadingState>()]));
    });
  });
}

class SessionBlocMock extends Mock implements SessionBloc {}

class ListEmployeeMock extends Mock implements ListEmployee {}
