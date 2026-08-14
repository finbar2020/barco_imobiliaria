// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AgreementsApi extends AgreementsApi {
  _$AgreementsApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AgreementsApi;

  @override
  Future<Response<dynamic>> getAllInfo(
    String condoId,
    String unitTitle,
    bool onlyQuoteAndRule,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/agreement/allInfoV2');
    final Map<String, dynamic> $params = <String, dynamic>{
      'unitName': unitTitle,
      'onlyQuoteAndRule': onlyQuoteAndRule,
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
  Future<Response<dynamic>> getRecommendation(String condoId) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/agreement/recomendation');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPayday(String condoId) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/agreement/rule');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getInstallmentsCredit(
    String condoId,
    double totalValue,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/agreement/installmentCredit');
    final Map<String, dynamic> $params = <String, dynamic>{'value': totalValue};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postAgreement(
    String condoId,
    AgreementCreatedModel bodyDTO,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/agreement');
    final $body = bodyDTO;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAgreementDetails(
    String condoId,
    String agreementId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/agreement/details/${agreementId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
