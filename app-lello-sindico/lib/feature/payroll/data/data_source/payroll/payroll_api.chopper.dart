// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PayrollApi extends PayrollApi {
  _$PayrollApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PayrollApi;

  @override
  Future<Response<dynamic>> list(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/payrolls');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> get(
    String id,
    String period,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payrolls/${period}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
