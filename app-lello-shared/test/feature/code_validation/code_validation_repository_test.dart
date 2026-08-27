import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_http.dart';
import 'code_validation_support.dart';

void main() {
  late CodeValidationHarness harness;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSmsAutofill();
    harness = CodeValidationHarness();
  });

  group('CodeValidationRemoteDataSourceImpl', () {
    late CodeValidationRemoteDataSourceImpl dataSource;
    setUp(() {
      dataSource = CodeValidationRemoteDataSourceImpl(
          api: CodeValidationApi.create(buildChopperClientFor(harness)));
    });

    test('insertRequest envia o corpo e mapeia a resposta', () async {
      harness.mockGenerated();
      final model = CodeRequestModel()
        ..source = 'phone'
        ..value = '11988887777';
      final result = await dataSource.insertRequest(model);
      expect(result.id, 'REQ-1');
      expect(result.token, 'tok');
      final request = harness.http.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/code_request/generated');
      expect(request.body, contains('"value":"11988887777"'));
    });

    test('insertRequest com erro lança o ApiFailure', () async {
      harness.mockGenerated(status: 500, body: apiFailureBody());
      expect(() => dataSource.insertRequest(CodeRequestModel()),
          throwsA(isA<ApiFailure>()));
    });

    test('insertValidation aceita 202 e rejeita outros status', () async {
      harness.mockGeneratedValidate(status: 202);
      final model = CodeValidationModel(id: 'I', code: '1234');
      expect(await dataSource.insertValidation(model), same(model));

      harness.mockGeneratedValidate(status: 200, body: {'ok': true});
      expect(() => dataSource.insertValidation(model), throwsA(isA<Exception>()));
    });

    test('getDados2faAsync monta o caminho e a query', () async {
      harness.mockDados2fa('12345678901',
          emails: [contact('e1', 'a@b.com')], registered: true);
      final result = await dataSource.getDados2faAsync('12345678901', 7);
      expect(result.registered, isTrue);
      expect(result.emailContacts!.single.key, 'e1');
      final url = harness.http.requests.single.url;
      expect(url.path, '/code_request/2fa/12345678901');
      expect(url.queryParameters['idEmpresa'], '7');
    });

    test('request2faAsync devolve true no 200 e lança nos demais', () async {
      harness.mockRequest2fa();
      expect(await dataSource.request2faAsync('K1', 'sig'), isTrue);
      final url = harness.http.requests.single.url;
      expect(url.path, '/code_request/2fa/request');
      expect(url.queryParameters, {'hashToken': 'K1', 'hashDevice': 'sig'});

      harness.mockRequest2fa(status: 204, body: '');
      expect(() => dataSource.request2faAsync('K1', 'sig'),
          throwsA(isA<Exception>()));
    });

    test('validate2faAsync mapeia o token', () async {
      harness.mockValidate2fa(token: 'T1');
      final result = await dataSource.validate2faAsync('K1', '123456');
      expect(result.token, 'T1');
      final url = harness.http.requests.single.url;
      expect(url.queryParameters, {'hashToken': 'K1', 'tokenValue': '123456'});
    });
  });

  group('CodeValidationRepositoryImpl', () {
    test('register preenche a assinatura e devolve o pedido', () async {
      harness.mockGenerated();
      final result = await harness.repository.register(phoneRequest(
          origin: CodeValidationOrigin.changeNumber, cpf: '52998224725'));
      final request = result.fold((l) => null, (r) => r)!;
      expect(result, isA<Success<CodeRequest>>());
      expect(request.id, 'REQ-1');
      expect(request.cpf, '52998224725');
      expect(request.source, CodeValidationSource.phone);
      expect(request.origin, CodeValidationOrigin.changeNumber);
      expect(request.token, 'tok');
    });

    test('register com erro devolve UnknownFailure', () async {
      harness.mockGenerated(status: 500, body: apiFailureBody());
      final result = await harness.repository.register(phoneRequest());
      expect(result, isA<Rejection>());
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('validate devolve a validação no 202', () async {
      harness.mockGeneratedValidate();
      final result = await harness.repository
          .validate(CodeValidation(id: 'I', code: '1234'));
      expect(result, isA<Success>());
      expect(result.fold((l) => null, (r) => r)!.code, '1234');
    });

    test('validate nunca mapeia as falhas conhecidas da API', () async {
      /// Defeito: `insertValidation` não usa o `ApiMapper` e lança uma
      /// `Exception` genérica para qualquer status diferente de 202, então
      /// o `_mapApiFailure` de `validate` é código morto: toda falha vira
      /// `UnknownFailure`, mesmo `user_not_found_failure`,
      /// `code_previously_validated` e `max_attempts_exceeded`.
      Future<Failure> failing(int status, String? failure) async {
        harness.mockGeneratedValidate(
            status: status, body: apiFailureBody(status: status, failure: failure));
        final result = await harness.repository
            .validate(CodeValidation(id: 'I', code: '1'));
        return (result as Rejection).get();
      }

      expect(await failing(404, 'user_not_found_failure'), isA<UnknownFailure>());
      expect(
          await failing(409, 'validate_code_code_previously_validated_failure'),
          isA<UnknownFailure>());
      expect(
          await failing(
              429, 'validate_code_max_failed_attempts_exceeded_failure'),
          isA<UnknownFailure>());
      expect(await failing(400, null), isA<UnknownFailure>());
    });

    test('getDados2faAsync mapeia as falhas conhecidas da API', () async {
      Future<Failure> failing(int status, String? failure) async {
        harness.mockDados2fa('529',
            status: status, body: apiFailureBody(status: status, failure: failure));
        final result = await harness.repository.getDados2faAsync('529');
        return (result as Rejection).get();
      }

      expect(await failing(404, 'user_not_found_failure'),
          isA<RegistrationUserNotFoundFailure>());
      expect(
          await failing(409, 'validate_code_code_previously_validated_failure'),
          isA<RequestCodeAlreadyValidatedFailure>());
      expect(
          await failing(
              429, 'validate_code_max_failed_attempts_exceeded_failure'),
          isA<ValidateCodeMaxAttemptsExceededFailure>());
      expect(await failing(400, null), isA<UserUnkonwFailure>());
      expect(await failing(500, 'outra'), isA<UnknownFailure>());
    });

    test('validate com status inesperado (sem ApiFailure) é UnknownFailure',
        () async {
      harness.mockGeneratedValidate(status: 200, body: {});
      final result = await harness.repository
          .validate(CodeValidation(id: 'I', code: '1'));
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('getDados2faAsync sucesso e falhas', () async {
      harness.mockDados2fa('529', sms: [contact('s', '119')], registered: true);
      final ok = await harness.repository.getDados2faAsync('529', 1);
      expect(ok.fold((l) => null, (r) => r)!.smsContacts.single.value, '119');

      harness.mockDados2fa('529',
          status: 400, body: apiFailureBody(status: 400));
      final bad = await harness.repository.getDados2faAsync('529');
      expect((bad as Rejection).get(), isA<UserUnkonwFailure>());

      harness.mockDados2fa('529', status: 200, body: 'texto sem json');
      final broken = await harness.repository.getDados2faAsync('529');
      expect((broken as Rejection).get(), isA<UnknownFailure>());
    });

    test('validate2faAsync sucesso e falhas', () async {
      harness.mockValidate2fa(token: 'T');
      final ok = await harness.repository.validate2faAsync('K', '1');
      expect(ok.fold((l) => null, (r) => r)!.token, 'T');

      harness.mockValidate2fa(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      final notFound = await harness.repository.validate2faAsync('K', '1');
      expect((notFound as Rejection).get(),
          isA<RegistrationUserNotFoundFailure>());

      harness.mockValidate2fa(status: 200, body: '[1]');
      final broken = await harness.repository.validate2faAsync('K', '1');
      expect((broken as Rejection).get(), isA<UnknownFailure>());
    });

    test('request2faAsync sucesso e falhas', () async {
      harness.mockRequest2fa();
      expect(await harness.repository.request2faAsync('K', 's'),
          isA<Success<bool>>());

      harness.mockRequest2fa(status: 500, body: apiFailureBody());
      final err = await harness.repository.request2faAsync('K', 's');
      expect((err as Rejection).get(), isA<UnknownFailure>());

      harness.mockRequest2fa(status: 204, body: '');
      final noContent = await harness.repository.request2faAsync('K', 's');
      expect((noContent as Rejection).get(), isA<UnknownFailure>());
    });
  });
}

ChopperClient buildChopperClientFor(CodeValidationHarness harness) =>
    buildChopperClient(harness.http);
