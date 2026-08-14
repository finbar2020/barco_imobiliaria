import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  RequestValidationCode requestValidationCode;
  CodeValidationRepository repository;
  final request =
      CodeRequest(id: "1", value: "1", source: CodeValidationSource.email);

  setUp(() {
    repository = PhoneValidationRepositoryMock();
    requestValidationCode = RequestValidationCodeImpl(repository: repository);
  });

  group('call', () {
    test(
        'Should return rejection with expected failure when calling with null value',
        () async {
      Try<CodeRequest> result = await requestValidationCode(null);
      expect(result,
          IsAnd<Rejection>((value) => value.get() is InvalidParamFailure));
    });

    test(
        'Should return rejection with expected failure when calling with empty value',
        () async {
      Try<CodeRequest> result = await requestValidationCode(CodeRequest(
          source: CodeValidationSource.email,
          value: "",
          origin: CodeValidationOrigin.other));
      expect(result,
          IsAnd<Rejection>((value) => value.get() is InvalidCodeSourceFailure));
    });

    test('Should return call repository', () async {
      when(repository.register(request))
          .thenAnswer((_) async => Success(request));
      await requestValidationCode(request);
      verify(repository.register(request));
    });

    test('Should return success when repository succeeds', () async {
      when(repository.register(request))
          .thenAnswer((_) async => Success(request));
      Try<CodeRequest> result = await requestValidationCode(request);
      expect(
          result,
          IsAnd<Success<CodeRequest>>((value) =>
              value.get() != null && value.get().value == request.value));
    });

    test('Should return rejection when repository fails', () async {
      final failure = UnknownFailure(null);
      when(repository.register(request))
          .thenAnswer((_) async => Rejection(failure));
      Try<CodeRequest> result = await requestValidationCode(request);
      expect(
          result,
          IsAnd<Rejection<CodeRequest>>(
              (value) => value.get() is UnknownFailure));
    });
  });
}

class PhoneValidationRepositoryMock extends Mock
    implements CodeValidationRepository {}
