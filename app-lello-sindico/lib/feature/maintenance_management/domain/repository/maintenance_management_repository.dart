import 'dart:io';
import 'package:essentials/functional/try.dart';
import 'package:cross_file/cross_file.dart';
import 'package:shared_features/shared_features.dart';
import '../entity/chat/chat_messages_response_entity.dart';
import '../entity/maintenance_management_entity.dart';
import '../entity/legal_obligation_activity_history_entity.dart';
import '../entity/legal_obligation_entity.dart';
import '../entity/legal_obligation_notify_partner_result_entity.dart';
import '../entity/legal_obligation_upload_response_entity.dart';
import '../entity/maintenance_task_events_response_entity.dart';
import '../entity/efficiency_entity.dart';
import '../entity/filter_options_entity.dart';
import '../entity/procedure_options_entity.dart';
import '../entity/formulary_by_month_response_entity.dart';
import '../entity/task_by_month_response_entity.dart';
import '../entity/task_by_sector_entity.dart';
import '../entity/task_by_local_entity.dart';
import '../entity/task_by_asset_entity.dart';
import '../entity/locals_lookup_entity.dart';
import '../entity/assets_lookup_entity.dart';
import '../entity/create_task_entity.dart';
import '../entity/create_task_from_schedule_entity.dart';
import '../entity/calendar_days_response_entity.dart';
import '../entity/schedule_events_detail_response_entity.dart';
import '../entity/task_details_entity.dart';
import '../entity/task_formularies_entity.dart';
import '../entity/task_files_entity.dart';
import '../entity/edit_schedule_event_entity.dart';
import '../entity/delete_schedule_event_entity.dart';
import '../entity/event_details_entity.dart';
import '../entity/task_report_entity.dart';
import '../entity/submit_form_entity.dart';
import '../entity/schedule_event_history_entity.dart';
import '../entity/chat/chat_channel_entity.dart';
import '../entity/chat/chat_message_entity.dart';
import '../enum/legal_obligation_type.dart';

import '../entity/reset_schedule_event_entity.dart';

abstract class MaintenanceManagementRepository {
  Future<Try<CondominiumInfoEntity>> getCondominiumInfo();

  Future<Try<CondominiumInfoEntity>> getCondominiumInfoV2();

  Future<Try<MaintenanceTaskEventsResponseEntity>> getMaintenanceTaskEvents({
    required String dtstart,
    required String untilDate,
    required List<String> typeTask,
    required List<String> status,
    required String dayCurrent,
    List<String>? procedureGroupLabels,
    String? displayBy,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
    String? pageName,
  });

  Future<Try<ScheduleEventsDetailResponseEntity>> getScheduleEvents({
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

  Future<Try<EfficiencyResponseEntity>> getMaintenanceTasksEfficiency({
    required String dtStart,
    required String untilDate,
    required List<String> typeTask,
    required String dayCurrent,
    required List<String> procedureGroupLabels,
    required List<String> procedureGroupIds,
    required List<String> responsibleIds,
    required String displayBy,
    required List<String> status,
    String? pageName,
  });

  Future<Try<FilterOptionsEntity>> getMaintenanceTasksFilterOptions();

  Future<Try<UrlUploadS3>> getLegalObligationUploadUrl(String condoId);

  Future<Try<String>> uploadFileToS3(File file, String url);

  Future<Try<LegalObligationEntity>> getLegalObligations(
      LegalObligationType type);

  Future<Try<XFile>> downloadLegalObligationFile(String id, String type);

  Future<Try<LegalObligationUploadResponseEntity>> uploadLegalObligationFile({
    required String type,
    required String id,
    required String fileName,
    required String fileUrl,
    required String date,
  });

  Future<Try<LegalObligationActivityHistoryEntity>>
      getLegalObligationActivityHistory({
    required String id,
    required String type,
  });

  Future<Try<bool>> sendTechnicalInspectionEmail({
    required String type,
    required String id,
    required String email,
  });

  Future<Try<bool>> requestLegalObligationRenewal({
    required String type,
    required String id,
  });

  Future<Try<LegalObligationNotifyPartnerResultEntity>>
      notifyLegalObligationPartner({
    required String type,
  });

  Future<Try<ProcedureOptionsEntity>> getProcedureOptions(String typeTask);

  Future<Try<FormularyByMonthResponseEntity>> getFormularyByMonth({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });

  Future<Try<TaskByMonthResponseEntity>> getTaskByMonth({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });

  Future<Try<TaskBySectorResponseEntity>> getTaskBySector({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
    List<String>? localGroupIds,
    List<String>? procedureIds,
    List<String>? assetGroupIds,
    List<String>? sectorIds,
  });

  Future<Try<TaskByLocalResponseEntity>> getTaskByLocal({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
    List<String>? localGroupIds,
    List<String>? procedureIds,
    List<String>? assetGroupIds,
    List<String>? sectorIds,
  });

  Future<Try<TaskByAssetResponseEntity>> getTaskByAsset({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
    List<String>? localGroupIds,
    List<String>? procedureIds,
    List<String>? assetGroupIds,
    List<String>? sectorIds,
  });

  Future<Try<LocalsLookupEntity>> getLocalsLookup(String procedureIds);

  Future<Try<AssetsLookupEntity>> getAssetsLookup(String procedureIds);

  Future<Try<TaskSummaryEntity>> getTaskSummary(
      String dtStart, String untilDate);

  Future<Try<CreateTaskResponseEntity>> createTask(
      CreateTaskRequestEntity request);

  Future<Try<CreateTaskFromScheduleResponseEntity>> createTaskFromSchedule(
      CreateTaskFromScheduleRequestEntity request);

  Future<Try<CalendarDaysResponseEntity>> getCalendarDays({
    required int month,
    required int year,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  });

  Future<Try<ScheduleEventsDetailResponseEntity>> getScheduleEventsDetail({
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

  Future<Try<TaskDetailsEntity>> getTaskDetails(String taskId);

  Future<Try<TaskFormulariesResponseEntity>> getTaskFormularies(String taskId);

  Future<Try<TaskFilesResponseEntity>> getTaskFiles(String taskId);

  Future<Try<EditScheduleEventResponseEntity>> editScheduleEvent(
      EditScheduleEventRequestEntity request);

  Future<Try<DeleteScheduleEventResponseEntity>> deleteScheduleEvent(
      DeleteScheduleEventRequestEntity request);

  Future<Try<ResetScheduleEventEntity>> resetScheduleEvent(
      String scheduleEventId);

  Future<Try<EventDetailsEntity>> getEventDetails(String eventId);

  Future<Try<TaskReportEntity>> getTaskReport(String eventId);

  Future<Try<SubmitFormResponseEntity>> submitForm(
      SubmitFormRequestEntity request);

  Future<Try<ScheduleEventHistoryEntity>> getScheduleEventHistory(
      String eventId);

  // Chat methods
  Future<Try<List<ChatChannelEntity>>> filterChatChannels({
    String? dtStart,
    String? untilDate,
    String? display,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? status,
    List<String>? typeTask,
  });

  Future<Try<ChatMessagesResponseEntity>> getChatMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  });

  Future<Try<ChatMessageEntity>> sendChatMessage({
    required String channelId,
    required String content,
  });

  Future<Try<ChatChannelEntity>> createChatChannel({
    required String taskId,
  });
}
