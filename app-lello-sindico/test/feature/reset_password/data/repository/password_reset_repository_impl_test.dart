import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  PasswordResetRepository repository;
  PasswordResetRemoteDataSource remote;

  final _reset = PasswordReset();
  final _resetModel = PasswordResetModel();

  setUp(() {
    remote = PasswordResetRemoteDataSourceMock();
    repository = PasswordResetRepositoryImpl(dataSource: remote);
  });

  group('post', () {
    test('Should call remote data source post', () async {
      await repository.post(_reset);
      verify(remote.post(any));
    });

    test('Should return success when remote data source succeeds posting',
        () async {
      when(remote.post(any)).thenAnswer((_) async => _resetModel);
      final result = await repository.post(_reset);
      expect(result, isA<Success<PasswordReset>>());
    });

    test('Should return rejection when remote data source fails posting',
        () async {
      when(remote.post(any)).thenThrow(Exception());
      final result = await repository.post(_reset);
      expect(result, isA<Rejection<PasswordReset>>());
    });
  });
}

class PasswordResetRemoteDataSourceMock extends Mock
    implements PasswordResetRemoteDataSource {}
