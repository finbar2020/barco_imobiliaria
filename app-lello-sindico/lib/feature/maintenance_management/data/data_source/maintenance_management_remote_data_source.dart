import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import '../model/condominium_info_model.dart';
import '../model/maintenance_task_events_response_model.dart';
import 'package:chopper/chopper.dart';
import '../model/maintenance_task_events_request_model.dart';
import '../model/efficiency_request_model.dart';
import '../model/efficiency_response_model.dart';
import '../model/filter_options_model.dart';
import '../model/procedure_options_model.dart';
import '../model/formulary_by_month_request_model.dart';
import '../model/formulary_by_month_response_model.dart';
import '../model/task_by_month_request_model.dart';
import '../model/task_by_month_response_model.dart';
import '../model/task_by_sector_request_model.dart';
import '../model/task_by_sector_response_model.dart';
import '../model/task_by_local_request_model.dart';
import '../model/task_by_local_response_model.dart';
import '../model/task_by_asset_request_model.dart';
import '../model/task_by_asset_response_model.dart';
import '../model/assets_lookup_model.dart';
import '../model/locals_lookup_model.dart';
import '../model/task_files_model.dart';
import '../model/create_task_from_schedule_request_model.dart';
import '../model/create_task_from_schedule_response_model.dart';
import '../model/task_summary_model.dart';
import '../model/create_task_request_model.dart';
import '../model/create_task_response_model.dart';
import '../model/calendar_days_response_model.dart';
import '../model/schedule_events_detail_response_model.dart';
import '../model/task_details_model.dart';
import '../model/task_formularies_model.dart';
import '../model/edit_schedule_event_request_model.dart';
import '../model/delete_schedule_event_request_model.dart';
import '../model/event_details_model.dart';
import '../model/taskflow_event_model.dart';
import '../model/submit_form_request_model.dart';
import '../model/submit_form_response_model.dart';
import '../model/schedule_event_history_response_model.dart';
import '../model/legal_obligation_response_model.dart';
import '../model/legal_obligation_activity_history_response_model.dart';
import '../model/chat/filter_chat_channels_request_model.dart';
import '../model/chat/chat_channel_model.dart';
import '../model/chat/chat_message_model.dart';
import '../model/chat/send_chat_message_request_model.dart';
import '../model/chat/create_chat_channel_request_model.dart';
import '../model/upload_legal_obligation_request_model.dart';
import '../model/upload_legal_obligation_response_model.dart';
import '../model/send_technical_inspection_email_request_model.dart';
import '../model/legal_obligation_notify_partner_result_model.dart';
import 'package:cross_file/cross_file.dart';

abstract class MaintenanceManagementRemoteDataSource {
  Future<CondominiumInfoModel> getCondominiumInfo();

  Future<CondominiumInfoModel> getCondominiumInfoV2();

  Future<MaintenanceTaskEventsResponseModel> getMaintenanceTaskEvents(
    MaintenanceTaskEventsRequestModel request,
  );

  Future<ScheduleEventsDetailResponseModel> getScheduleEvents({
    required String dtStart,
    required String untilDate,
    required String dayCurrent,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    String? pageName,
  });

  Future<EfficiencyResponseModel> getMaintenanceTasksEfficiency(
    EfficiencyRequestModel request,
  );

  Future<FilterOptionsModel> getMaintenanceTasksFilterOptions();

  Future<LegalObligationResponseModel> getLegalObligations(String type);

  Future<XFile> downloadLegalObligationFile(String id, String type);

  Future<UrlUploadS3Model> getLegalObligationUploadUrl(String condoId);

  Future<UploadLegalObligationResponseModel> uploadLegalObligationFile(
    UploadLegalObligationRequestModel request,
  );

  Future<bool> requestLegalObligationRenewal({
    required String id,
    required String type,
  });

  Future<LegalObligationNotifyPartnerResultModel> notifyLegalObligationPartner({
    required String type,
  });

  Future<LegalObligationActivityHistoryResponseModel>
      getLegalObligationActivityHistory({
    required String id,
    required String type,
  });

  Future<bool> sendTechnicalInspectionEmail(
    SendTechnicalInspectionEmailRequestModel request,
  );

  Future<ProcedureOptionsModel> getProcedureOptions(String typeTask);

  Future<FormularyByMonthResponseModel> getFormularyByMonth(
    FormularyByMonthRequestModel request,
  );

  Future<TaskByMonthResponseModel> getTaskByMonth(
    TaskByMonthRequestModel request,
  );

  Future<TaskBySectorResponseModel> getTaskBySector(
    TaskBySectorRequestModel request,
  );

  Future<TaskByLocalResponseModel> getTaskByLocal(
    TaskByLocalRequestModel request,
  );

  Future<TaskByAssetResponseModel> getTaskByAsset(
    TaskByAssetRequestModel request,
  );

  Future<LocalsLookupModel> getLocalsLookup(String procedureIds);

  Future<AssetsLookupModel> getAssetsLookup(String procedureIds);

  Future<TaskSummaryModel> getTaskSummary(String dtStart, String untilDate);

  Future<CreateTaskResponseModel> createTask(CreateTaskRequestModel request);

  Future<CreateTaskFromScheduleResponseModel> createTaskFromSchedule(
      CreateTaskFromScheduleRequestModel request);

  Future<CalendarDaysResponseModel> getCalendarDays(
    int month,
    int year, {
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  });

  Future<ScheduleEventsDetailResponseModel> getScheduleEventsDetail({
    required String dtStart,
    required String untilDate,
    required String dayCurrent,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    String? pageName,
  });

  Future<TaskDetailsModel> getTaskDetails(String taskId);

  Future<ScheduleEventHistoryResponseModel> getScheduleEventHistory(
      String eventId);

  Future<TaskFormulariesResponseModel> getTaskFormularies(String taskId);

  Future<TaskFilesResponseModel> getTaskFiles(String taskId);

  Future<Map<String, dynamic>> editScheduleEvent(
      EditScheduleEventRequestModel request);

  Future<Map<String, dynamic>> deleteScheduleEvent(
      DeleteScheduleEventRequestModel request);

  Future<Response> resetScheduleEvent(String scheduleEventId);

  Future<EventDetailsModel> getEventDetails(String eventId);

  Future<TaskflowEventModel> getTaskflowEvent(String eventId);

  Future<SubmitFormResponseModel> submitForm(SubmitFormRequestModel request);

  // Chat methods
  Future<ChatChannelsResponseModel> getChannels({
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
  });

  Future<ChatChannelsResponseModel> filterChatChannels(
    FilterChatChannelsRequestModel request,
  );

  Future<ChatMessagesResponseModel> getChatMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  });

  Future<ChatMessageModel> sendChatMessage(
    SendChatMessageRequestModel request,
  );

  Future<CreateChatChannelResponseModel> createChatChannel(
    CreateChatChannelRequestModel request,
  );
}
