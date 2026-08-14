// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_preferences_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$NotificationsPreferencesApi extends NotificationsPreferencesApi {
  _$NotificationsPreferencesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = NotificationsPreferencesApi;

  @override
  Future<Response<dynamic>> getNotificationsPrefences(String reference) {
    final Uri $url = Uri.parse('dashboard/${reference}/pendencies/rules');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateNotificationsPrefences(
    String reference,
    List<NotificationsPreferencesModel> body,
  ) {
    final Uri $url = Uri.parse('dashboard/${reference}/pendencies/rules');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
