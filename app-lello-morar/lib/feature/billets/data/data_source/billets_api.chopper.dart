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
  Future<Response<dynamic>> fetchBillets(
    String reference,
    String unitId,
    bool showAll,
  ) {
    final Uri $url = Uri.parse('/billet/${reference}/${unitId}');
    final Map<String, dynamic> $params = <String, dynamic>{'showAll': showAll};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getBilletPdf(String nrBillet) {
    final Uri $url = Uri.parse('/billet/${nrBillet}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
