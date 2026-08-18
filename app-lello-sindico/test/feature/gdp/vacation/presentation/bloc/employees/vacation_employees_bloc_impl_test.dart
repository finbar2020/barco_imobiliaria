import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc_impl.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../../matcher/is_and_matcher.dart';
import '../../../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  const List<Employee> _emptyEmployees = [];
  final _session = Session()..selectedCondominium = Condominium(id: '123');
  VacationEmployeesBloc bloc;
  SessionBloc sessionBloc;
  ListEmployeeMock listEmployee;

  Future _setupLoaded(VacationEmployeesBloc bloc, Session session,
      {List<Employee> items = _emptyEmployees}) async {
    when(listEmployee.call(any)).thenAnswer((_) async => Success(items));

    bloc.add(VacationEmployeesLoadEvent(
        condominiumId: session.selectedCondominium.id));
    await expectLater(
        bloc,
        emitsInOrder([
          isA<VacationEmployeesLoadingState>(),
          isA<VacationEmployeesLoadingState>(),
          isA<VacationEmployeesLoadedState>(),
        ]));
  }

  setUp(() {
    listEmployee = ListEmployeeMock();
    sessionBloc = SessionBlocMock();
    bloc = VacationEmployeesBlocImpl(
        sessionBloc: sessionBloc, listEmployee: listEmployee);
  });

  group('beginRefresh', () {
    test('Should emit loading state when session is loaded', () async {
      await _setupLoaded(bloc, _session);

      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadedState>(),
            isA<VacationEmployeesLoadingState>()
          ]));
    });

    test('Should not emit loading state when in loading state', () async {
      bloc.beginRefresh();

      expect(bloc, emitsInOrder([isA<VacationEmployeesLoadingState>()]));
    });

    test('Should not emit loading state when in paging state', () async {
      when(listEmployee.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Success([]);
      });

      bloc.add(VacationEmployeesNextPageEvent());
      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadingState>(),
            isA<VacationEmployeesPagingState>()
          ]));

      bloc.beginRefresh();

      expect(bloc, emitsInOrder([isA<VacationEmployeesPagingState>()]));
    });
  });

  group('beginSearch', () {
    test('Should emit searching state if session is already loaded', () async {
      await _setupLoaded(bloc, _session);
      String searchQuery;
      List<Employee> employees = [];

      when(listEmployee.call(any)).thenAnswer((_) async => Success(employees));
      bloc.beginSearch(searchQuery);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadedState>(),
            IsAnd<VacationEmployeesSearchingState>(
                (state) => state.query == searchQuery),
            IsAnd<VacationEmployeesLoadedState>(
                (state) => state.data == employees)
          ]));
    });

    test('Should emit load failed state if listEmployees fails', () async {
      await _setupLoaded(bloc, _session);
      String searchQuery;

      when(listEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginSearch(searchQuery);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadedState>(),
            IsAnd<VacationEmployeesSearchingState>(
                (state) => state.query == searchQuery),
            IsAnd<VacationEmployeesLoadFailedState>(
                (state) => state.error is UnknownFailure)
          ]));
    });

    test('Should not emit search state when already in search state', () async {
      await _setupLoaded(bloc, _session);

      when(listEmployee.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Success([]);
      });

      bloc.beginSearch(null);
      await Future.delayed(Duration(milliseconds: 1));
      bloc.beginSearch(null);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesSearchingState>(),
            isA<VacationEmployeesLoadedState>(),
          ]));
    });

    test('Should not emit search state when in paging state', () async {
      when(listEmployee.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Success([]);
      });

      bloc.add(VacationEmployeesNextPageEvent());
      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadingState>(),
            isA<VacationEmployeesPagingState>()
          ]));

      bloc.beginSearch(null);

      expect(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesPagingState>(),
            isA<VacationEmployeesLoadedState>(),
          ]));
    });

    test('Should not emit search state when in loading state', () async {
      bloc.beginSearch(null);

      expect(bloc, emitsInOrder([isA<VacationEmployeesLoadingState>()]));
    });

    test(
        'Should rerun searching state from queue after receiving multiple calls',
        () async {
      await _setupLoaded(bloc, _session);
      String searchQuery1 = 'a';
      String searchQuery2 = 'ab';
      String searchQuery3 = 'abc';

      when(listEmployee.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 101));
        return Success([]);
      });

      bloc.beginSearch(searchQuery1);
      await Future.delayed(Duration(milliseconds: 50));
      bloc.beginSearch(searchQuery2);
      await Future.delayed(Duration(milliseconds: 50));
      bloc.beginSearch(searchQuery3);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<VacationEmployeesSearchingState>(
                (state) => state.query == searchQuery1),
            isA<VacationEmployeesLoadedState>(),
            IsAnd<VacationEmployeesSearchingState>(
                (state) => state.query == searchQuery3),
            isA<VacationEmployeesLoadedState>()
          ]));
    });
  });

  group('beginLoadNextPage', () {
    test(
        'Should emit paging state if state is loaded and pagination is not done',
        () async {
      await _setupLoaded(bloc, _session, items: [Employee()]);

      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadedState>(),
            isA<VacationEmployeesPagingState>(),
            isA<VacationEmployeesLoadedState>()
          ]));
    });

    test('Should emit page failed state if listEmployees fails', () async {
      await _setupLoaded(bloc, _session, items: [Employee()]);

      when(listEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesLoadedState>(),
            isA<VacationEmployeesPagingState>(),
            IsAnd<VacationEmployeesPageFailedState>(
                (state) => state.error is UnknownFailure)
          ]));
    });

    test(
        'Should not emit paging state if state is loaded and pagination is done',
        () async {
      await _setupLoaded(bloc, _session);

      bloc.beginLoadNextPage();

      await expectLater(
          bloc, emitsInOrder([isA<VacationEmployeesLoadedState>()]));

      expect(bloc, neverEmits([isA<VacationEmployeesPagingState>()]));

      await bloc.close();
    });

    test('Should not emit paging state when in loading state', () async {
      bloc.beginLoadNextPage();

      expect(bloc, emitsInOrder([isA<VacationEmployeesLoadingState>()]));
    });

    test('Should not emit paging state when in paging state', () async {
      final employees = [Employee()];
      await _setupLoaded(bloc, _session, items: employees);
      when(listEmployee.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Success(employees);
      });

      bloc.beginLoadNextPage();
      await Future.delayed(Duration(milliseconds: 5));
      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<VacationEmployeesPagingState>(),
            isA<VacationEmployeesLoadedState>()
          ]));
    });
  });
}

class ListEmployeeMock extends Mock implements ListEmployee {}
