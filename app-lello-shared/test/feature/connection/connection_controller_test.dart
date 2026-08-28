import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:essentials/essentials.dart'
    hide isNull, isNotNull, X509Certificate;
import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/shared_features.dart'
    hide isNull, isNotNull, X509Certificate;

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeConnectivity extends ConnectivityPlatform
    with MockPlatformInterfaceMixin {
  List<ConnectivityResult> result = [ConnectivityResult.wifi];
  int calls = 0;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    calls++;
    return result;
  }
}

class _FakeUseCase extends Fake implements ConnectionUseCase {
  bool success = true;
  int calls = 0;

  @override
  Future<Try<bool>> call(ConnectionParams params) async {
    calls++;
    if (success) return Success(true);
    return Rejection(UnknownFailure('lello fora'));
  }
}

/// `HttpClient` falso para o Dio interno do controller (verificação do
/// Google): responde [statusCode] ou falha com `SocketException`.
class _FakeHttpOverrides extends HttpOverrides {
  _FakeHttpOverrides(this.client);
  final _FakeHttpClient client;

  @override
  HttpClient createHttpClient(SecurityContext? context) => client;
}

class _FakeHttpClient extends Fake implements HttpClient {
  int statusCode = 200;
  bool fail = false;
  int calls = 0;
  Duration? connectionTimeout;
  Duration idleTimeout = const Duration(seconds: 15);
  final urls = <Uri>[];

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    calls++;
    urls.add(url);
    if (fail) throw const SocketException('sem internet');
    return _FakeHttpClientRequest(statusCode);
  }

  @override
  void close({bool force = false}) {}
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  _FakeHttpClientRequest(this.statusCode);
  final int statusCode;
  bool followRedirects = true;
  int maxRedirects = 5;
  bool persistentConnection = true;

  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse(statusCode);

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {
  final _values = <String, List<String>>{};

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _values[name] = ['$value'];
  }

  @override
  void forEach(void Function(String name, List<String> values) action) =>
      _values.forEach(action);
}

class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  _FakeHttpClientResponse(this.statusCode);

  @override
  final int statusCode;

  @override
  String get reasonPhrase => 'OK';

  @override
  bool get isRedirect => false;

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  X509Certificate? get certificate => null;

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      // O adaptador do Dio faz `cast<Uint8List>()` no corpo: `codeUnits`
      // (CodeUnits) falharia no cast.
      Stream<List<int>>.fromIterable(
              [Uint8List.fromList(utf8.encode('<html></html>'))])
          .listen(onData,
              onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<R> cast<R>() => Stream.castFrom<List<int>, R>(this);
}

