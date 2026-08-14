import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_detail_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  CondominiumBalanceDetailRepository repository;
  LoadCondominiumBalanceDetail loadCondominiumBalanceDetail;

  final _balance = CondominiumBalanceDetail();
  var _filter = CondominiumBalanceDetailFilter();

  setUp(() {
    repository = CondominiumBalanceDetailRepositoryMock();
    loadCondominiumBalanceDetail =
        LoadCondominiumBalanceDetailImpl(repository: repository);
  });

  group('call', () {
    test('Should return expected failure if parameter is null', () async {
      final result = await loadCondominiumBalanceDetail(null);
      expect(
          result,
          IsAnd<Rejection<CondominiumBalanceDetail>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return expected failure if parameter is empty', () async {
      final result = await loadCondominiumBalanceDetail(
          LoadCondominiumBalanceDetailParam(condominiumId: ""));
      expect(
          result,
          IsAnd<Rejection<CondominiumBalanceDetail>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should call repository select', () async {
      final id = "123";
      final reference = "123";
      when(repository.select(LoadCondominiumBalanceDetailParam(
              condominiumId: id, filter: _filter, reference: reference)))
          .thenAnswer((_) async => Success(_balance));
      await loadCondominiumBalanceDetail(LoadCondominiumBalanceDetailParam(
          condominiumId: id, filter: _filter));
      verify(repository.select(LoadCondominiumBalanceDetailParam(
          condominiumId: id, filter: _filter, reference: reference)));
    });

    test('Should return success when repository succeeds', () async {
      final id = "123";
      final reference = "123";
      when(repository.select(LoadCondominiumBalanceDetailParam(
          condominiumId: id, filter: _filter, reference: reference)))
          .thenAnswer((_) async => Success(_balance));
      final result = await loadCondominiumBalanceDetail(
          LoadCondominiumBalanceDetailParam(
              condominiumId: id, filter: _filter));
      expect(
          result,
          IsAnd<Success<CondominiumBalanceDetail>>(
              (it) => it.get() == _balance));
    });

    test('Should return rejection when repository succeeds', () async {
      final id = "123";
      final reference = "123";
      when(repository.select(LoadCondominiumBalanceDetailParam(
          condominiumId: id, filter: _filter, reference: reference)))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await loadCondominiumBalanceDetail(
          LoadCondominiumBalanceDetailParam(
              condominiumId: id, filter: _filter));
      expect(result, isA<Rejection<CondominiumBalanceDetail>>());
    });
  });
}

class CondominiumBalanceDetailRepositoryMock extends Mock
    implements CondominiumBalanceDetailRepository {}
