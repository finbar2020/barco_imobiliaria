// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DocumentsApi extends DocumentsApi {
  _$DocumentsApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DocumentsApi;

  @override
  Future<Response<dynamic>> getDocumentsInfoList(
    String id,
    String documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) {
    final Uri $url =
        Uri.parse('digitalRepository/documents_info/${documentType}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dateFrom': dateFrom,
      'dateTo': dateTo,
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
  Future<Response<dynamic>> getDocumentsFile(String documentName) {
    final Uri $url = Uri.parse('digitalRepository/documents/${documentName}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
