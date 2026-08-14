import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  AuthenticationBlocImpl bloc;
  AuthenticateMock authenticate;
  LogoutMock logout;
  GetToken getToken;

  final failure = UnknownFailure(null);
  final validCredentials = Credentials(username: "123", password: "456");
  final validAccessToken = AccessToken();

  setUp(() {
    authenticate = AuthenticateMock();
    logout = LogoutMock();
    getToken = GetTokenMock();

    bloc = AuthenticationBlocImpl(
        authenticate: authenticate, logout: logout, getToken: getToken);
  });

  group('Login', () {
    test('Should call authenticate use case', () async {
      when(authenticate.call(any))
          .thenAnswer((_) async => Success(validAccessToken));
      bloc.beginLogin(validCredentials);
      await expectLater(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatingState>(),
          ]));
      verify(authenticate(validCredentials));
    });

    test('Should emit authentication failed state when authentication fails',
        () async {
      when(authenticate.call(any)).thenAnswer((_) async => Rejection(failure));
      bloc.beginLogin(validCredentials);
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatingState>(), //new state after authentication
            isA<AuthenticationFailedState>() //new state after authentication
          ]));
    });

    test('Should emit authenticated state when authentication succeeds',
        () async {
      when(authenticate.call(any))
          .thenAnswer((_) async => Success(validAccessToken));
      bloc.beginLogin(validCredentials);
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatingState>(), //new state after authentication
            isA<AuthenticatedState>() //new state after authentication
          ]));
    });
  });

  group('SignOut', () {
    test('Should call logout', () async {
      when(logout.call()).thenAnswer((_) async => Success(Nothing()));
      bloc.beginLogout();
      await expectLater(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<UnauthenticatedState>(), //default state
          ]));
      verify(logout());
    });
    test('Should emit logout event if logout succeeds', () async {
      when(logout.call()).thenAnswer((_) async => Success(Nothing()));
      bloc.beginLogout();
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<UnauthenticatedState>() //new state after logout
          ]));
    });
    test('Should not emit anyt event if logout fails', () async {
      when(logout.call()).thenAnswer((_) async => Rejection(failure));
      bloc.beginLogout();
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
          ]));
    });
  });

  group('load', () {
    test('Should emit authenticated state is repository returns token',
        () async {
      when(getToken.call(GetTokenParams()))
          .thenAnswer((_) async => Success(validAccessToken));
      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatedState>() //new state after logout
          ]));
    });
    test('Should emit unauthenticated state is repository returns null',
        () async {
      when(getToken.call(GetTokenParams()))
          .thenAnswer((_) async => Success(null));
      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
          ]));
    });

    test('Should emit unauthenticated state is repository fails null',
        () async {
      when(getToken.call(GetTokenParams()))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoad();
      expect(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
          ]));
    });
  });

  group('ResetIfFailed', () {
    test('Should emit reset event if previous state was failed', () async {
      when(authenticate.call(any))
          .thenAnswer((_) async => Rejection(InvalidCredentialsFailure()));
      bloc.beginLogin(validCredentials);
      bloc.resetIfFailed();

      expectLater(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatingState>(), //default state
            isA<AuthenticationFailedState>(), //default state
          ]));
    });
    test('Should not emit any extra event if authentication succeeeds',
        () async {
      when(authenticate.call(any))
          .thenAnswer((_) async => Success(validAccessToken));
      bloc.beginLogin(validCredentials);
      bloc.resetIfFailed();

      expectLater(
          bloc,
          emitsInOrder([
            isA<UnauthenticatedState>(), //default state
            isA<AuthenticatingState>(), //loding state
            isA<AuthenticatedState>() //success state
          ]));
    });
  });
}

class GetTokenMock extends Mock implements GetToken {}

class AuthenticateMock extends Mock implements Authenticate {}

class LogoutMock extends Mock implements Logout {}
