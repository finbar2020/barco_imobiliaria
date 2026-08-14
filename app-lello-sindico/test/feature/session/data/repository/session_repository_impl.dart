import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/session/data/data_source/session_local_data_source.dart';
import 'package:lello/feature/session/data/model/session_model.dart';
import 'package:lello/feature/session/data/repository/session_repository_impl.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  SessionRepository repository;
  SessionLocalDataSource localDataSource;

  final _sessionModel = SessionModel();
  final _session = Session();

  setUp(() {
    localDataSource = SessionLocalDataSourceMock();
    repository = SessionRepositoryImpl(sessionDataSource: localDataSource);
  });

  group('select', () {
    test('Should call local data source', () async {
      when(localDataSource.select()).thenAnswer((_) async => _sessionModel);
      await repository.select();
      verify(localDataSource.select());
    });

    test('Should return success when local data source returns value',
        () async {
      when(localDataSource.select()).thenAnswer((_) async => _sessionModel);
      final result = await repository.select();
      expect(
          result, IsAnd<Success<Session>>((it) => it.get() == _sessionModel));
    });

    test('Should return rejection when local data source throws any error',
        () async {
      when(localDataSource.select()).thenThrow(Exception());
      final result = await repository.select();
      expect(result, isA<Rejection<Session>>());
    });
  });

  group('save', () {
    test('Should call local data source', () async {
      when(localDataSource.save(any)).thenAnswer((_) async => _sessionModel);
      await repository.save(_session);
      verify(localDataSource.save(any));
    });

    test('Should return success when remote data source returns value',
        () async {
      when(localDataSource.save(any)).thenAnswer((_) async => _sessionModel);
      final result = await repository.save(_session);
      expect(result, IsAnd<Success<Session>>((it) => it.get() != null));
    });

    test('Should return rejection when remote data source throws any error',
        () async {
      when(localDataSource.select()).thenThrow(Exception());
      final result = await repository.save(_session);
      expect(result, isA<Rejection<Session>>());
    });
  });
}

class SessionLocalDataSourceMock extends Mock
    implements SessionLocalDataSource {}
