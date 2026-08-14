import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:lello/feature/pendency/data/data_source/local/pendency_local_data_source.dart';
import 'package:lello/feature/pendency/data/data_source/remote/pendency_remote_data_source.dart';
import 'package:lello/feature/pendency/data/model/pendency_model.dart';
import 'package:lello/feature/pendency/data/repository/pendency_repository_impl.dart';
import 'package:lello/feature/pendency/domain/entity/pendency.dart';
import 'package:lello/feature/pendency/domain/repository/pendency_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  PendencyRepository repository;
  PendencyLocalDataSource localDataSource;
  PendencyRemoteDataSource remoteDataSource;

  final List<PendencyModel> _models = [PendencyModel()];
  final List<Pendency> _entities = [Pendency()];

  setUp(() {
    localDataSource = PendencyLocalDataSourceMock();
    remoteDataSource = PendencyRemoteDataSourceMock();
    repository = PendencyRepositoryImpl(
        localDataSource: localDataSource, remoteDataSource: remoteDataSource);
  });

  group('select', () {
    test('Should call remote data source list', () async {
      final condominiumId = "1";
      final lastPendencyId = "2";
      when(remoteDataSource.list(condominiumId, lastPendencyId))
          .thenAnswer((_) async => _models);
      await repository.select(condominiumId, lastPendencyId: lastPendencyId);
      verify(remoteDataSource.list(condominiumId, lastPendencyId));
    });

    test('Should return success expected data when remote data source succeeds',
        () async {
      final condominiumId = "1";
      final lastPendencyId = "2";
      when(remoteDataSource.list(condominiumId, lastPendencyId))
          .thenAnswer((_) async => _models);
      final result = await repository.select(condominiumId,
          lastPendencyId: lastPendencyId);
      expect(
          result,
          IsAnd<Success<List<Pendency>>>(
              (it) => it.get().length == _models.length));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      final condominiumId = "1";
      final lastPendencyId = "2";
      when(remoteDataSource.list(condominiumId, lastPendencyId))
          .thenThrow(Exception());
      final result = await repository.select(condominiumId,
          lastPendencyId: lastPendencyId);
      expect(result, isA<Rejection<List<Pendency>>>());
    });

    test(
        'Should persist data into local data source when remote datasource succeeds fetching data and not paging',
        () async {
      final condominiumId = "1";
      final lastPendencyId = null;
      when(remoteDataSource.list(condominiumId, lastPendencyId))
          .thenAnswer((_) async => _models);
      final result = await repository.select(condominiumId,
          lastPendencyId: lastPendencyId);
      verify(localDataSource.save(condominiumId, any));
    });

    test(
        'Should not persist data into local data source when remote datasource succeeds fetching data while paging',
        () async {
      final condominiumId = "1";
      final lastPendencyId = "2";
      when(remoteDataSource.list(condominiumId, lastPendencyId))
          .thenAnswer((_) async => _models);
      await repository.select(condominiumId, lastPendencyId: lastPendencyId);
      verifyZeroInteractions(localDataSource.save(condominiumId, any));
    });
  });

  group('selectCache', () {
    test('Should call local data source list', () async {
      final condominiumId = "1";

      when(localDataSource.list(condominiumId))
          .thenAnswer((_) async => _models);
      await repository.selectCache(condominiumId);
      verify(localDataSource.list(condominiumId));
    });

    test('Should return success expected data when local data source succeeds',
        () async {
      final condominiumId = "1";
      when(localDataSource.list(condominiumId))
          .thenAnswer((_) async => _models);
      final result = await repository.select(condominiumId);
      expect(
          result,
          IsAnd<Success<List<Pendency>>>(
              (it) => it.get().length == _models.length));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      final condominiumId = "1";
      when(localDataSource.list(condominiumId)).thenThrow(Exception());
      final result = await repository.select(condominiumId);
      expect(result, isA<Rejection<List<Pendency>>>());
    });
  });

  group('save', () {
    test('Should call local data source save', () async {
      final condominiumId = "1";
      when(localDataSource.save(condominiumId, any))
          .thenAnswer((_) async => _models);
      await repository.save(condominiumId, _entities);
      verify(localDataSource.save(condominiumId, any));
    });

    test('Should return success expected data when remote data source succeeds',
        () async {
      final condominiumId = "1";
      when(localDataSource.save(condominiumId, any))
          .thenAnswer((_) async => _models);
      final result = await repository.save(condominiumId, _entities);
      expect(
          result,
          IsAnd<Success<List<Pendency>>>(
              (it) => it.get().length == _models.length));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      final condominiumId = "1";

      when(localDataSource.save(condominiumId, any)).thenThrow(Exception());
      final result = await repository.save(condominiumId, _entities);
      expect(result, isA<Rejection<List<Pendency>>>());
    });
  });

  group('clear', () {
    test('Should call local data source clear', () async {
      await repository.clear();
      verify(localDataSource.clear(null));
    });

    test('Should return success expected data when remote data source succeeds',
        () async {
      final result = await repository.clear();
      expect(result, isA<Success<Nothing>>());
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      final condominiumId = "1";

      when(localDataSource.clear(null)).thenThrow(Exception());
      final result = await repository.clear();
      expect(result, isA<Rejection<Nothing>>());
    });
  });
}

class PendencyLocalDataSourceMock extends Mock
    implements PendencyLocalDataSource {}

class PendencyRemoteDataSourceMock extends Mock
    implements PendencyRemoteDataSource {}
