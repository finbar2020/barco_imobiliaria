import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'code_validation_support.dart';

void main() {
  late CodeValidationHarness harness;
  final throwing = ThrowingCodeValidationRepository();

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSmsAutofill();
    harness = CodeValidationHarness();
  });

  Failure rejected(Try result) => (result as Rejection).get();

  group('GetDados2faImpl', () {
    test('cpf vazio é inválido', () async {
      final useCase = GetDados2faImpl(repository: harness.repository);
      expect(rejected(await useCase(CodeDataParam(cpf: ''))),
          isA<InvalidGetDados2faFailure>());
      expect(harness.http.requests, isEmpty);
    });

    test('delega ao repositório', () async {
      harness.mockDados2fa('529', emails: [contact('e', 'a@b.com')]);
      final useCase = GetDados2faImpl(repository: harness.repository);
      final result = await useCase(CodeDataParam(cpf: '529', idEmpresa: 3));
      expect(result.fold((l) => null, (r) => r)!.emailContacts, hasLength(1));
      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '3');
    });

    test('exceção vira UnknownFailure', () async {
      final useCase = GetDados2faImpl(repository: throwing);
      expect(rejected(await useCase(CodeDataParam(cpf: '1'))),
          isA<UnknownFailure>());
    });
  });

  group('Request2faImpl', () {
    test('id vazio é inválido', () async {
      final useCase = Request2faImpl(repository: harness.repository);
      expect(rejected(await useCase(Tequest2faParam(id: '', appSignature: 's'))),
          isA<InvalidRequest2faFailure>());
    });

    test('delega ao repositório', () async {
      harness.mockRequest2fa();
      final useCase = Request2faImpl(repository: harness.repository);
      final result = await useCase(Tequest2faParam(id: 'K', appSignature: 's'));
      expect(result, isA<Success<bool>>());
    });

    test('exceção vira UnknownFailure', () async {
      final useCase = Request2faImpl(repository: throwing);
      expect(rejected(await useCase(Tequest2faParam(id: 'K', appSignature: 's'))),
          isA<UnknownFailure>());
    });
  });

  group('RequestValidationCodeImpl', () {
    test('valida valor e token', () async {
      final useCase =
          RequestValidationCodeImpl(repository: harness.repository);
      expect(rejected(await useCase(phoneRequest(value: '', token: 'abcd'))),
          isA<InvalidCodeSourceFailure>());
      expect(rejected(await useCase(phoneRequest(token: 'abc'))),
          isA<InvalidCodeValidationFailure>());
    });

    test('registra pelo repositório', () async {
      harness.mockGenerated();
      final useCase =
          RequestValidationCodeImpl(repository: harness.repository);
      final result = await useCase(phoneRequest(token: 'abcd'));
      expect(result.fold((l) => null, (r) => r)!.id, 'REQ-1');
    });

    test('exceção vira UnknownFailure', () async {
      final useCase = RequestValidationCodeImpl(repository: throwing);
      expect(rejected(await useCase(phoneRequest(token: 'abcd'))),
          isA<UnknownFailure>());
    });
  });

  group('Validate2faImpl', () {
    test('id ou valor vazios são inválidos', () async {
      final useCase = Validate2faImpl(repository: harness.repository);
      expect(rejected(await useCase(Validate2faParam(id: '', value: '1'))),
          isA<InvalidValidate2faFailure>());
      expect(rejected(await useCase(Validate2faParam(id: 'K', value: ''))),
          isA<InvalidValidate2faFailure>());
    });

    test('delega ao repositório', () async {
      harness.mockValidate2fa(token: 'T');
      final useCase = Validate2faImpl(repository: harness.repository);
      final result = await useCase(Validate2faParam(id: 'K', value: '1'));
      expect(result.fold((l) => null, (r) => r)!.token, 'T');
    });

    test('exceção vira UnknownFailure', () async {
      final useCase = Validate2faImpl(repository: throwing);
      expect(rejected(await useCase(Validate2faParam(id: 'K', value: '1'))),
          isA<UnknownFailure>());
    });
  });

  group('ValidateCodeImpl', () {
    test('código nulo ou vazio é inválido', () async {
      final useCase = ValidateCodeImpl(repository: harness.repository);
      expect(rejected(await useCase(CodeValidation(id: 'I'))),
          isA<InvalidCodeValidationFailure>());
      expect(rejected(await useCase(CodeValidation(id: 'I', code: ''))),
          isA<InvalidCodeValidationFailure>());
    });

    test('sucesso devolve a validação e rejeição vira inválido', () async {
      harness.mockGeneratedValidate();
      final useCase = ValidateCodeImpl(repository: harness.repository);
      final ok = await useCase(CodeValidation(id: 'I', code: '1234'));
      expect(ok.fold((l) => null, (r) => r)!.id, 'I');

      harness.mockGeneratedValidate(
          status: 429,
          body: apiFailureBody(
              status: 429,
              failure: 'validate_code_max_failed_attempts_exceeded_failure'));
      final bad = await useCase(CodeValidation(id: 'I', code: '1234'));
      expect(rejected(bad), isA<InvalidCodeValidationFailure>());
    });

    test('exceção vira UnknownFailure', () async {
      final useCase = ValidateCodeImpl(repository: throwing);
      expect(rejected(await useCase(CodeValidation(id: 'I', code: '1'))),
          isA<UnknownFailure>());
    });
  });
}
