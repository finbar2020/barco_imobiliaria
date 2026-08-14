// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$IncomeApi extends IncomeApi {
  _$IncomeApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = IncomeApi;

  @override
  Future<Response<dynamic>> get(
    String id,
    String period,
  ) {
    final Uri $url = Uri.parse('/condominiums/${id}/incomes/${period}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
