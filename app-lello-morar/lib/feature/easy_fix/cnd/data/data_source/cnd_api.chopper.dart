// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cnd_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CndApi extends CndApi {
  _$CndApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CndApi;

  @override
  Future<Response<dynamic>> generateCertificateNoOutstandingDebt(
    String condominiumId,
    UnitProfileModel body,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/easyfix/cnd');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
