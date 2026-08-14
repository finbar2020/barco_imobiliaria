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
  Future<Response<dynamic>> getDocumentsByUnit(
    String condominiumId,
    String documentType,
    String unitId,
  ) {
    final Uri $url = Uri.parse(
        '/documents/condominium/${condominiumId}/type/${documentType}/unit/${unitId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDocumentsByCondominium(
    String condominiumId,
    String documentType,
  ) {
    final Uri $url = Uri.parse(
        '/documents/condominium/${condominiumId}/type/${documentType}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
