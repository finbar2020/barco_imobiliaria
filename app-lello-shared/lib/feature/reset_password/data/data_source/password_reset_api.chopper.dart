// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PasswordResetApi extends PasswordResetApi {
  _$PasswordResetApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PasswordResetApi;

  @override
  Future<Response<dynamic>> post(PasswordResetModel model) {
    final Uri $url = Uri.parse('/change_password');
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
