import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:essentials/essentials.dart' show FlavorConfig;
import 'package:essentials/network/api_performace_monitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/network/authorization_header_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';

import '../helpers/firebase_mocks.dart';

class _FakeTokens extends Fake implements AccessTokenLocalDataSource {
  _FakeTokens({this.token, this.throws = false});
  final String? token;
  final bool throws;

  @override
  Future<AccessTokenModel?> select({required String role}) async {
    if (throws) throw Exception('sem token');
    return token == null ? null : (AccessTokenModel()..accessToken = token);
  }
}

class _FakeChain implements Chain<dynamic> {
  _FakeChain(this.request);

  @override
  final Request request;
  Request? forwarded;

  @override
  FutureOr<Response<dynamic>> proceed(Request request) async {
    forwarded = request;
    return Response<dynamic>(http.Response('ok', 200), 'ok');
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
    FlavorConfig.init();
    PackageInfo.setMockInitialValues(
      appName: 'morar',
      packageName: 'app.lello.morar',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  Request _request() => Request('GET', Uri.parse('/me'), Uri.parse('http://localhost'));

  test('adiciona os cabeçalhos padrão e o bearer', () async {
    final interceptor = AuthorizationHeaderInterceptor(
      dataSource: _FakeTokens(token: 'jwt-1'),
      monitor: ApiPerformaceMonitor(),
    );
    final chain = _FakeChain(_request());
    final response = await interceptor.intercept(chain);
    expect(response.statusCode, 200);
    final headers = chain.forwarded!.headers;
    expect(headers['Authorization'], 'Bearer jwt-1');
    expect(headers['app-version'], '9.9.9');
    expect(headers['X-Lello-Client-Type'], 'MORAR');
    expect(headers['Connection'], 'keep-alive');
    expect(headers['X-Lello-Flavor'], isNotEmpty);
    expect(headers['idEmpresa'], isNotEmpty);
  });

  test('sem token não envia Authorization', () async {
    final interceptor = AuthorizationHeaderInterceptor(
      dataSource: _FakeTokens(),
      monitor: ApiPerformaceMonitor(),
    );
    final chain = _FakeChain(_request());
    await interceptor.intercept(chain);
    expect(chain.forwarded!.headers.containsKey('Authorization'), isFalse);
    expect(chain.forwarded!.headers['app-version'], '9.9.9');
  });

  test('erro ao ler o token usa versão não identificada', () async {
    final interceptor = AuthorizationHeaderInterceptor(
      dataSource: _FakeTokens(throws: true),
      monitor: ApiPerformaceMonitor(),
    );
    final chain = _FakeChain(_request());
    await interceptor.intercept(chain);
    expect(chain.forwarded!.headers['app-version'], 'unidentified');
    expect(chain.forwarded!.headers.containsKey('Authorization'), isFalse);
  });
}
