import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  ResetPassword resetPassword;
  PasswordResetRepository repository;

  final _codeRequest = CodeRequest(
    source: CodeValidationSource.phone,
    value: "123",
    origin: CodeValidationOrigin.other,
  );

  final _reset = PasswordReset()
    ..codeValidationId = "1"
    ..phone = "123"
    ..password = "1";

  setUp(() {
    repository = PasswordResetRepositoryMock();
    resetPassword = ResetPasswordImpl(repository: repository);
  });

  group('call', () {
    group('with invalid data', () {
      test(
          'Should return invalid param failure when calling with null parameter',
          () async {
        final result = await resetPassword.call(null);
        expect(
            result,
            IsAnd<Rejection<PasswordReset>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should return invalid phone failure when calling with null phone',
          () async {
        final param = PasswordReset()
          ..codeValidationId = "123"
          ..phone = null
          ..password = "1";
        final result = await resetPassword.call(param);
        expect(
            result,
            IsAnd<Rejection<PasswordReset>>(
                (it) => it.get() is InvalidCpfFailure));
      });

      test('Should return invalid phone failure when calling with empty phone',
          () async {
        final param = PasswordReset()
          ..codeValidationId = "123"
          ..phone = ""
          ..password = "1";

        final result = await resetPassword.call(param);
        expect(
            result,
            IsAnd<Rejection<PasswordReset>>(
                (it) => it.get() is InvalidCpfFailure));
      });
    });
    group('with valid data', () {
      test('Should call repository post', () async {
        await resetPassword.call(_reset);
        verify(repository.post(_reset));
      });

      test('Should return success when repository succeeds posting', () async {
        when(repository.post(_reset)).thenAnswer((_) async => Success(_reset));
        final result = await resetPassword.call(_reset);
        expect(
            result, IsAnd<Success<PasswordReset>>((it) => it.get() == _reset));
      });

      test('Should return rejection when repository fails posting', () async {
        when(repository.post(_reset))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await resetPassword.call(_reset);
        expect(result, isA<Rejection<PasswordReset>>());
      });
    });
  });
}

class PasswordResetRepositoryMock extends Mock
    implements PasswordResetRepository {}
