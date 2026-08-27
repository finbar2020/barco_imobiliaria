import 'package:chopper/chopper.dart' hide HttpMethod;
import 'package:essentials/network/api_performace_monitor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../helpers/firebase_mocks.dart';

class _FakeHttpMetric extends HttpMetricPlatform {
  _FakeHttpMetric(this.url, this.method, {this.failOnStop = false});
  final String url;
  final HttpMethod method;
  final bool failOnStop;
  bool started = false;
  bool stopped = false;
  int? _requestPayloadSize;
  int? _responsePayloadSize;
  String? _responseContentType;
  int? _httpResponseCode;

  @override
  int? get requestPayloadSize => _requestPayloadSize;
  @override
  set requestPayloadSize(int? v) => _requestPayloadSize = v;
  @override
  int? get responsePayloadSize => _responsePayloadSize;
  @override
  set responsePayloadSize(int? v) => _responsePayloadSize = v;
  @override
  String? get responseContentType => _responseContentType;
  @override
  set responseContentType(String? v) => _responseContentType = v;
  @override
  int? get httpResponseCode => _httpResponseCode;
  @override
  set httpResponseCode(int? v) => _httpResponseCode = v;

  @override
  Future<void> start() async => started = true;

  @override
  Future<void> stop() async {
    if (failOnStop) throw StateError('falha ao parar');
    stopped = true;
  }
}

class _FakePerformance extends FirebasePerformancePlatform {
  final metrics = <_FakeHttpMetric>[];
  bool failOnCreate = false;
  bool failOnStop = false;

  @override
  FirebasePerformancePlatform delegateFor({required FirebaseApp app}) => this;

  @override
  Future<bool> isPerformanceCollectionEnabled() async => true;

  @override
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {}

  @override
  HttpMetricPlatform newHttpMetric(String url, HttpMethod httpMethod) {
    if (failOnCreate) throw StateError('sem performance');
    final metric = _FakeHttpMetric(url, httpMethod, failOnStop: failOnStop);
    metrics.add(metric);
    return metric;
  }
}

Request _request(String method, {int? contentLength}) {
  final r = Request(method, Uri.parse('/users/1/'), Uri.parse('http://api.local'));
  if (contentLength != null) r.contentLength = contentLength;
  return r;
}

Response<dynamic> _response(String? uuid,
    {int status = 200, String body = 'corpo', Map<String, String>? headers}) {
  final baseRequest = http.Request('GET', Uri.parse('http://api.local/users/1'));
  if (uuid != null) baseRequest.headers['custom-uuid'] = uuid;
  return Response<dynamic>(
    http.Response(body, status,
        request: baseRequest,
        headers: headers ?? {'Content-Type': 'application/json'}),
    body,
  );
}

void main() {
  late _FakePerformance performance;

  setUpAll(() async {
    await setUpFakeFirebase();
    performance = _FakePerformance();
    FirebasePerformancePlatform.instance = performance;
  });

  setUp(() {
    performance.metrics.clear();
    performance.failOnCreate = false;
    performance.failOnStop = false;
  });

  test('start cria a métrica, inicia e devolve o header custom-uuid', () async {
    final monitor = ApiPerformaceMonitor();
    final headers = await monitor.start(_request('GET', contentLength: 12), {'a': 'b'});
    expect(headers['a'], 'b');
    expect(headers['custom-uuid'], isNotEmpty);
    expect(performance.metrics, hasLength(1));
    final metric = performance.metrics.single;
    expect(metric.started, isTrue);
    expect(metric.url, 'http://api.local/users/1/');
    expect(metric.requestPayloadSize, 12);
  });

  /// Corrigido: o método é comparado pelo nome do enum em maiúsculas, então
  /// cada verbo HTTP cai no `HttpMethod` correspondente.
  test('método HTTP é mapeado para o HttpMethod correspondente', () async {
    final esperados = {
      'GET': HttpMethod.Get,
      'POST': HttpMethod.Post,
      'PUT': HttpMethod.Put,
      'PATCH': HttpMethod.Patch,
      'DELETE': HttpMethod.Delete,
      'HEAD': HttpMethod.Head,
      'OPTIONS': HttpMethod.Options,
      'CONNECT': HttpMethod.Connect,
      'TRACE': HttpMethod.Trace,
    };
    for (final entry in esperados.entries) {
      performance.metrics.clear();
      await ApiPerformaceMonitor().start(_request(entry.key), {});
      expect(performance.metrics.single.method, entry.value,
          reason: entry.key);
    }
    expect(performance.metrics.single.requestPayloadSize, isNull);
  });

  test('método em minúsculas ou desconhecido', () async {
    await ApiPerformaceMonitor().start(_request('post'), {});
    expect(performance.metrics.single.method, HttpMethod.Post);
    performance.metrics.clear();
    await ApiPerformaceMonitor().start(_request('PURGE'), {});
    expect(performance.metrics.single.method, HttpMethod.Get);
  });

  test('stop preenche a métrica pelo uuid e a remove do mapa', () async {
    final monitor = ApiPerformaceMonitor();
    final headers = await monitor.start(_request('GET'), {});
    final uuid = headers['custom-uuid']!;
    await monitor.stop(_response(uuid, status: 201, body: 'abcd'));
    final metric = performance.metrics.single;
    expect(metric.stopped, isTrue);
    expect(metric.httpResponseCode, 201);
    expect(metric.responsePayloadSize, 4);
    expect(metric.responseContentType, 'application/json');

    // Segundo stop com o mesmo uuid não encontra métrica e não falha.
    metric.stopped = false;
    await monitor.stop(_response(uuid));
    expect(metric.stopped, isFalse);
  });

  test('stop sem uuid ou sem request não falha', () async {
    final monitor = ApiPerformaceMonitor();
    await monitor.stop(_response(null));
    await monitor.stop(Response<dynamic>(http.Response('x', 200), 'x'));
  });

  test('falha ao criar a métrica devolve os headers sem uuid', () async {
    performance.failOnCreate = true;
    final headers = await ApiPerformaceMonitor().start(_request('GET'), {'k': 'v'});
    expect(headers, {'k': 'v'});
  });

  test('falha ao parar a métrica é engolida', () async {
    performance.failOnStop = true;
    final monitor = ApiPerformaceMonitor();
    final headers = await monitor.start(_request('GET'), {});
    await monitor.stop(_response(headers['custom-uuid']));
    expect(performance.metrics.single.stopped, isFalse);
  });
}
