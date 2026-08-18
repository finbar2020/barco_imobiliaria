import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc_impl.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';

import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListEmployee listEmployee;
  SessionBloc sessionBloc;
  EmployeeListBloc bloc;

  var _employee = Employee();
  setUp(() {
    listEmployee = ListEmployeeMock();
    sessionBloc = SessionBlocMock();
    bloc = EmployeeListBlocImpl(
        sessionBloc: sessionBloc, listEmployee: listEmployee);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(listEmployee.call(any)).thenAnswer((_) async => Success([_employee]));
    bloc = EmployeeListBlocImpl(
        sessionBloc: sessionBloc, listEmployee: listEmployee);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<EmployeeListLoadingState>(),
          isA<EmployeeListLoadingState>(),
          isA<EmployeeListLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = EmployeeListBlocImpl(
          sessionBloc: sessionBloc, listEmployee: listEmployee);

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadingState>() //default state
          ]));
    });

    test(
        'Should call load employee use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listEmployee.call(any))
          .thenAnswer((_) async => Success([_employee]));

      bloc = EmployeeListBlocImpl(
          sessionBloc: sessionBloc, listEmployee: listEmployee);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadingState>(),
            isA<EmployeeListLoadingState>(),
            isA<EmployeeListLoadedState>()
          ]));

      verify(listEmployee.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listEmployee.call(any))
          .thenAnswer((_) async => Success([_employee]));
      await setLoaded();
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadedState>(),
            isA<EmployeeListLoadingState>(),
            isA<EmployeeListLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadedState>(),
            isA<EmployeeListLoadingState>(),
            isA<EmployeeListLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listEmployee.call(any))
          .thenAnswer((_) async => Success([_employee]));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadingState>(),
          ]));
    });
  });

  group('begin load next page', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listEmployee.call(any))
          .thenAnswer((_) async => Success([_employee]));
      await setLoaded();
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadedState>(),
            isA<EmployeeListPagingState>(),
            isA<EmployeeListLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadedState>(),
            isA<EmployeeListPagingState>(),
            isA<EmployeeListPageFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listEmployee.call(any))
          .thenAnswer((_) async => Success([_employee]));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeListLoadingState>(),
          ]));
    });
  });
}

class ListEmployeeMock extends Mock implements ListEmployee {}
