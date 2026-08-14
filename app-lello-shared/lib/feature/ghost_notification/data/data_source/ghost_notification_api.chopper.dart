// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_notification_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$GhostNotificationApi extends GhostNotificationApi {
  _$GhostNotificationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = GhostNotificationApi;

  @override
  Future<Response<dynamic>> sendGhostNotification(
    GhostNotificationModel body,
    String id,
    String type,
  ) {
    final Uri $url = Uri.parse('ghostNotification');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'tipo': type,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
