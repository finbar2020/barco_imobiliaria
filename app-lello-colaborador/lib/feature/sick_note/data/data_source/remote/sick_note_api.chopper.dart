// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sick_note_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SickNoteApi extends SickNoteApi {
  _$SickNoteApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SickNoteApi;

  @override
  Future<Response<dynamic>> registerSickNote(
    SickNoteModel model,
    String id,
  ) {
    final Uri $url = Uri.parse('digitalRepository/sick_note/register');
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
  Future<Response<dynamic>> getAwsUrl(String id) {
    final Uri $url = Uri.parse('digitalRepository/urlUploadImage');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
