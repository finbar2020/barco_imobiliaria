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
  Future<Response<dynamic>> getAgreementsReport(
    String condominiumId,
    String fromDate,
    String toDate,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/agreement/report');
    final Map<String, dynamic> $params = <String, dynamic>{
      'from_date': fromDate,
      'to_date': toDate,
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
  Future<Response<dynamic>> getAllAgreementsInfo(String condominiumId) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/agreement/allInfo');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAgreementsList(
    String condominiumId,
    String? status,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/agreement');
    final Map<String, dynamic> $params = <String, dynamic>{'status': status};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getRules(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/agreement/rule');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> changeRules(
    String condominiumId,
    AgreementsRulesModel agreementsRulesModel,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/agreement/rule');
    final $body = agreementsRulesModel;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> agreementUpdateStatus(
    String condominiumId,
    AgreementUpdateStatusModel updateStatus,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/agreement/updateStatus');
    final $body = updateStatus;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
