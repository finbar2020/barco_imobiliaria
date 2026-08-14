import 'package:chopper/chopper.dart';

part 'maintenance_management_api.chopper.dart';

@ChopperApi()
abstract class MaintenanceManagementApi extends ChopperService {
  @GET(path: "/maintenance/workflows/info")
  Future<Response> getCondominiumInfo();

  @GET(path: "/maintenance/workflows/info")
  Future<Response> getCondominiumInfoV2(
    @Header('X-Session-Version') String sessionVersion,
  );

  @GET(path: "/maintenance/tasks/events")
  Future<Response> getMaintenanceTaskEvents(
      @Query("typeTask") List<String> typeTask,
      @Query("status") List<String> status,
      @Query("dtStart") String dtStart,
      @Query("untilDate") String untilDate,
      @Query("dayCurrent") String dayCurrent,
      {@Query("assetIds") List<String>? assetIds,
      @Query("localIds") List<String>? localIds,
      @Query("responsibleIds") List<String>? responsibleIds,
      @Query("pageName") String? pageName,
      @Query("isLogQuery") bool? isLogQuery});

  @GET(path: "/maintenance/schedule-events")
  Future<Response> getScheduleEvents({
    @Query("dtStart") required String dtStart,
    @Query("untilDate") required String untilDate,
    @Query("dayCurrent") required String dayCurrent,
    @Query("typeTask") List<String>? typeTask,
    @Query("status") List<String>? status,
    @Query("assetIds") List<String>? assetIds,
    @Query("localIds") List<String>? localIds,
    @Query("responsibleIds") List<String>? responsibleIds,
    @Query("pageName") String? pageName,
  });

  @POST(path: "/maintenance/tasks/efficiency")
  Future<Response> getMaintenanceTasksEfficiency(
      @Body() Map<String, dynamic> body);

  @GET(path: "/maintenance/tasks/filter-options")
  Future<Response> getMaintenanceTasksFilterOptions();

  @GET(path: "/maintenance/legal-obligations")
  Future<Response> getLegalObligations(
    @Query("type") String type,
    @Header('X-Session-Version') String sessionVersion,
  );

  @GET(path: "/maintenance/legal-obligations/download-file")
  Future<Response> downloadLegalObligationFile(
    @Query("id") String id,
    @Query("type") String type,
  );

  @GET(path: "/condominiums/{id}/payments/aws-payload")
  Future<Response> getLegalObligationUploadUrl(@Path("id") String condoId);

