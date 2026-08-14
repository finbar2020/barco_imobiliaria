// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_point_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DigitalPointApi extends DigitalPointApi {
  _$DigitalPointApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DigitalPointApi;

  @override
  Future<Response<dynamic>> registerPoint(
    DigitalPointModel model,
    String id,
  ) {
    final Uri $url = Uri.parse('condominiums/${id}/digital_point/register');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> requestDigitalPointService(
    String id,
    String imageHash,
  ) {
    final Uri $url = Uri.parse(
        'condominiums/${id}/digital_point/requestService/${imageHash}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAwsUrl(String id) {
    final Uri $url =
        Uri.parse('condominiums/${id}/digital_point/urlUploadImage');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkDigitalPoint(
    String id,
    DateTime date,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${id}/digital_point/CheckDigitalPointByDate');
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> syncDigitalPointWithoutLogin(
      DigitalPointModel model) {
    final Uri $url =
        Uri.parse('condominiums/{id}/digital_point/sync_digital_points');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
