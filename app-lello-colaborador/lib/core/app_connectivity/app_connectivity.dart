import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppConnectivity {
  final Connectivity connectivity;

  AppConnectivity({
    required this.connectivity,
  });

  bool isConnected(List<ConnectivityResult> connectivityResult) {
    return !connectivityResult.every((x) => x == ConnectivityResult.none);
  }

  Future<bool> checkConnectivity() =>
      connectivity.checkConnectivity().then((value) => isConnected(value));

  Future<bool> isOfflineMode() async {
    final AirplaneModeStatus status =
        await AirplaneModeChecker.instance.checkAirplaneMode();
    switch (status) {
      case AirplaneModeStatus.on:
        return true;
      case AirplaneModeStatus.off:
        return false;
    }
  }
}
