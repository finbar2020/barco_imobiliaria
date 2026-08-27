import 'package:essentials/methods/geolocation/geolocation_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'fake_geolocator.dart';

void main() {
  test('calculateDistanceKm entre São Paulo e Rio', () {
    final d = GeolocationUtils.calculateDistanceKm(-23.55, -46.63, -22.91, -43.17);
    expect(d, closeTo(357, 5));
    expect(GeolocationUtils.calculateDistanceKm(0, 0, 0, 0), 0);
  });

  test('getUserGeolocationPosition devolve nulo quando o Firebase não existe',
      () async {
    // Sem Firebase inicializado, `logAnalytics` lança e o caso de uso cai no
    // catch geral devolvendo Rejection → nulo.
    final geo = instalaGeolocatorFalso();
    geo.porPrecisao[LocationAccuracy.high] = posicao();
    expect(await GeolocationUtils.getUserGeolocationPosition(true), isNull);
    expect(geo.pedidas, [LocationAccuracy.high]);
  });

  test('getUserGeolocationPosition devolve nulo sem posição', () async {
    instalaGeolocatorFalso();
    expect(await GeolocationUtils.getUserGeolocationPosition(false), isNull);
  });
}
