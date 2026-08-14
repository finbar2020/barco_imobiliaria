import 'dart:convert';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/maintenance_management/data/exceptions/maintenance_management_api_exception.dart';
import 'package:lello/feature/maintenance_management/data/model/event_details_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_details_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_summary_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_formularies_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_files_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_history_response_model.dart';
import '../model/condominium_info_model.dart';
import '../model/create_task_from_schedule_request_model.dart';
import '../model/create_task_from_schedule_response_model.dart';
import '../model/maintenance_task_events_response_model.dart';
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
import '../model/locals_lookup_model.dart';
import '../model/assets_lookup_model.dart';
import '../model/create_task_request_model.dart';
import '../model/create_task_response_model.dart';
import '../model/calendar_days_response_model.dart';
import '../model/schedule_events_detail_response_model.dart';
import '../model/edit_schedule_event_request_model.dart';
import '../model/delete_schedule_event_request_model.dart';
import '../model/taskflow_event_model.dart';
import '../model/submit_form_request_model.dart';
import '../model/submit_form_response_model.dart';
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
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';

import '../../api/maintenance_management_api.dart';
import 'maintenance_management_remote_data_source.dart';

class MaintenanceManagementRemoteDataSourceImpl
    implements MaintenanceManagementRemoteDataSource {
  final MaintenanceManagementApi api;

  MaintenanceManagementRemoteDataSourceImpl(this.api);

  @override
  Future<CondominiumInfoModel> getCondominiumInfo() {
    return api.getCondominiumInfo().then((response) {
      if (response.isSuccessful) {
        final model = ApiMapper.map(response, (json) {
          final condominiumModel = CondominiumInfoModel.fromJson(json);
          return condominiumModel;
        });
        return model;
      } else {
        // Parse error response body to extract error_code
        try {
          final errorBody = jsonDecode(response.bodyString);
          final errorCode = errorBody['error_code'] ?? '';
          final errorMessage = errorBody['message'] ?? 'Unknown error';
          // Throw MaintenanceManagementApiException with error_code as separate field
          throw MaintenanceManagementApiException(errorCode, errorMessage);
        } catch (e) {
          // If e is already MaintenanceManagementApiException, rethrow it
          if (e is MaintenanceManagementApiException) rethrow;
          // Fallback to original error handling if JSON parsing fails
          throw Exception(
              (response.error as ApiFailure?)?.detail ?? 'Unknown error');
        }
      }
    });
  }

  @override
  Future<CondominiumInfoModel> getCondominiumInfoV2() {
    return api.getCondominiumInfoV2('v2').then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => CondominiumInfoModel.fromJson(json));
      } else {
        try {
          final errorBody = jsonDecode(response.bodyString);
          final errorCode =
              errorBody['error_code'] ?? errorBody['errorCode'] ?? '';
          final errorMessage = errorBody['message'] ?? 'Unknown error';
          throw MaintenanceManagementApiException(errorCode, errorMessage);
        } catch (e) {
          if (e is MaintenanceManagementApiException) rethrow;
          throw Exception(
              (response.error as ApiFailure?)?.detail ?? 'Unknown error');
        }
      }
    });
  }

  @override
  Future<MaintenanceTaskEventsResponseModel> getMaintenanceTaskEvents(
    MaintenanceTaskEventsRequestModel request,
  ) {
    return api
        .getMaintenanceTaskEvents(
            request.filters.typeTask,
            request.filters.status,
            request.dtstart,
            request.untilDate,
            request.filters.dayCurrent,
            assetIds: request.filters.assetIds.isNotEmpty
                ? request.filters.assetIds
                : null,
            localIds: request.filters.localIds.isNotEmpty
                ? request.filters.localIds
                : null,
            responsibleIds: request.filters.responsibleIds.isNotEmpty
                ? request.filters.responsibleIds
                : null,
            pageName: request.pageName,
            isLogQuery: false)
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response,
            (json) => MaintenanceTaskEventsResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
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
  }) {
    return api
        .getScheduleEvents(
      dtStart: dtStart,
      untilDate: untilDate,
      dayCurrent: dayCurrent,
      typeTask: typeTask,
      status: status,
      assetIds: assetIds,
      localIds: localIds,
      responsibleIds: responsibleIds,
      pageName: pageName,
    )
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response,
            (json) => ScheduleEventsDetailResponseModel.fromJson(json));
      } else {
        if (response.error is ApiFailure) {
          throw Exception((response.error as ApiFailure).detail);
        }
        throw Exception((response.error as ApiFailure).detail);
      }
    }).catchError((error, stackTrace) {
      throw error;
    });
  }

  @override
  Future<EfficiencyResponseModel> getMaintenanceTasksEfficiency(
    EfficiencyRequestModel request,
  ) {
    return api.getMaintenanceTasksEfficiency(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => EfficiencyResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<FilterOptionsModel> getMaintenanceTasksFilterOptions() {
    return api.getMaintenanceTasksFilterOptions().then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => FilterOptionsModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<LegalObligationResponseModel> getLegalObligations(String type) {
    return api.getLegalObligations(type, 'v2').then((response) {
      if (response.isSuccessful) {
        final model = ApiMapper.map(
          response,
          (json) => LegalObligationResponseModel.fromJson(json),
        );

        if (!model.success) {
          throw Exception(model.message ?? 'Erro ao obter obrigacoes legais');
        }

        return model;
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<XFile> downloadLegalObligationFile(String id, String type) async {
    final response = await api.downloadLegalObligationFile(id, type);
    if (!response.isSuccessful || response.body == null) {
      throw Exception('Failed to download legal obligation file');
    }

    Directory dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final File file =
        File("${dir.path}/legal-obligation-$id-$type-$timestamp.pdf");

    file.createSync();

    try {
      final responseBody = response.body;

      // Keep a fallback in case the API switches back to returning base64 JSON
      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        final base64Data = responseBody['data'] as String;
        await file.writeAsBytes(base64.decode(base64Data));
      } else {
        // Write raw bytes directly since the API returns application/pdf
        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      throw Exception('Erro ao processar arquivo: $e');
    }

    return XFile(file.path);
  }

  @override
  Future<UrlUploadS3Model> getLegalObligationUploadUrl(String condoId) async {
    final response = await api.getLegalObligationUploadUrl(condoId);
    return ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
  }

  @override
  Future<UploadLegalObligationResponseModel> uploadLegalObligationFile(
    UploadLegalObligationRequestModel request,
  ) {
    return api.uploadLegalObligationFile(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response,
            (json) => UploadLegalObligationResponseModel.fromJson(json));
      } else {
        try {
          final errorBody = jsonDecode(response.bodyString);
          final errorCode =
              errorBody['error_code'] ?? errorBody['errorCode'] ?? '';
          final errorMessage = errorBody['message'] ?? 'Unknown error';
          throw MaintenanceManagementApiException(errorCode, errorMessage);
        } catch (e) {
          if (e is MaintenanceManagementApiException) rethrow;
          throw Exception(
              (response.error as ApiFailure?)?.detail ?? 'Unknown error');
        }
      }
    });
  }

  @override
  Future<bool> requestLegalObligationRenewal({
    required String id,
    required String type,
  }) {
    return api.requestLegalObligationRenewal(id, type).then((response) {
      Map<String, dynamic> body = const {};

      try {
        if (response.body is Map<String, dynamic>) {
          body = response.body as Map<String, dynamic>;
        } else if ((response.bodyString ?? '').isNotEmpty) {
          body = jsonDecode(response.bodyString) as Map<String, dynamic>;
        }
      } catch (_) {
        // Ignore parsing error and fallback to generic handling below.
      }

      final success = body['success'] as bool? ?? response.isSuccessful;
      if (response.isSuccessful && success) {
        return true;
      }

      final message = body['message']?.toString();
      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      if (response.error is ApiFailure) {
        final detail = (response.error as ApiFailure).detail;
        if (detail != null && detail.isNotEmpty) {
          throw Exception(detail);
        }
      }

      throw Exception('Erro ao solicitar renovacao com parceiro');
    });
  }

  @override
  Future<LegalObligationNotifyPartnerResultModel> notifyLegalObligationPartner({
    required String type,
  }) {
    return api.notifyLegalObligationPartner(type).then((response) {
      Map<String, dynamic> body = const {};

      try {
        if (response.body is Map<String, dynamic>) {
          body = response.body as Map<String, dynamic>;
        } else if ((response.bodyString ?? '').isNotEmpty) {
          body = jsonDecode(response.bodyString) as Map<String, dynamic>;
        }
      } catch (_) {
        // Ignore parsing error and fallback to generic handling below.
      }

      final success = body['success'] as bool? ?? response.isSuccessful;
      final message = body['message']?.toString();
      final shouldLockButton = _resolveNotifyPartnerButtonLock(body);

      if (response.isSuccessful) {
        return LegalObligationNotifyPartnerResultModel(
          success: success,
          message: message,
          shouldLockButton: shouldLockButton,
        );
      }

      final fallbackMessage = (response.error is ApiFailure)
          ? (response.error as ApiFailure).detail
          : null;

      return LegalObligationNotifyPartnerResultModel(
        success: success,
        message: message?.isNotEmpty == true
            ? message
            : (fallbackMessage?.isNotEmpty == true
                ? fallbackMessage
                : 'Erro ao notificar parceiro'),
        shouldLockButton: shouldLockButton,
      );
    });
  }


  bool _resolveNotifyPartnerButtonLock(Map<String, dynamic> body) {
    final metadata = body['metadata'];
    if (metadata is Map<String, dynamic>) {
      final requestPartner = metadata['request_partner'];
      if (requestPartner is bool) {
        return requestPartner;
      }
    }

    // Sem metadata válida, mantém botão bloqueado por segurança.
    return true;
  }

  @override
  Future<LegalObligationActivityHistoryResponseModel>
      getLegalObligationActivityHistory({
    required String id,
    required String type,
  }) {
    return api.getLegalObligationActivityHistory(id, type).then((response) {
      if (response.isSuccessful) {
        final model = ApiMapper.map(
          response,
          (json) => LegalObligationActivityHistoryResponseModel.fromJson(json),
        );

        if (!model.success) {
          throw Exception(
              model.message ?? 'Erro ao obter histórico da obrigação legal');
        }

        return model;
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<bool> sendTechnicalInspectionEmail(
    SendTechnicalInspectionEmailRequestModel request,
  ) {
    return api.sendTechnicalInspectionEmail(request.toJson()).then((response) {
      if (response.isSuccessful) {
        final body = jsonDecode(response.bodyString) as Map<String, dynamic>;
        return body['success'] as bool? ?? true;
      } else {
        try {
          final errorBody = jsonDecode(response.bodyString);
          final errorMessage = errorBody['message'] ?? 'Erro ao enviar e-mail';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception((response.error as ApiFailure?)?.detail ??
              'Erro ao enviar e-mail');
        }
      }
    });
  }

  @override
  Future<ProcedureOptionsModel> getProcedureOptions(String typeTask) {
    return api.getProcedureOptions(typeTask).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => ProcedureOptionsModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<FormularyByMonthResponseModel> getFormularyByMonth(
    FormularyByMonthRequestModel request,
  ) {
    final requestJson = request.toJson();

    return api.getFormularyByMonth(requestJson).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => FormularyByMonthResponseModel.fromJson(json));
      } else {
        final apiFailure = response.error as ApiFailure;

        String errorMessage = 'Erro na API de formulários por mês';

        if (apiFailure.detail != null) {
          errorMessage += ': ${apiFailure.detail}';
        }

        errorMessage += ' (HTTP ${response.statusCode})';

        try {
          if (apiFailure.detail != null && apiFailure.detail!.contains('{')) {
            final errorData = jsonDecode(apiFailure.detail!);
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('technicalDetail')) {
                errorMessage +=
                    '\nDetalhes técnicos: ${errorData['technicalDetail']}';
              }
              if (errorData.containsKey('context')) {
                errorMessage += '\nContexto: ${errorData['context']}';
              }
              if (errorData.containsKey('exceptionType')) {
                errorMessage +=
                    '\nTipo de exceção: ${errorData['exceptionType']}';
              }
            }
          }
        } catch (e) {
          // Falha ao analisar o JSON - ignorar
        }

        throw Exception(errorMessage);
      }
    }).catchError((error) {
      throw Exception('Erro inesperado na comunicação com a API: $error');
    });
  }

  @override
  Future<TaskByMonthResponseModel> getTaskByMonth(
    TaskByMonthRequestModel request,
  ) {
    final requestJson = request.toJson();

    return api.getTaskByMonth(requestJson).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskByMonthResponseModel.fromJson(json));
      } else {
        final apiFailure = response.error as ApiFailure;

        String errorMessage = 'Erro na API de tarefas por mês';

        if (apiFailure.detail != null) {
          errorMessage += ': ${apiFailure.detail}';
        }

        errorMessage += ' (HTTP ${response.statusCode})';

        try {
          if (apiFailure.detail != null && apiFailure.detail!.contains('{')) {
            final errorData = jsonDecode(apiFailure.detail!);
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('technicalDetail')) {
                errorMessage +=
                    '\nDetalhes técnicos: ${errorData['technicalDetail']}';
              }
              if (errorData.containsKey('context')) {
                errorMessage += '\nContexto: ${errorData['context']}';
              }
              if (errorData.containsKey('exceptionType')) {
                errorMessage +=
                    '\nTipo de exceção: ${errorData['exceptionType']}';
              }
            }
          }
        } catch (e) {
          // Falha ao analisar o JSON - ignorar
        }

        throw Exception(errorMessage);
      }
    }).catchError((error) {
      throw Exception('Erro inesperado na comunicação com a API: $error');
    });
  }

  @override
  Future<TaskBySectorResponseModel> getTaskBySector(
    TaskBySectorRequestModel request,
  ) {
    final requestJson = request.toJson();

    return api.getTaskBySector(requestJson).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskBySectorResponseModel.fromJson(json));
      } else {
        final apiFailure = response.error as ApiFailure;

        String errorMessage = 'Erro na API de tarefas por setor';

        if (apiFailure.detail != null) {
          errorMessage += ': ${apiFailure.detail}';
        }

        errorMessage += ' (HTTP ${response.statusCode})';

        try {
          if (apiFailure.detail != null && apiFailure.detail!.contains('{')) {
            final errorData = jsonDecode(apiFailure.detail!);
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('technicalDetail')) {
                errorMessage +=
                    '\nDetalhes técnicos: ${errorData['technicalDetail']}';
              }
              if (errorData.containsKey('context')) {
                errorMessage += '\nContexto: ${errorData['context']}';
              }
              if (errorData.containsKey('exceptionType')) {
                errorMessage +=
                    '\nTipo de exceção: ${errorData['exceptionType']}';
              }
            }
          }
        } catch (e) {
          // Falha ao analisar o JSON - ignorar
        }

        throw Exception(errorMessage);
      }
    }).catchError((error) {
      throw Exception('Erro inesperado na comunicação com a API: $error');
    });
  }

  @override
  Future<TaskByLocalResponseModel> getTaskByLocal(
    TaskByLocalRequestModel request,
  ) {
    final requestJson = request.toJson();

    return api.getTaskByLocal(requestJson).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskByLocalResponseModel.fromJson(json));
      } else {
        final apiFailure = response.error as ApiFailure;

        String errorMessage = 'Erro na API de tarefas por local';

        if (apiFailure.detail != null) {
          errorMessage += ': ${apiFailure.detail}';
        }

        errorMessage += ' (HTTP ${response.statusCode})';

        try {
          if (apiFailure.detail != null && apiFailure.detail!.contains('{')) {
            final errorData = jsonDecode(apiFailure.detail!);
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('technicalDetail')) {
                errorMessage +=
                    '\nDetalhes técnicos: ${errorData['technicalDetail']}';
              }
              if (errorData.containsKey('context')) {
                errorMessage += '\nContexto: ${errorData['context']}';
              }
              if (errorData.containsKey('exceptionType')) {
                errorMessage +=
                    '\nTipo de exceção: ${errorData['exceptionType']}';
              }
            }
          }
        } catch (e) {
          // Falha ao analisar o JSON - ignorar
        }

        throw Exception(errorMessage);
      }
    }).catchError((error) {
      throw Exception('Erro inesperado na comunicação com a API: $error');
    });
  }

  @override
  Future<TaskByAssetResponseModel> getTaskByAsset(
    TaskByAssetRequestModel request,
  ) {
    final requestJson = request.toJson();

    return api.getTaskByAsset(requestJson).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskByAssetResponseModel.fromJson(json));
      } else {
        final apiFailure = response.error as ApiFailure;

        String errorMessage = 'Erro na API de tarefas por equipamento';

        if (apiFailure.detail != null) {
          errorMessage += ': ${apiFailure.detail}';
        }

        errorMessage += ' (HTTP ${response.statusCode})';

        try {
          if (apiFailure.detail != null && apiFailure.detail!.contains('{')) {
            final errorData = jsonDecode(apiFailure.detail!);
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('technicalDetail')) {
                errorMessage +=
                    '\nDetalhes técnicos: ${errorData['technicalDetail']}';
              }
              if (errorData.containsKey('context')) {
                errorMessage += '\nContexto: ${errorData['context']}';
              }
              if (errorData.containsKey('exceptionType')) {
                errorMessage +=
                    '\nTipo de exceção: ${errorData['exceptionType']}';
              }
            }
          }
        } catch (e) {
          // Falha ao analisar o JSON - ignorar
        }

        throw Exception(errorMessage);
      }
    }).catchError((error) {
      throw Exception('Erro inesperado na comunicação com a API: $error');
    });
  }

  @override
  Future<LocalsLookupModel> getLocalsLookup(String procedureIds) {
    return api.getLocalsLookup(procedureIds).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => LocalsLookupModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<AssetsLookupModel> getAssetsLookup(String procedureIds) {
    return api.getAssetsLookup(procedureIds).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => AssetsLookupModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<TaskSummaryModel> getTaskSummary(String dtStart, String untilDate) {
    return api.getTaskSummary(dtStart, untilDate).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskSummaryModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<CreateTaskResponseModel> createTask(CreateTaskRequestModel request) {
    return api.createTask(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => CreateTaskResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<CreateTaskFromScheduleResponseModel> createTaskFromSchedule(
      CreateTaskFromScheduleRequestModel request) {
    return api.createTaskFromSchedule(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response,
            (json) => CreateTaskFromScheduleResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<CalendarDaysResponseModel> getCalendarDays(
    int month,
    int year, {
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  }) {
    // Calcula o primeiro e último dia do mês
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);

    // Tenta formato mais simples apenas com data (sem horário)
    final dtStart =
        "${firstDayOfMonth.year.toString().padLeft(4, '0')}-${firstDayOfMonth.month.toString().padLeft(2, '0')}-${firstDayOfMonth.day.toString().padLeft(2, '0')}";
    final untilDate =
        "${lastDayOfMonth.year.toString().padLeft(4, '0')}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}";

    return api
        .getCalendarDays(
      month,
      year,
      dtStart,
      untilDate,
      typeTask,
      status,
      assetIds,
      localIds,
      responsibleIds,
    )
        .then((response) {
      if (response.isSuccessful) {
        final responseData = response.body;

        if (responseData is List) {
          return CalendarDaysResponseModel.fromTasksArray(
              responseData, month, year);
        } else if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('days') && responseData['days'] is List) {
            return CalendarDaysResponseModel.fromDaysArray(
                responseData['days'] as List<dynamic>, month, year);
          }

          // Verifica se o Map tem a estrutura esperada (month, year, days)
          if (responseData.containsKey('month') &&
              responseData.containsKey('year') &&
              responseData.containsKey('days')) {
            return CalendarDaysResponseModel.fromJson(responseData);
          } else {
            // Procura por um campo que possa conter a lista de tarefas
            List<dynamic>? tasksList;

            if (responseData.containsKey('data')) {
              final dataField = responseData['data'];

              if (dataField is Map<String, dynamic> &&
                  dataField.containsKey('days')) {
                final daysList = dataField['days'];

                if (daysList is List) {
                  return CalendarDaysResponseModel.fromDaysArray(
                      daysList, month, year);
                } else {}
              } else if (dataField is List) {
                // A estrutura é uma lista de dias, cada dia tem um campo "tasks"
                // Vamos extrair as informações dos dias diretamente
                return CalendarDaysResponseModel.fromDaysArray(
                    dataField, month, year);
              } else {}
            }

            if (responseData.containsKey('tasks') &&
                responseData['tasks'] is List) {
              tasksList = responseData['tasks'] as List<dynamic>;
            } else if (responseData.containsKey('events') &&
                responseData['events'] is List) {
              tasksList = responseData['events'] as List<dynamic>;
            } else if (responseData.containsKey('items') &&
                responseData['items'] is List) {
              tasksList = responseData['items'] as List<dynamic>;
            } else {
              if (responseData.containsKey('dtStart') ||
                  responseData.containsKey('date')) {
                tasksList = [responseData];
              }
            }

            if (tasksList != null) {
              return CalendarDaysResponseModel.fromTasksArray(
                  tasksList, month, year);
            } else {
              // Retorna calendário vazio
              return CalendarDaysResponseModel(
                month: month,
                year: year,
                days: [],
              );
            }
          }
        } else {
          throw Exception(
              'Formato de resposta inesperado do endpoint calendar');
        }
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
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
  }) {
    return api
        .getScheduleEvents(
      dtStart: dtStart,
      untilDate: untilDate,
      dayCurrent: dayCurrent,
      typeTask: typeTask,
      status: status,
      assetIds: assetIds,
      localIds: localIds,
      responsibleIds: responsibleIds,
      pageName: pageName,
    )
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response,
            (json) => ScheduleEventsDetailResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<TaskDetailsModel> getTaskDetails(String taskId) {
    return api.getTaskDetails(taskId).then((response) {
      if (response.isSuccessful) {
        try {
          final result = ApiMapper.map(
              response, (json) => TaskDetailsModel.fromJson(json));
          return result;
        } catch (e) {
          throw e;
        }
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    }).onError((error, stackTrace) {
      throw error!;
    });
  }

  TaskDetailsModel _getMockTaskDetailsWithCompletedFormulary() {
    return TaskDetailsModel(
      id: 'mock-task-for-report',
      name: 'Tarefa Mock para Teste de Relatório',
      status: 'ACTIVE',
      typeTask: 'MANUTENCAO',
      currentFormularyId: 'mock-formulary-001',
      currentFormularyName: 'Formulário de Execução Concluído',
      currentResponsibleId: 'user-123',
      currentResponsibleName: 'João Silva',
      currentResponsibleType: 'EMPLOYEE',
      localAndAsset: 'Área Comum - Piscina',
      createdAt:
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      currentFormulary: TaskDetailsFormularyModel(
        id: 'mock-formulary-001',
        name: 'Formulário de Execução Concluído',
        position: 1,
        enabled: true,
      ),
    );
  }

  @override
  Future<TaskFormulariesResponseModel> getTaskFormularies(String taskId) {
    return api.getTaskFormularies(taskId).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskFormulariesResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<TaskFilesResponseModel> getTaskFiles(String taskId) {
    return api.getTaskFiles(taskId).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => TaskFilesResponseModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<Map<String, dynamic>> editScheduleEvent(
      EditScheduleEventRequestModel request) {
    return api.editScheduleEvent(false, request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response, (json) => json);
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<Map<String, dynamic>> deleteScheduleEvent(
      DeleteScheduleEventRequestModel request) {
    return api
        .deleteScheduleEvent(false, request.scheduleEventId, request.mode)
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(response, (json) => json);
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<EventDetailsModel> getEventDetails(String eventId) {
    return api.getEventDetails(eventId).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
            response, (json) => EventDetailsModel.fromJson(json));
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<TaskflowEventModel> getTaskflowEvent(String eventId) async {
    try {
      final response = await api.getTaskflowEvent(eventId);

      if (response.isSuccessful && response.body != null) {
        try {
          final responseModel = TaskflowEventResponseModel.fromJson(
              response.body as Map<String, dynamic>);
          final taskflowEvent = responseModel.data;
          return taskflowEvent;
        } catch (e) {
          throw Exception('Failed to parse taskflow event response: $e');
        }
      } else {
        throw Exception(
            'Failed to load taskflow event. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get taskflow event: $e');
    }
  }

  @override
  Future<SubmitFormResponseModel> submitForm(
      SubmitFormRequestModel request) async {
    return api.submitForm(false, request.toJson()).then((response) {
      if (response.isSuccessful) {
        try {
          final result = ApiMapper.map(
              response, (json) => SubmitFormResponseModel.fromJson(json));
          return result;
        } catch (e) {
          rethrow;
        }
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<ScheduleEventHistoryResponseModel> getScheduleEventHistory(
      String eventId) async {
    try {
      final response = await api.getScheduleEventHistory(eventId);

      if (response.isSuccessful && response.body != null) {
        try {
          return ScheduleEventHistoryResponseModel.fromJson(
              response.body as Map<String, dynamic>);
        } catch (e) {
          throw Exception(
              'Failed to parse schedule event history response: $e');
        }
      } else {
        throw Exception(
            'Failed to load schedule event history. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get schedule event history: $e');
    }
  }

  @override
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
  }) {
    return api
        .getChannels(
      dayCurrent: dayCurrent,
      status: status,
      typeTask: typeTask,
      assetIds: assetIds,
      localIds: localIds,
      responsibleIds: responsibleIds,
      first: first,
      after: after,
      before: before,
      last: last,
      isLogQuery: isLogQuery,
    )
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
          response,
          (json) => ChatChannelsResponseModel.fromJson(json),
        );
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<ChatChannelsResponseModel> filterChatChannels(
    FilterChatChannelsRequestModel request,
  ) {
    return api.filterChatChannels(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
          response,
          (json) => ChatChannelsResponseModel.fromJson(json),
        );
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<ChatMessagesResponseModel> getChatMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  }) {
    return api
        .getChatMessages(channelId, before: before, after: after, limit: limit)
        .then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
          response,
          (json) => ChatMessagesResponseModel.fromJson(json),
        );
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<ChatMessageModel> sendChatMessage(
    SendChatMessageRequestModel request,
  ) {
    return api.sendChatMessage(request.toJson()).then((response) {
      if (response.isSuccessful) {
        // A API retorna o ID da mensagem no campo 'data'
        // Precisamos construir um ChatMessageModel com os dados que temos
        final messageId =
            ApiMapper.map(response, (json) => json['data'] as String);

        // Criar modelo com dados do request + ID retornado
        return ChatMessageModel(
          id: messageId,
          content: request.content,
          channelId: request.channelId,
          authorId: null, // Será preenchido pelo backend
          messageType: request.messageType,
          createdAt: request.sentAt,
          author: const ChatAuthorModel(
            id: 'current_user',
            name: 'Você',
            email: '',
            imageUrl: null,
            username: null,
            status: null,
            profile: null,
          ),
          attachment: null,
        );
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<CreateChatChannelResponseModel> createChatChannel(
    CreateChatChannelRequestModel request,
  ) {
    return api.createChatChannel(request.toJson()).then((response) {
      if (response.isSuccessful) {
        return ApiMapper.map(
          response,
          (json) => CreateChatChannelResponseModel.fromJson(json),
        );
      } else {
        throw Exception((response.error as ApiFailure).detail);
      }
    });
  }

  @override
  Future<Response> resetScheduleEvent(String scheduleEventId) {
    return api.resetScheduleEvent(scheduleEventId);
  }
}
