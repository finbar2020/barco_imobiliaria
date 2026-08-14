import 'dart:math';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/pendency/domain/repository/pendency_repository.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  Logout logout;
  AccessTokenRepository repository;
  PendencyRepository pendencyRepository;
  SessionRepository sessionRepository;

  setUp(() {
    repository = MockAccessTokenRepository();
    pendencyRepository = MockPendencyRepository();
    sessionRepository = MockSessionRepository();
    logout = LogoutImpl(
        repository: repository,
        sessionRepository: sessionRepository,
        pendencyRepository: pendencyRepository);
  });

  group('call', () {
    test('Should call repository save method when credentials are valid',
        () async {
      when(repository.save(null)).thenAnswer((_) async => Success(null));

      await logout();
      verify(repository.save(null));
      verify(pendencyRepository.clear());
      verify(sessionRepository.clear());
    });

    test('Should return success when credentials are valid', () async {
      when(repository.save(null)).thenAnswer((_) async => Success(null));

      var result = await logout.call();
      expect(result, isA<Success>());
    });

    test('Should return error when repository fails to post data', () async {
      when(repository.save(null))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      var result = await logout();
      expect(result, isA<Rejection>());
    });
  });
}

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

class MockPendencyRepository extends Mock implements PendencyRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}
