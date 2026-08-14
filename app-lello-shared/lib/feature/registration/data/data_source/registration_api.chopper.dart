// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$RegistrationApi extends RegistrationApi {
  _$RegistrationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = RegistrationApi;

  @override
  Future<Response<dynamic>> post(
    RegistrationModel model,
    int? idEmpresa,
  ) {
    final Uri $url = Uri.parse('/registration');
    final Map<String, dynamic> $params = <String, dynamic>{
      'idEmpresa': idEmpresa,
    };
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> get(String cpf) {
    final Uri $url = Uri.parse('/registration/sindico/${cpf}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> registerFcmToken(RegisterFcmTokenModel model) {
    final Uri $url = Uri.parse('/dashboard/register_fcm_token');
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
  Future<Response<dynamic>> disableFcmToken(RegisterFcmTokenModel model) {
    final Uri $url = Uri.parse('/dashboard/disable_fcm_token');
    final $body = model;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
