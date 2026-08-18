import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:cross_file/cross_file.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/maintenance_management/data/data_source/maintenance_management_remote_data_source.dart';
import 'package:lello/feature/maintenance_management/data/model/assets_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_days_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_channel_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_message_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/create_chat_channel_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/filter_chat_channels_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/send_chat_message_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/condominium_info_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/delete_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/edit_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/event_details_model.dart';
import 'package:lello/feature/maintenance_management/data/model/filter_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_activity_history_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_notify_partner_result_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/locals_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/origin_answer_model.dart';
import 'package:lello/feature/maintenance_management/data/model/procedure_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_history_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_events_detail_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/send_technical_inspection_email_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_details_model.dart'
    hide ParentScheduleEventModel;
import 'package:lello/feature/maintenance_management/data/model/task_files_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_formularies_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_summary_model.dart';
import 'package:lello/feature/maintenance_management/data/model/taskflow_event_model.dart';
import 'package:lello/feature/maintenance_management/data/model/upload_legal_obligation_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/upload_legal_obligation_response_model.dart';
import 'package:lello/feature/maintenance_management/data/repository/maintenance_management_repository_impl.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_from_schedule_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/delete_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/edit_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_history_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/submit_form_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_report_entity.dart';
import 'package:lello/feature/maintenance_management/domain/enum/legal_obligation_type.dart';
import 'package:shared_features/shared_features.dart';

Map<String, dynamic> _condoJson() => {
      'id': 'c1',
      'assets': 2,
      'floor': 'térreo',
      'localsCount': 4,
      'workflowUsers': '3',
      'condominiumName': 'Edifício',
      'blocksCount': 1,
      'unitsCount': 10,
      'hasEmployee': true,
      'tokens': [
        {'fornecedor': 'TRACKING_TRADE', 'token': 'jwt'},
      ],
    };

Map<String, dynamic> _scheduleDetailJson() => {
      'success': true,
      'message': 'ok',
      'legacyStatusCode': 200,
      'data': {
        'taskSummaryDay': {
          'total': 1,
          'done': 1,
          'notStarted': 0,
          'draft': 0,
        },
        'taskFormulary': [
          {'idSchedule': 's1', 'idScheduleEvent': 'e1', 'name': 'Limpeza'},
        ],
        'obligations': [
          {'id': 'o1', 'name': 'AVCB', 'reference': 1},
        ],
      },
    };

ChatChannelsResponseModel _channels() => ChatChannelsResponseModel.fromJson({
      'success': true,
      'data': [
        {
          'id': 'ch1',
          'typeTask': 'ROTINA',
          'status': 'OPEN',
          'task': {'id': 't1', 'name': 'Limpeza'},
        }
      ],
    });

