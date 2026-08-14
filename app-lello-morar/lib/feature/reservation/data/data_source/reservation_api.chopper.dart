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
  Future<Response<dynamic>> getSpaces(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/spaces');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCalendar(
    String condominiumId,
    String spaceId,
    String startDate,
    String endDate,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/reservation/calendar/day/${spaceId}');
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
  Future<Response<dynamic>> getHours(
    String condominiumId,
    String spaceId,
    DateTime date,
    String unitId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/reservation/calendar/hours/${spaceId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'date': date,
      'unitId': unitId,
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
  Future<Response<dynamic>> getReservations(
    String condominiumId,
    String unitId,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/reservations');
    final Map<String, dynamic> $params = <String, dynamic>{'unitId': unitId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteReservation(
    String condominiumId,
    String reservationId,
    String reservationType,
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
  Future<Response<dynamic>> postReservations(
    String condominiumId,
    String spaceId,
    Object body,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/reservations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
