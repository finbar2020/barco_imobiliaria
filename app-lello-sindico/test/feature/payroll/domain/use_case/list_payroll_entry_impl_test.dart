import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PayrollEntryRepository repository;
  ListPayrollEntry listPayrollEntry;
  final _entry = PayrollEntry();

  setUp(() {
    repository = PayrollEntryRepositoryMock();
    listPayrollEntry = ListPayrollEntryImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param =
            ListPayrollEntryParam(condominiumId: null, period: DateTime.now());
        final result = await listPayrollEntry.call(param);
        expect(
            result,
            IsAnd<Rejection<List<PayrollEntry>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param =
            ListPayrollEntryParam(condominiumId: "", period: DateTime.now());
        final result = await listPayrollEntry.call(param);
        expect(
            result,
            IsAnd<Rejection<List<PayrollEntry>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if payroll id is null',
          () async {
        final param = ListPayrollEntryParam(condominiumId: "1", period: null);
        final result = await listPayrollEntry.call(param);
        expect(
            result,
            IsAnd<Rejection<List<PayrollEntry>>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.list(any, any))
          .thenAnswer((_) async => Success([_entry]));
      final period = DateTime.now();
      final param = ListPayrollEntryParam(condominiumId: "1", period: period);
      await listPayrollEntry.call(param);
      verify(repository.list("1", period));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.list(any, any))
          .thenAnswer((_) async => Success([_entry]));
      final param =
          ListPayrollEntryParam(condominiumId: "1", period: DateTime.now());
      final result = await listPayrollEntry.call(param);
      expect(result,
          IsAnd<Success<List<PayrollEntry>>>((it) => it.get()[0] == _entry));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.list(any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param =
          ListPayrollEntryParam(condominiumId: "1", period: DateTime.now());
      final result = await listPayrollEntry.call(param);
      expect(
          result,
          IsAnd<Rejection<List<PayrollEntry>>>(
              (it) => it.get() is UnknownFailure));
    });
  });
}

class PayrollEntryRepositoryMock extends Mock
    implements PayrollEntryRepository {}