class _FakeRemote extends Fake
    implements MaintenanceManagementRemoteDataSource {
  Object? error;
  bool emptyHistory = false;
  bool mismatchChannel = false;

  T _orThrow<T>(T value) {
    if (error != null) throw error!;
    return value;
  }

  @override
  Future<CondominiumInfoModel> getCondominiumInfo() async =>
      _orThrow(CondominiumInfoModel.fromJson(_condoJson()));

  @override
  Future<CondominiumInfoModel> getCondominiumInfoV2() async =>
      _orThrow(CondominiumInfoModel.fromJson(_condoJson()));

  @override
  Future<UrlUploadS3Model> getLegalObligationUploadUrl(String condoId) async =>
      _orThrow(UrlUploadS3Model(fileName: 'a.pdf', url: 'https://s3'));

  @override
  Future<LegalObligationResponseModel> getLegalObligations(String type) async =>
      _orThrow(LegalObligationResponseModel.fromJson({
        'success': true,
        'message': 'ok',
        'metadata': {'requestPartner': true},
        'data': [
          {
            'id': '1',
            'description': 'AVCB',
            'status': 'PENDING',
            'availableActions': ['NOTIFY'],
          }
        ],
      }));

  @override
  Future<UploadLegalObligationResponseModel> uploadLegalObligationFile(
    UploadLegalObligationRequestModel request,
  ) async =>
      _orThrow(UploadLegalObligationResponseModel(
        success: true,
        link: 'https://s3/a.pdf',
      ));

  @override
  Future<XFile> downloadLegalObligationFile(String id, String type) async =>
      _orThrow(XFile('a.pdf'));

  @override
  Future<LegalObligationActivityHistoryResponseModel>
      getLegalObligationActivityHistory({
    required String id,
    required String type,
  }) async =>
          _orThrow(LegalObligationActivityHistoryResponseModel.fromJson({
            'success': true,
            'data': [
              {
                'collectionCode': 'c1',
                'date': '2026-01-10',
                'description': 'enviado',
                'responsible': 'Ana',
                'status': 'DONE',
              }
            ],
          }));

  @override
  Future<bool> sendTechnicalInspectionEmail(
    SendTechnicalInspectionEmailRequestModel request,
  ) async =>
      _orThrow(true);

  @override
  Future<bool> requestLegalObligationRenewal({
    required String id,
    required String type,
  }) async =>
      _orThrow(true);

  @override
  Future<LegalObligationNotifyPartnerResultModel> notifyLegalObligationPartner({
    required String type,
  }) async =>
      _orThrow(const LegalObligationNotifyPartnerResultModel(
        success: true,
        shouldLockButton: false,
        message: 'ok',
      ));

  @override
  Future<MaintenanceTaskEventsResponseModel> getMaintenanceTaskEvents(
    MaintenanceTaskEventsRequestModel request,
  ) async =>
      _orThrow(MaintenanceTaskEventsResponseModel(
        taskSummaryDay:
            TaskSummaryModel(total: 1, done: 1, notStarted: 0, draft: 0),
        taskFormulary: const [],
      ));

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
  }) async =>
      _orThrow(ScheduleEventsDetailResponseModel.fromJson(_scheduleDetailJson()));

  @override
  Future<EfficiencyResponseModel> getMaintenanceTasksEfficiency(
    EfficiencyRequestModel request,
  ) async =>
      _orThrow(EfficiencyResponseModel.fromJson({
        'efficiency_response': [
          {'id': 'g1', 'name': 'Grupo', 'done': 1, 'not_started': 2, 'draft': 0}
        ],
        'task_summary': {'total': 3, 'done': 1, 'notStarted': 2, 'draft': 0},
      }));

  @override
  Future<FilterOptionsModel> getMaintenanceTasksFilterOptions() async =>
      _orThrow(FilterOptionsModel.fromJson({
        'locals': [
          {'id': 'l1', 'name': 'Hall'}
        ],
        'assets': [
          {'id': 'a1', 'name': 'Bomba'}
        ],
        'responsibles': [
          {'id': 'r1', 'name': 'Maria'}
        ],
        'employee_group': [
          {'id': 'g1', 'name': 'Manutenção'}
        ],
      }));

  @override
  Future<ProcedureOptionsModel> getProcedureOptions(String typeTask) async =>
      _orThrow(ProcedureOptionsModel.fromJson({
        'procedure_options': [
          {
            'id': 1,
            'title': 'Limpeza',
            'first_responsible': {'id': 'u1', 'name': 'João'},
          }
        ],
      }));

  @override
  Future<FormularyByMonthResponseModel> getFormularyByMonth(
    FormularyByMonthRequestModel request,
  ) async =>
      _orThrow(FormularyByMonthResponseModel.fromJson({
        'formularyByMonthDTO': [
          {
            'name': 'Rotina',
            'data': [
              {'key': 'ok', 'value': 1}
            ],
          }
        ],
        'totalConcluidos': 1,
        'totalNaoConcluidos': 0,
        'totalGeral': 1,
      }));

  @override
  Future<TaskByMonthResponseModel> getTaskByMonth(
    TaskByMonthRequestModel request,
  ) async =>
      _orThrow(TaskByMonthResponseModel.fromJson({
        'formularyByMonthDTO': [
          {
            'name': 'Jan',
            'data': [
              {'key': 'done', 'value': 2}
            ],
          }
        ],
        'totalConcluidos': 2,
        'totalNaoConcluidos': 0,
        'totalGeral': 2,
      }));

  @override
  Future<TaskBySectorResponseModel> getTaskBySector(
    TaskBySectorRequestModel request,
  ) async =>
      _orThrow(TaskBySectorResponseModel.fromJson({
        'data': [
          {'id': 's1', 'name': 'Elétrica', 'value': 4, 'color': '#fff'}
        ],
      }));

  @override
  Future<TaskByLocalResponseModel> getTaskByLocal(
    TaskByLocalRequestModel request,
  ) async =>
      _orThrow(TaskByLocalResponseModel.fromJson({
        'data': [
          {
            'id': 'l1',
            'name': 'Hall',
            'done': 1,
            'draft': 0,
            'not_started': 2,
            'total': 3,
          }
        ],
      }));

  @override
  Future<TaskByAssetResponseModel> getTaskByAsset(
    TaskByAssetRequestModel request,
  ) async =>
      _orThrow(TaskByAssetResponseModel.fromJson({
        'data_task_by_asset_response': [
          {
            'id': '12',
            'name': 'Bomba',
            'done': 1,
            'draft': 0,
            'not_started': 1,
            'total': 2,
          }
        ],
      }));

  @override
  Future<LocalsLookupModel> getLocalsLookup(String procedureIds) async =>
      _orThrow(LocalsLookupModel.fromJson({
        'locals': [
          {'id': 'l1', 'name': 'Hall', 'hierarchy_locals': 'Bloco A'}
        ],
      }));

  @override
  Future<AssetsLookupModel> getAssetsLookup(String procedureIds) async =>
      _orThrow(AssetsLookupModel.fromJson({
        'assets': [
          {'id': 'a1', 'name': 'Bomba'}
        ],
      }));

  @override
  Future<TaskSummaryModel> getTaskSummary(String dtStart, String untilDate) async =>
      _orThrow(TaskSummaryModel(total: 2, done: 1, notStarted: 1, draft: 0));

  @override
  Future<CreateTaskResponseModel> createTask(
    CreateTaskRequestModel request,
  ) async =>
      _orThrow(CreateTaskResponseModel(
        idSchedule: 's1',
        idScheduleEvents: const ['e1'],
      ));

  @override
  Future<CreateTaskFromScheduleResponseModel> createTaskFromSchedule(
    CreateTaskFromScheduleRequestModel request,
  ) async =>
      _orThrow(CreateTaskFromScheduleResponseModel.fromJson({
        'task': {'id': 't1', 'name': 'Limpeza'},
        'event': {'id': 'e1', 'name': 'Evento'},
      }));

  @override
  Future<CalendarDaysResponseModel> getCalendarDays(
    int month,
    int year, {
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  }) async =>
      _orThrow(CalendarDaysResponseModel.fromJson({
        'month': month,
        'year': year,
        'days': [
          {'day': 10, 'hasEvents': true, 'taskCount': 2}
        ],
      }));

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
  }) async =>
      _orThrow(ScheduleEventsDetailResponseModel.fromJson(_scheduleDetailJson()));

  @override
  Future<TaskDetailsModel> getTaskDetails(String taskId) async =>
      _orThrow(TaskDetailsModel.fromJson({
        'id': taskId,
        'name': 'Limpeza',
        'status': 'PENDING',
        'type_task': 'ROTINA',
      }));

  @override
  Future<TaskFormulariesResponseModel> getTaskFormularies(String taskId) async =>
      _orThrow(TaskFormulariesResponseModel.fromJson({
        'formularies': [
          {'name': 'Form', 'status': 'DONE', 'position': 1, 'can_start': true}
        ],
      }));

  @override
  Future<TaskFilesResponseModel> getTaskFiles(String taskId) async =>
      _orThrow(TaskFilesResponseModel.fromJson({
        'files': [
          {
            'id': 'f1',
            'task_id': taskId,
            'url': 'https://s3',
            'filename': 'a.png',
            'created_at': '2026-01-10',
            'author_id': 'u1',
            'extension': 'png',
          }
        ],
      }));

  @override
  Future<Map<String, dynamic>> editScheduleEvent(
    EditScheduleEventRequestModel request,
  ) async =>
      _orThrow({'success': true, 'message': 'ok'});

  @override
  Future<Map<String, dynamic>> deleteScheduleEvent(
    DeleteScheduleEventRequestModel request,
  ) async =>
      _orThrow({'success': true, 'message': 'ok'});

  @override
  Future<Response> resetScheduleEvent(String scheduleEventId) async =>
      _orThrow(Response(http.Response('{}', 200), {
        'success': true,
        'message': 'ok',
      }));

  @override
  Future<EventDetailsModel> getEventDetails(String eventId) async =>
      _orThrow(EventDetailsModel(id: eventId));

  @override
  Future<TaskflowEventModel> getTaskflowEvent(String eventId) async =>
      _orThrow(_taskflow(eventId));

  @override
  Future<SubmitFormResponseModel> submitForm(
    SubmitFormRequestModel request,
  ) async =>
      _orThrow(SubmitFormResponseModel(success: true, message: 'ok', data: 'd1'));

  @override
  Future<ScheduleEventHistoryResponseModel> getScheduleEventHistory(
    String eventId,
  ) async {
    if (emptyHistory) {
      return _orThrow(const ScheduleEventHistoryResponseModel(
        success: true,
        message: 'ok',
      ));
    }
    return _orThrow(ScheduleEventHistoryResponseModel.fromJson({
        'success': true,
        'message': 'ok',
        'data': {
          'time_description': 'manhã',
          'time_start': '08:00',
          'name': 'Limpeza',
          'local_or_asset': 'Hall',
          'dt_start': '2026-01-10',
          'until': '2026-01-10',
          'all_day': false,
          'items': [
            {
              'dt_start': '2026-01-10',
              'status': 'DONE',
              'activity_type': 'EDIT',
              'subject_name': 'Limpeza',
              'responsible_name': 'Ana',
            }
          ],
        },
      }));
  }

  @override
  Future<ChatChannelsResponseModel> filterChatChannels(
    FilterChatChannelsRequestModel request,
  ) async =>
      _orThrow(_channels());

  @override
  Future<ChatMessagesResponseModel> getChatMessages({
    required String channelId,
    String? before,
    String? after,
    int? limit,
  }) async =>
      _orThrow(ChatMessagesResponseModel.fromJson({
        'success': true,
        'currentUserId': 'u1',
        'cursor': {'hasPreviousPage': false, 'hasNextPage': false},
        'data': [
          {
            'id': 'm1',
            'content': 'olá',
            'createdAt': '10/01/2026 08:30:00',
            'author': {'id': 'u1', 'name': 'Ana', 'email': 'a@b.com'},
          }
        ],
      }));

  @override
  Future<ChatMessageModel> sendChatMessage(
    SendChatMessageRequestModel request,
  ) async =>
      _orThrow(ChatMessageModel.fromJson({
        'id': 'm1',
        'content': request.content,
        'createdAt': request.sentAt,
        'author': {'id': 'u1', 'name': 'Ana', 'email': 'a@b.com'},
      }));

  @override
  Future<CreateChatChannelResponseModel> createChatChannel(
    CreateChatChannelRequestModel request,
  ) async =>
      _orThrow(CreateChatChannelResponseModel(
        channelId: mismatchChannel ? 'missing' : 'ch1',
      ));
}

