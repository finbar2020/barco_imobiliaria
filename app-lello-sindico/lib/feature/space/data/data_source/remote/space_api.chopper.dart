// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SpaceApi extends SpaceApi {
  _$SpaceApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SpaceApi;

  @override
  Future<Response<dynamic>> get(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/spaces');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> listTypes(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/spaces_types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> post(
    String condominiumId,
    SpaceModel space,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/spaces');
    final $body = space;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> put(
    String condominiumId,
    String spaceId,
    SpaceModel space,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/spaces/${spaceId}');
    final $body = space;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDates(
    String id, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/spaces/calendar');
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
  Future<Response<dynamic>> getCalendar(
    String id,
    String spaceId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/spaces/calendar/day/${spaceId}');
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
    String id,
    String spaceId, {
    required DateTime date,
    String? unitId,
  }) {
    final Uri $url = Uri.parse(
        '/condominiums/${id}/spaces/reservation/calendar/hours/${spaceId}');
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
}
