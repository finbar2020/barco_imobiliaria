import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  final _condominiumId = '1';
  final _employeeId = 'A';
  final _reportType = EmployeeReportType.vacation;
  final _employeeReport = EmployeeReport();
  EmployeeReportRepository repository;
  GetEmployeeReport getEmployeeReport;

  setUp(() {
    repository = EmployeeReportRepositoryMock();
    getEmployeeReport = GetEmployeeReportImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param = GetEmployeeReportParam(
            condominiumId: null,
            employeeId: _employeeId,
            reportType: _reportType);
        final result = await getEmployeeReport.call(param);
        expect(
            result,
            IsAnd<Rejection<EmployeeReport>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param = GetEmployeeReportParam(
            condominiumId: '',
            employeeId: _employeeId,
            reportType: _reportType);
        final result = await getEmployeeReport.call(param);
        expect(
            result,
            IsAnd<Rejection<EmployeeReport>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employeeId is null',
          () async {
        final param = GetEmployeeReportParam(
            condominiumId: _condominiumId,
            employeeId: null,
            reportType: _reportType);
        final result = await getEmployeeReport.call(param);
        expect(
            result,
            IsAnd<Rejection<EmployeeReport>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employeeId is empty',
          () async {
        final param = GetEmployeeReportParam(
            condominiumId: _condominiumId,
            employeeId: '',
            reportType: _reportType);
        final result = await getEmployeeReport.call(param);
        expect(
            result,
            IsAnd<Rejection<EmployeeReport>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if reportType is null',
          () async {
        final param = GetEmployeeReportParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            reportType: null);
        final result = await getEmployeeReport.call(param);
        expect(
            result,
            IsAnd<Rejection<EmployeeReport>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.get(any, any, any))
          .thenAnswer((_) async => Success(_employeeReport));
      final param = GetEmployeeReportParam(
          condominiumId: _condominiumId,
          employeeId: _employeeId,
          reportType: _reportType);
      await getEmployeeReport.call(param);
      verify(repository.get('1', 'A', EmployeeReportType.vacation));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.get(any, any, any))
          .thenAnswer((_) async => Success(_employeeReport));
      final param = GetEmployeeReportParam(
          condominiumId: _condominiumId,
          employeeId: _employeeId,
          reportType: _reportType);
      final result = await getEmployeeReport.call(param);
      expect(result,
          IsAnd<Success<EmployeeReport>>((it) => it.get() == _employeeReport));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.get(any, any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param = GetEmployeeReportParam(
          condominiumId: _condominiumId,
          employeeId: _employeeId,
          reportType: _reportType);
      final result = await getEmployeeReport.call(param);
      expect(result,
          IsAnd<Rejection<EmployeeReport>>((it) => it.get() is UnknownFailure));
    });
  });
}

class EmployeeReportRepositoryMock extends Mock
    implements EmployeeReportRepository {}
