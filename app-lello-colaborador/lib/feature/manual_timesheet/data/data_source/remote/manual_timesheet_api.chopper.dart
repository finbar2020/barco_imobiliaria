// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_timesheet_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ManualTimeSheetApi extends ManualTimeSheetApi {
  _$ManualTimeSheetApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ManualTimeSheetApi;

  @override
  Future<Response<dynamic>> registerManualTimeSheet(
    ManualTimeSheetModel model,
    String id,
  ) {
    final Uri $url = Uri.parse('digitalRepository/manual_timesheet/register');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAwsUrl(String id) {
    final Uri $url = Uri.parse('digitalRepository/urlUploadImage');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
