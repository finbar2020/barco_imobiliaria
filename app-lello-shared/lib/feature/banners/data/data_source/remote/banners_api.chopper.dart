// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BannersApi extends BannersApi {
  _$BannersApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BannersApi;

  @override
  Future<Response<dynamic>> getBanners(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/banners/v2');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
