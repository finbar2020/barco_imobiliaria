import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Request, Response;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_features/core/network/refresh_authenticator_interceptor.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

class _FakeTokens extends Fake implements AccessTokenLocalDataSource {
  _FakeTokens({this.token, this.throws = false});
  String? token;
  bool throws;
  int selects = 0;

  @override
  Future<AccessTokenModel?> select({required String role}) async {
    selects++;
    if (throws) throw StateError('sem cache');
    return token == null ? null : (AccessTokenModel()..accessToken = token);
  }
}

class _FakeRefreshToken extends Fake implements RefreshToken {
  bool success = true;
  int calls = 0;

  /// Quando definido, a chamada só termina quando o completer completar.
  Completer<Try<AccessToken?>>? pending;

  @override
  Future<Try<AccessToken?>> call() async {
    calls++;
    if (pending != null) return pending!.future;
    return success
        ? Success(AccessToken()..accessToken = 'novo')
        : Rejection(UnknownFailure('refresh falhou'));
  }
}

Request _request({Map<String, String> headers = const {}}) => Request(
    'GET', Uri.parse('/me'), Uri.parse('http://localhost'),
    headers: headers);

Response<dynamic> _response(int status) =>
    Response<dynamic>(http.Response('', status), null);

void main() {
  late _FakeTokens tokens;
  late _FakeRefreshToken refresh;
  late RefreshAuthenticatorInterceptor interceptor;

  setUp(() {
    tokens = _FakeTokens(token: 'jwt-2');
    refresh = _FakeRefreshToken();
    interceptor =
        RefreshAuthenticatorInterceptor(dataSource: tokens, refreshToken: refresh);
  });

  test('só reage a 401', () async {
    expect(await interceptor.authenticate(_request(), _response(200)), isNull);
    expect(await interceptor.authenticate(_request(), _response(403)), isNull);
    expect(refresh.calls, 0);
  });

  test('401 já reenviado não tenta de novo', () async {
    final result = await interceptor.authenticate(
        _request(headers: {RefreshAuthenticatorInterceptor.retryCountHeader: '1'}),
        _response(401));

    expect(result, isNull);
    expect(refresh.calls, 0);
  });

  test('401 renova o token e reenvia com o bearer e o contador', () async {
    final result =
        await interceptor.authenticate(_request(), _response(401), _request());

    expect(refresh.calls, 1);
    expect(result!.headers['Authorization'], 'Bearer jwt-2');
    expect(result.headers[RefreshAuthenticatorInterceptor.retryCountHeader], '1');
    expect(result.url.path, '/me');
  });

  test('token já com Bearer não duplica o prefixo', () async {
    tokens.token = 'Bearer jwt-3';

    final result = await interceptor.authenticate(_request(), _response(401));

    expect(result!.headers['Authorization'], 'Bearer jwt-3');
  });

  test('renovação com falha devolve nulo', () async {
    refresh.success = false;

    expect(await interceptor.authenticate(_request(), _response(401)), isNull);
    expect(tokens.selects, 0);
  });

  test('sem token no cache depois de renovar devolve nulo', () async {
    tokens.token = null;

    expect(await interceptor.authenticate(_request(), _response(401)), isNull);
    expect(refresh.calls, 1);
  });

  test('erro ao ler o cache é tratado e libera novas renovações', () async {
    tokens.throws = true;
    expect(await interceptor.authenticate(_request(), _response(401)), isNull);

    tokens.throws = false;
    final result = await interceptor.authenticate(_request(), _response(401));
    expect(result, isNotNull);
    expect(refresh.calls, 2);
  });

  test('pedidos simultâneos esperam a mesma renovação', () async {
    final completer = Completer<Try<AccessToken?>>();
    refresh.pending = completer;

    final first = interceptor.authenticate(_request(), _response(401));
    await Future<void>.delayed(Duration.zero);
    final second = interceptor.authenticate(_request(), _response(401));
    await Future<void>.delayed(Duration.zero);
    expect(refresh.calls, 1);

    completer.complete(Success(AccessToken()..accessToken = 'novo'));
    final results =
        await Future.wait([Future.value(first), Future.value(second)]);

    expect(results.every((r) => r?.headers['Authorization'] == 'Bearer jwt-2'),
        isTrue);
    expect(refresh.calls, 1);
  });

  test('callbacks de resultado são nulos', () {
    expect(interceptor.onAuthenticationFailed, isNull);
    expect(interceptor.onAuthenticationSuccessful, isNull);
  });
}
