// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PreferencesApi extends PreferencesApi {
  _$PreferencesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PreferencesApi;

  @override
  Future<Response<dynamic>> getPreferencesNotification() {
    final Uri $url = Uri.parse('/me/preferences/notification');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> putPreferencesNotification(
      List<PreferencesNotificationModel> body) {
    final Uri $url = Uri.parse('/me/preferences/notification');
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
