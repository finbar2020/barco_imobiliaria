import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/accountability_model.dart';
import 'package:lello/feature/accountability/data/repository/accountability_repository_impl.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';

void main() {
  AccountabilityRemoteDataSource dataSource;
  AccountabilityRepository repository;

  final condominiumId = "123";
  final period = DateTime.now();
  final model = AccountabilityModel();

  setUp(() {
    dataSource = AccountabilityRemoteDataSourceMock();
    repository = AccountabilityRepositoryImpl(dataSource: dataSource);
  });

  group('select', () {
    test('Should call data source select', () async {
      when(dataSource.select(condominiumId, period))
          .thenAnswer((_) async => model);
      await repository.select(condominiumId, period);
      verify(dataSource.select(condominiumId, period));
    });

    test('Should return success if data source succeeds', () async {
      when(dataSource.select(condominiumId, period))
          .thenAnswer((_) async => model);
      final result = await repository.select(condominiumId, period);
      expect(result, isA<Success<Accountability>>());
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.select(condominiumId, period)).thenThrow(Exception());
      final result = await repository.select(condominiumId, period);
      expect(result, isA<Rejection<Accountability>>());
    });
  });
}

class AccountabilityRemoteDataSourceMock extends Mock
    implements AccountabilityRemoteDataSource {}
