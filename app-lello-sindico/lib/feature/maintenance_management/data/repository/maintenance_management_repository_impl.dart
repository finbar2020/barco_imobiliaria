import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_from_schedule_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_files_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_formularies_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_history_entity.dart';
import '../../domain/entity/legal_obligation_upload_response_entity.dart';
import '../../domain/entity/task_report_entity.dart';
import '../mapper/origin_answer_mapper.dart';
import '../model/taskflow_event_model.dart';
import '../../adapters/condominium_info_adapters.dart';
import '../../adapters/maintenance_task_event_model_adapter.dart';
import '../../adapters/efficiency_adapter.dart';
import '../../adapters/filter_options_model_adapter.dart';
import '../../adapters/legal_obligation_activity_history_model_adapter.dart';
import '../../adapters/legal_obligation_model_adapter.dart';
import '../../adapters/procedure_options_model_adapter.dart';
import '../../adapters/formulary_by_month_adapter.dart';
import '../../adapters/task_by_month_adapter.dart';
import '../../adapters/task_by_sector_model_adapter.dart';
import '../../adapters/task_by_local_model_adapter.dart';
import '../../adapters/task_by_asset_model_adapter.dart';
import '../../adapters/locals_lookup_model_adapter.dart';
import '../../adapters/assets_lookup_model_adapter.dart';
import '../../domain/entity/event_details_entity.dart';
import '../adapter/create_task_adapter.dart';
import '../../adapters/create_task_from_schedule_adapter.dart';
import '../adapter/edit_schedule_event_adapter.dart';
import '../adapter/delete_schedule_event_adapter.dart';
import '../adapter/event_details_model_adapter.dart';

import '../adapter/schedule_events_detail_model_adapter.dart';
import '../../adapters/task_details_model_adapter.dart';
import '../../adapters/task_formularies_model_adapter.dart';
import '../../adapters/task_files_model_adapter.dart';
import '../../domain/entity/maintenance_management_entity.dart';
import '../../domain/entity/legal_obligation_activity_history_entity.dart';
import '../../domain/entity/maintenance_task_events_response_entity.dart';
import '../../domain/entity/legal_obligation_entity.dart';
import '../../domain/entity/legal_obligation_notify_partner_result_entity.dart';
import '../../domain/entity/efficiency_entity.dart';
import '../../domain/entity/filter_options_entity.dart';
import '../../domain/entity/procedure_options_entity.dart';
import '../../domain/entity/formulary_by_month_response_entity.dart';
import '../../domain/entity/task_by_month_response_entity.dart';
import '../../domain/entity/task_by_sector_entity.dart';
import '../../domain/entity/task_by_local_entity.dart';
import '../../domain/entity/task_by_asset_entity.dart';
import '../../domain/entity/locals_lookup_entity.dart';
import '../../domain/entity/assets_lookup_entity.dart';
import '../../domain/entity/create_task_entity.dart';
import '../../domain/entity/calendar_days_response_entity.dart';
import '../../domain/entity/edit_schedule_event_entity.dart';
import '../../domain/entity/delete_schedule_event_entity.dart';
import '../../domain/entity/reset_schedule_event_entity.dart';
import '../../domain/entity/submit_form_entity.dart';
import '../adapter/submit_form_adapter.dart';
import '../../adapters/chat/chat_channel_adapter.dart';
import '../../adapters/chat/chat_message_adapter.dart';
import '../model/chat/filter_chat_channels_request_model.dart';
import '../model/chat/chat_channel_model.dart';
import '../model/chat/chat_message_model.dart';
import '../model/chat/send_chat_message_request_model.dart';
import '../model/chat/create_chat_channel_request_model.dart';
import '../../domain/entity/chat/chat_channel_entity.dart';
import '../../domain/entity/chat/chat_message_entity.dart';
import '../../domain/entity/chat/chat_messages_response_entity.dart';
import '../../api/maintenance_management_api.dart';

import '../../domain/entity/schedule_events_detail_response_entity.dart';
import '../../domain/repository/maintenance_management_repository.dart';
import '../../domain/enum/legal_obligation_type.dart';
import '../data_source/maintenance_management_remote_data_source.dart';
import '../model/maintenance_task_events_request_model.dart';
import '../model/efficiency_request_model.dart';
import '../model/formulary_by_month_request_model.dart';
import '../model/task_by_month_request_model.dart';
import '../model/task_by_sector_request_model.dart';
import '../model/task_by_local_request_model.dart';
import '../model/task_by_asset_request_model.dart';
import 'dart:async';
import 'dart:io';
import '../model/delete_schedule_event_response_model.dart';
import '../model/upload_legal_obligation_request_model.dart';
import '../model/upload_legal_obligation_response_model.dart';
import '../model/send_technical_inspection_email_request_model.dart';
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:shared_features/shared_features.dart';

