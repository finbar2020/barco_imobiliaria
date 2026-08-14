// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_approval_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentApprovalApi extends PaymentApprovalApi {
  _$PaymentApprovalApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentApprovalApi;

  @override
  Future<Response<dynamic>> post(
    String condominiumId,
    String paymentId,
    PaymentApprovalModel body,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/payments/${paymentId}/approvals');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
