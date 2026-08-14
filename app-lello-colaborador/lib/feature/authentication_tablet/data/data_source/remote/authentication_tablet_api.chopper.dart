// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_tablet_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthenticationTabletApi extends AuthenticationTabletApi {
  _$AuthenticationTabletApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthenticationTabletApi;

  @override
  Future<Response<dynamic>> getInfoByCondominiumCode(int condoCode) {
    final Uri $url = Uri.parse('/registration/condo_info/code/${condoCode}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
