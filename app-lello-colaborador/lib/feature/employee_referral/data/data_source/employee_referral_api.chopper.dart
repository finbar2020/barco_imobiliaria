// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_referral_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$EmployeeReferralApi extends EmployeeReferralApi {
  _$EmployeeReferralApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = EmployeeReferralApi;

  @override
  Future<Response<dynamic>> registerEmployeeReferral(
    EmployeeReferralModel model,
    String condoId,
    String employeeId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condoId}/employees/${employeeId}/referral/register');
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
  Future<Response<dynamic>> getCities(
    String condoId,
    String employeeId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condoId}/employees/${employeeId}/referral/cities');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAwsUrl(
    String condoId,
    String employeeId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condoId}/employees/${employeeId}/referral/urlUploadImage');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
