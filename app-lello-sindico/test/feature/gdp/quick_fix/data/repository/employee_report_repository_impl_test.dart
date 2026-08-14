import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source.dart';
import 'package:lello/feature/gdp/quick_fix/data/model/employee_report_model.dart';
import 'package:lello/feature/gdp/quick_fix/data/repository/employee_report_repository_impl.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  final _condominiumId = '1';
  final _employeeId = 'A';
  final _reportType = EmployeeReportType.vacation;
  final _model = EmployeeReportModel()
    ..type = EmployeeReportType.vacation
    ..employee = EmployeeModel()
    ..items = []
    ..stabilityDescription = "lorem"
    ..stabilityEnd = DateTime.now()
    ..stabilityStart = DateTime.now();

  EmployeeReportRemoteDataSource dataSource;
  EmployeeReportRepository repository;

  setUp(() {
    dataSource = EmployeeReportRemoteDataSourceMock();
    repository = EmployeeReportRepositoryImpl(remoteDataSource: dataSource);
  });

  group('get', () {
    test('Should call remote data source', () async {
      when(dataSource.get(_condominiumId, _employeeId, _reportType))
          .thenAnswer((_) async => _model);
      await repository.get(_condominiumId, _employeeId, _reportType);
      verify(dataSource.get(_condominiumId, _employeeId, _reportType));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.get(_condominiumId, _employeeId, _reportType))
          .thenThrow(Exception());
      final result =
          await repository.get(_condominiumId, _employeeId, _reportType);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if remote data source succeeds', () async {
      when(dataSource.get(_condominiumId, _employeeId, _reportType))
          .thenAnswer((_) async => _model);
      final result =
          await repository.get(_condominiumId, _employeeId, _reportType);
      expect(result, IsAnd<Success<EmployeeReport>>((it) => it.length() == 1));
    });
  });
}

class EmployeeReportRemoteDataSourceMock extends Mock
    implements EmployeeReportRemoteDataSource {}
