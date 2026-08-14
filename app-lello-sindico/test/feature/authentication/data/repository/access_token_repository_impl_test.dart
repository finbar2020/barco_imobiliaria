import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../matcher/is_and_matcher.dart';

class MockAccessTokenDataSource extends Mock
    implements AccessTokenLocalDataSource {}

void main() {
  AccessTokenRepository repository;
  AccessTokenLocalDataSource dataSource;

  final validEntity = AccessToken()
    ..accessToken = "1"
    ..refreshToken = "2"
    ..expiresIn = DateTime.now();

  final validModel = AccessTokenModel()
    ..accessToken = "1"
    ..refreshToken = "2"
    ..expiresIn = 3;

  setUp(() {
    dataSource = MockAccessTokenDataSource();
    repository = AccessTokenRepositoryImpl(dataSource: dataSource);
  });

  group('select', () {
    test('Should request data from data source', () async {
      await repository.select();
      verify(dataSource.select());
    });

    test('Should return success with null when data source returns no data',
        () async {
      when(dataSource.select()).thenAnswer((_) => null);

      Try<AccessToken> data = await repository.select();
      expect(data, isA<Success<AccessToken>>());

      var result = (data as Success<AccessToken>).get();
      expect(result, isNull);
    });

    test(
        'Should return success with model when data source returns expected data',
        () async {
      when(dataSource.select()).thenAnswer((_) async => validModel);

      Try<AccessToken> data = await repository.select();
      expect(data, isA<Success<AccessToken>>());

      var result = (data as Success<AccessToken>).get();
      expect(result.accessToken, validModel.accessToken);
    });

    test('Should return rejection when data source throws an error', () async {
      var exception = Exception();
      when(dataSource.select()).thenThrow(exception);

      Try<AccessToken> data = await repository.select();
      expect(data, isA<Rejection<AccessToken>>());

      var result = (data as Rejection<AccessToken>).get();
      expect(result.error, equals(exception));
    });
  });

  group('save', () {
    test('Should store data into data source', () async {
      when(dataSource.save(any)).thenAnswer((_) async => validModel);

      await repository.save(validEntity);
      verify(dataSource.save(any));
    });

    group('Saving null data', () {
      test('Should return success with null when storing null data', () async {
        when(dataSource.save(null)).thenAnswer((_) async => null);

        Try<AccessToken> data = await repository.save(null);
        expect(data, IsAnd<Success<AccessToken>>((it) => it.get() == null));
      });
    });

    group('Saving valid data', () {
      test('Should return success with null when storing null data', () async {
        when(dataSource.save(any)).thenAnswer((_) async => validModel);

        Try<AccessToken> data = await repository.save(validEntity);
        expect(
            data,
            IsAnd<Success<AccessToken>>(
                (it) => it.get().accessToken == validModel.accessToken));
      });
    });
  });
}
