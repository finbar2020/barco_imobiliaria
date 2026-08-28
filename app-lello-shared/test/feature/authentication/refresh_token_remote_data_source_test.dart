import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/model/refresh_token_request_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'authentication_support.dart';

void main() {
  late LocalHttpServer server;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() async {
    server = await LocalHttpServer.start();
  });

  final request = RefreshTokenRequestModel(token: 'jwt-1', refreshToken: 'r1');

  RefreshTokenRemoteDataSourceImpl build([String? baseUrl]) =>
      RefreshTokenRemoteDataSourceImpl(
          baseUrl: Uri.parse(baseUrl ?? server.baseUrl));

  test('posta o token e o refresh em /refreshToken e devolve o modelo',
      () async {
    server.respondJson(tokenJson(accessToken: 'jwt-2'));

    final model = await withRealHttp(() => build().refreshToken(request));

    expect(model!.accessToken, 'jwt-2');
    final received = server.requests.single;
    expect(received.method, 'POST');
    expect(received.uri.path, '/refreshToken');
    expect(jsonDecode(server.bodies.single),
        {'token': 'jwt-1', 'refresh_token': 'r1'});
  });

  test('resposta de erro com JSON vira ApiFailure', () async {
    server.respondJson(
        apiFailureBody(
            status: 403,
            failure: RefreshTokenRemoteDataSourceImpl.bad_refresh_token_failure),
        status: 403);

    await expectLater(
      withRealHttp(() => build().refreshToken(request)),
      throwsA(isA<ApiFailure>().having((f) => f.failure, 'failure',
          RefreshTokenRemoteDataSourceImpl.bad_refresh_token_failure)),
    );
  });

  test('resposta de erro sem JSON registra no Crashlytics e relança o DioException',
      () async {
    server.respondText('indisponível', status: 502);

    await expectLater(withRealHttp(() => build().refreshToken(request)),
        throwsA(isA<dio.DioException>()));
  });

  test('sem conexão relança o DioException', () async {
    final closed = await LocalHttpServer.start();
    final url = closed.baseUrl;
    await closed.server.close(force: true);

    await expectLater(withRealHttp(() => build(url).refreshToken(request)),
        throwsA(isA<dio.DioException>()));
  });

  test('sucesso sem status 200 lança exceção genérica', () async {
    server.handler = (req) async {
      req.response.statusCode = 204;
      await req.response.close();
    };

    await expectLater(withRealHttp(() => build().refreshToken(request)),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem',
            contains('Erro ao atualizar o token'))));
  });
}
