// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MeApi extends MeApi {
  _$MeApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MeApi;

  @override
  Future<Response<dynamic>> get([int? idEmpresa]) {
    final Uri $url = Uri.parse('/me');
    final Map<String, dynamic> $params = <String, dynamic>{
      'idEmpresa': idEmpresa
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
  Future<Response<dynamic>> patch(
    MeModel me,
    String code,
  ) {
    final Uri $url = Uri.parse('/me');
    final Map<String, dynamic> $params = <String, dynamic>{'code': code};
    final $body = me;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updatePassword(MePasswordModel me) {
    final Uri $url = Uri.parse('/me/change_password');
    final $body = me;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
