// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$NotificationsApi extends NotificationsApi {
  _$NotificationsApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = NotificationsApi;

  @override
  Future<Response<dynamic>> loadNotifications(
    String reference,
    int limit,
    int page,
  ) {
    final Uri $url = Uri.parse('/dashboard/${reference}/pendencies/pagination');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'page': page,
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
  Future<Response<dynamic>> updateNotification(String notificationId) {
    final Uri $url = Uri.parse('/dashboard/pendencies/markRead');
    final Map<String, dynamic> $params = <String, dynamic>{
      'notificationId': notificationId
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> markAllReadNotification() {
    final Uri $url = Uri.parse('/dashboard/pendencies/markAllRead');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteAllReadNotification(bool read) {
    final Uri $url = Uri.parse('/dashboard/pendencies/deleteAllRead');
    final Map<String, dynamic> $params = <String, dynamic>{'read': read};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteNotification(String notificationId) {
    final Uri $url = Uri.parse('/dashboard/pendencies/delete');
    final Map<String, dynamic> $params = <String, dynamic>{
      'notificationId': notificationId
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getNotificationResume() {
    final Uri $url = Uri.parse('/dashboard/pendencies/resume');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendPushCallback(
    String notificationId,
    String type,
  ) {
    final Uri $url = Uri.parse('/dashboard/pendencies/sendCallback');
    final Map<String, dynamic> $params = <String, dynamic>{
      'notificationId': notificationId,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
