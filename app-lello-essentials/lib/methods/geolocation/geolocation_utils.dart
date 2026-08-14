import 'dart:math';

import 'package:essentials/methods/geolocation/get_custom_location_use_case.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationUtils {
  static double calculateDistanceKm(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<Position?> getUserGeolocationPosition(bool isOnline) async {
    try {
      GetCustomPositionUseCase caseU =
          GetCustomPositionUseCase(isOnline: isOnline);
      var result =
          await caseU.call(ParamsGetCustomPositionUseCase(debouncerTime: 30));
      return result.fold((l) => null, (r) => r);
    } catch (e) {
      return null;
    }
  }
}
