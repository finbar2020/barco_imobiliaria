// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_api.dart';

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
  Future<Response<dynamic>> list(
    String id,
    String unitId, {
    String? query,
    bool? loadAll,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/units/${unitId}/vehicles');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'loadAll': loadAll,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
