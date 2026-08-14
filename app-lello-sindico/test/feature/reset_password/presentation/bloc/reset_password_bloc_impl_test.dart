import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  ResetPasswordBloc bloc;
  ResetPassword resetPassword;
  RequestValidationCode requestValidationCode;

  final _codeRequest = CodeRequest(
      source: CodeValidationSource.phone,
      value: "123",
      id: "456",
      origin: CodeValidationOrigin.other,
      token: "1234");
  final _passwordReset = PasswordReset();

  setUp(() {
    resetPassword = ResetPasswordMock();
    requestValidationCode = RequestValidationCodeMock();
    bloc = ResetPasswordBlocImpl(
        requestValidationCode: requestValidationCode,
        resetPassword: resetPassword);
  });

  group('requestCode', () {
    test(
        'Should not call request validation code use case when bloc has no phone',
        () async {
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(_codeRequest));
      bloc.beginRequestCode();
      verifyNever(requestValidationCode.call(any));
    });

    test('Should call request validation code use case when bloc no phone',
        () async {
      bloc.setPhone("123");
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(_codeRequest));
      bloc.beginRequestCode();
      await expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordRequestingCodeState>()
          ]));
      verify(requestValidationCode.call(any));
    });

    test('Should emit succeess state when request validation succeeds',
        () async {
      bloc.setPhone("123");
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(_codeRequest));
      bloc.beginRequestCode();
      expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordRequestingCodeState>(),
            isA<ResetPasswordRequestCodeSucceededState>()
          ]));
    });

    test('Should emit failure state when request validation succeeds',
        () async {
      bloc.setPhone("123");
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRequestCode();
      expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordRequestingCodeState>(),
            isA<ResetPasswordRequestCodeFailedState>()
          ]));
    });
  });

  group('beginResetPassword', () {
    test('Should call reset password use case', () async {
      when(resetPassword.call(any))
          .thenAnswer((_) async => Success(_passwordReset));

      bloc.beginResetPassword();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordResettingPasswordState>(),
          ]));

      verify(resetPassword.call(any));
    });

    test('Should emit succeess state when reset password succeeds', () async {
      when(resetPassword.call(any))
          .thenAnswer((_) async => Success(_passwordReset));
      bloc.beginResetPassword();
      expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordResettingPasswordState>(),
            isA<ResetPasswordSucceededState>()
          ]));
    });

    test('Should emit failure state when request validation succeeds',
        () async {
      when(resetPassword.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginResetPassword();
      expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordResettingPasswordState>(),
            isA<ResetPasswordFailedState>()
          ]));
    });
  });

  group('setPhone', () {
    test('Should not fail', () async {
      bloc.setPhone("123");
      expect(true, true);
    });
  });

  group('setValidation', () {
    test('Should emit request phone state', () async {
      bloc.setValidation(CodeValidation()..code = "123");
      expectLater(
          bloc,
          emitsInOrder([
            isA<ResetPasswordRequestPhoneState>(),
            isA<ResetPasswordRequestPasswordState>(),
          ]));
    });
  });
}

class RequestValidationCodeMock extends Mock implements RequestValidationCode {}

class ResetPasswordMock extends Mock implements ResetPassword {}