class _FakeUploader extends Fake implements AwsUploader {
  bool fail = false;

  @override
  Future<String> uploadS3(
    String url,
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    if (fail) {
      onError(Exception('s3'));
    } else {
      onComplete('https://s3/done');
    }
    return 'ok';
  }
}

TaskflowEventModel _taskflow(String eventId) {
  final file = TaskflowFileModel(
    id: 'f1',
    size: 10,
    name: 'foto.png',
    contentType: 'image/png',
    status: 'uploaded',
    bucket: 'b',
    firebaseRef: 'ref',
    localUri: 'file://a',
    uploadTaskId: 'u1',
    deviceId: 'd1',
    url: 'https://s3/a',
  );
  return TaskflowEventModel(
    id: eventId,
    formularyId: 'f1',
    status: 'done',
    responsibleName: 'Ana',
    finishedAt: 'data-invalida',
    createdAt: '2026-01-09T08:00:00.000Z',
    lastContentAnswers: {
      'q-text': TaskflowAnswerModel(
        questionId: 'q-text',
        type: 'TEXT',
        content: 'ok',
        updatedAt: DateTime(2026, 1, 10).millisecondsSinceEpoch,
      ),
      'other-key': TaskflowAnswerModel(
        questionId: 'q-radio',
        type: 'RADIO',
        content: 'o1',
      ),
      'q-select': TaskflowAnswerModel(
        questionId: 'q-select',
        type: 'SELECT',
        content: 'missing',
      ),
      'q-file': TaskflowAnswerModel(
        questionId: 'q-file',
        type: 'FILE',
        content: [file],
      ),
      'q-file-json': TaskflowAnswerModel(
        questionId: 'q-file-json',
        type: 'FILE',
        content:
            '[{"name":"doc.pdf","url":"https://s3/doc.pdf","contentType":"application/pdf","size":20}]',
      ),
      'q-file-bad': TaskflowAnswerModel(
        questionId: 'q-file-bad',
        type: 'FILE',
        content: 'not-json',
      ),
      'q-no-type': TaskflowAnswerModel(
        questionId: 'q-no-type',
        type: 'TEXT',
        content: 'x',
      ),
      'q-many': TaskflowAnswerModel(
        questionId: 'q-many',
        type: 'SELECT',
        content: 'm1',
      ),
      'q-dep': TaskflowAnswerModel(
        questionId: 'q-dep',
        type: 'FILE',
        content: [file],
      ),
      'q-few': TaskflowAnswerModel(
        questionId: 'q-few',
        type: 'RADIO',
        content: 'a',
      ),
      'q-unknown': TaskflowAnswerModel(
        questionId: 'q-unknown',
        type: 'TEXT',
        content: '1',
      ),
      'q-drop': TaskflowAnswerModel(
        questionId: 'q-drop',
        type: 'SELECT',
        content: 'd1',
      ),
      'q-area': TaskflowAnswerModel(
        questionId: 'q-area',
        type: 'TEXT',
        content: 'texto longo',
      ),
      'q-file-noext': TaskflowAnswerModel(
        questionId: 'q-file-noext',
        type: 'FILE',
        content: [
          TaskflowFileModel(
            id: 'f2',
            size: 1,
            name: 'readme',
            contentType: 'text/plain',
            status: 'uploaded',
            bucket: 'b',
            firebaseRef: 'ref',
            localUri: 'file://a',
            uploadTaskId: 'u1',
            deviceId: 'd1',
            url: 'https://s3/a',
          ),
        ],
      ),
      'q-dep-missing': TaskflowAnswerModel(
        questionId: 'q-dep-missing',
        type: 'FILE',
        content: [file],
      ),
    },
    formulary: TaskflowFormularyModel(
      id: 'f1',
      name: 'Checklist',
      questions: [
        TaskflowQuestionModel(
          id: 'q-text',
          name: 'Observação',
          fieldType: 'TEXT',
        ),
        TaskflowQuestionModel(
          id: 'q-radio',
          name: 'OK?',
          fieldType: 'RADIO',
          options: [
            TaskflowQuestionOptionModel(id: 'o1', name: 'Sim'),
            TaskflowQuestionOptionModel(id: 'o2', name: 'Não'),
          ],
        ),
        TaskflowQuestionModel(
          id: 'q-select',
          name: 'Setor',
          fieldType: 'SELECT',
          options: [
            TaskflowQuestionOptionModel(id: 's1', name: 'A'),
          ],
        ),
        TaskflowQuestionModel(
          id: 'q-file',
          name: 'Foto',
          fieldType: 'FILE',
        ),
        TaskflowQuestionModel(
          id: 'q-file-json',
          name: 'Laudo',
          fieldType: 'UPLOAD',
        ),
        TaskflowQuestionModel(
          id: 'q-file-bad',
          name: 'Anexo',
          fieldType: 'FILE',
        ),
        TaskflowQuestionModel(id: 'q-no-type', name: 'Livre'),
        TaskflowQuestionModel(
          id: 'q-few',
          name: 'Poucas',
          options: [
            TaskflowQuestionOptionModel(id: 'a', name: 'A'),
            TaskflowQuestionOptionModel(id: 'b', name: 'B'),
          ],
        ),
        TaskflowQuestionModel(
          id: 'q-many',
          name: 'Muitas',
          options: List.generate(
            6,
            (i) => TaskflowQuestionOptionModel(id: 'm$i', name: 'Op $i'),
          ),
        ),
        TaskflowQuestionModel(
          id: 'q-hidden',
          name: 'Escondida',
          fieldType: 'TEXT',
        ),
        TaskflowQuestionModel(
          id: 'q-dep',
          name: 'Foto condicional',
          fieldType: 'FILE',
        ),
        TaskflowQuestionModel(
          id: 'q-unknown',
          name: 'Outro',
          fieldType: 'NUMBER',
        ),
        TaskflowQuestionModel(
          id: 'q-drop',
          name: 'Dropdown',
          fieldType: 'DROPDOWN',
          options: [
            TaskflowQuestionOptionModel(id: 'd1', name: 'Um'),
          ],
        ),
        TaskflowQuestionModel(
          id: 'q-area',
          name: 'Área',
          fieldType: 'TEXTAREA',
        ),
        TaskflowQuestionModel(
          id: 'q-file-noext',
          name: 'Sem extensão',
          fieldType: 'FILE',
        ),
      ],
      expressions: [
        TaskflowExpressionModel(
          id: 'q-dep',
          factors: [
            TaskflowFactorModel(
              targetValue: 'o1',
              originId: 'q-radio',
              comparisonType: 'EQ',
            ),
          ],
        ),
        TaskflowExpressionModel(
          id: 'q-dep-missing',
          factors: [
            TaskflowFactorModel(
              targetValue: 'o1',
              originId: 'q-radio',
              comparisonType: 'EQUALS',
            ),
          ],
        ),
      ],
    ),
    childTasks: [
      TaskflowChildTaskModel(
        scheduleEventId: 'child-1',
        originAnswer: OriginAnswerModel(id: 'o1', eventId: eventId, questionId: 'q-radio'),
      ),
    ],
  );
}

