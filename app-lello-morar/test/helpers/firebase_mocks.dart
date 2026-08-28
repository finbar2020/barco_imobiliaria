// Mocks das plataformas do Firebase para permitir testar código que resolve
// `FirebaseRemoteConfig.instance` sem inicializar o Firebase de verdade.
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_crashlytics_platform_interface/firebase_crashlytics_platform_interface.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  FakeRemoteConfigPlatform({this.values = const {}});

  /// Mutável: o `FirebaseRemoteConfig.instance` guarda o delegate na primeira
  /// resolução, então trocar de instância entre testes não tem efeito.
  Map<String, String> values;

  int fetches = 0;
  int activations = 0;
  RemoteConfigSettings? configSettings;

  @override
  FirebaseRemoteConfigPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    Map<dynamic, dynamic>? remoteConfigValues,
  }) =>
      this;

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {
    configSettings = settings;
  }

  @override
  Future<void> fetch() async {
    fetches++;
  }

  @override
  Future<bool> fetchAndActivate() async {
    activations++;
    return true;
  }

  @override
  Future<bool> activate() async => true;

  @override
  Future<void> setDefaults(Map<String, dynamic> defaultParameters) async {}

  @override
  String getString(String key) => values[key] ?? '';

  @override
  bool getBool(String key) => values[key] == 'true';

  @override
  int getInt(String key) => int.tryParse(values[key] ?? '') ?? 0;

  @override
  double getDouble(String key) => double.tryParse(values[key] ?? '') ?? 0;

  @override
  Map<String, RemoteConfigValue> getAll() => {};

  @override
  RemoteConfigValue getValue(String key) => RemoteConfigValue(
        values[key]?.codeUnits,
        values.containsKey(key) ? ValueSource.valueRemote : ValueSource.valueStatic,
      );

  @override
  RemoteConfigSettings get settings =>
      configSettings ??
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(seconds: 10),
      );

  @override
  DateTime get lastFetchTime => DateTime(2026, 1, 1);

  @override
  RemoteConfigFetchStatus get lastFetchStatus => RemoteConfigFetchStatus.success;

  @override
  Stream<RemoteConfigUpdate> get onConfigUpdated => const Stream.empty();
}

/// Core falso que já entrega as constantes exigidas pelo Crashlytics.
class _FakeFirebaseCoreHostApi implements TestFirebaseCoreHostApi {
  static final _options = CoreFirebaseOptions(
    apiKey: 'fake',
    projectId: 'fake',
    appId: 'fake',
    messagingSenderId: 'fake',
  );

  /// As constantes ficam aninhadas pelo nome do canal de cada plugin.
  static const _pluginConstants = <String, dynamic>{
    'plugins.flutter.io/firebase_crashlytics': {
      'isCrashlyticsCollectionEnabled': true,
    },
  };

  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async =>
      CoreInitializeResponse(
        name: appName,
        options: _options,
        pluginConstants: _pluginConstants,
      );

  @override
  Future<List<CoreInitializeResponse>> initializeCore() async => [
        CoreInitializeResponse(
          name: defaultFirebaseAppName,
          options: _options,
          pluginConstants: _pluginConstants,
        ),
      ];

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async => _options;
}

class FakeCrashlyticsPlatform extends FirebaseCrashlyticsPlatform {
  FakeCrashlyticsPlatform() : super(appInstance: Firebase.app());

  final userIdentifiers = <String>[];
  final logs = <String>[];

  @override
  FirebaseCrashlyticsPlatform setInitialValues({
    bool? isCrashlyticsCollectionEnabled,
  }) =>
      this;

  @override
  Future<void> setUserIdentifier(String identifier) async {
    userIdentifiers.add(identifier);
  }

  @override
  Future<void> log(String message) async {
    logs.add(message);
  }

  @override
  Future<void> setCustomKey(String key, String value) async {}

  @override
  Future<void> recordError({
    String? exception,
    String? information,
    String? reason,
    bool? fatal,
    List<Map<String, String>>? stackTraceElements,
    String? buildId,
    List<String>? loadingUnits,
  }) async {}

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {}
}

class FakeMessagingPlatform extends FirebaseMessagingPlatform {
  FakeMessagingPlatform({this.token = 'fcm-token', this.initialMessage});

  final String? token;

  /// Mensagem entregue quando o app é aberto a partir de um push com o
  /// aplicativo encerrado. Mutável pelo mesmo motivo do remote config: o
  /// `FirebaseMessaging.instance` guarda o delegate na primeira resolução.
  RemoteMessage? initialMessage;
  final deletedTokens = <String>[];

  @override
  FirebaseMessagingPlatform delegateFor({FirebaseApp? app}) => this;

  @override
  FirebaseMessagingPlatform setInitialValues({
    bool? isAutoInitEnabled,
  }) =>
      this;

