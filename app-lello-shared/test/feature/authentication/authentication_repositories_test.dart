import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'authentication_support.dart';

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('AccessTokenRepositoryImpl', () {
    late AuthenticationHarness harness;
    late InMemoryAccessTokenLocalDataSource local;

    setUp(() {
      local = InMemoryAccessTokenLocalDataSource();
      harness = AuthenticationHarness(local: local);
    });

    final credentials =
        Credentials(username: '529.982.247-25', password: 'senha');

    test('select devolve a entidade do cache e falha vira rejeição', () async {
      local.tokens[''] = AccessTokenModel.fromJson(tokenJson());

      final result = await harness.repository.select();
      expect(result, isA<Success<AccessToken?>>());
      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-1');

      final byRole = await harness.repository.select(role: 'X');
      expect(byRole.fold((_) => 'erro', (t) => t), isNull);

      local.throwOnSelect = true;
      final failed = await harness.repository.select();
      expect(failed, isA<Rejection>());
      expect((failed as Rejection).get(), isA<UnknownFailure>());
    });

    test('save persiste a entidade convertida e falha vira rejeição',
        () async {
      final result = await harness.repository.save(buildToken(), role: 'R');

      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
      expect(local.savedRoles, ['R']);
      expect(local.tokens['R']!.refreshToken, 'refresh-1');

      final nulo = await harness.repository.save(null);
      expect(nulo.fold((_) => 'erro', (t) => t), isNull);
      expect(local.tokens, isEmpty);

      local.throwOnSave = true;
      expect(await harness.repository.save(buildToken()), isA<Rejection>());
    });

    test('post envia só os dígitos do usuário e devolve o token', () async {
      harness.mockToken();

      final result = await harness.repository.post(credentials);

      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
      expect(harness.http.requests.single.body, contains('"52998224725"'));
    });

    test('post mapeia cada falha conhecida da API', () async {
      Future<Failure> failureFor(int status, String? failure) async {
        harness.mockToken(
            status: status,
            body: apiFailureBody(status: status, failure: failure));
        final result = await harness.repository.post(credentials);
        return (result as Rejection).get();
      }

      expect(await failureFor(403, null), isA<ForbidenTokenFailure>());
      expect(
          await failureFor(401, AuthenticationApi.invalid_credentials_failure),
          isA<InvalidCredentialsFailure>());
      expect(
          await failureFor(401, AuthenticationApi.unknow_credentials_failure),
          isA<UnknowCredentialsFailure>());
      expect(
          await failureFor(
              401, AuthenticationApi.not_registered_credentials_failure),
          isA<NotRegisteredCredentialsFailure>());
      expect(
          await failureFor(
              401, AuthenticationApi.no_role_for_credentials_failure),
          isA<NoRoleForCredentialsFailure>());
      final unknown = await failureFor(500, 'outra');
      expect(unknown, isA<UnknownFailure>());
      expect(unknown.error, isA<ApiFailure>());
    });

    test('falha conhecida usa o título, o detalhe ou o padrão como código',
        () async {
      Future<String?> codeFor(ApiFailure failure) async {
        final repository = AccessTokenRepositoryImpl(
            remoteDataSource: ApiFailureAccessTokenRemoteDataSource(failure),
            dataSource: local);
        final result = await repository.post(credentials);
        return (result as Rejection).get().code;
      }

      expect(await codeFor(buildApiFailure(status: 403, title: 'Proibido')),
          'Proibido');
      expect(
          await codeFor(buildApiFailure(status: 403)..detail = 'detalhe'),
          'detalhe');
      expect(await codeFor(buildApiFailure(status: 403)),
          'forbiden_token_failure');
      expect(
          await codeFor(buildApiFailure(
              failure: AuthenticationApi.invalid_credentials_failure)),
          'invalid_credentials_failure');
      expect(
          await codeFor(buildApiFailure(
              failure: AuthenticationApi.unknow_credentials_failure)),
          'unknow_credentials_failure');
      expect(
          await codeFor(buildApiFailure(
              failure: AuthenticationApi.not_registered_credentials_failure)),
          'not_registered_credentials_failure');
      expect(
          await codeFor(buildApiFailure(
              failure: AuthenticationApi.no_role_for_credentials_failure)),
          'no_role_for_credentials_failure');
    });

    test('post com exceção genérica devolve UnknownFailure', () async {
      final repository = AccessTokenRepositoryImpl(
          remoteDataSource: ThrowingAccessTokenRemoteDataSource(),
          dataSource: local);

      final result = await repository.post(credentials);

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    /// Corrigido: o prefixo do usuário enviado ao Crashlytics é calculado com
    /// um helper tolerante a valores curtos, então o `catch` nunca lança e a
    /// chamada devolve a rejeição normalmente.
    test('post com usuário curto e erro genérico devolve rejeição', () async {
      final repository = AccessTokenRepositoryImpl(
          remoteDataSource: ThrowingAccessTokenRemoteDataSource(),
          dataSource: local);

      final generico =
          await repository.post(Credentials(username: '123', password: 'p'));
      expect((generico as Rejection).get(), isA<UnknownFailure>());

      // Mesmo caminho pelo `on ApiFailure` que cai em UnknownFailure.
      final daApi = await AccessTokenRepositoryImpl(
              remoteDataSource: ApiFailureAccessTokenRemoteDataSource(
                  buildApiFailure(status: 500, failure: 'outra')),
              dataSource: local)
          .post(Credentials(username: '12', password: 'p'));
      expect((daApi as Rejection).get(), isA<UnknownFailure>());
    });

    test('postInvite devolve o token, mapeia falhas e cobre exceção genérica',
        () async {
      harness.mockInvite();
      final ok = await harness.repository.postInvite(credentials);
      expect(ok.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
      // O convite envia o usuário como veio (sem limpar a máscara).
      expect(harness.http.requests.single.body, contains('529.982.247-25'));

      harness.mockInvite(
          status: 401,
          body: apiFailureBody(
              status: 401,
              failure: AuthenticationApi.invalid_credentials_failure));
      final invalid = await harness.repository.postInvite(credentials);
      expect((invalid as Rejection).get(), isA<InvalidCredentialsFailure>());

      harness.mockInvite(status: 500, body: apiFailureBody());
      final unknown = await harness.repository.postInvite(credentials);
      expect((unknown as Rejection).get(), isA<UnknownFailure>());

      final throwing = AccessTokenRepositoryImpl(
          remoteDataSource: ThrowingAccessTokenRemoteDataSource(),
          dataSource: local);
      final generic = await throwing.postInvite(credentials);
      expect((generic as Rejection).get(), isA<UnknownFailure>());
    });

    test('switchRoles devolve o token, mapeia falhas e cobre exceção genérica',
        () async {
      harness.mockSwitch('C1', body: tokenJson(accessToken: 'novo'));
      final ok = await harness.repository.switchRoles('C1');
      expect(ok.fold((_) => null, (t) => t!.accessToken), 'novo');

      harness.mockSwitch('C1', status: 403, body: apiFailureBody(status: 403));
      final forbidden = await harness.repository.switchRoles('C1');
      expect((forbidden as Rejection).get(), isA<ForbidenTokenFailure>());

      final throwing = AccessTokenRepositoryImpl(
          remoteDataSource: ThrowingAccessTokenRemoteDataSource(),
          dataSource: local);
      final generic = await throwing.switchRoles('C1');
      expect((generic as Rejection).get(), isA<UnknownFailure>());
    });

    test('clear apaga o cache e falha vira rejeição', () async {
      local.tokens['R'] = AccessTokenModel.fromJson(tokenJson());

      final result = await harness.repository.clear();

      expect(result, isA<Success<Nothing>>());
      expect(local.tokens, isEmpty);

      local.throwOnSave = true;
      expect(await harness.repository.clear(), isA<Rejection>());
    });

    test('deleteAccount devolve sucesso ou rejeição', () async {
      harness.mockDelete();
      final ok = await harness.repository.deleteAccount();
      expect(ok.fold((_) => null, (r) => r), '');

      harness.mockDelete(status: 500, body: apiFailureBody());
      final failed = await harness.repository.deleteAccount();
      expect((failed as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('RefreshTokenRepositoryImpl', () {
    late InMemoryAccessTokenLocalDataSource local;
    late FakeRefreshTokenRemoteDataSource remote;
    late RefreshTokenRepositoryImpl repository;

    setUp(() {
      local = InMemoryAccessTokenLocalDataSource();
      remote = FakeRefreshTokenRemoteDataSource();
      repository =
          RefreshTokenRepositoryImpl(remoteDataSource: remote, dataSource: local);
    });

    test('select e save delegam ao cache e falhas viram rejeição', () async {
      local.tokens[''] = AccessTokenModel.fromJson(tokenJson());
      final selected = await repository.select();
      expect(selected.fold((_) => null, (t) => t!.accessToken), 'jwt-1');

      final saved = await repository.save(buildToken(), role: 'R');
      expect(saved.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
      expect(local.tokens['R'], isNotNull);

      local.throwOnSelect = true;
      local.throwOnSave = true;
      expect(await repository.select(), isA<Rejection>());
      expect(await repository.save(buildToken()), isA<Rejection>());
    });

    test('refreshToken envia o token atual e devolve o novo', () async {
      local.tokens[''] = AccessTokenModel.fromJson(tokenJson());

      final result = await repository.refreshToken();

      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-2');
      expect(remote.requests.single.token, 'jwt-1');
      expect(remote.requests.single.refreshToken, 'refresh-1');
    });

    test('sem token no cache rejeita com UnknownFailure', () async {
      final result = await repository.refreshToken();
      expect((result as Rejection).get(), isA<UnknownFailure>());
      expect(remote.requests, isEmpty);
    });

    test('sem refresh token rejeita com BadRefreshTokenFailure', () async {
      local.tokens[''] =
          AccessTokenModel.fromJson(tokenJson(refreshToken: null));

      final result = await repository.refreshToken();

      final failure = (result as Rejection).get();
      expect(failure, isA<BadRefreshTokenFailure>());
      expect(failure.code, 'no_refresh_token');
    });

    test('ApiFailure de refresh inválido ou 403 vira BadRefreshTokenFailure',
        () async {
      local.tokens[''] = AccessTokenModel.fromJson(tokenJson());

      remote.error = buildApiFailure(
          failure: RefreshTokenRemoteDataSourceImpl.bad_refresh_token_failure,
          title: 'Inválido');
      var result = await repository.refreshToken();
      var failure = (result as Rejection).get();
      expect(failure, isA<BadRefreshTokenFailure>());
      expect(failure.code, 'Inválido');

      remote.error = buildApiFailure(status: 403);
      result = await repository.refreshToken();
      failure = (result as Rejection).get();
      expect(failure, isA<BadRefreshTokenFailure>());
      expect(failure.code, 'bad_refresh_token_failure');

      remote.error = buildApiFailure(status: 500);
      result = await repository.refreshToken();
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('exceção genérica vira UnknownFailure', () async {
      local.tokens[''] = AccessTokenModel.fromJson(tokenJson());
      remote.error = StateError('boom');

      final result = await repository.refreshToken();

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('clear apaga o cache e falha vira rejeição', () async {
      local.tokens['R'] = AccessTokenModel.fromJson(tokenJson());
      expect(await repository.clear(), isA<Success<Nothing>>());
      expect(local.tokens, isEmpty);

      local.throwOnSave = true;
      expect(await repository.clear(), isA<Rejection>());
    });
  });
}
