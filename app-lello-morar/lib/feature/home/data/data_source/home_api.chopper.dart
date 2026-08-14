// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$HomeApi extends HomeApi {
  _$HomeApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = HomeApi;

  @override
  Future<Response<dynamic>> get(String condominiumId) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/accountabilities/{period}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getBanners(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/banners');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLink(String unitId) {
    final Uri $url = Uri.parse('/dashboard/clublello/getLink/${unitId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postTerms(String unitId) {
    final Uri $url =
        Uri.parse('/dashboard/clublello/acceptuserterms/${unitId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
