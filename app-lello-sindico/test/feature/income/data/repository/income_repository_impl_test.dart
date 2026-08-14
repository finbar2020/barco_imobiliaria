import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/income/data/data_source/local/income_local_data_source.dart';
import 'package:lello/feature/income/data/data_source/remote/income_remote_data_source.dart';

import 'package:lello/feature/income/data/model/income_model.dart';
import 'package:lello/feature/income/data/repository/income_repository_impl.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  IncomeRepository repository;
  IncomeLocalDataSource localDataSource;
  IncomeRemoteDataSource remoteDataSource;

  final _condoId = "123";
  final _period = DateTime.now();
  final _data = IncomeModel();

  setUp(() {
    localDataSource = IncomeLocalDataSourceMock();
    remoteDataSource = IncomeRemoteDataSourceMock();
    repository = IncomeRepositoryImpl(
        localDataSource: localDataSource, remoteDataSource: remoteDataSource);
  });

  group('select', () {
    group('with local origin ', () {
      test('Should call localDataSource list', () async {
        when(localDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        await repository.select(DataOrigin.local, _condoId, _period);
        verify(localDataSource.select(_condoId, _period));
        verifyZeroInteractions(remoteDataSource);
      });

      test('Should return success if datasource succeeds', () async {
        when(localDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        final result =
            await repository.select(DataOrigin.local, _condoId, _period);
        expect(result, isA<Success<Income>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(localDataSource.select(_condoId, _period)).thenThrow(Exception());
        final result =
            await repository.select(DataOrigin.local, _condoId, _period);
        expect(result, IsAnd<Rejection<Income>>((it) => it.get() is Failure));
      });
    });

    group('with remote origin ', () {
      test('Should call remote data source list', () async {
        when(remoteDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        await repository.select(DataOrigin.remote, _condoId, _period);
        verify(remoteDataSource.select(_condoId, _period));
      });

      test('Should call local data source insert', () async {
        when(remoteDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        await repository.select(DataOrigin.remote, _condoId, _period);
        verify(localDataSource.save(_condoId, _period, _data));
      });

      test(
          'Should return success if data source succeeds even if local data source crashes',
          () async {
        when(remoteDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        when(localDataSource.save(_condoId, any, any)).thenThrow(Exception());
        final result =
            await repository.select(DataOrigin.remote, _condoId, _period);
        expect(result, isA<Success<Income>>());
      });

      test('Should return success if data source succeeds', () async {
        when(remoteDataSource.select(_condoId, _period))
            .thenAnswer((_) async => _data);
        final result =
            await repository.select(DataOrigin.remote, _condoId, _period);
        expect(result, isA<Success<Income>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(remoteDataSource.select(_condoId, _period)).thenThrow(Exception());
        final result =
            await repository.select(DataOrigin.remote, _condoId, _period);
        expect(result, IsAnd<Rejection<Income>>((it) => it.get() is Failure));
      });
    });
  });
}

class IncomeLocalDataSourceMock extends Mock implements IncomeLocalDataSource {}

class IncomeRemoteDataSourceMock extends Mock
    implements IncomeRemoteDataSource {}
