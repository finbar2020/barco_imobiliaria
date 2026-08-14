// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailing_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MailingApi extends MailingApi {
  _$MailingApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MailingApi;

  @override
  Future<Response<dynamic>> fetchMailings(
    String unitId,
    bool showAll,
  ) {
    final Uri $url = Uri.parse('/concierge/mailing/${unitId}');
    final Map<String, dynamic> $params = <String, dynamic>{'showAll': showAll};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPicture(String hash) {
    final Uri $url = Uri.parse('/concierge/mailing/photo/${hash}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
