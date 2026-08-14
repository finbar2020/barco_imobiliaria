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
    int limit,
    int page,
  ) {
    final Uri $url = Uri.parse('/concierge/reportbook/paginated');
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
  Future<Response<dynamic>> geReports(
    DateTime? dateFrom,
    DateTime? dateTo,
    int? type,
    bool? closed,
    String? unitId,
    bool? showNewMessages,
    bool? showReplies,
    int limit,
    int page,
  ) {
    final Uri $url = Uri.parse('/concierge/reportbook/paginated');
    final Map<String, dynamic> $params = <String, dynamic>{
      'date_from': dateFrom,
      'date_until': dateTo,
      'type': type,
      'closed': closed,
      'unit_id': unitId,
      'showNewMessages': showNewMessages,
      'showReplies': showReplies,
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

  @override
  Future<Response<dynamic>> closeReport(String reportId) {
    final Uri $url = Uri.parse('/concierge/reportbook/${reportId}');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