void main() {
  late _FakeConnectivity connectivity;
  late _FakeUseCase useCase;
  late _FakeHttpClient httpClient;
  late List<MethodCall> toasts;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    connectivity = _FakeConnectivity();
    ConnectivityPlatform.instance = connectivity;
    useCase = _FakeUseCase();
    httpClient = _FakeHttpClient();
    HttpOverrides.global = _FakeHttpOverrides(httpClient);
    toasts = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async {
        toasts.add(call);
        return true;
      },
    );
  });

  tearDown(() {
    HttpOverrides.global = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('PonnamKarthik/fluttertoast'), null);
  });

  /// Roda [body] com tempo falso: o controller liga um `Timer.periodic` de
  /// 30 s no construtor e usa `Future.delayed` de 5 s entre as tentativas.
  void runFake(void Function(FakeAsync async, ConnectionController controller)
      body) {
    FakeAsync().run((async) {
      final controller = ConnectionController(connectionUseCase: useCase);
      body(async, controller);
      controller.onDispose();
      async.flushMicrotasks();
    });
  }

  /// Dispara [verify] e deixa as tentativas (3 × 5 s) passarem.
  void verifyAndDrain(FakeAsync async, ConnectionController controller) {
    controller.verifyConnections();
    async.flushMicrotasks();
    async.elapse(const Duration(seconds: 5));
    async.elapse(const Duration(seconds: 5));
    async.elapse(const Duration(seconds: 1));
  }

  test('sem conectividade básica não consulta nada', () {
    runFake((async, controller) {
      connectivity.result = [ConnectivityResult.none];

      verifyAndDrain(async, controller);

      expect(connectivity.calls, 1);
      expect(httpClient.calls, 0);
      expect(useCase.calls, 0);
      expect(toasts, isEmpty);
    });
  });

  test('com acesso ao Google encerra sem consultar a Lello', () {
    runFake((async, controller) {
      verifyAndDrain(async, controller);

      expect(httpClient.calls, 1);
      expect(httpClient.urls.single.host, 'www.google.com');
      expect(useCase.calls, 0);
      expect(toasts, isEmpty);
    });
  });

  test('Google fora do ar mas Lello acessível não avisa', () {
    runFake((async, controller) {
      httpClient.fail = true;

      verifyAndDrain(async, controller);

      expect(useCase.calls, 1);
      expect(toasts, isEmpty);
    });
  });

  test('Google com erro HTTP também cai na verificação da Lello', () {
    runFake((async, controller) {
      httpClient.statusCode = 500;

      verifyAndDrain(async, controller);

      expect(useCase.calls, 1);
    });
  });

  test('Lello inacessível tenta 3 vezes e avisa uma única vez', () {
    runFake((async, controller) {
      httpClient.fail = true;
      useCase.success = false;

      verifyAndDrain(async, controller);
      expect(useCase.calls, 3);
      expect(toasts, hasLength(1));
      expect(toasts.single.method, 'showToast');
      expect(toasts.single.arguments['msg'], contains('Sistema Lello'));

      // Enquanto continuar fora, não repete o aviso.
      verifyAndDrain(async, controller);
      expect(useCase.calls, 6);
      expect(toasts, hasLength(1));

      // Voltou: zera o aviso; caiu de novo: avisa outra vez.
      useCase.success = true;
      verifyAndDrain(async, controller);
      useCase.success = false;
      verifyAndDrain(async, controller);
      expect(toasts, hasLength(2));
    });
  });

  test('a verificação periódica roda a cada 30 s', () {
    runFake((async, controller) {
      connectivity.result = [ConnectivityResult.none];

      async.elapse(const Duration(seconds: 30));
      expect(connectivity.calls, 1);
      async.elapse(const Duration(seconds: 30));
      expect(connectivity.calls, 2);
    });
  });

  test('verificações concorrentes são ignoradas', () {
    runFake((async, controller) {
      controller.verifyConnections();
      controller.verifyConnections();
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 1));

      expect(connectivity.calls, 1);
    });
  });

  test('em segundo plano para de verificar e o timer se cancela', () {
    runFake((async, controller) {
      connectivity.result = [ConnectivityResult.none];
      controller.didChangeAppLifecycleState(AppLifecycleState.paused);

      controller.verifyConnections();
      async.flushMicrotasks();
      expect(connectivity.calls, 0);

      // O tick do timer cancela a verificação periódica.
      async.elapse(const Duration(seconds: 30));
      async.elapse(const Duration(seconds: 30));
      expect(connectivity.calls, 0);

      // Inativo, `starCheckConnection` não religa o timer.
      controller.starCheckConnection();
      async.elapse(const Duration(seconds: 30));
      expect(connectivity.calls, 0);

      // Ao voltar, verifica na hora.
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      async.flushMicrotasks();
      expect(connectivity.calls, 1);
    });
  });

  test('onDispose cancela o timer e remove o observador', () {
    FakeAsync().run((async) {
      final controller = ConnectionController(connectionUseCase: useCase);
      connectivity.result = [ConnectivityResult.none];

      controller.onDispose();
      async.elapse(const Duration(seconds: 60));

      expect(connectivity.calls, 0);
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('ConnectionParams pode ser criado', () {
    expect(ConnectionParams(), isNotNull);
  });
}
