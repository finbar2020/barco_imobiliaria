import 'package:airplane_mode_checker/airplane_mode_checker_platform_interface.dart';
import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAirplaneModePlatform extends AirplaneModeCheckerPlatform {
  _FakeAirplaneModePlatform(this.mode);

  String mode;

  @override
  Future<String?> checkAirplaneMode({String defaultValue = 'OFF'}) async =>
      mode;
}

class _FakeConnectivityPlatform extends ConnectivityPlatform {
  _FakeConnectivityPlatform(this.result);

  List<ConnectivityResult> result;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => result;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value(result);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeConnectivityPlatform platform;
  late _FakeAirplaneModePlatform airplaneMode;
  late AppConnectivity connectivity;

  setUp(() {
    platform = _FakeConnectivityPlatform([ConnectivityResult.wifi]);
    ConnectivityPlatform.instance = platform;
    airplaneMode = _FakeAirplaneModePlatform('OFF');
    AirplaneModeCheckerPlatform.instance = airplaneMode;
    connectivity = AppConnectivity(connectivity: Connectivity());
  });

  group('AppConnectivity', () {
    test('considera conectado quando há qualquer rede', () {
      expect(connectivity.isConnected([ConnectivityResult.wifi]), isTrue);
      expect(connectivity.isConnected([ConnectivityResult.mobile]), isTrue);
      expect(
        connectivity.isConnected(
          [ConnectivityResult.none, ConnectivityResult.wifi],
        ),
        isTrue,
      );
    });

    test('considera desconectado quando todas as redes estão ausentes', () {
      expect(connectivity.isConnected([ConnectivityResult.none]), isFalse);
      expect(
        connectivity.isConnected(
          [ConnectivityResult.none, ConnectivityResult.none],
        ),
        isFalse,
      );
    });

    test('checkConnectivity segue o estado da plataforma', () async {
      expect(await connectivity.checkConnectivity(), isTrue);

      platform.result = [ConnectivityResult.none];

      expect(await connectivity.checkConnectivity(), isFalse);
    });

    test('modo avião ligado indica modo offline', () async {
      airplaneMode.mode = 'ON';

      expect(await connectivity.isOfflineMode(), isTrue);
    });

    test('modo avião desligado não indica modo offline', () async {
      airplaneMode.mode = 'OFF';

      expect(await connectivity.isOfflineMode(), isFalse);
    });
  });
}
