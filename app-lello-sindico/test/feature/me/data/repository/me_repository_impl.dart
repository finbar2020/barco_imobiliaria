import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:lello/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/data/repository/me_repository_impl.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  MeRepository repository;
  MeLocalDataSource localDataSource;
  MeRemoteDataSource remoteDataSource;

  final _meModel = MeModel();
  final _me = Me();

  setUp(() {
    localDataSource = MeLocalDataSourceMock();
    remoteDataSource = MeRemoteDataSourceMock();
    repository = MeRepositoryImpl(
        localDataSource: localDataSource, remoteDataSource: remoteDataSource);
  });

  group('select', () {
    test('Should call remote data source', () async {
      when(remoteDataSource.get()).thenAnswer((_) async => _meModel);
      await repository.select();
      verify(remoteDataSource.get());
    });

    test('Should return success when remote data source returns value',
        () async {
      when(remoteDataSource.get()).thenAnswer((_) async => _meModel);
      final result = await repository.select();
      expect(result, IsAnd<Success<Me>>((it) => it.get() == _meModel));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      when(remoteDataSource.get()).thenThrow(Exception());
      final result = await repository.select();
      expect(result, isA<Rejection<Me>>());
    });

    test('Should save data locally after fetching from remote', () async {
      when(remoteDataSource.get()).thenAnswer((_) async => _meModel);
      await repository.select();
      verify(localDataSource.save(any));
    });
  });

  group('selectFromCache', () {
    test('Should call local data source', () async {
      when(localDataSource.select()).thenAnswer((_) async => _meModel);
      await repository.selectFromCache();
      verify(localDataSource.select());
    });

    test('Should return success when local data source returns value',
        () async {
      when(localDataSource.select()).thenAnswer((_) async => _meModel);
      final result = await repository.selectFromCache();
      expect(result, IsAnd<Success<Me>>((it) => it.get() == _meModel));
    });

    test('Should return rejection when local data source throws any error',
        () async {
      when(localDataSource.select()).thenThrow(Exception());
      final result = await repository.selectFromCache();
      expect(result, isA<Rejection<Me>>());
    });
  });

  group('save', () {
    test('Should call local data source', () async {
      when(localDataSource.save(any)).thenAnswer((_) async => _meModel);
      await repository.save(_me, "");
      verify(localDataSource.save(any));
    });

    test('Should return success when remote data source returns value',
        () async {
      when(localDataSource.save(any)).thenAnswer((_) async => _meModel);
      final result = await repository.save(_me, "");
      expect(result, IsAnd<Success<Me>>((it) => it.get() != null));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      when(localDataSource.select()).thenThrow(Exception());
      final result = await repository.save(_me, "");
      expect(result, isA<Rejection<Me>>());
    });
  });
}

class MeLocalDataSourceMock extends Mock implements MeLocalDataSource {}

class MeRemoteDataSourceMock extends Mock implements MeRemoteDataSource {}
