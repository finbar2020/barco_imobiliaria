// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_bank_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ResinBankApi extends ResinBankApi {
  _$ResinBankApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ResinBankApi;

  @override
  Future<Response<dynamic>> getResinBanks(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/refunds/banks');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllBankAccounts(String id) {
    final Uri $url = Uri.parse('/condominiums/${id}/refund_accounts');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createBankAccount(
    String id,
    ResinBankAccountModel newBankAccount,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/refund_accounts');
    final $body = newBankAccount;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteBankAccount(
    String id,
    String accountId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${id}/refund_accounts/${accountId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