  @override
  Future<String?> getToken({
    String? serviceWorkerScriptPath,
    String? vapidKey,
  }) async =>
      token;

  @override
  Future<void> deleteToken() async {}

  @override
  Future<RemoteMessage?> getInitialMessage() async => initialMessage;

  @override
  Future<void> setAutoInitEnabled(bool enabled) async {}
}

class FakeTracePlatform extends TracePlatform {
  final attributes = <String, String>{};
  bool started = false;
  bool stopped = false;

  @override
  Future<void> start() async => started = true;

  @override
  Future<void> stop() async => stopped = true;

  @override
  void putAttribute(String name, String value) => attributes[name] = value;

  @override
  void removeAttribute(String name) => attributes.remove(name);

  @override
  String? getAttribute(String name) => attributes[name];

  @override
  Map<String, String> getAttributes() => attributes;

  @override
  void incrementMetric(String name, int value) {}

  @override
  void setMetric(String name, int value) {}

  @override
  int getMetric(String name) => 0;
}

class FakePerformancePlatform extends FirebasePerformancePlatform {
  final traces = <String, FakeTracePlatform>{};

  @override
  FirebasePerformancePlatform delegateFor({required FirebaseApp app}) => this;

  @override
  Future<bool> isPerformanceCollectionEnabled() async => false;

  @override
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {}

  @override
  TracePlatform newTrace(String name) =>
      traces.putIfAbsent(name, FakeTracePlatform.new);
}

class FakeAnalyticsPlatform extends FirebaseAnalyticsPlatform {
  final events = <String, Map<String, Object?>?>{};
  final eventNames = <String>[];
  final userProperties = <String, String?>{};
  String? userId;
  bool? collectionEnabled;

  void reset() {
    events.clear();
    eventNames.clear();
    userProperties.clear();
    userId = null;
    collectionEnabled = null;
  }

  @override
  FirebaseAnalyticsPlatform delegateFor({
    required FirebaseApp app,
    Map<String, dynamic>? webOptions,
  }) =>
      this;

  @override
  Future<bool> isSupported() async => true;

  @override
  Future<String?> getAppInstanceId() async => 'instance';

  @override
  Future<int?> getSessionId() async => 1;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {
    eventNames.add(name);
    events[name] = parameters;
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    collectionEnabled = enabled;
  }

  @override
  Future<void> setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  }) async {
    userId = id;
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
    AnalyticsCallOptions? callOptions,
  }) async {
    userProperties[name] = value;
  }

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> setSessionTimeoutDuration(Duration timeout) async {}

  @override
  Future<void> setDefaultEventParameters(
    Map<String, Object?>? defaultParameters,
  ) async {}
}

FakeRemoteConfigPlatform? _remoteConfig;
FakeAnalyticsPlatform? _analytics;

/// Analytics falso compartilhado por todos os `setUpFakeFirebase` do
/// processo (o `FirebaseAnalytics.instance` guarda o delegate na primeira
/// resolução).
FakeAnalyticsPlatform get fakeAnalytics => _analytics ??= FakeAnalyticsPlatform();
FakeMessagingPlatform? _messaging;

/// Inicializa o Firebase falso e devolve o remote config de mentira usado.
Future<FakeRemoteConfigPlatform> setUpFakeFirebase({
  Map<String, String> remoteConfigValues = const {},
  RemoteMessage? initialMessage,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestFirebaseCoreHostApi.setUp(_FakeFirebaseCoreHostApi());
  await Firebase.initializeApp();
  FirebaseCrashlyticsPlatform.instance = FakeCrashlyticsPlatform();
  final messaging = _messaging ??= FakeMessagingPlatform();
  messaging.initialMessage = initialMessage;
  FirebaseMessagingPlatform.instance = messaging;
  FirebasePerformancePlatform.instance = FakePerformancePlatform();
  final analytics = fakeAnalytics..reset();
  FirebaseAnalyticsPlatform.instance = analytics;
  DatadogSdk.initializeForTesting();
  // O Adjust dispara `invokeMethod` sem aguardar: sem handler o canal
  // rejeitaria com MissingPluginException fora do zone do teste.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.adjust.sdk/api'),
    (_) async => null,
  );

  // O `FirebaseRemoteConfig.instance` guarda o delegate na primeira resolução:
  // reaproveitamos sempre o mesmo fake e só trocamos os valores.
  final remoteConfig = _remoteConfig ??= FakeRemoteConfigPlatform();
  remoteConfig.values = Map<String, String>.from(remoteConfigValues);
  remoteConfig.fetches = 0;
  remoteConfig.activations = 0;
  FirebaseRemoteConfigPlatform.instance = remoteConfig;
  return remoteConfig;
}
