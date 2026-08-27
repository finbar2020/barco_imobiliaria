import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position posicao({double lat = -23.55, double lon = -46.63, DateTime? quando,
        double accuracy = 5}) =>
    Position(
      latitude: lat,
      longitude: lon,
      timestamp: quando ?? DateTime.now(),
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

/// Geolocator falso: [porPrecisao] define, por precisão pedida, a posição a
/// devolver ou o erro a lançar; precisões ausentes lançam.
class FakeGeolocator extends GeolocatorPlatform with MockPlatformInterfaceMixin {
  final porPrecisao = <LocationAccuracy, Object>{};
  Position? ultimaConhecida;
  bool ultimaConhecidaFalha = false;
  final pedidas = <LocationAccuracy?>[];
  int pedidosUltima = 0;

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    final precisao = locationSettings?.accuracy;
    pedidas.add(precisao);
    final resultado = porPrecisao[precisao];
    if (resultado is Position) return resultado;
    throw resultado ?? const LocationServiceDisabledException();
  }

  @override
  Future<Position?> getLastKnownPosition({bool forceLocationManager = false}) async {
    pedidosUltima++;
    if (ultimaConhecidaFalha) throw const PermissionDeniedException('negado');
    return ultimaConhecida;
  }
}

FakeGeolocator instalaGeolocatorFalso() {
  final fake = FakeGeolocator();
  GeolocatorPlatform.instance = fake;
  return fake;
}
