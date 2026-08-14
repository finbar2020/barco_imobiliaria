import 'package:essentials/essentials.dart';
import 'package:firebase_performance/firebase_performance.dart' as perf;

class ApiPerformaceMonitor {
  ApiPerformaceMonitor();

  final _map = <String, HttpMetric>{};
  Future<Map<String, String>> start(
      Request request, Map<String, String> customHeadres) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
          request.url.normalizePath().toString(),
          perf.HttpMethod.values.firstWhere(
            (element) => element.toString() == request.method,
            orElse: () => perf.HttpMethod.Get,
          ));

      final requestKey = const Uuid().v1();
      _map[requestKey] = metric;
      customHeadres['custom-uuid'] = requestKey;
      final requestContentLength = request.contentLength;
      await metric.start();
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (_) {}
    return customHeadres;
  }

  Future<void> stop(Response response) async {
    try {
      final requestKey = response.base.request?.headers['custom-uuid'];
      final metric = _map[requestKey];
      metric
        ?..responsePayloadSize = response.bodyBytes.length
        ..responseContentType = response.headers['Content-Type']
        ..httpResponseCode = response.statusCode;
      await metric?.stop();
      _map.remove(requestKey);
    } catch (_) {}
  }
}
