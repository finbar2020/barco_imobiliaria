// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthenticationApi extends AuthenticationApi {
  _$AuthenticationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthenticationApi;

  @override
  Future<Response<dynamic>> post(AccessTokenRequestModel model) {
    final Uri $url = Uri.parse('/tokenrbac');
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
  Future<Response<dynamic>> postInvite(AccessTokenRequestModel model) {
    final Uri $url = Uri.parse('/tokenConvite');
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
  Future<Response<dynamic>> switchRoles(String ref) {
    final Uri $url = Uri.parse('/token/${ref}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteAccount() {
    final Uri $url = Uri.parse('/me/deleteAccount');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
