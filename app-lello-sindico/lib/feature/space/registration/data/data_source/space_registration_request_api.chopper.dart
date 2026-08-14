// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_registration_request_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SpaceRegistrationRequestApi extends SpaceRegistrationRequestApi {
  _$SpaceRegistrationRequestApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SpaceRegistrationRequestApi;

  @override
  Future<Response<dynamic>> post(
    String condominiumId,
    SpaceRegistrationRequestModel model,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/space-requests');
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
