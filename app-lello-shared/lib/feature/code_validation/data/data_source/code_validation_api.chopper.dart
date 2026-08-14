// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_validation_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CodeValidationApi extends CodeValidationApi {
  _$CodeValidationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CodeValidationApi;

  @override
  Future<Response<dynamic>> postRequest(CodeRequestModel model) {
    final Uri $url = Uri.parse('/code_request/generated');
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
  Future<Response<dynamic>> postValidation(CodeValidationModel model) {
    final Uri $url = Uri.parse('/code_request/generated/validate');
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
  Future<Response<dynamic>> getDados2faAsync(
    String cpf,
    int? idEmpresa,
  ) {
    final Uri $url = Uri.parse('/code_request/2fa/${cpf}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'idEmpresa': idEmpresa,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> request2faAsync(
    String hashToken,
    String hashDevice,
  ) {
    final Uri $url = Uri.parse('/code_request/2fa/request');
    final Map<String, dynamic> $params = <String, dynamic>{
      'hashToken': hashToken,
      'hashDevice': hashDevice,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> validate2faAsync(
    String hashToken,
    String tokenValue,
  ) {
    final Uri $url = Uri.parse('/code_request/2fa/validate');
    final Map<String, dynamic> $params = <String, dynamic>{
      'hashToken': hashToken,
      'tokenValue': tokenValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
