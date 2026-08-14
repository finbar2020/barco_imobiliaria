// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentApi extends PaymentApi {
  _$PaymentApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentApi;

  @override
  Future<Response<dynamic>> findByBarcode(
    String id,
    String barcode,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments');
    final Map<String, dynamic> $params = <String, dynamic>{'barcode': barcode};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> select(
    String id,
    String paymentId,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments/${paymentId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> findInstallments(
    String id,
    String paymentId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/payments/installments/${paymentId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> findLedgerAccounts(
    String id,
    String type,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments/ledger-accounts');
    final Map<String, dynamic> $params = <String, dynamic>{'supplier_id': type};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> findInstallmentsInApproval(
    String id,
    String installmentId,
    String dataCadastroDe,
    String dataCadastroAte,
    String? status,
    String? filtrarAprovador,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/payments/installments/list');
    final Map<String, dynamic> $params = <String, dynamic>{
      'installmentId': installmentId,
      'dataCadastroDe': dataCadastroDe,
      'dataCadastroAte': dataCadastroAte,
      'status': status,
      'filtrarAprovador': filtrarAprovador,
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
  Future<Response<dynamic>> post(
    String id,
    PaymentModel model,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAwsPayload(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments/aws-payload');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> processFiles(
    String condoId,
    List<String> body,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/payments/process-documents');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> list(
    String id,
    String? lastPaymentId, {
    DateTime? createdDateFrom,
    DateTime? createdDateTo,
    PaymentSource? source,
    String? entry,
    String? status,
    String? supplierIdentification,
    String? supplierName,
    String? documentNumber,
    double? totalValue,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments');
    final Map<String, dynamic> $params = <String, dynamic>{
      'last_payment_id': lastPaymentId,
      'created_date_from': createdDateFrom,
      'created_date_to': createdDateTo,
      'source': source,
      'entry': entry,
      'status': status,
      'supplier_identification': supplierIdentification,
      'supplier_name': supplierName,
      'document_number': documentNumber,
      'total_value': totalValue,
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
  Future<Response<dynamic>> listPaymentHistory(
    String id,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments/list-history');
    final Map<String, dynamic> $params = <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
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
  Future<Response<dynamic>> findSupplier(
    String id,
    String? name,
    String? document,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/payments/supplier/find');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'document': document,
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
  Future<Response<dynamic>> getSupplier(
    String id,
    String supplierId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/payments/supplier/${supplierId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendPayment(
    String condoId,
    PaymentDataModel body,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/payments/send-payment');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLedgerAccountBalance(
    String condoId,
    String accountId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condoId}/payments/ledger-account-balance/${accountId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendToken(
    String condoId,
    SendTokenRequestModel body,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/payments/send-token');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkToken(
    String condoId,
    int tokenId,
    int value,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/payments/check-token');
    final Map<String, dynamic> $params = <String, dynamic>{
      'tokenId': tokenId,
      'value': value,
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
  Future<Response<dynamic>> updateInstallments(
    String condoId,
    UpdateInstallmentRequestBody body,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/payments/update-installments');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkPerfilAprovacao(String condoId) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/payments/check-perfil-aprovacao');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateContaContabil(
    String condoId,
    int idLancamento,
    int idContaContabil,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condoId}/payments/${idLancamento}/update-conta-contabil/${idContaContabil}');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getContasPagar(
    String condoId,
    String? dataVencimentoDe,
    String? dataVencimentoAte,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condoId}/payments/contas-a-pagar');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dataVencimentoDe': dataVencimentoDe,
      'dataVencimentoAte': dataVencimentoAte,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
