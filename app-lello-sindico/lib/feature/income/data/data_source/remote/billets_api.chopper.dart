// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billets_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BilletsApi extends BilletsApi {
  _$BilletsApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BilletsApi;

  @override
  Future<Response<dynamic>> get(
    String id,
    String unitId,
    String period,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${id}/incomes/${period}/unit/${unitId}/billet');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUnitsByBillets(
    String id,
    String? query,
    String? status,
    DateTime? period,
    String? lastUnitId,
    bool? loadAll,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/units/byBillets');
    final Map<String, dynamic> $params = <String, dynamic>{
      'query': query,
      'status': status,
      'period': period,
      'lastUnitId': lastUnitId,
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
  Future<Response<dynamic>> downloadPdf(String nrBillet) {
    final Uri $url = Uri.parse('/billet/${nrBillet}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getBilletPeriodAvailability(
    String condominiumId,
    int? limit,
    int? page,
  ) {
    final Uri $url = Uri.parse('/billet/${condominiumId}/period_availability');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'page': page,
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
