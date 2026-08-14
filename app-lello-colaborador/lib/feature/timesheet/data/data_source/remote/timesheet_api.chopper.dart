// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TimesheetApi extends TimesheetApi {
  _$TimesheetApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TimesheetApi;

  @override
  Future<Response<dynamic>> getTimesheet(
    String id,
    DateTime period,
  ) {
    final Uri $url = Uri.parse('condominiums/${id}/digital_point/timesheet');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTimesheetDetail(
    String id,
    DateTime period,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${id}/digital_point/timesheet/detail');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTimesheetPeriods(String id) {
    final Uri $url = Uri.parse('timesheet/references/${id}/periods');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendEmail(
    String id,
    String email,
    DateTime period,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${id}/digital_point/timesheet_email');
    final Map<String, dynamic> $params = <String, dynamic>{
      'email': email,
      'period': period,
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
  Future<Response<dynamic>> signTimesheet(
    String id,
    String timesheetSignType,
    DateTime period,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${id}/digital_point/timesheet/sign');
    final Map<String, dynamic> $params = <String, dynamic>{
      'timesheetSignType': timesheetSignType,
      'period': period,
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
