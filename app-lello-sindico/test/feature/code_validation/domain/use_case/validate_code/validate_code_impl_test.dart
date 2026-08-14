import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  ValidateCode validateCode;
  CodeValidationRepository repository;
  final value = "99999999";
  final code = "1234";
  final id = "1";
  final requestId = "2";
  final source = CodeValidationSource.email;

  final codeValidation = CodeValidation()
    ..requestId = requestId
    ..id = id
    ..value = value
    ..code = code
    ..source = source;

  setUp(() {
    repository = PhoneValidationRepositoryMock();
    validateCode = ValidateCodeImpl(repository: repository);
  });

  group('call', () {
    test(
        'Should return rejection with expected failure when calling with null value',
        () async {
      Try<CodeValidation> result = await validateCode(null);
      expect(
          result,
          IsAnd<Rejection>(
              (value) => value.get() is InvalidRequestCodeFailure));
    });

    test(
        'Should return rejection with expected failure when calling with empty value',
        () async {
      final invalidValidation = CodeValidation()
        ..id = id
        ..requestId = ""
        ..value = value
        ..code = code
        ..source = source;

      Try<CodeValidation> result = await validateCode(invalidValidation);
      expect(
          result,
          IsAnd<Rejection>(
              (value) => value.get() is InvalidRequestCodeFailure));
    });

    test(
        'Should return rejection with expected failure when calling with empty value',
        () async {
      final invalidValidation = CodeValidation()
        ..id = id
        ..requestId = requestId
        ..value = value
        ..code = ""
        ..source = source;

      Try<CodeValidation> result = await validateCode(invalidValidation);
      expect(
          result,
          IsAnd<Rejection>(
              (value) => value.get() is InvalidCodeValidationFailure));
    });

    test(
        'Should return rejection with expected failure when calling with empty value',
        () async {
      final invalidValidation = CodeValidation()
        ..id = id
        ..value = ""
        ..requestId = requestId
        ..code = code
        ..source = source;

      Try<CodeValidation> result = await validateCode(invalidValidation);
      expect(
          result,
          IsAnd<Rejection>(
              (value) => value.get() is InvalidRequestCodeFailure));
    });

    test('Should return call repository', () async {
      when(repository.validate(codeValidation))
          .thenAnswer((_) async => Success(codeValidation));
      await validateCode(codeValidation);
      verify(repository.validate(codeValidation));
    });

    test('Should return success when repository succeeds', () async {
      when(repository.validate(codeValidation))
          .thenAnswer((_) async => Success(codeValidation));
      Try<CodeValidation> result = await validateCode(codeValidation);
      expect(result, isA<Success<CodeValidation>>());
    });

    test('Should return rejection when repository fails', () async {
      final failure = UnknownFailure(null);
      when(repository.validate(codeValidation))
          .thenAnswer((_) async => Rejection(failure));
      Try<CodeValidation> result = await validateCode(codeValidation);
      expect(
          result,
          IsAnd<Rejection<CodeValidation>>(
              (value) => value.get() is UnknownFailure));
    });
  });
}

class PhoneValidationRepositoryMock extends Mock
    implements CodeValidationRepository {}
