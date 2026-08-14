import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
<<<<<<<< HEAD:test/feature/gdp/presentation/bloc/employee_bloc_test.dart
========
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
>>>>>>>> ca28a2e6 (higienizacao e padronizacao):test/feature/gdp/presentation/bloc/employee_bloc_impl_test.dart
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';

import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  GetEmployee getEmployee;
  SessionBloc sessionBloc;
  EmployeeBloc bloc;

  final sessionLoadedState = SessionLoadedState(
      Session()..selectedCondominium = Condominium(id: "123"));
  final employeeId = "1";
  var _employee = Employee();
  setUp(() {
    getEmployee = GetEmployeeMock();
    sessionBloc = SessionBlocMock();
    bloc = EmployeeBloc(sessionBloc: sessionBloc, getEmployee: getEmployee);
  });

  group('begin load', () {
    test('Should emit loading state when session state is already loaded',
        () async {
      when(sessionBloc.state).thenReturn(sessionLoadedState);
      when(getEmployee.call(any)).thenAnswer((_) async => Success(_employee));

      bloc.beginLoad(employeeId);

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeLoadingState>(),
            isA<EmployeeLoadingState>(),
            isA<EmployeeLoadedState>()
          ]));
    });

    test(
        'Should emit failure state when session state is already loaded and get employee fails',
        () async {
      when(sessionBloc.state).thenReturn(sessionLoadedState);
      when(getEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc.beginLoad(employeeId);

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeLoadingState>(),
            isA<EmployeeLoadingState>(),
            isA<EmployeeLoadFailedState>()
          ]));
    });

    test('Should emit nothing when session is not loaded yet', () async {
      when(sessionBloc.state).thenReturn(SessionLoadingState(null));
      when(getEmployee.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoad(employeeId);

      expect(
          bloc,
          emitsInOrder([
            isA<EmployeeLoadingState>(),
          ]));
    });
  });
}

class GetEmployeeMock extends Mock implements GetEmployee {}
