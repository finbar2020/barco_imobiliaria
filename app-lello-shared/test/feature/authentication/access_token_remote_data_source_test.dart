import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_request_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'authentication_support.dart';

void main() {
  late AuthenticationHarness harness;

  setUp(() {
    harness = AuthenticationHarness();
  });

  final request = AccessTokenRequestModel(username: '123', password: 'p');

  test('post envia as credenciais e devolve o modelo', () async {
    harness.mockToken();

    final model = await harness.remoteDataSource.post(request);

    expect(model!.accessToken, 'jwt-1');
    final sent = harness.http.requests.single;
    expect(sent.method, 'POST');
    expect(sent.url.path, '/tokenrbac');
    expect(jsonDecode(sent.body), {'username': '123', 'password': 'p'});
  });

  test('post com erro lança o ApiFailure convertido', () async {
    harness.mockToken(
        status: 401,
        body: apiFailureBody(
            status: 401, failure: AuthenticationApi.invalid_credentials_failure));

    await expectLater(
      harness.remoteDataSource.post(request),
      throwsA(isA<ApiFailure>().having((f) => f.failure, 'failure',
          AuthenticationApi.invalid_credentials_failure)),
    );
  });

  test('postInvite usa a rota do convite', () async {
    harness.mockInvite(body: tokenJson(accessToken: 'convite'));

    final model = await harness.remoteDataSource.postInvite(request);

    expect(model!.accessToken, 'convite');
    expect(harness.requestedPaths, ['/tokenConvite']);
  });

  test('postInvite com erro lança', () async {
    harness.mockInvite(status: 500, body: apiFailureBody());
    await expectLater(
        harness.remoteDataSource.postInvite(request), throwsA(isA<ApiFailure>()));
  });

  test('switchRoles usa a referência na rota', () async {
    harness.mockSwitch('CONDO-1', body: tokenJson(accessToken: 'trocado'));

    final model = await harness.remoteDataSource.switchRoles('CONDO-1');

    expect(model!.accessToken, 'trocado');
    expect(harness.requestedPaths, ['/token/CONDO-1']);
  });

  test('switchRoles com erro lança', () async {
    harness.mockSwitch('X', status: 403, body: apiFailureBody(status: 403));
    await expectLater(harness.remoteDataSource.switchRoles('X'),
        throwsA(isA<ApiFailure>()));
  });

  test('deleteAccount devolve vazio no sucesso e lança no erro', () async {
    harness.mockDelete();
    expect(await harness.remoteDataSource.deleteAccount(), '');
    expect(harness.http.requests.single.method, 'DELETE');
    expect(harness.requestedPaths, ['/me/deleteAccount']);

    harness.mockDelete(status: 500, body: apiFailureBody());
    await expectLater(
        harness.remoteDataSource.deleteAccount(), throwsA(isA<ApiFailure>()));
  });

  test('erro sem corpo JSON lança o erro bruto', () async {
    harness.http.on('DELETE', '/me/deleteAccount',
        status: 500, body: 'texto', headers: const {'content-type': 'text/plain'});
    await expectLater(
        harness.remoteDataSource.deleteAccount(), throwsA(isNotNull));
  });
}
