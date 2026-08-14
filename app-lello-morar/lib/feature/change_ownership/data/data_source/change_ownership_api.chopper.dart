// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_ownership_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ChangeOwnershipApi extends ChangeOwnershipApi {
  _$ChangeOwnershipApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ChangeOwnershipApi;

  @override
  Future<Response<dynamic>> postChange(
    String condoId,
    ChangeOwnershipModel model,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/easyfix/change-ownership');
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
  Future<Response<dynamic>> getAwsPayload(String condoId) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/easyfix/aws-payload');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCanChange(String condoId) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/easyfix/can-change');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
