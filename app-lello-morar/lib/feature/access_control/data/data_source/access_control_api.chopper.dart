// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccessControlApi extends AccessControlApi {
  _$AccessControlApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccessControlApi;

  @override
  Future<Response<dynamic>> getVisitants(String unitId) {
    final Uri $url = Uri.parse('/concierge/accesscontrol/${unitId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> saveVisitant(AccessControlVisitantModel visitant) {
    final Uri $url = Uri.parse('/concierge/accesscontrol');
    final $body = visitant;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> editVisitant(AccessControlVisitantModel visitant) {
    final Uri $url = Uri.parse('/concierge/accesscontrol');
    final $body = visitant;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteVisitant(String gestId) {
    final Uri $url = Uri.parse('/concierge/accesscontrol/${gestId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> saveVisit(
    AccessControlAuthorizationsModel visit,
    String gestId,
    String unitId,
  ) {
    final Uri $url = Uri.parse('/concierge/accesscontrol/recurrence');
    final Map<String, dynamic> $params = <String, dynamic>{
      'gest_id': gestId,
      'unit_idv': unitId,
    };
    final $body = visit;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> editVisit(
    AccessControlAuthorizationsModel visitant,
    String recurrenceId,
  ) {
    final Uri $url =
        Uri.parse('/concierge/accesscontrol/recurrence/${recurrenceId}');
    final $body = visitant;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteVisit(String recurrenceId) {
    final Uri $url =
        Uri.parse('/concierge/accesscontrol/recurrence/${recurrenceId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAwsUrl() {
    final Uri $url = Uri.parse('/concierge/accesscontrol/getUrlS3');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> registerFacialBiometric(String hash) {
    final Uri $url =
        Uri.parse('/concierge/accesscontrol/registerFacialBiometric');
    final Map<String, dynamic> $params = <String, dynamic>{'hash': hash};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendInvite(AccessControlSendInviteModel body) {
    final Uri $url = Uri.parse('/concierge/accesscontrol/sendInvite');
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