  @POST(path: "/maintenance/legal-obligations/upload")
  Future<Response> uploadLegalObligationFile(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/legal-obligations/request-renewal")
  Future<Response> requestLegalObligationRenewal(
    @Query("id") String id,
    @Query("type") String type,
  );

  @POST(path: "/maintenance/legal-obligations/notify-partner")
  Future<Response> notifyLegalObligationPartner(
    @Query("type") String type,
  );

  @GET(path: "/maintenance/legal-obligations/history")
  Future<Response> getLegalObligationActivityHistory(
    @Query("id") String id,
    @Query("type") String type,
  );

  @POST(path: "/maintenance/legal-obligations/technical-inspection/send-email")
  Future<Response> sendTechnicalInspectionEmail(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/maintenance/procedures/options")
  Future<Response> getProcedureOptions(@Query("typeTask") String typeTask);

  @POST(path: "/maintenance/charts/formulary-by-month")
  Future<Response> getFormularyByMonth(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/charts/task-by-month")
  Future<Response> getTaskByMonth(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/charts/taskBySector")
  Future<Response> getTaskBySector(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/charts/taskByLocal")
  Future<Response> getTaskByLocal(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/charts/taskByAsset")
  Future<Response> getTaskByAsset(@Body() Map<String, dynamic> body);

  @GET(path: "/maintenance/lookup/locals")
  Future<Response> getLocalsLookup(@Query("procedureIds") String procedureIds);

  @GET(path: "/maintenance/lookup/assets")
  Future<Response> getAssetsLookup(@Query("procedureIds") String procedureIds);

  @GET(path: "/maintenance/tasks/task-summary")
  Future<Response> getTaskSummary(
    @Query("dtStart") String dtStart,
    @Query("untilDate") String untilDate,
  );

  @POST(path: "/maintenance/tasks")
  Future<Response> createTask(@Body() Map<String, dynamic> body);

  @GET(path: "/maintenance/schedule-events/calendar")
  Future<Response> getCalendarDays(
    @Query("month") int month,
    @Query("year") int year,
    @Query("dtStart") String dtStart,
    @Query("untilDate") String untilDate,
    @Query("typeTask") List<String>? typeTask,
    @Query("status") List<String>? status,
    @Query("assetIds") List<String>? assetIds,
    @Query("localIds") List<String>? localIds,
    @Query("responsibleIds") List<String>? responsibleIds,
  );

  @GET(path: "/maintenance/tasks/{taskId}")
  Future<Response> getTaskDetails(@Path("taskId") String taskId);

  @GET(path: "/maintenance/tasks/{taskId}/formularies")
  Future<Response> getTaskFormularies(@Path("taskId") String taskId);

  @GET(path: "/maintenance/tasks/{taskId}/files")
  Future<Response> getTaskFiles(@Path("taskId") String taskId);

  @GET(path: "/maintenance/taskflow-api/v1/events/{eventId}")
  Future<Response> getTaskflowEvent(@Path("eventId") String eventId);

  @PUT(path: "/maintenance/schedule-events")
  Future<Response> editScheduleEvent(
    @Query("isLogQuery") bool isLogQuery,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: "/maintenance/schedule-events/{scheduleEventId}")
  Future<Response> deleteScheduleEvent(
    @Query("isLogQuery") bool isLogQuery,
    @Path("scheduleEventId") String scheduleEventId,
    @Query("mode") String mode,
  );

  @GET(path: "/maintenance/events/{eventId}")
  Future<Response> getEventDetails(@Path("eventId") String eventId);

  @GET(path: "/maintenance/schedule-events/{eventId}/history")
  Future<Response> getScheduleEventHistory(@Path("eventId") String eventId);

  @POST(path: "/maintenance/tasks/step")
  Future<Response> createTaskFromSchedule(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/events/submit-form")
  Future<Response> submitForm(
    @Query("isLogQuery") bool isLogQuery,
    @Body() Map<String, dynamic> body,
  );

  // ========== Chat Endpoints ==========

  @GET(path: "/maintenance/channels")
  Future<Response> getChannels({
    @Query("dayCurrent") String? dayCurrent,
    @Query("status") List<String>? status,
    @Query("typeTask") List<String>? typeTask,
    @Query("assetIds") List<String>? assetIds,
    @Query("localIds") List<String>? localIds,
    @Query("responsibleIds") List<String>? responsibleIds,
    @Query("first") int? first,
    @Query("after") String? after,
    @Query("before") String? before,
    @Query("last") int? last,
    @Query("isLogQuery") bool? isLogQuery,
  });

  @POST(path: "/maintenance/channels/filter")
  Future<Response> filterChatChannels(@Body() Map<String, dynamic> body);

  @GET(path: "/maintenance/channels/{channelId}/messages")
  Future<Response> getChatMessages(
    @Path("channelId") String channelId, {
    @Query("before") String? before,
    @Query("after") String? after,
    @Query("limit") int? limit,
  });

  @POST(path: "/maintenance/channels/messages")
  Future<Response> sendChatMessage(@Body() Map<String, dynamic> body);

  @POST(path: "/maintenance/channels")
  Future<Response> createChatChannel(@Body() Map<String, dynamic> body);

  // ========== Schedule Event Reset ==========

  @POST(path: "/maintenance/schedule-events/{scheduleEventId}/reset")
  Future<Response> resetScheduleEvent(
    @Path("scheduleEventId") String scheduleEventId,
  );

  static MaintenanceManagementApi create(ChopperClient client) {
    return _$MaintenanceManagementApi(client);
  }
}
