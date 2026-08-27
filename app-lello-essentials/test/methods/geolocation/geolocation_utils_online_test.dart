import 'package:essentials/methods/geolocation/geolocation_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import '../../helpers/firebase_mocks.dart';
import 'fake_geolocator.dart';

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('getUserGeolocationPosition devolve a posição obtida', () async {
    final geo = instalaGeolocatorFalso();
    final pos = posicao();
    geo.porPrecisao[LocationAccuracy.high] = pos;
    expect(await GeolocationUtils.getUserGeolocationPosition(true), pos);
    expect(fakeAnalytics.eventNames, ['get_location_succ']);
  });
}
