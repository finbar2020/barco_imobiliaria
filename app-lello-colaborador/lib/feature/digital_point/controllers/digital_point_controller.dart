// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

import 'package:essentials/essentials.dart';

class DigitalPointController {
  final SessionBloc sessionBloc;
  final AppConnectivity appConnectivity;
  DigitalPointController({
    required this.sessionBloc,
    required this.appConnectivity,
  });
  //Check if user has inside the condominium area to clock in
  Future<bool?> hasUserRangeAllowed() async {
    bool hasPermission = await CheckPermissions.location();

    if (hasPermission == false) {
      return null;
    }

    final double rangeMaxPermitted =
        _getRangeMaxPermitted(sessionBloc: sessionBloc);
    var condoGeo = sessionBloc.getSession?.condominium.geographicCoordinates;

    if (condoGeo == null ||
        (condoGeo.latitudeDouble == null && condoGeo.longitudeDouble == null)) {
      //sem geolocalizacao do condominio, não da para validar
      return true;
    }

    if (sessionBloc.getSession?.me.isTabletSession == true) {
      //Tablet, não da para validar
      return true;
    }

    bool isOnline = await appConnectivity
        .checkConnectivity()
        .timeout(const Duration(seconds: 2), onTimeout: () => false);

    Position? position = sessionBloc.getSession?.lastPosition ??
        await GeolocationUtils.getUserGeolocationPosition(isOnline);
    if (position == null) {
      //Sem localização, não da para validar
      return true;
    }
    sessionBloc.getSession?.setLastPosition(position);
    double resultDistance = GeolocationUtils.calculateDistanceKm(
        position.latitude,
        position.longitude,
        condoGeo.latitudeDouble,
        condoGeo.longitudeDouble);

    if (resultDistance > rangeMaxPermitted) {
      return false;
    } else {
      return true;
    }
  }

  static double _getRangeMaxPermitted({required SessionBloc sessionBloc}) {
    double defaultValue = 0.3;

    try {
      FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
      if (remoteConfig != null) {
        var rangeMaxPermitted = jsonDecode(remoteConfig
            .getString(CustomFirebaseRemoteConfig.coordinatesRangeConfig));
        return rangeMaxPermitted ?? defaultValue;
      }
      return defaultValue;
    } catch (err) {
      return defaultValue;
    }
  }
}