class MaintenanceManagementRepositoryImpl
    implements MaintenanceManagementRepository {
  final MaintenanceManagementRemoteDataSource remoteDataSource;
  final AwsUploader awsUploader;

  MaintenanceManagementRepositoryImpl(this.remoteDataSource, this.awsUploader);

  @override
  Future<Try<CondominiumInfoEntity>> getCondominiumInfo() async {
    try {
      final result = await remoteDataSource.getCondominiumInfo();
      final entity = result.toEntity;
      return Success(entity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CondominiumInfoEntity>> getCondominiumInfoV2() async {
    try {
      final result = await remoteDataSource.getCondominiumInfoV2();
      return Success(result.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getLegalObligationUploadUrl(String condoId) async {
    try {
      final model = await remoteDataSource.getLegalObligationUploadUrl(condoId);
      return Success(model.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<String>> uploadFileToS3(File file, String url) async {
    try {
      final completer = Completer<Try<String>>();
      await awsUploader.uploadS3(
        url,
        file,
        onComplete: (uploadedUrl) {
          completer.complete(Success(uploadedUrl));
        },
        onError: (e) {
          completer.complete(Rejection(UnknownFailure(e)));
        },
      );
      return completer.future;
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<LegalObligationEntity>> getLegalObligations(
      LegalObligationType type) async {
    try {
      final result = await remoteDataSource.getLegalObligations(type.apiValue);
      return Success(result.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<LegalObligationUploadResponseEntity>> uploadLegalObligationFile({
    required String type,
    required String id,
    required String fileName,
    required String fileUrl,
    required String date,
  }) async {
    try {
      final request = UploadLegalObligationRequestModel(
        type: type,
        id: id,
        fileName: fileName,
        fileUrl: fileUrl,
        date: date,
      );

      final model = await remoteDataSource.uploadLegalObligationFile(request);
      return Success(LegalObligationUploadResponseEntity(
        success: model.success,
        link: model.link,
      ));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<XFile>> downloadLegalObligationFile(String id, String type) async {
    try {
      final result =
          await remoteDataSource.downloadLegalObligationFile(id, type);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<LegalObligationActivityHistoryEntity>>
      getLegalObligationActivityHistory({
    required String id,
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.getLegalObligationActivityHistory(
        id: id,
        type: type,
      );
      return Success(result.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<bool>> sendTechnicalInspectionEmail({
    required String type,
    required String id,
    required String email,
  }) async {
    try {
      final request = SendTechnicalInspectionEmailRequestModel(
        type: type,
        id: id,
        email: email,
      );
      final result =
          await remoteDataSource.sendTechnicalInspectionEmail(request);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<bool>> requestLegalObligationRenewal({
    required String type,
    required String id,
  }) async {
    try {
      final result = await remoteDataSource.requestLegalObligationRenewal(
        id: id,
        type: type,
      );
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<LegalObligationNotifyPartnerResultEntity>>
      notifyLegalObligationPartner({
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.notifyLegalObligationPartner(
        type: type,
      );
      return Success(
        LegalObligationNotifyPartnerResultEntity(
          success: result.success,
          message: result.message,
          shouldLockButton: result.shouldLockButton,
        ),
      );
    } catch (err) {
      return Rejection(
        UnknownFailure(err),
      );
    }
  }

  @override
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
  }) async {
    try {
      final request = MaintenanceTaskEventsRequestModel(
        dtstart: dtstart,
        untilDate: untilDate,
        filters: MaintenanceTaskEventsRequestFiltersModel(
          typeTask: typeTask,
          procedureGroupLabels: procedureGroupLabels ?? [],
          displayBy: displayBy ?? "GRUPO",
          status: status,
          dayCurrent: dayCurrent,
          assetIds: assetIds ?? [],
          localIds: localIds ?? [],
          responsibleIds: responsibleIds ?? [],
        ),
        pageName: pageName,
      );

      final model = await remoteDataSource.getMaintenanceTaskEvents(request);
      return Success(model.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final model = await remoteDataSource.getScheduleEvents(
        dtStart: dtStart,
        untilDate: untilDate,
        dayCurrent: dayCurrent,
        typeTask: typeTask,
        status: status,
        assetIds: assetIds,
        localIds: localIds,
        responsibleIds: responsibleIds,
        pageName: pageName,
      );
      return Success(ScheduleEventsDetailModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final request = EfficiencyRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: EfficiencyFiltersModel(
          typeTask: typeTask,
          dayCurrent: dayCurrent,
          procedureGroupLabels: procedureGroupLabels,
          procedureGroupIds: procedureGroupIds,
          responsibleIds: responsibleIds,
          displayBy: displayBy,
          status: status,
        ),
        pageName: pageName,
      );

      final model =
          await remoteDataSource.getMaintenanceTasksEfficiency(request);
      return Success(model.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<FilterOptionsEntity>> getMaintenanceTasksFilterOptions() async {
    try {
      final model = await remoteDataSource.getMaintenanceTasksFilterOptions();
      return Success(FilterOptionsModelAdapter.fromModel(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ProcedureOptionsEntity>> getProcedureOptions(
      String typeTask) async {
    try {
      final model = await remoteDataSource.getProcedureOptions(typeTask);
      return Success(ProcedureOptionsModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<FormularyByMonthResponseEntity>> getFormularyByMonth({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) async {
    try {
      final request = FormularyByMonthRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: FormularyByMonthFiltersModel(
          typeTask: typeTask ?? [],
          status: status ?? [],
          dayCurrent: "",
          responsibleIds: responsibleIds ?? [],
          localIds: localIds ?? [],
          assetIds: assetIds ?? [],
        ),
      );

      final model = await remoteDataSource.getFormularyByMonth(request);
      return Success(model.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskByMonthResponseEntity>> getTaskByMonth({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) async {
    try {
      final request = TaskByMonthRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: TaskByMonthFiltersModel(
          typeTask: typeTask ?? ["ORDEM_SERVICO"],
          status: status ?? [],
          responsibleIds: responsibleIds ?? [],
          localIds: localIds ?? [],
          assetIds: assetIds ?? [],
        ),
      );

      final model = await remoteDataSource.getTaskByMonth(request);
      return Success(model.toEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final request = TaskBySectorRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: TaskBySectorFiltersModel(
          responsibleIds: responsibleIds ?? [],
          assetIds: assetIds ?? [],
          localIds: localIds ?? [],
          typeTask: typeTask ?? ["ORDEM_SERVICO"],
          status: status ?? [],
          dayCurrent: dayCurrent ?? "",
          localGroupIds: localGroupIds ?? [],
          procedureIds: procedureIds ?? [],
          assetGroupIds: assetGroupIds ?? [],
          sectorIds: sectorIds ?? [],
        ),
      );

      final model = await remoteDataSource.getTaskBySector(request);
      return Success(TaskBySectorResponseModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final request = TaskByLocalRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: TaskByLocalFiltersModel(
          responsibleIds: responsibleIds ?? [],
          assetIds: assetIds ?? [],
          localIds: localIds ?? [],
          typeTask: typeTask ?? ["ORDEM_SERVICO"],
          status: status ?? [],
          dayCurrent: dayCurrent ?? "",
          localGroupIds: localGroupIds ?? [],
          procedureIds: procedureIds ?? [],
          assetGroupIds: assetGroupIds ?? [],
          sectorIds: sectorIds ?? [],
        ),
      );

      final model = await remoteDataSource.getTaskByLocal(request);
      return Success(TaskByLocalResponseModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final request = TaskByAssetRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        filters: TaskByAssetFiltersModel(
          responsibleIds: responsibleIds ?? [],
          assetIds: assetIds ?? [],
          localIds: localIds ?? [],
          typeTask: typeTask ?? ["ORDEM_SERVICO"],
          status: status ?? [],
          dayCurrent: dayCurrent ?? "",
          localGroupIds: localGroupIds ?? [],
          procedureIds: procedureIds ?? [],
          assetGroupIds: assetGroupIds ?? [],
          sectorIds: sectorIds ?? [],
        ),
      );

      final model = await remoteDataSource.getTaskByAsset(request);
      return Success(TaskByAssetResponseModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<LocalsLookupEntity>> getLocalsLookup(String procedureIds) async {
    try {
      final model = await remoteDataSource.getLocalsLookup(procedureIds);
      return Success(LocalsLookupModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<AssetsLookupEntity>> getAssetsLookup(String procedureIds) async {
    try {
      final model = await remoteDataSource.getAssetsLookup(procedureIds);
      return Success(AssetsLookupModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskSummaryEntity>> getTaskSummary(
      String dtStart, String untilDate) async {
    try {
      final model = await remoteDataSource.getTaskSummary(dtStart, untilDate);
      return Success(model.toEfficiencyEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CreateTaskResponseEntity>> createTask(
      CreateTaskRequestEntity request) async {
    try {
      final requestModel = CreateTaskModelAdapter.fromEntity(request);
      final responseModel = await remoteDataSource.createTask(requestModel);
      return Success(CreateTaskModelAdapter.toEntity(responseModel));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CreateTaskFromScheduleResponseEntity>> createTaskFromSchedule(
      CreateTaskFromScheduleRequestEntity request) async {
    try {
      final requestModel = CreateTaskFromScheduleAdapter.toModel(request);
      final responseModel =
          await remoteDataSource.createTaskFromSchedule(requestModel);
      return Success(CreateTaskFromScheduleAdapter.toEntity(responseModel));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CalendarDaysResponseEntity>> getCalendarDays({
    required int month,
    required int year,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  }) async {
    try {
      final responseModel = await remoteDataSource.getCalendarDays(
        month,
        year,
        typeTask: typeTask,
        status: status,
        assetIds: assetIds,
        localIds: localIds,
        responsibleIds: responsibleIds,
      );
      return Success(responseModel.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
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
  }) async {
    try {
      final responseModel = await remoteDataSource.getScheduleEventsDetail(
        dtStart: dtStart,
        untilDate: untilDate,
        dayCurrent: dayCurrent,
        typeTask: typeTask,
        status: status,
        assetIds: assetIds,
        localIds: localIds,
        responsibleIds: responsibleIds,
        pageName: pageName,
      );
      return Success(ScheduleEventsDetailModelAdapter.toEntity(responseModel));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskDetailsEntity>> getTaskDetails(String taskId) async {
    try {
      final model = await remoteDataSource.getTaskDetails(taskId);
      final entity = TaskDetailsModelAdapter.toEntity(model);
      return Success(entity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskFormulariesResponseEntity>> getTaskFormularies(
      String taskId) async {
    try {
      final model = await remoteDataSource.getTaskFormularies(taskId);
      return Success(TaskFormulariesModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskFilesResponseEntity>> getTaskFiles(String taskId) async {
    try {
      final model = await remoteDataSource.getTaskFiles(taskId);
      return Success(TaskFilesModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<EditScheduleEventResponseEntity>> editScheduleEvent(
      EditScheduleEventRequestEntity request) async {
    try {
      final model = EditScheduleEventAdapter.fromEntity(request);
      final response = await remoteDataSource.editScheduleEvent(model);
      return Success(EditScheduleEventAdapter.toEntity(response));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<DeleteScheduleEventResponseEntity>> deleteScheduleEvent(
      DeleteScheduleEventRequestEntity request) async {
    try {
      final model = DeleteScheduleEventAdapter.fromEntity(request);
      final response = await remoteDataSource.deleteScheduleEvent(model);
      final responseModel = DeleteScheduleEventResponseModel.fromJson(response);
      return Success(DeleteScheduleEventAdapter.toEntity(responseModel));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResetScheduleEventEntity>> resetScheduleEvent(
      String scheduleEventId) async {
    try {
      final response =
          await remoteDataSource.resetScheduleEvent(scheduleEventId);

      // O response.body já é um Map, não precisa de jsonDecode
      final responseJson = response.body as Map<String, dynamic>;

      final entity = ResetScheduleEventEntity.fromJson(responseJson);

      return Success(entity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<EventDetailsEntity>> getEventDetails(String eventId) async {
    try {
      final model = await remoteDataSource.getEventDetails(eventId);
      return Success(EventDetailsModelAdapter.toEntity(model));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<TaskReportEntity>> getTaskReport(String eventId) async {
    try {
      final taskflowEvent = await remoteDataSource.getTaskflowEvent(eventId);
      final result = _mapToTaskReportEntity(taskflowEvent);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  TaskReportEntity _mapToTaskReportEntity(TaskflowEventModel model) {
    final List<TaskReportQuestionEntity> questions = [];

    for (final question in model.formulary.questions) {
      final answer =
          _findAnswerForQuestion(question.id, model.lastContentAnswers);

      final shouldShowQuestion = _shouldShowQuestion(
        question,
        model.lastContentAnswers,
        model.formulary.expressions,
      );

      if (shouldShowQuestion) {
        // Procura por respostas de FILE dependentes deste campo RADIO/SELECT
        final dependentFileAnswers = _findDependentFileAnswers(
          question.id,
          model.lastContentAnswers,
          model.formulary.expressions,
          model.formulary.questions,
        );

        questions.add(TaskReportQuestionEntity(
          id: question.id,
          question: question.name,
          type: _mapFieldTypeToQuestionType(question),
          options: question.options?.map((option) => option.name).toList(),
          isRequired:
              _isQuestionRequired(question, model.formulary.expressions),
          answer: answer != null ? _mapToAnswerEntity(answer, question) : null,
          dependentFileAnswers: dependentFileAnswers,
        ));
      }
    }

    return TaskReportEntity(
      id: model.id,
      taskId: model.id,
      stepName: model.formulary.name,
      responsibleName: model.responsibleName,
      status: model.status.toUpperCase(),
      completedAt:
          model.finishedAt != null ? _formatDateTime(model.finishedAt!) : null,
      createdAt: model.createdAt,
      finishedAt: model.finishedAt,
      formularName: model.formulary.name,
      questions: questions,
      childTasks: model.childTasks
          ?.map((childTask) => ChildTaskEntity(
                scheduleEventId: childTask.scheduleEventId,
                originAnswer: childTask.originAnswer?.toEntity(),
              ))
          .toList(),
    );
  }

  TaskflowAnswerModel? _findAnswerForQuestion(
    String questionId,
    Map<String, TaskflowAnswerModel>? answers,
  ) {
    if (answers == null) return null;

    final directAnswer = answers[questionId];
    if (directAnswer != null) return directAnswer;

    for (final answer in answers.values) {
      if (answer.questionId == questionId) {
        return answer;
      }
    }

    return null;
  }

  List<TaskReportAnswerEntity> _findDependentFileAnswers(
    String parentQuestionId,
    Map<String, TaskflowAnswerModel>? answers,
    List<TaskflowExpressionModel>? expressions,
    List<TaskflowQuestionModel> allQuestions,
  ) {
    final dependentAnswers = <TaskReportAnswerEntity>[];

    if (answers == null || expressions == null) return dependentAnswers;

    // Procura por expressions que têm este campo como origin_id (controlador)
    for (final expression in expressions) {
      final isControlledByParent = expression.factors.any(
        (factor) => factor.originId == parentQuestionId,
      );

      if (isControlledByParent) {
        // O ID da expression é o ID do campo FILE dependente
        final dependentAnswer = _findAnswerForQuestion(expression.id, answers);

        if (dependentAnswer != null && dependentAnswer.type == 'FILE') {
          // Busca a pergunta real do formulário para pegar o nome
          final realQuestion = allQuestions.firstWhere(
            (q) => q.id == expression.id,
            orElse: () => TaskflowQuestionModel(
              id: expression.id,
              name: '',
              position: 0,
              formularyId: '',
              fieldType: 'FILE',
            ),
          );

          final answerEntity =
              _mapToAnswerEntity(dependentAnswer, realQuestion);
          dependentAnswers.add(answerEntity);
        }
      }
    }

    return dependentAnswers;
  }

  bool _shouldShowQuestion(
    TaskflowQuestionModel question,
    Map<String, TaskflowAnswerModel>? answers,
    List<TaskflowExpressionModel>? expressions,
  ) {
    // Só exibe perguntas que foram respondidas
    final hasAnswer = _findAnswerForQuestion(question.id, answers) != null;
    if (!hasAnswer) return false;

    // Se a pergunta é controlada por uma expression (hidden com condicional),
    // ela NÃO deve aparecer como pergunta principal, apenas como dependente
    if (expressions != null) {
      final isControlledByExpression = expressions.any(
        (expr) => expr.id == question.id,
      );

      // Se é controlada por expression, não exibe como pergunta principal
      if (isControlledByExpression) return false;
    }

    return true;
  }

  bool _isQuestionRequired(
    TaskflowQuestionModel question,
    List<TaskflowExpressionModel>? expressions,
  ) {
    return true;
  }

  bool _evaluateExpression(
    TaskflowExpressionModel expression,
    Map<String, TaskflowAnswerModel>? answers,
  ) {
    if (answers == null) return false;

    // Para que a expression seja verdadeira, pelo menos um factor deve ser verdadeiro
    for (final factor in expression.factors) {
      final answer = _findAnswerForQuestion(factor.originId, answers);

      if (answer == null) continue;

      // Para campos RADIO/SELECT, o content é o ID da opção selecionada
      final answerContent = answer.content?.toString() ?? '';
      final targetValue = factor.targetValue;

      switch (factor.comparisonType.toUpperCase()) {
        case 'EQUALS':
        case 'EQ':
          if (answerContent == targetValue) return true;
          break;
        case 'NOT_EQUALS':
        case 'NEQ':
          if (answerContent != targetValue) return true;
          break;
        case 'CONTAINS':
          if (answerContent.contains(targetValue)) return true;
          break;
        default:
          // Se não reconhece o tipo de comparação, assume verdadeiro
          return true;
      }
    }

    // Se nenhum factor foi verdadeiro, a expression é falsa
    return false;
  }

  TaskReportQuestionType _mapFieldTypeToQuestionType(
      TaskflowQuestionModel question) {
    if (question.fieldType != null) {
      switch (question.fieldType!.toUpperCase()) {
        case 'RADIO':
          return TaskReportQuestionType.radio;
        case 'SELECT':
        case 'DROPDOWN':
          return TaskReportQuestionType.select;
        case 'FILE':
        case 'UPLOAD':
          return TaskReportQuestionType.file;
        case 'TEXTAREA':
        case 'TEXT':
          return TaskReportQuestionType.textarea;
        default:
          break;
      }
    }

    if (question.options == null || question.options!.isEmpty) {
      return TaskReportQuestionType.textarea;
    }

    if (question.options!.length <= 5) {
      return TaskReportQuestionType.radio;
    } else {
      return TaskReportQuestionType.select;
    }
  }

  TaskReportAnswerEntity _mapToAnswerEntity(
    TaskflowAnswerModel answer,
    TaskflowQuestionModel question,
  ) {
    final questionType = _mapFieldTypeToQuestionType(question);

    switch (questionType) {
      case TaskReportQuestionType.textarea:
        return TaskReportAnswerEntity(
          id: answer.questionId,
          questionId: answer.questionId,
          type: TaskReportAnswerType.text,
          textValue: answer.content?.toString(),
          answeredAt: answer.updatedAt != null
              ? _formatTimestamp(answer.updatedAt!)
              : null,
          questionName: question.name,
        );

      case TaskReportQuestionType.radio:
      case TaskReportQuestionType.select:
        final selectedOption = question.options?.firstWhere(
          (option) => option.id == answer.content,
          orElse: () => TaskflowQuestionOptionModel(
            id: '',
            name: answer.content?.toString() ?? 'Opção não encontrada',
          ),
        );

        return TaskReportAnswerEntity(
          id: selectedOption?.id ??
              answer.questionId, // Usa ID da opção selecionada
          questionId: answer.questionId,
          type: TaskReportAnswerType.singleChoice,
          selectedOption: selectedOption?.name,
          answeredAt: answer.updatedAt != null
              ? _formatTimestamp(answer.updatedAt!)
              : null,
          questionName: question.name,
        );

      case TaskReportQuestionType.file:
        List<TaskReportFileEntity> files = [];

        if (answer.content is List<TaskflowFileModel>) {
          // Conteúdo já é uma lista de TaskflowFileModel
          files = (answer.content as List<TaskflowFileModel>)
              .map((file) => TaskReportFileEntity(
                    id: file.id,
                    url: file.url,
                    filename: file.name,
                    extension: _getFileExtension(file.name),
                    sizeInBytes: file.size,
                  ))
              .toList();
        } else if (answer.content is String) {
          // Conteúdo é uma string JSON que precisa ser parseada
          try {
            final decoded = json.decode(answer.content as String);
            if (decoded is List) {
              files = decoded.map((fileJson) {
                final fileModel = TaskflowFileModel.fromJson(
                    fileJson as Map<String, dynamic>);
                return TaskReportFileEntity(
                  id: fileModel.id,
                  url: fileModel.url,
                  filename: fileModel.name,
                  extension: _getFileExtension(fileModel.name),
                  sizeInBytes: fileModel.size,
                );
              }).toList();
            }
          } catch (e) {
            // Log do erro para debug em desenvolvimento
            files = [];
          }
        }

        return TaskReportAnswerEntity(
          id: answer.questionId,
          questionId: answer.questionId,
          type: TaskReportAnswerType.file,
          files: files,
          answeredAt: answer.updatedAt != null
              ? _formatTimestamp(answer.updatedAt!)
              : null,
          questionName: question.name,
        );
    }
  }

  String _formatDateTime(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDateTime;
    }
  }

  String _formatTimestamp(int timestamp) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp.toString();
    }
  }

  String _getFileExtension(String filename) {
    final dotIndex = filename.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < filename.length - 1) {
      return filename.substring(dotIndex + 1).toLowerCase();
    }
    return '';
  }

  @override
  Future<Try<SubmitFormResponseEntity>> submitForm(
      SubmitFormRequestEntity request) async {
    try {
      final requestModel = SubmitFormAdapter.toModel(request);
      final responseModel = await remoteDataSource.submitForm(requestModel);
      return Success(SubmitFormAdapter.toEntity(responseModel));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ScheduleEventHistoryEntity>> getScheduleEventHistory(
      String eventId) async {
    try {
      final model = await remoteDataSource.getScheduleEventHistory(eventId);
      final entity = ScheduleEventHistoryEntity(
        timeDescription: model.data?.timeDescription ?? '',
        timeStart: model.data?.timeStart ?? '',
        name: model.data?.name ?? '',
        localOrAsset: model.data?.localOrAsset ?? '',
        dtStart: model.data?.dtStart ?? '',
        until: model.data?.until ?? '',
        items: model.data?.items
                ?.map((item) => ScheduleEventHistoryItemEntity(
                      dtStart: item.dtStart ?? '',
                      status: item.status ?? '',
                      until: item.until ?? '',
                      activityType: item.activityType,
                      descriptionActivityType: item.descriptionActivityType,
                      subjectName: item.subjectName,
                      updatedAt: item.updatedAt,
                      updatedAtFormatted: item.updatedAtFormatted,
                      responsibleId: item.responsibleId,
                      responsibleName: item.responsibleName,
                    ))
                .toList() ??
            [],
        allDay: model.data?.allDay ?? false,
      );
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Try<List<ChatChannelEntity>>> filterChatChannels({
    String? dtStart,
    String? untilDate,
    String? display,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? status,
    List<String>? typeTask,
  }) async {
    try {
      final request = FilterChatChannelsRequestModel(
        dtStart: dtStart,
        untilDate: untilDate,
        display: display,
        dayCurrent: dayCurrent,
        responsibleIds: responsibleIds,
        assetIds: assetIds,
        status: status,
        typeTask: typeTask,
      );
      final result = await remoteDataSource.filterChatChannels(request);
      final entities = result.data.map((model) => model.toEntity()).toList();
      return Success(entities);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ChatMessagesResponseEntity>> getChatMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  }) async {
    try {
      final result = await remoteDataSource.getChatMessages(
        channelId: channelId,
        before: before,
        after: after,
        limit: limit,
      );
      final entities = result.data.map((model) => model.toEntity()).toList();
      final response = ChatMessagesResponseEntity(
        messages: entities,
        currentUserId: result.currentUserId,
      );
      return Success(response);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ChatMessageEntity>> sendChatMessage({
    required String channelId,
    required String content,
  }) async {
    try {
      // Formatar data no padrão dd/MM/yyyy HH:mm:ss
      final now = DateTime.now();
      final sentAt =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final request = SendChatMessageRequestModel(
        channelId: channelId,
        content: content,
        messageType: 'TEXT',
        sentAt: sentAt,
      );
      final result = await remoteDataSource.sendChatMessage(request);
      final entity = result.toEntity();
      return Success(entity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ChatChannelEntity>> createChatChannel({
    required String taskId,
  }) async {
    try {
      final request = CreateChatChannelRequestModel(taskId: taskId);
      final response = await remoteDataSource.createChatChannel(request);

      // Buscar o canal criado para ter todos os dados
      final filterRequest = FilterChatChannelsRequestModel();
      final channels = await remoteDataSource.filterChatChannels(filterRequest);
      final channel =
          channels.data.firstWhere((c) => c.id == response.channelId);
      final entity = channel.toEntity();
      return Success(entity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
