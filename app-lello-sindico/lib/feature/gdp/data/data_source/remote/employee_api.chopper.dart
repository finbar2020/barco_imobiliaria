// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$EmployeeApi extends EmployeeApi {
  _$EmployeeApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = EmployeeApi;

  @override
  Future<Response<dynamic>> list(
    String condominiumId,
    String? lastEmployeeId, {
    String? name,
    String? role,
    double? salaryFrom,
    double? salaryTo,
    DateTime? dobFrom,
    DateTime? dobTo,
    DateTime? hiringDateFrom,
    DateTime? hiringDateTo,
    String? conditionName,
    String? status,
  }) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/employees');
    final Map<String, dynamic> $params = <String, dynamic>{
      'last_employee_id': lastEmployeeId,
      'name': name,
      'role': role,
      'salary_from': salaryFrom,
      'salary_to': salaryTo,
      'dob_from': dobFrom,
      'dob_to': dobTo,
      'hiring_date_from': hiringDateFrom,
      'hiring_date_to': hiringDateTo,
      'condition_name': conditionName,
      'status': status,
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
  Future<Response<dynamic>> get(
    String condominiumId,
    String employeeId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/employees/${employeeId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
