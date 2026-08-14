// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_approval_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccountabilityApprovalApi extends AccountabilityApprovalApi {
  _$AccountabilityApprovalApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccountabilityApprovalApi;

  @override
  Future<Response<dynamic>> post(
    String condominiumId,
    String period,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/accountabilities/${period}/approvals');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
