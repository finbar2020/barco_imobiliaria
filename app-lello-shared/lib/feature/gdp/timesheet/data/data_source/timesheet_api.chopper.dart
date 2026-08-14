// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TimesheetGDPApi extends TimesheetGDPApi {
  _$TimesheetGDPApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TimesheetGDPApi;

  @override
  Future<Response<dynamic>> list(
    String condominiumId, {
    String? name,
    String? idEmployee,
    String? type,
    DateTime? dobFrom,
    DateTime? dobTo,
  }) {
    final Uri $url = Uri.parse('/timesheet/references/${condominiumId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'id_Employee': idEmployee,
      'type': type,
      'dob_from': dobFrom,
      'dob_to': dobTo,
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
  Future<Response<dynamic>> listEmployees(String condominiumId) {
    final Uri $url = Uri.parse('/timesheet/employees/${condominiumId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getReportDay(
    String condominiumId, {
    String? name,
    String? idEmployee,
    String? type,
    DateTime? dobFrom,
    DateTime? dobTo,
  }) {
    final Uri $url = Uri.parse('/timesheet/report/day/${condominiumId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'id_Employee': idEmployee,
      'type': type,
      'dob_from': dobFrom,
      'dob_to': dobTo,
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
  Future<Response<dynamic>> listSignature(
    String condominiumId, {
    String? name,
    String? idEmployee,
    String? type,
    DateTime? dobFrom,
    DateTime? dobTo,
  }) {
    final Uri $url = Uri.parse('/timesheet/signatures/${condominiumId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'id_Employee': idEmployee,
      'type': type,
      'dob_from': dobFrom,
      'dob_to': dobTo,
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
  Future<Response<dynamic>> sign(
    String condominiumId,
    TimesheetSignatureRequestModel signatures,
  ) {
    final Uri $url = Uri.parse('/timesheet/signatures/${condominiumId}');
    final $body = signatures;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> insertTimesheetEvent(
    String condominiumId,
    TimesheetEventModel event,
  ) {
    final Uri $url = Uri.parse('/timesheet/event/${condominiumId}');
    final $body = event;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> requestTimesheet(String condominiumId) {
    final Uri $url = Uri.parse('/timesheet/request/${condominiumId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
