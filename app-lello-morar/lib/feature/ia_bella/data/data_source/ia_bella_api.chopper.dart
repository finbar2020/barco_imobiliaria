// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$IaBellaApi extends IaBellaApi {
  _$IaBellaApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = IaBellaApi;

  @override
  Future<Response<dynamic>> startSession(String condoId) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/bella/start_session');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendMessage(
    String condoId,
    IaBellaSendMessageModel body,
  ) {
    final Uri $url = Uri.parse('condominiums/${condoId}/bella/new_question');
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
  Future<Response<dynamic>> downloadPdf(
    String condoId,
    String documentId,
    String serviceType,
  ) {
    final Uri $url = Uri.parse(
        'condominiums/${condoId}/bella/download_pdf?documentId=${documentId}&serviceType=${serviceType}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> evaluate(
    String condoId,
    IaBellaRateResponseModel body,
  ) {
    final Uri $url = Uri.parse('condominiums/${condoId}/bella/evaluate');
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
  Future<Response<dynamic>> finalEvaluation(
    String condoId,
    IaBellaFinalEvaluationModel body,
  ) {
    final Uri $url =
        Uri.parse('condominiums/${condoId}/bella/final_evaluation');
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
