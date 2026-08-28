import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'reset_password_support.dart';

void main() {
  late ResetPasswordHarness harness;

  setUp(() async {
    harness = await installResetPasswordHarness();
  });

  group('PasswordResetRemoteDataSourceImpl', () {
    test('post envia o modelo em /change_password e devolve o próprio modelo',
        () async {
      harness.mockChangePassword();
      final model = PasswordResetModel.fromEntity(buildReset())!;

      final result = await harness.repository.dataSource.post(model);

      expect(result, same(model));
      final request = harness.http.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/change_password');
      expect(jsonDecode(request.body),
          {'password': 'Senha123', 'cpf': cpfDigitos, 'token': 'TOKEN-OK'});
    });

    test('erro da API lança o ApiFailure', () async {
      harness.mockChangePassword(status: 400, body: apiFailureBody(status: 400));

      await expectLater(
          harness.repository.dataSource
              .post(PasswordResetModel.fromEntity(buildReset())!),
          throwsA(isA<ApiFailure>()));
    });
  });

  group('PasswordResetRepositoryImpl', () {
    test('post devolve a entidade no sucesso', () async {
      harness.mockChangePassword();

      final result = await harness.repository.post(buildReset());

      expect(result.fold((_) => null, (r) => r.cpf), cpfDigitos);
    });

    test('post com erro da API registra no Crashlytics e rejeita', () async {
      harness.mockChangePassword(status: 500, body: apiFailureBody());

      final result = await harness.repository.post(buildReset());

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('post2fa monta o modelo a partir dos parâmetros', () async {
      harness.mockChangePassword();

      final result = await harness.repository.post2fa(
          ResetPassword2faParams(cpf: cpfDigitos, password: 'p', token: 't'));

      expect(result.fold((_) => null, (r) => r.password), 'p');
      expect(jsonDecode(harness.http.requests.single.body),
          {'password': 'p', 'cpf': cpfDigitos, 'token': 't'});
    });

    test('post2fa com exceção rejeita', () async {
      final repository = PasswordResetRepositoryImpl(
          dataSource: ThrowingPasswordResetDataSource());

      final result = await repository.post2fa(
          ResetPassword2faParams(cpf: cpfDigitos, password: 'p', token: 't'));

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    /// Corrigido: o prefixo do CPF enviado ao Crashlytics passa por um helper
    /// tolerante a valores curtos ou nulos, então o `catch` sempre devolve a
    /// rejeição.
    test('erro com CPF curto ou nulo rejeita em vez de lançar', () async {
      final repository = PasswordResetRepositoryImpl(
          dataSource: ThrowingPasswordResetDataSource());

      expect(((await repository.post(buildReset(cpf: '123'))) as Rejection)
          .get(), isA<UnknownFailure>());
      expect(((await repository.post(buildReset(cpf: null))) as Rejection)
          .get(), isA<UnknownFailure>());
      expect(
          ((await repository.post2fa(ResetPassword2faParams(
                  cpf: '12', password: 'p', token: 't'))) as Rejection)
              .get(),
          isA<UnknownFailure>());
      expect(
          ((await repository.post2fa(ResetPassword2faParams(
                  cpf: null, password: 'p', token: 't'))) as Rejection)
              .get(),
          isA<UnknownFailure>());
    });
  });

  group('use cases', () {
    test('ResetPasswordImpl valida cpf e senha antes de chamar o repositório',
        () async {
      harness.mockChangePassword();
      final useCase = ResetPasswordImpl(repository: harness.repository);

      expect(((await useCase.call(buildReset(cpf: null))) as Rejection).get(),
          isA<InvalidCpfFailure>());
      expect(((await useCase.call(buildReset(cpf: ''))) as Rejection).get(),
          isA<InvalidCpfFailure>());
      expect(
          ((await useCase.call(buildReset(password: null))) as Rejection).get(),
          isA<InvalidPasswordFailure>());
      expect(((await useCase.call(buildReset(password: ''))) as Rejection).get(),
          isA<InvalidPasswordFailure>());
      expect(harness.http.requests, isEmpty);

      final ok = await useCase.call(buildReset());
      expect(ok, isA<Success<PasswordReset>>());
      expect(harness.requestedPaths, ['/change_password']);
    });

    test('ResetPassword2faImpl valida cpf e senha antes de chamar o repositório',
        () async {
      harness.mockChangePassword();
      final useCase = ResetPassword2faImpl(repository: harness.repository);

      Future<Failure> failureFor(String? cpf, String? password) async =>
          ((await useCase.call(ResetPassword2faParams(
                  cpf: cpf, password: password, token: 't'))) as Rejection)
              .get();

      expect(await failureFor(null, 'p'), isA<InvalidResetPassword2faFailure>());
      expect(await failureFor('', 'p'), isA<InvalidResetPassword2faFailure>());
      expect(await failureFor(cpfDigitos, null),
          isA<InvalidResetPassword2faFailure>());
      expect(await failureFor(cpfDigitos, ''),
          isA<InvalidResetPassword2faFailure>());
      expect(harness.http.requests, isEmpty);

      final ok = await useCase.call(
          ResetPassword2faParams(cpf: cpfDigitos, password: 'p', token: 't'));
      expect(ok, isA<Success<PasswordReset>>());
    });
  });
}
