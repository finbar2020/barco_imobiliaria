// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_entry_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PayrollEntryApi extends PayrollEntryApi {
  _$PayrollEntryApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PayrollEntryApi;

  @override
  Future<Response<dynamic>> get(
    String condominiumId,
    String payrollId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/payrolls/${payrollId}/entries');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
