import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll_impl.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PayrollRepository repository;
  GetPayroll getPayroll;
  final _payroll = Payroll();
  final _period = DateTime.now();

  setUp(() {
    repository = PayrollRepositoryMock();
    getPayroll = GetPayrollImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should throw invalid param failure if condominium is null',
          () async {
        final param = GetPayrollParam(condominiumId: null, period: _period);
        final result = await getPayroll.call(param);
        expect(result,
            IsAnd<Rejection<Payroll>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium is empty',
          () async {
        final param = GetPayrollParam(condominiumId: "", period: _period);
        final result = await getPayroll.call(param);
        expect(result,
            IsAnd<Rejection<Payroll>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if period is null', () async {
        final param = GetPayrollParam(condominiumId: "1", period: null);
        final result = await getPayroll.call(param);
        expect(result,
            IsAnd<Rejection<Payroll>>((it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.select(any, any))
          .thenAnswer((_) async => Success(_payroll));
      final param = GetPayrollParam(condominiumId: "1", period: _period);
      await getPayroll.call(param);
      verify(repository.select("1", _period));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.select(any, any))
          .thenAnswer((_) async => Success(_payroll));
      final param = GetPayrollParam(condominiumId: "1", period: _period);
      final result = await getPayroll.call(param);
      expect(result, IsAnd<Success<Payroll>>((it) => it.get() == _payroll));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.select(any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param = GetPayrollParam(condominiumId: "1", period: _period);
      final result = await getPayroll.call(param);
      expect(result,
          IsAnd<Rejection<Payroll>>((it) => it.get() is UnknownFailure));
    });
  });
}

class PayrollRepositoryMock extends Mock implements PayrollRepository {}
