import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PayrollRepository repository;
  ListPayroll listPayroll;
  final _payroll = Payroll();

  setUp(() {
    repository = PayrollRepositoryMock();
    listPayroll = ListPayrollImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param = ListPayrollParam(condominiumId: null);
        final result = await listPayroll.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Payroll>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param = ListPayrollParam(condominiumId: "");
        final result = await listPayroll.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Payroll>>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.list(any)).thenAnswer((_) async => Success([_payroll]));
      final param = ListPayrollParam(condominiumId: "1");
      await listPayroll.call(param);
      verify(repository.list("1"));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.list(any)).thenAnswer((_) async => Success([_payroll]));
      final param = ListPayrollParam(condominiumId: "1");
      final result = await listPayroll.call(param);
      expect(result,
          IsAnd<Success<List<Payroll>>>((it) => it.get()[0] == _payroll));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.list(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param = ListPayrollParam(condominiumId: "1");
      final result = await listPayroll.call(param);
      expect(result,
          IsAnd<Rejection<List<Payroll>>>((it) => it.get() is UnknownFailure));
    });
  });
}

class PayrollRepositoryMock extends Mock implements PayrollRepository {}
