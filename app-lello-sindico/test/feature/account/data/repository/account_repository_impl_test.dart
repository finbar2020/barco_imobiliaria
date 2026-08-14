import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/account/data/data_source/local/account_local_data_source.dart';
import 'package:lello/feature/account/data/data_source/remote/account_remote_data_source.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:lello/feature/account/data/repository/account_repository_impl.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  AccountRepository repository;
  AccountLocalDataSource localDataSource;
  AccountRemoteDataSource remoteDataSource;

  final _condoId = "123";
  final _data = [AccountModel()];

  setUp(() {
    localDataSource = AccountLocalDataSourceMock();
    remoteDataSource = AccountRemoteDataSourceMock();
    repository = AccountRepositoryImpl(
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
        expect(result, isA<Success<List<Account>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(localDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.local, _condoId);
        expect(result,
            IsAnd<Rejection<List<Account>>>((it) => it.get() is Failure));
      });
    });

    group('with remote origin ', () {
      test('Should call remote data source list', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.remote, _condoId);
        verify(remoteDataSource.list(_condoId));
      });

      test('Should call local data source save', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.remote, _condoId);
        verify(localDataSource.save(_condoId, _data));
      });

      test(
          'Should return success if data source succeeds even if local data source crashes',
          () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        when(localDataSource.save(_condoId, any)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result, isA<Success<List<Account>>>());
      });

      test('Should return success if data source succeeds', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result, isA<Success<List<Account>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(remoteDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result,
            IsAnd<Rejection<List<Account>>>((it) => it.get() is Failure));
      });
    });
  });
}

class AccountLocalDataSourceMock extends Mock
    implements AccountLocalDataSource {}

class AccountRemoteDataSourceMock extends Mock
    implements AccountRemoteDataSource {}
