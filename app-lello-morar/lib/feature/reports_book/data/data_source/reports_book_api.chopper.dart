// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_book_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReportsBookApi extends ReportsBookApi {
  _$ReportsBookApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReportsBookApi;

  @override
  Future<Response<dynamic>> getAllReports(
    String unitId,
    int limit,
  ) {
    final Uri $url = Uri.parse('/concierge/reportbook/${unitId}');
    final Map<String, dynamic> $params = <String, dynamic>{'limit': limit};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postNewReport(ReportCreateModel reportBook) {
    final Uri $url = Uri.parse('/concierge/reportbook');
    final $body = reportBook;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getReport(
    String unitId,
    String reportId,
  ) {
    final Uri $url = Uri.parse('/concierge/reportbook/${unitId}/${reportId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> putReportContent(
    String reportId,
    ContentSendModel body,
  ) {
    final Uri $url = Uri.parse('/concierge/reportbook/${reportId}');
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
