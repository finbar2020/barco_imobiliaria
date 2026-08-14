// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ResidentApi extends ResidentApi {
  _$ResidentApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ResidentApi;

  @override
  Future<Response<dynamic>> list(
    String id, {
    String? lastResidentId,
    String? query,
    bool? loadAll,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/residents');
    final Map<String, dynamic> $params = <String, dynamic>{
      'lastResidentId': lastResidentId,
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

  @override
  Future<Response<dynamic>> listFromUnit(
    String id,
    String unitId,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/units/${unitId}/residents');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
