// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subuser_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SubUserApi extends SubUserApi {
  _$SubUserApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SubUserApi;

  @override
  Future<Response<dynamic>> fetchSubUser(String unityId) {
    final Uri $url = Uri.parse('/concierge/subUser/${unityId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> upateSubUser(SubUserModel resident) {
    final Uri $url = Uri.parse('/concierge/subUser');
    final $body = resident;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> insertSubUser(SubUserModel resident) {
    final Uri $url = Uri.parse('/concierge/subUser');
    final $body = resident;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchSubUserRoles() {
    final Uri $url = Uri.parse('/concierge/subUser/enabled_roles');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkSeventhService(String reference) {
    final Uri $url = Uri.parse('/concierge/accesscontrol/getServiceSeventh');
    final Map<String, dynamic> $params = <String, dynamic>{
      'reference': reference
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
  Future<Response<dynamic>> getPendingRequests(
    String unitId,
    String status,
  ) {
    final Uri $url = Uri.parse('/concierge/subUser/pending_requests/${unitId}');
    final Map<String, dynamic> $params = <String, dynamic>{'status': status};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendAccessRenewRequest(String unitId) {
    final Uri $url = Uri.parse('/concierge/subUser/renew_access/${unitId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateAccessRequestStatus(
      UpdateAccessRequestStatusModel body) {
    final Uri $url =
        Uri.parse('/concierge/subUser/pending_requests/change-status');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteSubUser(
    String unitId,
    String cpfCnpj,
  ) {
    final Uri $url = Uri.parse('/concierge/subUser/${unitId}/${cpfCnpj}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
