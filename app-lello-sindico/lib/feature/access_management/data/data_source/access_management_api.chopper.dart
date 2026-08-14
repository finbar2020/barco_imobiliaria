// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_management_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccessManagementApi extends AccessManagementApi {
  _$AccessManagementApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccessManagementApi;

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
  Future<Response<dynamic>> sendInvite(AccessManagementSendInviteModel body) {
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
