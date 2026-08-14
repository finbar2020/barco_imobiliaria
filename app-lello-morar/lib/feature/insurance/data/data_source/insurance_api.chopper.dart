// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$InsuranceApi extends InsuranceApi {
  _$InsuranceApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = InsuranceApi;

  @override
  Future<Response<dynamic>> getImage(
    String serviceId,
    String hash,
  ) {
    final Uri $url = Uri.parse('/${serviceId}/file/${hash}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getInsurance(String unitId) {
    final Uri $url = Uri.parse('/insurance/${unitId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postInsurance(String unitId) {
    final Uri $url = Uri.parse('/insurance/${unitId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
