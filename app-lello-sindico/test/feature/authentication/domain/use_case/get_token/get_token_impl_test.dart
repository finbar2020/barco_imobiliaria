import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  GetToken getToken;
  AccessTokenRepository repository;

  final _token = AccessToken();

  setUp(() {
    repository = AccessTokenRepositoryMock();
    getToken = GetTokenImpl(repository: repository);
  });

  group('call', () {
    test('Should call repository select', () async {
      await getToken(GetTokenParams());
      verify(repository.select());
    });

    test('Should return success if repository succeeeds', () async {
      when(repository.select()).thenAnswer((_) async => Success(_token));
      final result = await getToken(GetTokenParams());
      expect(result, IsAnd<Success<AccessToken>>((it) => it.get() == _token));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.select())
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await getToken(GetTokenParams());
      expect(result,
          IsAnd<Rejection<AccessToken>>((it) => it.get() is UnknownFailure));
    });
  });
}

class AccessTokenRepositoryMock extends Mock implements AccessTokenRepository {}
