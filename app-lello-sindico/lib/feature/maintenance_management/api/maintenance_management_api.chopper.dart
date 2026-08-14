// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_management_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MaintenanceManagementApi extends MaintenanceManagementApi {
  _$MaintenanceManagementApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MaintenanceManagementApi;

  @override
  Future<Response<dynamic>> getCondominiumInfo() {
    final Uri $url = Uri.parse('/maintenance/workflows/info');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCondominiumInfoV2(String sessionVersion) {
    final Uri $url = Uri.parse('/maintenance/workflows/info');
    final Map<String, String> $headers = {
      'X-Session-Version': sessionVersion,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMaintenanceTaskEvents(
    List<String> typeTask,
    List<String> status,
    String dtStart,
    String untilDate,
    String dayCurrent, {
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    String? pageName,
    bool? isLogQuery,
  }) {
    final Uri $url = Uri.parse('/maintenance/tasks/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'typeTask': typeTask,
      'status': status,
      'dtStart': dtStart,
      'untilDate': untilDate,
      'dayCurrent': dayCurrent,
      'assetIds': assetIds,
      'localIds': localIds,
      'responsibleIds': responsibleIds,
      'pageName': pageName,
      'isLogQuery': isLogQuery,
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
  Future<Response<dynamic>> getScheduleEvents({
    required String dtStart,
    required String untilDate,
    required String dayCurrent,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    String? pageName,
  }) {
    final Uri $url = Uri.parse('/maintenance/schedule-events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dtStart': dtStart,
      'untilDate': untilDate,
      'dayCurrent': dayCurrent,
      'typeTask': typeTask,
      'status': status,
      'assetIds': assetIds,
      'localIds': localIds,
      'responsibleIds': responsibleIds,
      'pageName': pageName,
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
  Future<Response<dynamic>> getMaintenanceTasksEfficiency(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/tasks/efficiency');
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
  Future<Response<dynamic>> getMaintenanceTasksFilterOptions() {
    final Uri $url = Uri.parse('/maintenance/tasks/filter-options');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLegalObligations(
    String type,
    String sessionVersion,
  ) {
    final Uri $url = Uri.parse('/maintenance/legal-obligations');
    final Map<String, dynamic> $params = <String, dynamic>{'type': type};
    final Map<String, String> $headers = {
      'X-Session-Version': sessionVersion,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> downloadLegalObligationFile(
    String id,
    String type,
  ) {
    final Uri $url = Uri.parse('/maintenance/legal-obligations/download-file');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
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
  Future<Response<dynamic>> getLegalObligationUploadUrl(String condoId) {
    final Uri $url = Uri.parse('/condominiums/${condoId}/payments/aws-payload');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadLegalObligationFile(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/legal-obligations/upload');
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
  Future<Response<dynamic>> requestLegalObligationRenewal(
    String id,
    String type,
  ) {
    final Uri $url =
        Uri.parse('/maintenance/legal-obligations/request-renewal');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> notifyLegalObligationPartner(String type) {
    final Uri $url =
        Uri.parse('/maintenance/legal-obligations/notify-partner');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLegalObligationActivityHistory(
    String id,
    String type,
  ) {
    final Uri $url = Uri.parse('/maintenance/legal-obligations/history');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
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
  Future<Response<dynamic>> sendTechnicalInspectionEmail(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse(
        '/maintenance/legal-obligations/technical-inspection/send-email');
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
  Future<Response<dynamic>> getProcedureOptions(String typeTask) {
    final Uri $url = Uri.parse('/maintenance/procedures/options');
    final Map<String, dynamic> $params = <String, dynamic>{
      'typeTask': typeTask
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
  Future<Response<dynamic>> getFormularyByMonth(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/charts/formulary-by-month');
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
  Future<Response<dynamic>> getTaskByMonth(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/charts/task-by-month');
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
  Future<Response<dynamic>> getTaskBySector(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/charts/taskBySector');
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
  Future<Response<dynamic>> getTaskByLocal(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/charts/taskByLocal');
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
  Future<Response<dynamic>> getTaskByAsset(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/charts/taskByAsset');
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
  Future<Response<dynamic>> getLocalsLookup(String procedureIds) {
    final Uri $url = Uri.parse('/maintenance/lookup/locals');
    final Map<String, dynamic> $params = <String, dynamic>{
      'procedureIds': procedureIds
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
  Future<Response<dynamic>> getAssetsLookup(String procedureIds) {
    final Uri $url = Uri.parse('/maintenance/lookup/assets');
    final Map<String, dynamic> $params = <String, dynamic>{
      'procedureIds': procedureIds
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
  Future<Response<dynamic>> getTaskSummary(
    String dtStart,
    String untilDate,
  ) {
    final Uri $url = Uri.parse('/maintenance/tasks/task-summary');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dtStart': dtStart,
      'untilDate': untilDate,
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
  Future<Response<dynamic>> createTask(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/tasks');
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
  Future<Response<dynamic>> getCalendarDays(
    int month,
    int year,
    String dtStart,
    String untilDate,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  ) {
    final Uri $url = Uri.parse('/maintenance/schedule-events/calendar');
    final Map<String, dynamic> $params = <String, dynamic>{
      'month': month,
      'year': year,
      'dtStart': dtStart,
      'untilDate': untilDate,
      'typeTask': typeTask,
      'status': status,
      'assetIds': assetIds,
      'localIds': localIds,
      'responsibleIds': responsibleIds,
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
  Future<Response<dynamic>> getTaskDetails(String taskId) {
    final Uri $url = Uri.parse('/maintenance/tasks/${taskId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTaskFormularies(String taskId) {
    final Uri $url = Uri.parse('/maintenance/tasks/${taskId}/formularies');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTaskFiles(String taskId) {
    final Uri $url = Uri.parse('/maintenance/tasks/${taskId}/files');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTaskflowEvent(String eventId) {
    final Uri $url =
        Uri.parse('/maintenance/taskflow-api/v1/events/${eventId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> editScheduleEvent(
    bool isLogQuery,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/maintenance/schedule-events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'isLogQuery': isLogQuery
    };
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteScheduleEvent(
    bool isLogQuery,
    String scheduleEventId,
    String mode,
  ) {
    final Uri $url =
        Uri.parse('/maintenance/schedule-events/${scheduleEventId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'isLogQuery': isLogQuery,
      'mode': mode,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getEventDetails(String eventId) {
    final Uri $url = Uri.parse('/maintenance/events/${eventId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getScheduleEventHistory(String eventId) {
    final Uri $url =
        Uri.parse('/maintenance/schedule-events/${eventId}/history');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createTaskFromSchedule(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/tasks/step');
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
  Future<Response<dynamic>> submitForm(
    bool isLogQuery,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/maintenance/events/submit-form');
    final Map<String, dynamic> $params = <String, dynamic>{
      'isLogQuery': isLogQuery
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getChannels({
    String? dayCurrent,
    List<String>? status,
    List<String>? typeTask,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    int? first,
    String? after,
    String? before,
    int? last,
    bool? isLogQuery,
  }) {
    final Uri $url = Uri.parse('/maintenance/channels');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dayCurrent': dayCurrent,
      'status': status,
      'typeTask': typeTask,
      'assetIds': assetIds,
      'localIds': localIds,
      'responsibleIds': responsibleIds,
      'first': first,
      'after': after,
      'before': before,
      'last': last,
      'isLogQuery': isLogQuery,
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
  Future<Response<dynamic>> filterChatChannels(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/channels/filter');
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
  Future<Response<dynamic>> getChatMessages(
    String channelId, {
    String? before,
    String? after,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/maintenance/channels/${channelId}/messages');
    final Map<String, dynamic> $params = <String, dynamic>{
      'before': before,
      'after': after,
      'limit': limit,
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
  Future<Response<dynamic>> sendChatMessage(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/channels/messages');
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
  Future<Response<dynamic>> createChatChannel(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/maintenance/channels');
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
  Future<Response<dynamic>> resetScheduleEvent(String scheduleEventId) {
    final Uri $url =
        Uri.parse('/maintenance/schedule-events/${scheduleEventId}/reset');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
