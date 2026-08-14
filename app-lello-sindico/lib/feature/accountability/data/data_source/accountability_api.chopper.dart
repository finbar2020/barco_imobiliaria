// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccountabilityApi extends AccountabilityApi {
  _$AccountabilityApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccountabilityApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String period,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/accountabilities/${period}/grouped');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPeriod(String condominiumId) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/accountabilities/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> listType(String condominiumId) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/questions/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> listDoubt(
    String condominiumId,
    DoubtSituation? questionSituation,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/questions/');
    final Map<String, dynamic> $params = <String, dynamic>{
      'question_situation': questionSituation
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
  Future<Response<dynamic>> listDoubtDetail(
    String condominiumId,
    String id,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/questions/detail/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendDoubt(
    String condominiumId,
    AccountabilityDoubtRequestModel doubt,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/questions/');
    final $body = doubt;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postRecommendation(
    String condominiumId,
    String period,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/accountabilities/${period}/recommendation/approve');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
