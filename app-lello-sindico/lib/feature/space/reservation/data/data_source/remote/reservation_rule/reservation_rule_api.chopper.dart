// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_rule_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReservationRuleApi extends ReservationRuleApi {
  _$ReservationRuleApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReservationRuleApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String spaceId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/spaces/${spaceId}/rules');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getChangeRules(String condominiumId) {
    final Uri $url = Uri.parse('/schedulemoving/rule/${condominiumId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postChangeRules(
    String condominiumId,
    Map<String, dynamic> rule,
  ) {
    final Uri $url = Uri.parse('/schedulemoving/rule/{condominiumId}');
    final $body = rule;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
