import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/vacation/data/data_source/vacation_remote_data_source.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_model.dart';
import 'package:lello/feature/gdp/vacation/data/repository/vacation_repository_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  final _condominiumId = '1';
  final _employeeId = 'A';
  final _model = VacationModel()
    ..employee = (EmployeeModel()..id = _employeeId);
  VacationRepository repository;
  VacationRemoteDataSource dataSource;

  group('getVacation', () {
    setUp(() {
      dataSource = VacationRemoteDataSourceMock();
      repository = VacationRepositoryImpl(remoteDataSource: dataSource);
    });

    test('Should call remote data source', () async {
      when(dataSource.find(_condominiumId, _employeeId))
          .thenAnswer((_) async => _model);
      await repository.getVacation(_condominiumId, _employeeId);
      verify(dataSource.find(_condominiumId, _employeeId));
    });

    test('Should return succeess if remote data source call is successful',
        () async {
      when(dataSource.find(_condominiumId, _employeeId))
          .thenAnswer((_) async => _model);
      final result = await repository.getVacation(_condominiumId, _employeeId);
      expect(
          result,
          IsAnd<Success<Vacation>>(
              (it) => it.get().employee.id == _model.employee.id));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.find(_condominiumId, _employeeId)).thenThrow(Exception());
      final result = await repository.getVacation(_condominiumId, _employeeId);
      expect(result, isA<Rejection>());
    });
  });
}

class VacationRemoteDataSourceMock extends Mock
    implements VacationRemoteDataSource {}
