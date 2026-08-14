// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_meeting_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DigitalMeetingApi extends DigitalMeetingApi {
  _$DigitalMeetingApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DigitalMeetingApi;

  @override
  Future<Response<dynamic>> getMeetings(
    bool showAll,
    String unitId,
  ) {
    final Uri $url = Uri.parse('/meeting/unit/${unitId}');
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
  Future<Response<dynamic>> getMeetingData(String tokenHash) {
    final Uri $url = Uri.parse('/meeting/hash/${tokenHash}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
