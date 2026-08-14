// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccountabilityApi extends AccountabilityApi {
  _$AccountabilityApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccountabilityApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String period,
  ) {
    final Uri $url =
        Uri.parse('/accountabilities/${condominiumId}/${period}/grouped');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPeriod(String condominiumId) {
    final Uri $url = Uri.parse('/accountabilities/${condominiumId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
