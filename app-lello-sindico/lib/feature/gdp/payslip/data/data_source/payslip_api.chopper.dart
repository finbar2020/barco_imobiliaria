// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payslip_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PayslipApi extends PayslipApi {
  _$PayslipApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PayslipApi;

  @override
  Future<Response<dynamic>> get(String registrationNumber) {
    final Uri $url =
        Uri.parse('/digitalRepository/documents/${registrationNumber}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFile(
    String nameFile,
    String registrationNumber,
  ) {
    final Uri $url = Uri.parse(
        '/digitalRepository/documents/${nameFile}/${registrationNumber}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
