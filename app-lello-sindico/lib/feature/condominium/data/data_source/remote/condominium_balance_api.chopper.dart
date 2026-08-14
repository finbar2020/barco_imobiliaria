// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_balance_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CondominiumBalanceApi extends CondominiumBalanceApi {
  _$CondominiumBalanceApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CondominiumBalanceApi;

  @override
  Future<Response<dynamic>> get(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/balance');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDetail(
    String id, {
    DateTime? startDate,
    DateTime? endDate,
    bool? orderByDate,
    bool? orderByCount,
    bool? onlyReceita,
    bool? onlyDespesa,
    String? selectCount,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/balance/details');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'order_by_date': orderByDate,
      'order_by_count': orderByCount,
      'only_receita': onlyReceita,
      'only_despesa': onlyDespesa,
      'select_count': selectCount,
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
  Future<Response<dynamic>> getCondominiumSimple(String id) {
    final Uri $url = Uri.parse('/condominium/${id}/simple');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
