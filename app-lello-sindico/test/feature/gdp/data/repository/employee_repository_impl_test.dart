import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:lello/feature/gdp/data/data_source/local/employee_local_data_source.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_remote_data_source.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/data/repository/employee_repository_impl.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/repository/employee_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  EmployeeRemoteDataSource dataSource;
  EmployeeLocalDataSource localDataSource;
  EmployeeRepository repository;
  setUp(() {
    dataSource = EmployeeRemoteDataSourceMock();
    localDataSource = EmployeeLocalDataSourceMock();
    repository = EmployeeRepositoryImpl(
        remoteDataSource: dataSource, localDataSource: localDataSource);
  });

  final _condominiumId = "1";
  final _employeeId = "2";
  final model = EmployeeModel();

  group('list', () {
    test(
        'Should call local data source select method when selecting local origin',
        () async {
      final filter = EmployeeListFilter();
      when(localDataSource.list(_condominiumId))
          .thenAnswer((_) async => [model]);
      await repository.list(_condominiumId, DataOrigin.local,
          lastEmployeeId: _employeeId, filter: filter);
      verify(localDataSource.list(_condominiumId));
    });

    test(
        'Should call remote data source select method when selecting local origin',
        () async {
      final filter = EmployeeListFilter();
      when(dataSource.list(_condominiumId,
              lastEmployeeId: _employeeId, filter: filter))
          .thenAnswer((_) async => [model]);
      await repository.list(_condominiumId, DataOrigin.remote,
          lastEmployeeId: _employeeId, filter: filter);
      verify(dataSource.list(_condominiumId,
          lastEmployeeId: _employeeId, filter: filter));
    });

    test(
        'Should call local data source save method when selecting remote origin and it succeeds',
        () async {
      final filter = EmployeeListFilter();
      when(dataSource.list(_condominiumId,
              lastEmployeeId: _employeeId, filter: filter))
          .thenAnswer((_) async => [model]);
      await repository.list(_condominiumId, DataOrigin.remote);
      verify(localDataSource.save(_condominiumId, any));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.list(_condominiumId)).thenThrow(Exception());
      final result = await repository.list(_condominiumId, DataOrigin.remote);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if remote data source succeeds', () async {
      when(dataSource.list(_condominiumId)).thenAnswer((_) async => [model]);
      final result = await repository.list(_condominiumId, DataOrigin.remote);
      expect(result, IsAnd<Success<List<Employee>>>((it) => it.length() == 1));
    });

    test('Should return rejection if local  data source throws any error',
        () async {
      when(localDataSource.list(_condominiumId)).thenThrow(Exception());
      final result = await repository.list(_condominiumId, DataOrigin.local);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if local data source succeeds', () async {
      when(localDataSource.list(_condominiumId))
          .thenAnswer((_) async => [model]);
      final result = await repository.list(_condominiumId, DataOrigin.local);
      expect(result, IsAnd<Success<List<Employee>>>((it) => it.length() == 1));
    });
  });

  group('get', () {
    test('Should call remote data source', () async {
      when(dataSource.get(_condominiumId, _employeeId))
          .thenAnswer((_) async => model);
      await repository.get(_condominiumId, _employeeId);
      verify(dataSource.get(_condominiumId, _employeeId));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.get(_condominiumId, _employeeId)).thenThrow(Exception());
      final result = await repository.get(_condominiumId, _employeeId);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if remote data source succeeds', () async {
      when(dataSource.get(_condominiumId, _employeeId))
          .thenAnswer((_) async => model);
      final result = await repository.get(_condominiumId, _employeeId);
      expect(result, IsAnd<Success<Employee>>((it) => it.length() == 1));
    });
  });
}

class EmployeeRemoteDataSourceMock extends Mock
    implements EmployeeRemoteDataSource {}

class EmployeeLocalDataSourceMock extends Mock
    implements EmployeeLocalDataSource {}
