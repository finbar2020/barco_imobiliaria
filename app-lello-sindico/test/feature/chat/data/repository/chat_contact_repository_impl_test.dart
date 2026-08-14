import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/chat/data/data_source/local/chat_contact_local_data_source.dart';
import 'package:lello/feature/chat/data/data_source/remote/contact/chat_contact_remote_data_source.dart';
import 'package:lello/feature/chat/data/model/chat_contact_model.dart';
import 'package:lello/feature/chat/data/repository/chat_contact_repository_impl.dart';
import 'package:lello/feature/chat/domain/entity/chat_contact.dart';
import 'package:lello/feature/chat/domain/repository/chat_contact_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  ChatContactRepository repository;
  ChatContactLocalDataSource localDataSource;
  ChatContactRemoteDataSource remoteDataSource;

  final _condoId = "123";
  final _data = [ChatContactModel()];

  setUp(() {
    localDataSource = ChatContactLocalDataSourceMock();
    remoteDataSource = ChatContactRemoteDataSourceMock();
    repository = ChatContactRepositoryImpl(
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
        expect(result, isA<Success<List<ChatContact>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(localDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.local, _condoId);
        expect(result,
            IsAnd<Rejection<List<ChatContact>>>((it) => it.get() is Failure));
      });
    });

    group('with remote origin ', () {
      test('Should call remote data source list', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        await repository.list(DataOrigin.remote, _condoId,
            query: "q", lastContactId: "r");
        verify(remoteDataSource.list(_condoId, query: "q", lastContactId: "r"));
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
        expect(result, isA<Success<List<ChatContact>>>());
      });

      test('Should return success if data source succeeds', () async {
        when(remoteDataSource.list(_condoId)).thenAnswer((_) async => _data);
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result, isA<Success<List<ChatContact>>>());
      });

      test('Should return rejection if datasource throws', () async {
        when(remoteDataSource.list(_condoId)).thenThrow(Exception());
        final result = await repository.list(DataOrigin.remote, _condoId);
        expect(result,
            IsAnd<Rejection<List<ChatContact>>>((it) => it.get() is Failure));
      });
    });
  });
}

class ChatContactLocalDataSourceMock extends Mock
    implements ChatContactLocalDataSource {}

class ChatContactRemoteDataSourceMock extends Mock
    implements ChatContactRemoteDataSource {}
