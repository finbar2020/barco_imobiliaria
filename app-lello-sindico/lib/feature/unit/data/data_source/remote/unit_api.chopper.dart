// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UnitApi extends UnitApi {
  _$UnitApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UnitApi;

  @override
  Future<Response<dynamic>> list(
    String id, {
    String? lastUnitId,
    String? query,
    bool? loadAll,
    String? blockName,
    String? unitName,
    bool? hasAppInstalled,
    bool? showOnlyUnitsWithBiometrics,
    String? vehicleIdentification,
    String? vehicleTypeSelected,
    bool? filterOnlyWithTenant,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/units/full');
    final Map<String, dynamic> $params = <String, dynamic>{
      'lastUnitId': lastUnitId,
      'q': query,
      'loadAll': loadAll,
      'blockName': blockName,
      'unitName': unitName,
      'hasAppInstalled': hasAppInstalled,
      'showOnlyUnitsWithBiometrics': showOnlyUnitsWithBiometrics,
      'vehicleIdentification': vehicleIdentification,
      'vehicleTypeSelected': vehicleTypeSelected,
      'filterOnlyWithTenant': filterOnlyWithTenant,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> listSimple(String id) {
    final Uri $url = Uri.parse('/condominium/${id}/simple');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
