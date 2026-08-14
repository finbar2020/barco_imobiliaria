// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReservationApi extends ReservationApi {
  _$ReservationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReservationApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String spaceId,
    DateTime date,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/calendar/day/hours/${spaceId}');
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllReservations(
    String condominiumId,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/reservations');
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
  Future<Response<dynamic>> delete(
    String condominiumId,
    String reservationId,
    String? reservationType,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/reservations/${reservationId}/${reservationType}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postMaintenance(
    String condominiumId,
    String spaceId,
    ReservationRegistrationModel model,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/maintenances');
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
  Future<Response<dynamic>> postReservations(
    String condominiumId,
    String spaceId,
    ReservationRegistrationModel model,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/reservations');
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
  Future<Response<dynamic>> postRaffles(
    String condominiumId,
    String spaceId,
    ReservationRaffleDataModel model,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/spaces/${spaceId}/raffles');
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
  Future<Response<dynamic>> getRaffle(
    String condominiumId,
    String spaceId,
    String reservationId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/raffles/${reservationId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postRaffleExecution(
    String condominiumId,
    String spaceId,
    String reservationId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/raffles/${reservationId}/executions');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
