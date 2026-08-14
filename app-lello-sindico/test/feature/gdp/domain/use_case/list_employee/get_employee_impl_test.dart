import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/repository/employee_repository.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  EmployeeRepository repository;
  GetEmployee listEmployee;
  final _employee = Employee();

  setUp(() {
    repository = EmployeeRepositoryMock();
    listEmployee = GetEmployeeImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param = GetEmployeeParam(condominiumId: null, employeeId: "1");
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<Employee>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param = GetEmployeeParam(condominiumId: "", employeeId: "1");
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<Employee>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employeeId is null',
          () async {
        final param = GetEmployeeParam(condominiumId: "1", employeeId: null);
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<Employee>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employeeId is empty',
          () async {
        final param = GetEmployeeParam(condominiumId: "1", employeeId: "");
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<Employee>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.get(any, any))
          .thenAnswer((_) async => Success(_employee));
      final param = GetEmployeeParam(condominiumId: "1", employeeId: "2");
      await listEmployee.call(param);
      verify(repository.get("1", "2"));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.get(any, any))
          .thenAnswer((_) async => Success(_employee));
      final param = GetEmployeeParam(condominiumId: "1", employeeId: "2");
      final result = await listEmployee.call(param);
      expect(result, IsAnd<Success<Employee>>((it) => it.get() == _employee));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.get(any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param = GetEmployeeParam(condominiumId: "1", employeeId: "2");
      final result = await listEmployee.call(param);
      expect(result,
          IsAnd<Rejection<Employee>>((it) => it.get() is UnknownFailure));
    });
  });
}

class EmployeeRepositoryMock extends Mock implements EmployeeRepository {}