void main() {
  late _FakeRemote remote;
  late _FakeUploader uploader;
  late MaintenanceManagementRepositoryImpl repo;

  setUp(() {
    remote = _FakeRemote();
    uploader = _FakeUploader();
    repo = MaintenanceManagementRepositoryImpl(remote, uploader);
  });

  test('repositório mapeia condomínio, obrigações, gráficos e agenda', () async {
    expect(await repo.getCondominiumInfo(), isA<Success>());
    expect(await repo.getCondominiumInfoV2(), isA<Success>());
    expect(await repo.getLegalObligationUploadUrl('c1'), isA<Success<UrlUploadS3>>());
    expect(
      await repo.getLegalObligations(LegalObligationType.condominium),
      isA<Success>(),
    );
    expect(
      await repo.uploadLegalObligationFile(
        type: 'PDF',
        id: '1',
        fileName: 'a.pdf',
        fileUrl: 'https://s3',
        date: '2026-01-10',
      ),
      isA<Success>(),
    );
    expect(await repo.downloadLegalObligationFile('1', 'PDF'), isA<Success<XFile>>());
    expect(
      await repo.getLegalObligationActivityHistory(id: '1', type: 'PDF'),
      isA<Success>(),
    );
    expect(
      await repo.sendTechnicalInspectionEmail(
        type: 'PDF',
        id: '1',
        email: 'a@b.com',
      ),
      isA<Success<bool>>(),
    );
    expect(
      await repo.requestLegalObligationRenewal(type: 'PDF', id: '1'),
      isA<Success<bool>>(),
    );
    expect(
      await repo.notifyLegalObligationPartner(type: 'PDF'),
      isA<Success>(),
    );
    expect(
      await repo.getMaintenanceTaskEvents(
        dtstart: '01/01/2026',
        untilDate: '07/01/2026',
        typeTask: const ['ROTINA'],
        status: const ['PENDENTE'],
        dayCurrent: '03/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getScheduleEvents(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getMaintenanceTasksEfficiency(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        typeTask: const ['ROTINA'],
        dayCurrent: '03/01/2026',
        procedureGroupLabels: const [],
        procedureGroupIds: const [],
        responsibleIds: const [],
        displayBy: 'GRUPO',
        status: const ['PENDENTE'],
      ),
      isA<Success>(),
    );
    expect(await repo.getMaintenanceTasksFilterOptions(), isA<Success>());
    expect(await repo.getProcedureOptions('ROTINA'), isA<Success>());
    expect(
      await repo.getFormularyByMonth(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getTaskByMonth(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getTaskBySector(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getTaskByLocal(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Success>(),
    );
    expect(
      await repo.getTaskByAsset(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Success>(),
    );
    expect(await repo.getLocalsLookup('p1'), isA<Success>());
    expect(await repo.getAssetsLookup('p1'), isA<Success>());
    expect(await repo.getTaskSummary('01/01/2026', '31/01/2026'), isA<Success>());
  });

  test('repositório cria, edita, apaga e lista detalhes da tarefa', () async {
    expect(
      await repo.createTask(CreateTaskRequestEntity(
        procedureGroupId: 'g1',
        procedureId: 'p1',
        allDay: true,
        dtStart: '2026-01-10',
        repeat: false,
      )),
      isA<Success>(),
    );
    expect(
      await repo.createTaskFromSchedule(CreateTaskFromScheduleRequestEntity(
        scheduleId: 's1',
        scheduleEventId: 'e1',
      )),
      isA<Success>(),
    );
    expect(
      await repo.getCalendarDays(month: 1, year: 2026),
      isA<Success>(),
    );
    expect(
      await repo.getScheduleEventsDetail(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      isA<Success>(),
    );
    expect(await repo.getTaskDetails('t1'), isA<Success>());
    expect(await repo.getTaskFormularies('t1'), isA<Success>());
    expect(await repo.getTaskFiles('t1'), isA<Success>());
    expect(
      await repo.editScheduleEvent(EditScheduleEventRequestEntity(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '2026-01-10',
        allDay: false,
        repeat: false,
        updateType: 'THIS',
      )),
      isA<Success>(),
    );
    expect(
      await repo.deleteScheduleEvent(const DeleteScheduleEventRequestEntity(
        scheduleEventId: 'e1',
        mode: 'THIS_SCHEDULE_EVENT',
      )),
      isA<Success>(),
    );
    expect(await repo.resetScheduleEvent('e1'), isA<Success>());
    expect(await repo.getEventDetails('e1'), isA<Success>());
    expect(
      await repo.submitForm(SubmitFormRequestEntity(
        eventId: 'e1',
        answers: {
          'q1': AnswerEntity(type: 'TEXT', questionId: 'q1', content: 'ok'),
        },
      )),
      isA<Success>(),
    );
    expect(await repo.getScheduleEventHistory('e1'), isA<Success>());
  });

  test('getTaskReport mapeia perguntas, arquivos e tarefas filhas', () async {
    final result = await repo.getTaskReport('e1');
    expect(result, isA<Success<TaskReportEntity>>());
    final report = (result as Success<TaskReportEntity>).get();
    expect(report.stepName, 'Checklist');
    expect(report.status, 'DONE');
    expect(report.childTasks, isNotEmpty);
    expect(report.questions.any((q) => q.type == TaskReportQuestionType.file),
        isTrue);
    expect(report.questions.any((q) => q.id == 'q-dep'), isFalse);
    expect(
      report.questions
          .firstWhere((q) => q.id == 'q-radio')
          .dependentFileAnswers,
      isNotEmpty,
    );
  });

  test('chat filtra, lista, envia e cria canal', () async {
    expect(await repo.filterChatChannels(dayCurrent: '10/01/2026'), isA<Success>());
    expect(await repo.getChatMessages(channelId: 'ch1'), isA<Success>());
    expect(
      await repo.sendChatMessage(channelId: 'ch1', content: 'oi'),
      isA<Success>(),
    );
    expect(await repo.createChatChannel(taskId: 't1'), isA<Success>());
  });

  test('upload S3 completa e falha', () async {
    expect(await repo.uploadFileToS3(File('a.pdf'), 'https://s3'), isA<Success<String>>());
    uploader.fail = true;
    expect(await repo.uploadFileToS3(File('a.pdf'), 'https://s3'), isA<Rejection<String>>());
  });

  test('histórico vazio e canal inexistente viram sucesso/rejeição', () async {
    remote.emptyHistory = true;
    final history = await repo.getScheduleEventHistory('e1');
    expect(history, isA<Success>());
    expect(
      (history as Success<ScheduleEventHistoryEntity>).get().items,
      isEmpty,
    );

    remote.mismatchChannel = true;
    expect(await repo.createChatChannel(taskId: 't1'), isA<Rejection>());
  });

  test('falha do remote vira Rejection', () async {
    remote.error = Exception('timeout');
    expect(await repo.getCondominiumInfo(), isA<Rejection>());
    expect(await repo.getCondominiumInfoV2(), isA<Rejection>());
    expect(await repo.getLegalObligationUploadUrl('c1'), isA<Rejection>());
    expect(
      await repo.getLegalObligations(LegalObligationType.condominium),
      isA<Rejection>(),
    );
    expect(
      await repo.uploadLegalObligationFile(
        type: 'PDF',
        id: '1',
        fileName: 'a.pdf',
        fileUrl: 'https://s3',
        date: '2026-01-10',
      ),
      isA<Rejection>(),
    );
    expect(await repo.downloadLegalObligationFile('1', 'PDF'), isA<Rejection>());
    expect(
      await repo.getLegalObligationActivityHistory(id: '1', type: 'PDF'),
      isA<Rejection>(),
    );
    expect(
      await repo.sendTechnicalInspectionEmail(
        type: 'PDF',
        id: '1',
        email: 'a@b.com',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.requestLegalObligationRenewal(type: 'PDF', id: '1'),
      isA<Rejection>(),
    );
    expect(await repo.notifyLegalObligationPartner(type: 'PDF'), isA<Rejection>());
    expect(
      await repo.getMaintenanceTaskEvents(
        dtstart: '01/01/2026',
        untilDate: '07/01/2026',
        typeTask: const ['ROTINA'],
        status: const ['PENDENTE'],
        dayCurrent: '03/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getScheduleEvents(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getMaintenanceTasksEfficiency(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        typeTask: const ['ROTINA'],
        dayCurrent: '03/01/2026',
        procedureGroupLabels: const [],
        procedureGroupIds: const [],
        responsibleIds: const [],
        displayBy: 'GRUPO',
        status: const ['PENDENTE'],
      ),
      isA<Rejection>(),
    );
    expect(await repo.getMaintenanceTasksFilterOptions(), isA<Rejection>());
    expect(await repo.getProcedureOptions('ROTINA'), isA<Rejection>());
    expect(
      await repo.getFormularyByMonth(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getTaskByMonth(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getTaskBySector(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getTaskByLocal(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(
      await repo.getTaskByAsset(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(await repo.getLocalsLookup('p1'), isA<Rejection>());
    expect(await repo.getAssetsLookup('p1'), isA<Rejection>());
    expect(await repo.getTaskSummary('01/01/2026', '31/01/2026'), isA<Rejection>());
    expect(
      await repo.createTask(CreateTaskRequestEntity(
        procedureGroupId: 'g1',
        procedureId: 'p1',
        allDay: true,
        dtStart: '2026-01-10',
        repeat: false,
      )),
      isA<Rejection>(),
    );
    expect(
      await repo.createTaskFromSchedule(CreateTaskFromScheduleRequestEntity(
        scheduleId: 's1',
        scheduleEventId: 'e1',
      )),
      isA<Rejection>(),
    );
    expect(await repo.getCalendarDays(month: 1, year: 2026), isA<Rejection>());
    expect(
      await repo.getScheduleEventsDetail(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      isA<Rejection>(),
    );
    expect(await repo.getTaskDetails('t1'), isA<Rejection>());
    expect(await repo.getTaskFormularies('t1'), isA<Rejection>());
    expect(await repo.getTaskFiles('t1'), isA<Rejection>());
    expect(
      await repo.editScheduleEvent(EditScheduleEventRequestEntity(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '2026-01-10',
        allDay: false,
        repeat: false,
        updateType: 'THIS',
      )),
      isA<Rejection>(),
    );
    expect(
      await repo.deleteScheduleEvent(const DeleteScheduleEventRequestEntity(
        scheduleEventId: 'e1',
        mode: 'THIS_SCHEDULE_EVENT',
      )),
      isA<Rejection>(),
    );
    expect(await repo.resetScheduleEvent('e1'), isA<Rejection>());
    expect(await repo.getEventDetails('e1'), isA<Rejection>());
    expect(await repo.getTaskReport('e1'), isA<Rejection>());
    expect(
      await repo.submitForm(SubmitFormRequestEntity(
        eventId: 'e1',
        answers: {
          'q1': AnswerEntity(type: 'TEXT', questionId: 'q1', content: 'ok'),
        },
      )),
      isA<Rejection>(),
    );
    expect(await repo.getScheduleEventHistory('e1'), isA<Rejection>());
    expect(await repo.filterChatChannels(), isA<Rejection>());
    expect(await repo.getChatMessages(channelId: 'ch1'), isA<Rejection>());
    expect(
      await repo.sendChatMessage(channelId: 'ch1', content: 'oi'),
      isA<Rejection>(),
    );
    expect(await repo.createChatChannel(taskId: 't1'), isA<Rejection>());
  });
}
