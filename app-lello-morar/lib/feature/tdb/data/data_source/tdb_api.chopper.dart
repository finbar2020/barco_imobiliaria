// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tdb_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TDBApi extends TDBApi {
  _$TDBApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TDBApi;

  @override
  Future<Response<dynamic>> getTDBInfo(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/tdb');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
