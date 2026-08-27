import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:essentials/essentials.dart';
import 'package:essentials/stores/store_package_info.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/generated/l10n.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/shared_features.dart'
    show ConnectionController, ConnectionUseCase;

import 'fake_permission_handler.dart';
import 'firebase_mocks.dart';
import 'fixtures.dart';
import 'init_sqflite_ffi.dart';
import 'load_golden_fonts.dart';
import 'pump_app.dart';
import 'test_application_container.dart' show TestEnvironment;
import 'test_localization.dart';

/// Rota usada por [pumpPage] para a página sob teste.
const pageRouteName = '/page-under-test';

/// Servidor HTTP falso: as APIs chopper do container batem aqui.
///
/// ```dart
/// harness.http.on('GET', '/billet/R1/101', body: {'data': []});
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

/// ConnectionController sem o Timer periódico de verificação de rede.
class QuietConnectionController extends ConnectionController {
  QuietConnectionController({required super.connectionUseCase});

  @override
  Future<void> starCheckConnection() async {}

  /// O `resumed` do ciclo de vida dispararia `verifyConnections`, que usa o
  /// plugin connectivity_plus (sem implementação no teste).
  @override
  Future<void> verifyConnections() async {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
}

/// Container real + fakes de infraestrutura para testar páginas inteiras.
class PageHarness {
  PageHarness._(
      this.sessionBloc, this.http, this.circuitBreaker, this.remoteConfig);

  final FakeSessionBloc sessionBloc;
  final FakeHttp http;
  final CircuitBreakerController circuitBreaker;

  /// Remote config falso: altere `remoteConfig.values` antes de pumpar.
  final FakeRemoteConfigPlatform remoteConfig;

  ApplicationContainer get container => ApplicationContainer.instance();

  T resolve<T extends Object>() => container.resolve<T>();

  /// Substitui um registro do container por [instance] (ex.: um controller
  /// ou use case fake).
  Future<void> override<T extends Object>(T instance) async {
    final locator = container.locator;
    if (locator.isRegistered<T>()) {
      await locator.unregister<T>();
    }
    locator.registerSingleton<T>(instance);
  }
}

/// Sobe o `ApplicationContainer` real com:
/// - Firebase/Datadog/Adjust/permission_handler/sms_autofill falsos;
/// - `SessionBloc` trocado por [FakeSessionBloc] (sessão de [testSession]);
/// - `CircuitBreakerController` sobre um Firestore em memória;
/// - `ChopperClient` apontando para [FakeHttp].
///
/// Chame SEMPRE no `setUp` (fora do fake async do testWidgets): timers que o
/// container cria no setUp são reais e não disparam "Timer is still pending";
/// dentro do corpo do teste eles viram FakeTimers pendentes. O `tearDown` de
/// reset é registrado aqui.
Future<PageHarness> installPageHarness({
  FakeSessionBloc? sessionBloc,
  Map<String, String> remoteConfigValues = const {},
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();
  FlavorConfig.init();
  setFakePermissionHandler(FakePermissionHandler());
  final remoteConfig =
      await setUpFakeFirebase(remoteConfigValues: remoteConfigValues);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('sms_autofill'),
          (call) async => call.method == 'getAppSignature' ? 'sig' : null);
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: 'morar',
    packageName: 'br.com.lello.morar',
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );
  Hive.init(Directory.systemTemp.createTempSync('morar_page').path);
  // Telas leem `AppInfo.instance.packageInfo` (versão do app).
  await AppInfo.init();

  final container = ApplicationContainer.instance();
  final locator = container.locator;
  await locator.reset(dispose: true);
  await container.setUp(TestEnvironment());

  // O ConnectionController (resolvido pelo afterSetup) liga um Timer
  // periódico de 30s — e religa ao receber `AppLifecycleState.resumed` — que
  // faria o testWidgets falhar com "Timer is still pending". Trocamos por uma
  // versão que nunca inicia o timer.
  await locator<ConnectionController>().onDispose();
  await locator.unregister<ConnectionController>();
  locator.registerLazySingleton<ConnectionController>(
    () => QuietConnectionController(connectionUseCase: locator()),
  );

  final session = sessionBloc ?? FakeSessionBloc();
  await locator.unregister<SessionBloc>();
  locator.registerSingleton<SessionBloc>(session);

  final circuit = CircuitBreakerController(
    database: FakeFirebaseFirestore(),
    sessionBloc: session,
    environment: TestEnvironment(),
  );
  await locator.unregister<CircuitBreakerController>();
  locator.registerSingleton<CircuitBreakerController>(circuit);

  final fakeHttp = FakeHttp();
  await locator.unregister<chopper.ChopperClient>();
  locator.registerLazySingleton<chopper.ChopperClient>(
    () => chopper.ChopperClient(
      client: fakeHttp.client,
      baseUrl: Uri.parse('http://localhost'),
      converter: const chopper.JsonConverter(),
      errorConverter: ApiFailureConverter(),
    ),
  );

  addTearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('sms_autofill'), null);
    await locator.reset(dispose: true);
  });

  return PageHarness._(session, fakeHttp, circuit, remoteConfig);
}

/// Monta [page] como rota nomeada ([pageRouteName]) de um MaterialApp com
/// tema, localização (`AppLocalization` de teste + `S`) e o `SessionBloc`
/// do container no contexto. Rotas desconhecidas viram um `SizedBox` com o
/// nome da rota, para verificar navegação via [observer] ou [find.byKey].
///
/// [arguments] chega em `ModalRoute.of(context)!.settings.arguments`.
Future<void> pumpPage(
  WidgetTester tester,
  Widget page, {
  Object? arguments,
  Map<String, WidgetBuilder> routes = const {},
  RecordingNavigatorObserver? observer,
  Size surface = const Size(400, 800),
  bool settle = true,
  Map<String, String> locOverrides = const {},
}) async {
  await tester.runAsync(loadGoldenFonts);
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
  final base = LelloTheme.light;
  final theme = base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Roboto'),
  );

  // Image.network devolve um PNG 1x1 em vez de falhar com HTTP 400.
  await mockNetworkImagesFor(() => tester.pumpWidget(
    BlocProvider<SessionBloc>.value(
      value: sessionBloc,
      child: MaterialApp(
        theme: theme,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: [
          TestLocDelegate(overrides: locOverrides),
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorObservers: [if (observer != null) observer],
        initialRoute: pageRouteName,
        onGenerateRoute: (settings) {
          if (settings.name == pageRouteName) {
            return MaterialPageRoute(
              settings: RouteSettings(name: pageRouteName, arguments: arguments),
              builder: (_) => page,
            );
          }
          final builder = routes[settings.name];
          return MaterialPageRoute(
            settings: settings,
            builder: builder ??
                (_) => Scaffold(
                      key: Key('route:${settings.name}'),
                      body: Text('rota ${settings.name}'),
                    ),
          );
        },
      ),
    ),
  ));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Emite [state] direto no [bloc] (útil para estados difíceis de alcançar
/// pelo fluxo real) e espera a tela reagir.
Future<void> emitState(
  WidgetTester tester,
  Bloc bloc,
  Object state, {
  bool settle = true,
}) async {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  bloc.emit(state);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Finder da tela de destino gerada por [pumpPage] para rotas desconhecidas.
Finder findRoute(String name) => find.byKey(Key('route:$name'));
