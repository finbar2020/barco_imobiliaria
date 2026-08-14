import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_monthly_income_impl.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  IncomeRepository repository;
  GetIncome getMonthlyIncome;

  final condominiumId = "1744";
  final entity = Income();
  final period = DateTime.now();

  final origin = DataOrigin.local;
  final params = GetIncomeParam(
      condominiumId: condominiumId, origin: origin, period: period);

  setUp(() {
    repository = MonthlyIncomeRepositoryMock();
    getMonthlyIncome = GetIncomeImpl(repository: repository);
  });

  group('call', () {
    group('With invalid params', () {
      test('Should invalid params when param is null', () async {
        final result = await getMonthlyIncome.call(null);
        expect(result,
            IsAnd<Rejection<Income>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is null', () async {
        final invalid =
            GetIncomeParam(condominiumId: null, origin: origin, period: period);
        final result = await getMonthlyIncome.call(invalid);
        expect(result,
            IsAnd<Rejection<Income>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is empty', () async {
        final invalid =
            GetIncomeParam(condominiumId: "", origin: origin, period: period);
        final result = await getMonthlyIncome.call(invalid);
        expect(result,
            IsAnd<Rejection<Income>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when origin is null', () async {
        final invalid = GetIncomeParam(
            condominiumId: condominiumId, origin: null, period: period);
        final result = await getMonthlyIncome.call(invalid);
        expect(result,
            IsAnd<Rejection<Income>>((it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository select', () async {
      when(repository.select(any, any, any))
          .thenAnswer((_) async => Success(entity));
      await getMonthlyIncome.call(params);
      verify(repository.select(origin, condominiumId, period));
    });

    test('Should return success when repository succeeeds', () async {
      when(repository.select(any, any, any))
          .thenAnswer((_) async => Success(entity));
      final result = await getMonthlyIncome.call(params);
      expect(result, IsAnd<Success<Income>>((it) => it.get() == entity));
    });

    test('Should return rejection when repository succeeeds', () async {
      when(repository.select(any, any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await getMonthlyIncome.call(params);
      expect(
          result, IsAnd<Rejection<Income>>((it) => it.get() is UnknownFailure));
    });
  });
}

class MonthlyIncomeRepositoryMock extends Mock implements IncomeRepository {}
