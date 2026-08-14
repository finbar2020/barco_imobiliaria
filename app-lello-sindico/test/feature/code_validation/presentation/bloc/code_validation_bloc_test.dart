import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  CodeValidationBlocImpl bloc;
  ValidatePhoneMock validatePhone;

  final source = CodeValidationSource.email;
  final _codeRequest = CodeRequest(id: "1", value: "123", source: source);
  final _codeValidation = CodeValidation()
    ..id = "1"
    ..value = "123"
    ..code = "456"
    ..source = source;

  setUp(() {
    validatePhone = ValidatePhoneMock();
    bloc = CodeValidationBlocImpl(validateCode: validatePhone);
  });

  tearDown(() {
    bloc.close();
  });

  group('setup', () {
    test('Should emit new state containing registration', () async {
      bloc.setup(_codeRequest);
      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<CodeValidationState>((state) => state.request == null),
            IsAnd<CodeValidationState>(
                (state) => state.request == _codeRequest),
          ]));
    });
  });

  group('beginValidation', () {
    test('Should emit validation failed if setup was not previously called',
        () async {
      bloc.beginValidation("123");

      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<CodeValidationState>((state) => state.request == null),
          ]));
    });

    test('Should call validate phone use case when setup was previosly called',
        () async {
      when(validatePhone.call(any))
          .thenAnswer((_) async => Success(_codeValidation));

      bloc.setup(_codeRequest);
      bloc.beginValidation("1234");

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<CodeValidationState>((state) => state.request == null),
            IsAnd<CodeValidationState>(
                (state) => state.request == _codeRequest),
            isA<CodeValidationValidatingState>(),
          ]));

      verify(validatePhone.call(any));
    });

    test('Should emit failure state when phone validation fails', () async {
      when(validatePhone.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc.setup(_codeRequest);
      bloc.beginValidation("1234");

      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<CodeValidationState>((state) => state.request == null),
            IsAnd<CodeValidationState>(
                (state) => state.request == _codeRequest),
            isA<CodeValidationValidatingState>(),
            isA<CodeValidationFailedState>()
          ]));
    });

    test('Should emit success state when phone validation succeeds', () async {
      when(validatePhone.call(any))
          .thenAnswer((_) async => Success(_codeValidation));

      bloc.setup(_codeRequest);
      bloc.beginValidation("1234");

      expect(
          bloc,
          emitsInOrder([
            IsAnd<CodeValidationState>((state) => state.request == null),
            IsAnd<CodeValidationState>(
                (state) => state.request == _codeRequest),
            isA<CodeValidationValidatingState>(),
            IsAnd<CodeValidationSucceededState>(
                (state) => state.validation == _codeValidation),
          ]));
    });
  });
}

class ValidatePhoneMock extends Mock implements ValidateCode {}
