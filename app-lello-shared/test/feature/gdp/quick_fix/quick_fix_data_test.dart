import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/model/employee_report_item_model.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/model/employee_report_model.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_item.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';

import 'quick_fix_test_helpers.dart';

void main() {
  group('EmployeeReportType', () {
    test('value/getValue, parse e parseString', () {
      expect(EmployeeReportType.vacation.value, 'vacation');
      expect(EmployeeReportType.termination.getValue(), 'termination');
      expect(EmployeeReportTypeHelper.parse('vacation'), EmployeeReportType.vacation);
      expect(EmployeeReportTypeHelper.parse('termination'), EmployeeReportType.termination);
      expect(EmployeeReportTypeHelper.parse('outro'), isNull);
      expect(EmployeeReportTypeHelper.parseString(EmployeeReportType.vacation), 'Férias');
      expect(EmployeeReportTypeHelper.parseString(EmployeeReportType.termination), 'Rescisão');
    });
  });

  group('EmployeeReportItemModel', () {
    test('fromJson, toJson, toEntity e fromEntity', () {
      final model = EmployeeReportItemModel.fromJson(reportItemJson('Férias', 10.5));
      expect(model.description, 'Férias');
      expect(model.value, 10.5);
      expect(model.toJson(), {'description': 'Férias', 'value': 10.5});
      final entity = model.toEntity();
      expect(entity, isA<EmployeeReportItem>());
      expect(entity.value, 10.5);
      expect(EmployeeReportItemModel.fromEntity(entity)!.description, 'Férias');
      expect(EmployeeReportItemModel.fromEntity(null), isNull);
    });
  });

  group('EmployeeReportModel', () {
    test('fromJson completo, toJson, toEntity e fromEntity', () {
      final model = EmployeeReportModel.fromJson(reportJson());
      expect(model.type, EmployeeReportType.vacation);
      expect(model.employee?.name, 'Ana');
      expect(model.items, hasLength(2));
      expect(model.items?.last.value, '411.5');
      expect(model.stabilityDescription, 'Gestante');
      expect(model.stabilityStart, DateTime(2026, 1, 10));
      expect(model.stabilityEnd, DateTime(2026, 6, 10));

      final json = model.toJson();
      expect(json['type'], 'vacation');
      expect(json['employee'], isA<EmployeeModel>());
      expect(json['stability_start'], startsWith('2026-01-10'));

      final entity = model.toEntity();
      expect(entity, isA<EmployeeReport>());
      expect(entity.employee?.name, 'Ana');
      expect(entity.items?.first.description, 'Férias');
      expect(entity.stabilityEnd, DateTime(2026, 6, 10));

      final volta = EmployeeReportModel.fromEntity(entity)!;
      expect(volta.type, EmployeeReportType.vacation);
      expect(volta.employee?.name, 'Ana');
      expect(volta.items, hasLength(2));
      expect(volta.stabilityDescription, 'Gestante');
      expect(EmployeeReportModel.fromEntity(null), isNull);
    });

    test('nulos: sem funcionário, itens e datas', () {
      final model = EmployeeReportModel.fromJson({'type': 'termination'});
      expect(model.type, EmployeeReportType.termination);
      expect(model.employee, isNull);
      expect(model.items, isNull);
      expect(model.stabilityStart, isNull);
      expect(model.toJson()['stability_end'], isNull);
      final entity = model.toEntity();
      expect(entity.items, isEmpty);
      expect(entity.employee, isNull);
      final volta = EmployeeReportModel.fromEntity(EmployeeReport(type: EmployeeReportType.vacation))!;
      expect(volta.items, isEmpty);
      expect(volta.employee, isNull);
      expect(EmployeeReportModel.fromJson({'type': null}).type, isNull);
      expect(() => EmployeeReportModel.fromJson({'type': 'x'}), throwsArgumentError);
    });

    test('entidades', () {
      final filter = EmployeeReportFilter(
          reportType: EmployeeReportType.vacation, employee: employee());
      expect(filter.employee?.id, 'E1');
      expect(EmployeeReportFilter().reportType, isNull);
      final report = EmployeeReport(
          employee: employee(),
          items: [EmployeeReportItem()..description = 'x'],
          stabilityDescription: 's',
          stabilityStart: DateTime(2026),
          stabilityEnd: DateTime(2027),
          type: EmployeeReportType.termination);
      expect(report.items, hasLength(1));
      expect(report.type, EmployeeReportType.termination);
    });
  });

  group('data source, repositório e use case', () {
    late QuickFixEnv env;
    setUp(() => env = QuickFixEnv());

    test('get envia o tipo do relatório como query', () async {
      env.stubReport('E1', reportJson(type: 'termination'));
      final model = await env.reportDataSource.get('C1', 'E1', EmployeeReportType.termination);
      expect(model.type, EmployeeReportType.termination);
      expect(env.paths, [reportPath('E1')]);
      expect(env.http.requests.single.url.queryParameters['report_type'], 'termination');

      final result = await env.reportRepository.get('C1', 'E1', EmployeeReportType.vacation);
      expect(result, isA<Success<EmployeeReport>>());
      expect(result.getOrElse(() => EmployeeReport()).employee?.name, 'Ana');
    });

    test('erro da api vira Rejection(UnknownFailure)', () async {
      env.http.failAll();
      expect(() => env.reportDataSource.get('C1', 'E1', EmployeeReportType.vacation),
          throwsA(anything));
      final result = await env.reportRepository.get('C1', 'E1', EmployeeReportType.vacation);
      expect(result.fold((l) => l, (r) => null), isA<UnknownFailure>());
    });

    test('use case valida condomínio e funcionário', () async {
      final semCond = await env.getEmployeeReport.call(GetEmployeeReportParam(
          condominiumId: '', employeeId: 'E1', reportType: EmployeeReportType.vacation));
      expect(semCond.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      final semFunc = await env.getEmployeeReport.call(GetEmployeeReportParam(
          condominiumId: 'C1', employeeId: '', reportType: EmployeeReportType.vacation));
      expect(semFunc.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      expect(env.http.requests, isEmpty);

      env.stubReport('E1', reportJson());
      final ok = await env.getEmployeeReport.call(GetEmployeeReportParam(
          condominiumId: 'C1', employeeId: 'E1', reportType: EmployeeReportType.vacation));
      expect(ok.getOrElse(() => EmployeeReport()).items, hasLength(2));
    });
  });
}
