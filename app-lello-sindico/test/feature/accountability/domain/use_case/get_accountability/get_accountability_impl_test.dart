import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  AccountabilityRepository repository;
  GetAccountability getAccountability;

  final period = DateTime.now();
  final condominiumId = "123";
  final model = Accountability();

  setUp(() {
    repository = AccountabilityRepositoryMock();
    getAccountability = GetAccountabilityImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should return rejection when calling with null', () async {
        final result = await getAccountability.call(null);
        expect(
            result,
            IsAnd<Rejection<Accountability>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection when calling with null condominium id',
          () async {
        final param =
            GetAccountabilityParam(condominiumId: null, period: period);
        final result = await getAccountability.call(param);
        expect(
            result,
            IsAnd<Rejection<Accountability>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection when calling with empty condominium id',
          () async {
        final param = GetAccountabilityParam(condominiumId: '', period: period);
        final result = await getAccountability.call(param);
        expect(
            result,
            IsAnd<Rejection<Accountability>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection when calling with null period', () async {
        final param =
            GetAccountabilityParam(condominiumId: condominiumId, period: null);
        final result = await getAccountability.call(param);
        expect(
            result,
            IsAnd<Rejection<Accountability>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    group('with vaild parameters', () {
      test('Should call repository select', () async {
        final param = GetAccountabilityParam(
            condominiumId: condominiumId, period: period);
        when(repository.select(condominiumId, period))
            .thenAnswer((_) async => Success(model));
        await getAccountability.call(param);
        verify(repository.select(condominiumId, period));
      });

      test('Should return success when repository succeeeds', () async {
        final param = GetAccountabilityParam(
            condominiumId: condominiumId, period: period);
        when(repository.select(condominiumId, period))
            .thenAnswer((_) async => Success(model));
        final result = await getAccountability.call(param);
        expect(
            result, IsAnd<Success<Accountability>>((it) => it.get() == model));
      });

      test('Should return rejection when repository fails', () async {
        final param = GetAccountabilityParam(
            condominiumId: condominiumId, period: period);
        when(repository.select(condominiumId, period))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await getAccountability.call(param);
        expect(
            result,
            IsAnd<Rejection<Accountability>>(
                (it) => it.get() is UnknownFailure));
      });
    });
  });
}

class AccountabilityRepositoryMock extends Mock
    implements AccountabilityRepository {}
