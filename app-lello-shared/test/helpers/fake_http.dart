import 'dart:convert';

import 'package:chopper/chopper.dart' as chopper;
import 'package:essentials/essentials.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Servidor HTTP falso para as APIs chopper.
///
/// ```dart
/// fakeHttp.on('GET', '/comfort/partners', body: {'data': []});
/// final client = buildChopperClient(fakeHttp);
/// final api = ComfortApi.create(client);
/// ```
/// O `path` é comparado com o caminho da URL (sem query) por igualdade ou,
/// se terminar com `*`, por prefixo. Sem rota cadastrada responde 404 com
/// `{}`. Todas as requisições ficam em [requests].
class FakeHttp {
  final _routes = <_FakeRoute>[];
  final requests = <http.Request>[];

  void on(
    String method,
    String path, {
    int status = 200,
    Object? body = const <String, dynamic>{},
    Map<String, String> headers = const {'content-type': 'application/json'},
  }) {
    _routes.removeWhere((r) => r.method == method && r.path == path);
    _routes.add(_FakeRoute(method.toUpperCase(), path, status, body, headers));
  }

  /// Faz toda requisição responder [status] com [body].
  void failAll({int status = 500, Object? body = const {'message': 'erro'}}) {
    _routes.clear();
    on('*', '*', status: status, body: body);
  }

  void reset() {
    _routes.clear();
    requests.clear();
  }

  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    final path = request.url.path;
    for (final r in _routes.reversed) {
      if (r.matches(request.method, path)) {
        final body = r.body is String ? r.body as String : jsonEncode(r.body);
        return http.Response(body, r.status, headers: r.headers);
      }
    }
    return http.Response('{}', 404,
        headers: const {'content-type': 'application/json'});
  }

  http.Client get client => MockClient(_handle);
}

class _FakeRoute {
  _FakeRoute(this.method, this.path, this.status, this.body, this.headers);
  final String method;
  final String path;
  final int status;
  final Object? body;
  final Map<String, String> headers;

  bool matches(String m, String p) {
    if (method != '*' && method != m.toUpperCase()) return false;
    if (path == '*') return true;
    if (path.endsWith('*')) return p.startsWith(path.substring(0, path.length - 1));
    return p == path;
  }
}

/// ChopperClient apontando para [fakeHttp] (base url `http://localhost`),
/// com os mesmos conversores usados pelos apps.
chopper.ChopperClient buildChopperClient(FakeHttp fakeHttp,
        {String baseUrl = 'http://localhost'}) =>
    chopper.ChopperClient(
      client: fakeHttp.client,
      baseUrl: Uri.parse(baseUrl),
      converter: const chopper.JsonConverter(),
      errorConverter: ApiFailureConverter(),
    );
