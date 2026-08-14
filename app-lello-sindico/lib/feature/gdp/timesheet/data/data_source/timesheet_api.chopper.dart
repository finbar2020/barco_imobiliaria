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
  Future<Response<dynamic>> getMonthResume(String dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/month_resume');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> getDayAppointments(String dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/appointments');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> getOccurrenceDetail(
    String dataReferencia,
    String tipo,
  ) {
    final Uri $url = Uri.parse('/timesheet/occurrence');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia,
      'tipo': tipo,
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
  Future<Response<dynamic>> getGroupedOccurrence(
    String dataReferencia,
    String tipo,
  ) {
    final Uri $url = Uri.parse('/timesheet/occurrence/grouped');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia,
      'tipo': tipo,
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
  Future<Response<dynamic>> postAction(
      List<TimesheetOccurrenceRequestModel> models) {
    final Uri $url = Uri.parse('/timesheet/occurrence/action');
    final $body = models;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getOccurrenceVacation(String dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/occurrence/vacation');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> getVacationReceipt(String archiveName) {
    final Uri $url = Uri.parse('/timesheet/occurrence/vacation/receipt');
    final Map<String, dynamic> $params = <String, dynamic>{
      'archiveName': archiveName
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
  Future<Response<dynamic>> getOccurrenceCertificate(String dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/occurrence/certificate');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> postAddManualAppointment(
      List<TimesheetAddManualModel> models) {
    final Uri $url = Uri.parse('/timesheet/appointments/add_manual');
    final $body = models;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getManualAppointments(
    String numCra,
    DateTime dataReferencia,
  ) {
    final Uri $url = Uri.parse('/timesheet/appointments/manual');
    final Map<String, dynamic> $params = <String, dynamic>{
      'numCra': numCra,
      'date': dataReferencia,
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
  Future<Response<dynamic>> getTimesheet(String dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/occurrence/timesheet');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> getListEmployees(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/employees/working');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTimesheetEmployeeDetail(
    String numCra,
    DateTime dataReferencia,
  ) {
    final Uri $url = Uri.parse('/timesheet/ByDateAndNumcra');
    final Map<String, dynamic> $params = <String, dynamic>{
      'numCra': numCra,
      'date': dataReferencia,
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
  Future<Response<dynamic>> putSignatureOrNotify(
      TimesheetSignatureRequestModel signature) {
    final Uri $url = Uri.parse('/timesheet/signatureOrNotify');
    final $body = signature;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPointMirrorList(DateTime dataReferencia) {
    final Uri $url = Uri.parse('/timesheet/pointMirror');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataReferencia': dataReferencia
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
  Future<Response<dynamic>> getCheckInData(
    String numCra,
    DateTime dataReferencia,
  ) {
    final Uri $url = Uri.parse('/timesheet/checkInData');
    final Map<String, dynamic> $params = <String, dynamic>{
      'numCra': numCra,
      'date': dataReferencia,
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
  Future<Response<dynamic>> getTimesheetPeriods(String id) {
    final Uri $url = Uri.parse('timesheet/references/${id}/periods');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
