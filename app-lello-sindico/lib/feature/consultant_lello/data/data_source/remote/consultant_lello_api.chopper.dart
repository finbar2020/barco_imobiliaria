// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultant_lello_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ConsultantApi extends ConsultantApi {
  _$ConsultantApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ConsultantApi;

  @override
  Future<Response<dynamic>> get(String number) {
    final Uri $url = Uri.parse('/consultant');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
