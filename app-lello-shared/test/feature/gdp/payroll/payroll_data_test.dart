import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/payroll/data/model/payroll_entry_model.dart';
import 'package:shared_features/feature/gdp/payroll/data/model/payroll_model.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';

import 'payroll_test_helpers.dart';

void main() {
  group('PayrollModel', () {
    test('fromJson, toJson, toEntity e fromEntity', () {
      final model = PayrollModel.fromJson(payrollJson());
      expect(model.period, DateTime(2026, 8));
      expect(model.type, 'Mensal');
      expect(model.value, 10000.5);
      expect(model.discounts, 1500.25);
      expect(model.balance, 8500.25);
      final json = model.toJson();
      expect(json['period'], startsWith('2026-08-01'));
      expect(json['balance'], 8500.25);

      final entity = model.toEntity();
      expect(entity, isA<Payroll>());
      expect(entity.period, DateTime(2026, 8));
      expect(entity.value, 10000.5);
      final volta = PayrollModel.fromEntity(entity)!;
      expect(volta.type, 'Mensal');
      expect(volta.discounts, 1500.25);
      expect(PayrollModel.fromEntity(null), isNull);
    });

    test('nulos e inteiros viram double', () {
      final model = PayrollModel.fromJson({'value': 10, 'discounts': null});
      expect(model.period, isNull);
      expect(model.value, 10.0);
      expect(model.discounts, isNull);
      expect(model.toJson()['period'], isNull);
      expect(model.toEntity().balance, isNull);
    });
  });

  group('PayrollEntryModel', () {
    test('fromJson, toJson, toEntity e fromEntity', () {
      final model = PayrollEntryModel.fromJson(payrollEntryJson());
      expect(model.id, 'PE1');
      expect(model.title, 'Salário');
      expect(model.value, 3000.0);
      expect(model.toJson(), {'id': 'PE1', 'title': 'Salário', 'value': 3000.0});

      final entity = model.toEntity();
      expect(entity, isA<PayrollEntry>());
      expect(entity.title, 'Salário');
      final volta = PayrollEntryModel.fromEntity(entity)!;
      expect(volta.id, 'PE1');
      expect(volta.value, 3000.0);
      expect(PayrollEntryModel.fromEntity(null), isNull);
      expect(PayrollEntryModel.fromJson({}).value, isNull);
    });
  });

  group('data sources e repositórios', () {
    late PayrollEnv env;
    setUp(() => env = PayrollEnv());

    test('list chama /payrolls e converte', () async {
      env.stubPayrolls([payrollJson(), payrollJson(period: '2026-07-01T00:00:00.000')]);
      final models = await env.payrollDataSource.list('C1');
      expect(models, hasLength(2));
      expect(env.paths, [payrollsPath]);

      final result = await env.payrollRepository.list('C1');
      expect(result, isA<Success<List<Payroll>>>());
      expect(result.getOrElse(() => []).first.period, DateTime(2026, 8));
    });

    test('select formata o período como yyyy-MM', () async {
      env.stubPayroll('2026-08', payrollJson());
      final model = await env.payrollDataSource.select('C1', DateTime(2026, 8, 15));
      expect(model.type, 'Mensal');
      expect(env.paths, ['$payrollsPath/2026-08']);

      final result = await env.payrollRepository.select('C1', DateTime(2026, 8, 15));
      expect(result.getOrElse(() => Payroll()).balance, 8500.25);
    });

    test('entries chama /payrolls/{período}/entries e converte', () async {
      env.stubEntries('2026-01', [payrollEntryJson(), payrollEntryJson(id: 'PE2', title: 'INSS')]);
      final models = await env.entryDataSource.list('C1', DateTime(2026, 1, 31));
      expect(models.map((e) => e.title), ['Salário', 'INSS']);
      expect(env.paths, ['$payrollsPath/2026-01/entries']);

      final result = await env.entryRepository.list('C1', DateTime(2026, 1, 31));
      expect(result.getOrElse(() => []).last.id, 'PE2');
    });

    test('erros da api viram Rejection(UnknownFailure)', () async {
      env.http.failAll();
      expect(() => env.payrollDataSource.list('C1'), throwsA(anything));
      final list = await env.payrollRepository.list('C1');
      expect(list.fold((l) => l, (r) => null), isA<UnknownFailure>());
      final select = await env.payrollRepository.select('C1', DateTime(2026, 8));
      expect(select.fold((l) => l, (r) => null), isA<UnknownFailure>());
      final entries = await env.entryRepository.list('C1', DateTime(2026, 8));
      expect(entries.fold((l) => l, (r) => null), isA<UnknownFailure>());
    });
  });

  group('use cases', () {
    late PayrollEnv env;
    setUp(() => env = PayrollEnv());

    test('validam o condomínio e delegam ao repositório', () async {
      final semCond = await env.listPayroll.call(ListPayrollParam(condominiumId: ''));
      expect(semCond.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      final getSemCond = await env.getPayroll
          .call(GetPayrollParam(condominiumId: '', period: DateTime(2026, 8)));
      expect(getSemCond.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      final entriesSemCond = await env.listPayrollEntry
          .call(ListPayrollEntryParam(condominiumId: '', period: DateTime(2026, 8)));
      expect(entriesSemCond.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      expect(env.http.requests, isEmpty);

      env.stubPayrolls([payrollJson()]);
      env.stubPayroll('2026-08', payrollJson());
      env.stubEntries('2026-08', [payrollEntryJson()]);
      final list = await env.listPayroll.call(ListPayrollParam(condominiumId: 'C1'));
      expect(list.getOrElse(() => []), hasLength(1));
      final get = await env.getPayroll
          .call(GetPayrollParam(condominiumId: 'C1', period: DateTime(2026, 8)));
      expect(get.getOrElse(() => Payroll()).type, 'Mensal');
      final entries = await env.listPayrollEntry
          .call(ListPayrollEntryParam(condominiumId: 'C1', period: DateTime(2026, 8)));
      expect(entries.getOrElse(() => []).single.title, 'Salário');
    });
  });
}
