// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_preferences_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MyPreferencesApi extends MyPreferencesApi {
  _$MyPreferencesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MyPreferencesApi;

  @override
  Future<Response<dynamic>> getPreferencesZeroPaper(int unitId) {
    final Uri $url = Uri.parse('me/preferences/unit-personal-data');
    final Map<String, dynamic> $params = <String, dynamic>{'idUnidade': unitId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> putPreferencesZeroPaper(AccessData body) {
    final Uri $url = Uri.parse('me/preferences/unit-personal-data');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getStreetTypesList() {
    final Uri $url = Uri.parse('me/preferences/street-type-list');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
