import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  CondominiumBalanceRepository repository;
  LoadCondominiumBalance loadCondominiumBalance;

  final _balance = CondominiumBalance();

  setUp(() {
    repository = CondominiumBalanceRepositoryMock();
    loadCondominiumBalance = LoadCondominiumBalanceImpl(repository: repository);
  });

  group('call', () {
    test('Should return expected failure if parameter is null', () async {
      final result = await loadCondominiumBalance(null);
      expect(
          result,
          IsAnd<Rejection<CondominiumBalance>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return expected failure if parameter is empty', () async {
      final result =
          await loadCondominiumBalance(new CondominiumBalanceParam());
      expect(
          result,
          IsAnd<Rejection<CondominiumBalance>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should call repository select', () async {
      final id = "123";
      when(repository.select(new CondominiumBalanceParam(id: id)))
          .thenAnswer((_) async => Success(_balance));
      await loadCondominiumBalance(new CondominiumBalanceParam(id: id));
      verify(repository.select(new CondominiumBalanceParam(id: id)));
    });

    test('Should return success when repository succeeds', () async {
      final id = "123";
      when(repository.select(new CondominiumBalanceParam(id: id)))
          .thenAnswer((_) async => Success(_balance));
      final result =
          await loadCondominiumBalance(new CondominiumBalanceParam(id: id));
      expect(result,
          IsAnd<Success<CondominiumBalance>>((it) => it.get() == _balance));
    });

    test('Should return rejection when repository succeeds', () async {
      final id = "123";
      when(repository.select(new CondominiumBalanceParam(id: id)))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result =
          await loadCondominiumBalance(new CondominiumBalanceParam(id: id));
      expect(result, isA<Rejection<CondominiumBalance>>());
    });
  });
}

class CondominiumBalanceRepositoryMock extends Mock
    implements CondominiumBalanceRepository {}
