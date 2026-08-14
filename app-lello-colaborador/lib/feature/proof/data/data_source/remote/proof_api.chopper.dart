// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProofApi extends ProofApi {
  _$ProofApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProofApi;

  @override
  Future<Response<dynamic>> getProof(
    String condominiumId,
    DateTime date,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${condominiumId}/digital_point/proof');
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFileProof(
    String condominiumId,
    String fileName,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${condominiumId}/digital_point/proof/download');
    final Map<String, dynamic> $params = <String, dynamic>{
      'fileName': fileName
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
