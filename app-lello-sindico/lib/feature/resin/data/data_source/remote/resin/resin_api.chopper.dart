// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ResinApi extends ResinApi {
  _$ResinApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ResinApi;

  @override
  Future<Response<dynamic>> getResinParams(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/parameters');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getResinPeople(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/people');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getResinRefunds(
    String id, {
    DateTime? startDate,
    DateTime? endDate,
    String? protocol,
    String? status,
    String? inconsistency,
    String? type,
  }) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds');
    final Map<String, dynamic> $params = <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'protocol': protocol,
      'status': status,
      'inconsistency': inconsistency,
      'type': type,
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
  Future<Response<dynamic>> createNewRefund(
    String id,
    ResinRefundDTOModel refund,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds');
    final $body = refund;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> refundEdit(
    String id,
    ResinRefundDTOModel refund,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds');
    final $body = refund;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getResinRefundDetails(
    String id,
    String refundId,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/${refundId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadNewReceipt(
    String id,
    String refundId,
    ResinRefundReceiptModel receiptModel,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/refunds/${refundId}/receipt');
    final $body = receiptModel;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> refundCancel(
    String id,
    String refundId,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/${refundId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkMaxValue(
    String id,
    String type,
    double value,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/CheckMaxValue');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
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
}
