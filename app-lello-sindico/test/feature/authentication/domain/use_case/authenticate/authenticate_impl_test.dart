import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  Authenticate authenticate;
  AccessTokenRepository repository;
  AuthenticateFirebase authenticateFirebase;

  final credentials = Credentials(username: "1", password: "2");
  final accessToken = AccessToken()
    ..accessToken = "1"
    ..refreshToken = "2"
    ..firebaseToken = "3"
    ..expiresIn = DateTime.now();

  setUp(() {
    repository = MockAccessTokenRepository();
    authenticateFirebase = AuthenticateFirebaseMock();
    authenticate = AuthenticateImpl(
        repository: repository, authenticateFirebase: authenticateFirebase);
  });

  group('call', () {
    group('With invalid data', () {
      test('Should return invalid credentials when user is null', () async {
        Try<AccessToken> result =
            await authenticate(Credentials(username: null, password: "1"));
        expect(result, isA<Rejection>());
        var error = (result as Rejection<AccessToken>).get();
        expect(error, isA<InvalidCredentialsFailure>());
      });

      test('Should return invalid credentials when user is empty', () async {
        Try<AccessToken> result =
            await authenticate(Credentials(username: '', password: "1"));
        expect(result, isA<Rejection>());
        var error = (result as Rejection<AccessToken>).get();
        expect(error, isA<InvalidCredentialsFailure>());
      });

      test('Should return invalid credentials when password is null', () async {
        Try<AccessToken> result =
            await authenticate(Credentials(username: "1", password: null));
        expect(result, isA<Rejection>());
        var error = (result as Rejection<AccessToken>).get();
        expect(error, isA<InvalidCredentialsFailure>());
      });

      test('Should return invalid credentials when password is empty',
          () async {
        Try<AccessToken> result =
            await authenticate(Credentials(username: '1', password: ""));
        expect(result, isA<Rejection>());
        var error = (result as Rejection<AccessToken>).get();
        expect(error, isA<InvalidCredentialsFailure>());
      });
    });
    group('With valid data', () {
      test('Should call repository post method when credentials are valid',
          () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Success(accessToken));
        when(repository.save(accessToken))
            .thenAnswer((_) async => Success(accessToken));

        await authenticate(credentials);
        verify(repository.post(credentials));
      });

      test('Should call authenticate firebase when credentials are valid',
          () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Success(accessToken));
        when(repository.save(accessToken))
            .thenAnswer((_) async => Success(accessToken));

        await authenticate(credentials);
        verify(repository.post(credentials));
        verify(authenticateFirebase.call(accessToken.firebaseToken));
      });

      test('Should return success when credentials are valid', () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Success(accessToken));
        when(repository.save(accessToken))
            .thenAnswer((_) async => Success(accessToken));

        var result = await authenticate(credentials);
        expect(result, isA<Success>());
        var data = result.getOrElse(() => null);

        expect(data, isA<AccessToken>());
        expect(data.accessToken, equals(accessToken.accessToken));
        expect(data.refreshToken, equals(accessToken.refreshToken));
        expect(data.expiresIn, equals(accessToken.expiresIn));
        verify(repository.save(accessToken));
      });

      test('Should persist data when credentials are valid', () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Success(accessToken));
        when(repository.save(accessToken))
            .thenAnswer((_) async => Success(accessToken));

        await authenticate(credentials);
        verify(repository.save(accessToken));
      });

      test('Should return error when repository fails to post data', () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));

        var result = await authenticate(credentials);
        expect(result, isA<Rejection>());
      });

      test('Should not return error when repository fails to persist data',
          () async {
        when(repository.post(credentials))
            .thenAnswer((_) async => Success(accessToken));
        when(repository.save(accessToken))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));

        var result = await authenticate(credentials);
        expect(result, isA<Success>());
      });
    });
  });
}

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

class AuthenticateFirebaseMock extends Mock implements AuthenticateFirebase {}
