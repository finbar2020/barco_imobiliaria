import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';
import 'package:shared_features/feature/registration/data/model/register_fcm_token_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_http.dart';
import '../code_validation/code_validation_support.dart';
import 'registration_support.dart';

void main() {
  late RegistrationHarness harness;

  setUp(() async {
    harness = await installRegistrationHarness();
  });

  Failure rejected(Try result) => (result as Rejection).get();

  group('RegistrationRemoteDataSourceImpl', () {
    late RegistrationRemoteDataSourceImpl dataSource;
    setUp(() {
      dataSource = RegistrationRemoteDataSourceImpl(
          api: RegistrationApi.create(buildChopperClient(harness.http)));
    });

    test('post envia o corpo, a query idEmpresa e mapeia a resposta', () async {
      harness.mockRegistration();
      final model = RegistrationModel(cpf: cpfDigitos, password: 'x');
      final result = await dataSource.post(model, 3);
      expect(result.name, 'Ana Silva');
      final request = harness.http.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/registration');
      expect(request.url.queryParameters['idEmpresa'], '3');
      expect(request.body, contains('"cpf":"$cpfDigitos"'));

      await dataSource.post(model);
      expect(harness.http.requests.last.url.queryParameters, isEmpty);
    });

    test('get busca o síndico pelo cpf', () async {
      harness.mockSindico(cpfDigitos);
      final result = await dataSource.get(cpfDigitos);
      expect(result.emails, ['ana@lello.com']);
      expect(harness.http.requests.single.url.path,
          '/registration/sindico/$cpfDigitos');
    });

    test('registerFcmToken e disableFcmToken', () async {
      harness.mockRegisterFcm();
      final model = RegisterFcmTokenModel.fromEntity(buildFcmToken())!;
      final registered = await dataSource.registerFcmToken(model);
      expect(registered.token, 'fcm-1');
      expect(harness.http.requests.single.url.path,
          '/dashboard/register_fcm_token');

      harness.mockDisableFcm();
      expect(await dataSource.disableFcmToken(model), isTrue);
      expect(harness.http.requests.last.method, 'PUT');
      expect(harness.http.requests.last.url.path,
          '/dashboard/disable_fcm_token');

      harness.mockDisableFcm(status: 500, body: apiFailureBody());
      expect(() => dataSource.disableFcmToken(model),
          throwsA(isA<ApiFailure>()));
    });

    test('erros da API lançam ApiFailure', () async {
      harness.mockSindico(cpfDigitos,
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      expect(() => dataSource.get(cpfDigitos), throwsA(isA<ApiFailure>()));
    });
  });

  group('RegistrationRepositoryImpl', () {
    test('post devolve o cadastro', () async {
      harness.mockRegistration();
      final result = await harness.repository
          .post(Registration(cpf: cpfDigitos, password: 'x', idEmpresa: 2));
      expect(result, isA<Success<Registration>>());
      expect(result.fold((l) => null, (r) => r)!.name, 'Ana Silva');
      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '2');
    });

    test('post mapeia as falhas conhecidas', () async {
      Future<Failure> failing(int status, String? failure) async {
        harness.mockRegistration(
            status: status, body: apiFailureBody(status: status, failure: failure));
        return rejected(await harness.repository
            .post(Registration(cpf: cpfDigitos, password: 'x')));
      }

      expect(await failing(404, 'user_not_found_failure'),
          isA<RegistrationUserNotFoundFailure>());
      expect(await failing(409, 'user_already_registerd_failure'),
          isA<RegistrationUserAlreadyRegisteredFailure>());
      expect(await failing(500, 'outra'), isA<UnknownFailure>());
    });

    test('post com resposta inválida registra no Crashlytics', () async {
      harness.mockRegistration(status: 200, body: 'nao-json');
      final result = await harness.repository
          .post(Registration(cpf: cpfDigitos, password: 'x'));
      expect(rejected(result), isA<UnknownFailure>());
    });

    test('post com cpf curto ou nulo devolve a falha', () async {
      /// Corrigido: o prefixo do cpf enviado ao Crashlytics tolera cpf nulo
      /// ou menor que 5 caracteres, então o `catch` não lança mais e a
      /// falha é devolvida normalmente.
      harness.mockRegistration(status: 200, body: 'nao-json');
      expect(
          rejected(await harness.repository
              .post(Registration(cpf: '123', password: 'x'))),
          isA<UnknownFailure>());
      expect(rejected(await harness.repository.post(Registration(password: 'x'))),
          isA<UnknownFailure>());
    });

    test('get devolve o usuário e mapeia falhas', () async {
      harness.mockSindico(cpfDigitos);
      final ok = await harness.repository.get(cpfDigitos);
      expect(ok.fold((l) => null, (r) => r)!.name, 'Ana Silva');

      harness.mockSindico(cpfDigitos,
          status: 409,
          body: apiFailureBody(
              status: 409, failure: 'user_already_registerd_failure'));
      expect(rejected(await harness.repository.get(cpfDigitos)),
          isA<RegistrationUserAlreadyRegisteredFailure>());

      harness.mockSindico(cpfDigitos, status: 200, body: '[]');
      expect(rejected(await harness.repository.get(cpfDigitos)),
          isA<UnknownFailure>());
    });

    test('registerFcmToken devolve o token e mapeia falhas', () async {
      harness.mockRegisterFcm();
      final ok = await harness.repository.registerFcmToken(buildFcmToken());
      expect(ok.fold((l) => null, (r) => r)!.reference, ['R1', 'R2']);

      harness.mockRegisterFcm(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      expect(rejected(await harness.repository.registerFcmToken(buildFcmToken())),
          isA<RegistrationUserNotFoundFailure>());

      harness.mockRegisterFcm(status: 200, body: 'x');
      expect(rejected(await harness.repository.registerFcmToken(buildFcmToken())),
          isA<UnknownFailure>());
    });

    test('disableFcmToken devolve true e mapeia as falhas conhecidas',
        () async {
      harness.mockDisableFcm();
      expect(await harness.repository.disableFcmToken(buildFcmToken()),
          isA<Success<bool>>());

      /// Corrigido: `disableFcmToken` do data source propaga o `ApiFailure`
      /// da resposta, então `_mapApiFailure` é alcançado e
      /// `user_not_found_failure` vira `RegistrationUserNotFoundFailure`.
      harness.mockDisableFcm(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      expect(rejected(await harness.repository.disableFcmToken(buildFcmToken())),
          isA<RegistrationUserNotFoundFailure>());

      harness.mockDisableFcm(status: 500, body: 'x');
      expect(rejected(await harness.repository.disableFcmToken(buildFcmToken())),
          isA<UnknownFailure>());
    });
  });
}
