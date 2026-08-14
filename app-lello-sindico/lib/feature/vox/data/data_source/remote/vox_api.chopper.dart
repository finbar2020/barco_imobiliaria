// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vox_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$VoxApi extends VoxApi {
  _$VoxApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = VoxApi;

  @override
  Future<Response<dynamic>> getWarnings(String id) {
    final Uri $url = Uri.parse('/warnings/condominium/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getWarningById(String id) {
    final Uri $url = Uri.parse('/warnings/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postWarningRequest(WarningRequestModel body) {
    final Uri $url = Uri.parse('/requests/service');
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
  Future<Response<dynamic>> postWarning(
    String id,
    WarningCreateModel body,
  ) {
    final Uri $url = Uri.parse('/warnings/condominium/${id}/models');
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
  Future<Response<dynamic>> getWarningTemplates(String id) {
    final Uri $url = Uri.parse('/warnings/${id}/models');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getWarningReasons(String id) {
    final Uri $url = Uri.parse('/warnings/${id}/reasons');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFines(String id) {
    final Uri $url = Uri.parse('/fines/condominium/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFineById(String id) {
    final Uri $url = Uri.parse('/fines/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postFineRequest(FineRequestModel body) {
    final Uri $url = Uri.parse('/requests/service');
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
  Future<Response<dynamic>> getFineTemplates(String id) {
    final Uri $url = Uri.parse('/fines/${id}/models');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFineReasons(String id) {
    final Uri $url = Uri.parse('/fines/${id}/reasons');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAnnouncements(String id) {
    final Uri $url = Uri.parse('/announcements/condominium/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAnnouncementById(String id) {
    final Uri $url = Uri.parse('/announcements/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postAnnouncementRequest(
      AnnouncementRequestModel body) {
    final Uri $url = Uri.parse('/requests/service');
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
  Future<Response<dynamic>> postAnnouncement(
    String id,
    AnnouncementCreateModel body,
  ) {
    final Uri $url = Uri.parse('/announcements/${id}/templates');
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
  Future<Response<dynamic>> getAnnouncementModels(String id) {
    final Uri $url = Uri.parse('/announcements/${id}/models');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadImage(MultipartFile file) {
    final Uri $url = Uri.parse('/documents/image/upload');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile>(
        'file',
        file,
      )
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
