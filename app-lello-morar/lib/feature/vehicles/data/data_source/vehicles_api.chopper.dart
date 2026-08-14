// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$VehicleApi extends VehicleApi {
  _$VehicleApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = VehicleApi;

  @override
  Future<Response<dynamic>> getVehiclesList(String unitId) {
    final Uri $url = Uri.parse('/concierge/vehicle/${unitId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> post(VehicleModel vehicleModel) {
    final Uri $url = Uri.parse('/concierge/vehicle');
    final $body = vehicleModel;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> put(VehicleModel vehicleModel) {
    final Uri $url = Uri.parse('/concierge/vehicle');
    final $body = vehicleModel;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> delete(String id) {
    final Uri $url = Uri.parse('/concierge/vehicle/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
