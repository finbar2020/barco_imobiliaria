// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pendency_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PendencyApi extends PendencyApi {
  _$PendencyApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PendencyApi;

  @override
  Future<Response<dynamic>> get(
    String id,
    String? lastPendencyId,
  ) {
    final Uri $url = Uri.parse('/dashboard/${id}/pendencies');
    final Map<String, dynamic> $params = <String, dynamic>{
      'lastPendencyId': lastPendencyId
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
  Future<Response<dynamic>> getPagination(
    String id,
    int? currentSize,
  ) {
    final Uri $url = Uri.parse('/dashboard/${id}/pendenciesPagination');
    final Map<String, dynamic> $params = <String, dynamic>{
      'currentSize': currentSize
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
  Future<Response<dynamic>> update(
    String reference,
    String pendencyId,
    ReadNotificationModel body,
  ) {
    final Uri $url =
        Uri.parse('/dashboard/${reference}/pendencies/${pendencyId}');
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
