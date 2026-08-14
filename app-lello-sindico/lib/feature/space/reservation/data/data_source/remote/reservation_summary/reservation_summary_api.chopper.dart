// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_summary_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReservationSummaryApi extends ReservationSummaryApi {
  _$ReservationSummaryApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReservationSummaryApi;

  @override
  Future<Response<dynamic>> get(
    String id,
    String spaceId,
    String periodStart,
    String periodEnd,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${id}/spaces/reservation/calendar/day/${spaceId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': periodStart,
      'end_date': periodEnd,
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
