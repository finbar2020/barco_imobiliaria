// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_time_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReservationTimeApi extends ReservationTimeApi {
  _$ReservationTimeApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReservationTimeApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String spaceId,
    String date,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/spaces/${spaceId}/reservation_dates/${date}/times');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
