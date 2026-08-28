import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'registration_support.dart';

void main() {
  late RegistrationHarness harness;

  setUp(() async {
    harness = await installRegistrationHarness();
  });

  Failure rejected(Try result) => (result as Rejection).get();

  group('RegisterImpl', () {
    test('valida cpf e senha', () async {
      final useCase = RegisterImpl(repository: harness.repository);
      final semCpf = rejected(await useCase(Registration(password: 'x')));
      expect(semCpf, isA<RegistrationMissingRequiredDataFailure>());
      expect((semCpf as RegistrationMissingRequiredDataFailure).field, 'cpf');
      expect(
          (rejected(await useCase(Registration(cpf: '', password: 'x')))
                  as RegistrationMissingRequiredDataFailure)
              .field,
          'cpf');
      expect(
          (rejected(await useCase(Registration(cpf: '1')))
                  as RegistrationMissingRequiredDataFailure)
              .field,
          'password');
      expect(
          (rejected(await useCase(Registration(cpf: '1', password: '')))
                  as RegistrationMissingRequiredDataFailure)
              .field,
          'password');
      expect(harness.http.requests, isEmpty);
    });

    test('envia ao repositório', () async {
      harness.mockRegistration();
      final useCase = RegisterImpl(repository: harness.repository);
      final result = await useCase(Registration(cpf: cpfDigitos, password: 'x'));
      expect(result, isA<Success<Registration>>());
    });
  });

  group('GetMyUserImpl', () {
    test('cpf vazio é inválido', () async {
      final useCase = GetMyUserImpl(repository: harness.repository);
      expect(rejected(await useCase('')), isA<InvalidParamFailure>());
    });

    test('remove a máscara antes de consultar', () async {
      harness.mockSindico(cpfDigitos);
      final useCase = GetMyUserImpl(repository: harness.repository);
      final result = await useCase(cpfValido);
      expect(result.fold((l) => null, (r) => r)!.cpf, cpfDigitos);
      expect(harness.http.requests.single.url.path,
          '/registration/sindico/$cpfDigitos');
    });
  });

  group('RegisterFcmImpl', () {
    test('persiste o token', () async {
      harness.mockRegisterFcm();
      final useCase = RegisterFcmImpl(repository: harness.repository);
      final result =
          await useCase(RegisterFcmTokenParams(fcmToken: buildFcmToken()));
      expect(result.fold((l) => null, (r) => r)!.token, 'fcm-1');
    });

    test('propaga a falha do repositório', () async {
      harness.mockRegisterFcm(status: 500, body: 'x');
      final useCase = RegisterFcmImpl(repository: harness.repository);
      expect(
          rejected(await useCase(RegisterFcmTokenParams(fcmToken: buildFcmToken()))),
          isA<UnknownFailure>());
    });
  });

  group('DisableFcmImpl', () {
    test('usa o refresh token salvo e desliga o token', () async {
      harness.mockDisableFcm();
      final useCase = DisableFcmImpl(
          repository: harness.repository,
          accessTokenRepository: FakeAccessTokenRepository());
      final result = await useCase();
      expect(result, isA<Success<bool>>());
      final body = harness.http.requests.single.body;
      expect(body, contains('"refresh_token":"refresh-1"'));
      // Fora de Android/iOS o deviceId fica vazio.
      expect(body, contains('"device_id":""'));
    });

    test('sem token salvo envia refresh nulo e propaga a falha', () async {
      harness.mockDisableFcm(status: 500, body: 'x');
      final useCase = DisableFcmImpl(
          repository: harness.repository,
          accessTokenRepository: FakeAccessTokenRepository()..fail = true);
      expect(rejected(await useCase()), isA<UnknownFailure>());
      expect(harness.http.requests.single.body, contains('"refresh_token":null'));
    });
  });
}
