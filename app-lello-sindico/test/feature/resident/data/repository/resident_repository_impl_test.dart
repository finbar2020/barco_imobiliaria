import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/data/data_source/local/resident_local_data_source.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_remote_data_source.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';
import 'package:lello/feature/resident/data/repository/resident_repository_impl.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  ResidentRepository repository;
  ResidentLocalDataSource localDataSource;
  ResidentRemoteDataSource remoteDataSource;

  final _condoId = "123";
  final _unitId = "546";
  final _data = [ResidentModel()];

  setUp(() {
    localDataSource = ResidentLocalDataSourceMock();
    remoteDataSource = ResidentRemoteDataSourceMock();
    repository = ResidentRepositoryImpl(
        localDataSource: localDataSource, remoteDataSource: remoteDataSource);
  });

  group('list', () {
    group('with local origin ', () {
      test('Should call localDataSource list', () async {
        when(localDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.local, _condoId);
        verify(localDataSource.list(_condoId));
        verifyZeroInteractions(remoteDataSource);
      });

      test('Should return success if datasource succeeds', () async {
        when(localDataSource.list(_condoId)).thenAnswer((_) async => _data);
        final result = await repository.list(DataOrigin.local, _condoId);
        expect(result, isA<Success<List<Resident>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(localDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.local, _condoId);
        expect(result,
            IsAnd<Rejection<List<Resident>>>((it) => it.get() is Failure));
      });
    });

    group('with remote origin ', () {
      test('Should call remote data source list', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.remote, _condoId,
            query: "q", lastResidentId: "r");
        verify(
            remoteDataSource.list(_condoId, query: "q", lastResidentId: "r"));
      });

      test('Should call local data source insert', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.remote, _condoId);
        verify(localDataSource.insert(_condoId, _data));
      });

      test(
          'Should return success if data source succeeds even if local data source crashes',
          () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        when(localDataSource.insert(_condoId, any)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result, isA<Success<List<Resident>>>());
      });

      test('Should return success if data source succeeds', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result, isA<Success<List<Resident>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(remoteDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result,
            IsAnd<Rejection<List<Resident>>>((it) => it.get() is Failure));
      });
    });
  });

  group('listFromUnit', () {
    test('Should call remote data source list', () async {
      when(remoteDataSource.listFromUnit(_condoId, _unitId))
          .thenAnswer((_) async => _data);
      await repository.listFromUnit(_condoId, _unitId);
      verify(remoteDataSource.listFromUnit(_condoId, _unitId));
    });

    test('Should return success if data source succeeds', () async {
      when(remoteDataSource.listFromUnit(_condoId, _unitId))
          .thenAnswer((_) async => _data);
      final result = await repository.listFromUnit(_condoId, _unitId);
      expect(result, isA<Success<List<Resident>>>());
    });

    test('Should return rejection if datasource throws', () async {
      when(remoteDataSource.listFromUnit(_condoId, _unitId))
          .thenThrow(Exception());
      final result = await repository.listFromUnit(_condoId, _unitId);
      expect(result,
          IsAnd<Rejection<List<Resident>>>((it) => it.get() is Failure));
    });
  });
}

class ResidentLocalDataSourceMock extends Mock
    implements ResidentLocalDataSource {}

class ResidentRemoteDataSourceMock extends Mock
    implements ResidentRemoteDataSource {}
