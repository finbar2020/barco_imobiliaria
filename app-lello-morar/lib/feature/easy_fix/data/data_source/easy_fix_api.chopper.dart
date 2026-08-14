// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'easy_fix_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$EasyFixApi extends EasyFixApi {
  _$EasyFixApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = EasyFixApi;

  @override
  Future<Response<dynamic>> getEasyFixUnit(String condominiumId) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/easyfix/unit-contact');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateAddress(
    String condominiumId,
    EasyFixUnitModel address,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/easyfix/unit-contact/update');
    final $body = address;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCities(
    String condominiumId,
    String uf,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/easyfix/cities');
    final Map<String, dynamic> $params = <String, dynamic>{'uf': uf};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
