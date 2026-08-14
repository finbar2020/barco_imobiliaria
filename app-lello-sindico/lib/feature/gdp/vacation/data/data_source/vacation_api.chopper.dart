// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$VacationApi extends VacationApi {
  _$VacationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = VacationApi;

  @override
  Future<Response<dynamic>> getEmployeeVacation(
    String condominiumId,
    String employeeId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employees/${employeeId}/vacations');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getVacationPeriod(
    String condominiumId,
    String employeeId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employees/${employeeId}/vacations/periods');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLockedDays(
    String condominiumId,
    String employeeId,
    String startDate,
    String endDate,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employees/${employeeId}/vacations/holidays/');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
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
  Future<Response<dynamic>> postEmployeeVacation(
    String condominiumId,
    String employeeId,
    VacationRequestModel model,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employees/${employeeId}/vacations');
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
  Future<Response<dynamic>> createVacation(
    String condominiumId,
    String employeeId,
    VacationCreatedModel? vacationCreated,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/employees/${employeeId}/vacations/periods');
    final $body = vacationCreated;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
