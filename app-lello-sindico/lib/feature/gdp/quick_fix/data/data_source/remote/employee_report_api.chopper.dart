// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_report_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$EmployeeReportApi extends EmployeeReportApi {
  _$EmployeeReportApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = EmployeeReportApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String employeeId,
    String reportType,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employee/${employeeId}/reports');
    final Map<String, dynamic> $params = <String, dynamic>{
      'report_type': reportType
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
