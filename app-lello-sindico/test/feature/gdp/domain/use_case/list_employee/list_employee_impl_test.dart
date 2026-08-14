import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/repository/employee_repository.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  EmployeeRepository repository;
  ListEmployee listEmployee;
  final _employee = Employee();

  setUp(() {
    repository = EmployeeRepositoryMock();
    listEmployee = ListEmployeeImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param =
            ListEmployeeParam(condominiumId: null, origin: DataOrigin.local);
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Employee>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param =
            ListEmployeeParam(condominiumId: "", origin: DataOrigin.local);
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Employee>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if origin is null', () async {
        final param = ListEmployeeParam(condominiumId: "1", origin: null);
        final result = await listEmployee.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Employee>>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });
    test('Should call repository list', () async {
      when(repository.list(any, any,
              filter: anyNamed("filter"),
              lastEmployeeId: anyNamed("lastEmployeeId")))
          .thenAnswer((_) async => Success([_employee]));
      final filter = EmployeeListFilter();
      final param = ListEmployeeParam(
          condominiumId: "1",
          origin: DataOrigin.local,
          filter: filter,
          lastEmployeeId: "2");
      await listEmployee.call(param);
      verify(repository.list("1", DataOrigin.local,
          lastEmployeeId: "2", filter: filter));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.list(any, any,
              filter: anyNamed("filter"),
              lastEmployeeId: anyNamed("lastEmployeeId")))
          .thenAnswer((_) async => Success([_employee]));
      final param =
          ListEmployeeParam(condominiumId: "1", origin: DataOrigin.local);
      final result = await listEmployee.call(param);
      expect(
          result, IsAnd<Success<List<Employee>>>((it) => it.get().length == 1));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.list(any, any,
              filter: anyNamed("filter"),
              lastEmployeeId: anyNamed("lastEmployeeId")))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param =
          ListEmployeeParam(condominiumId: "1", origin: DataOrigin.local);
      final result = await listEmployee.call(param);
      expect(result,
          IsAnd<Rejection<List<Employee>>>((it) => it.get() is UnknownFailure));
    });
  });
}

class EmployeeRepositoryMock extends Mock implements EmployeeRepository {}
