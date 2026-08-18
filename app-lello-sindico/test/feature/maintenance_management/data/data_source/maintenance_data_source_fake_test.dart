import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lello/feature/maintenance_management/api/maintenance_management_api.dart';
import 'package:lello/feature/maintenance_management/data/data_source/maintenance_management_remote_data_source_impl.dart';
import 'package:lello/feature/maintenance_management/data/exceptions/maintenance_management_api_exception.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_days_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/create_chat_channel_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/filter_chat_channels_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/send_chat_message_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/delete_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/edit_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/send_technical_inspection_email_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/upload_legal_obligation_request_model.dart';

bool _apiFail = false;

Response<dynamic> _ok(dynamic body) {
  if (_apiFail) {
    return _fail();
  }
  final encoded = jsonEncode(body);
  return Response<dynamic>(
    http.Response(
      encoded,
      200,
      request: http.Request('GET', Uri.parse('https://example.com')),
      headers: {'content-type': 'application/json'},
    ),
    body,
  );
}

Response<dynamic> _fail({
  int status = 400,
  String bodyString = '{}',
  String detail = 'fail',
}) {
  return Response<dynamic>(
    http.Response(
      bodyString,
      status,
      request: http.Request('GET', Uri.parse('https://example.com')),
    ),
    {},
    error: ApiFailure()..detail = detail,
  );
}

Map<String, dynamic> _condo() => {
      'id': 'c1',
      'assets': 2,
      'floor': 'térreo',
      'localsCount': 4,
      'workflowUsers': '3',
      'condominiumName': 'Edifício',
      'blocksCount': 1,
      'unitsCount': 10,
      'hasEmployee': true,
    };

Map<String, dynamic> _scheduleDetail() => {
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

Map<String, dynamic> _taskflow() => {
      'success': true,
      'message': 'ok',
      'error_code': null,
      'legacy_status_code': 200,
      'data': {
        'id': 'e1',
        'formulary_id': 'f1',
        'status': 'DONE',
        'responsible_name': 'Ana',
        'finished_at': '2026-01-10',
        'formulary': {
          'id': 'f1',
          'name': 'Form',
          'procedure_id': 'p1',
          'enabled': true,
          'questions': [
            {'id': 'q1', 'name': 'Texto', 'field_type': 'TEXT'},
          ],
        },
      },
    };

Map<String, dynamic> _channels() => {
      'success': true,
      'data': [
        {
          'id': 'ch1',
          'typeTask': 'ROTINA',
          'status': 'OPEN',
          'task': {'id': 't1', 'name': 'Limpeza'},
        }
      ],
    };

class _FakeApi extends Fake implements MaintenanceManagementApi {
  dynamic calendarBody = <String, dynamic>{
    'month': 1,
    'year': 2026,
    'days': [
      {'day': 10, 'hasEvents': true, 'taskCount': 2}
    ],
  };
  bool failCharts = false;
  String chartDetail =
      '{"technicalDetail":"timeout","context":"charts","exceptionType":"IO"}';
  Object? downloadPayload;
  Map<String, dynamic>? legalHistoryBody;
  dynamic taskflowBody;
  dynamic scheduleHistoryBody;

  @override
  Future<Response> getCondominiumInfo() async => _ok(_condo());

  @override
  Future<Response> getCondominiumInfoV2(String sessionVersion) async =>
      _ok(_condo());

  @override
  Future<Response> getMaintenanceTaskEvents(
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
  }) async =>
      _ok({
        'taskSummaryDay': {
          'total': 2,
          'done': 1,
          'notStarted': 1,
          'draft': 0,
        },
        'taskFormulary': const [],
      });

  @override
  Future<Response> getScheduleEvents({
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
      _ok(_scheduleDetail());

  @override
  Future<Response> getMaintenanceTasksEfficiency(
          Map<String, dynamic> body) async =>
      _ok({
        'efficiency_response': [
          {'id': 'g1', 'name': 'Grupo', 'done': 1, 'not_started': 2, 'draft': 0}
        ],
        'task_summary': {'total': 3, 'done': 1, 'notStarted': 2, 'draft': 0},
      });

  @override
  Future<Response> getMaintenanceTasksFilterOptions() async => _ok({
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
      });

  @override
  Future<Response> getLegalObligations(
          String type, String sessionVersion) async =>
      _ok({
        'success': true,
        'message': 'ok',
        'metadata': {'requestPartner': true},
        'data': [
          {'id': '1', 'description': 'AVCB', 'status': 'PENDING'}
        ],
      });

  @override
  Future<Response> getLegalObligationUploadUrl(String condoId) async => _ok({
        'file_name': 'a.pdf',
        'url': 'https://s3',
      });

  @override
  Future<Response> uploadLegalObligationFile(Map<String, dynamic> body) async =>
      _ok({'success': true, 'link': 'https://s3/a.pdf'});

  @override
  Future<Response> requestLegalObligationRenewal(
          String id, String type) async =>
      _ok({'success': true});

  @override
  Future<Response> notifyLegalObligationPartner(String type) async => _ok({
        'success': true,
        'message': 'ok',
        'metadata': {'request_partner': false},
      });

  @override
  Future<Response> downloadLegalObligationFile(String id, String type) async {
    if (_apiFail) return _fail();
    if (downloadPayload is Map<String, dynamic>) {
      return _ok(downloadPayload);
    }
    final bytes = Uint8List.fromList(
      downloadPayload is List<int>
          ? List<int>.from(downloadPayload as List<int>)
          : const [37, 80, 68, 70],
    );
    return Response<dynamic>(
      http.Response.bytes(
        bytes,
        200,
        request: http.Request('GET', Uri.parse('https://example.com')),
      ),
      bytes,
    );
  }

  @override
  Future<Response> getLegalObligationActivityHistory(
          String id, String type) async =>
      _ok(legalHistoryBody ??
          {
            'success': true,
            'message': 'ok',
            'data': [
              {'date': '2026-01-10', 'description': 'enviado', 'status': 'DONE'}
            ],
          });

  @override
  Future<Response> sendTechnicalInspectionEmail(
          Map<String, dynamic> body) async =>
      _ok({'success': true});

  @override
  Future<Response> getProcedureOptions(String typeTask) async => _ok({
        'procedure_options': [
          {
            'id': 1,
            'title': 'Limpeza',
            'first_responsible': {'id': 'u1', 'name': 'João'},
          }
        ],
      });

  Response _chartOrFail(Map<String, dynamic> body) {
    if (failCharts) {
      return _fail(detail: chartDetail);
    }
    return _ok(body);
  }

  @override
  Future<Response> getFormularyByMonth(Map<String, dynamic> body) async =>
      _chartOrFail({
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
      });

  @override
  Future<Response> getTaskByMonth(Map<String, dynamic> body) async =>
      _chartOrFail({
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
      });

  @override
  Future<Response> getTaskBySector(Map<String, dynamic> body) async =>
      _chartOrFail({
        'data': [
          {'id': 's1', 'name': 'Elétrica', 'value': 4, 'color': '#fff'}
        ],
      });

  @override
  Future<Response> getTaskByLocal(Map<String, dynamic> body) async =>
      _chartOrFail({
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
      });

  @override
  Future<Response> getTaskByAsset(Map<String, dynamic> body) async =>
      _chartOrFail({
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
      });

  @override
  Future<Response> getLocalsLookup(String procedureIds) async => _ok({
        'locals': [
          {'id': 'l1', 'name': 'Hall', 'hierarchy_locals': 'Bloco A'}
        ],
      });

  @override
  Future<Response> getAssetsLookup(String procedureIds) async => _ok({
        'assets': [
          {'id': 'a1', 'name': 'Bomba'}
        ],
      });

  @override
  Future<Response> getTaskSummary(String dtStart, String untilDate) async =>
      _ok({'total': 4, 'done': 1, 'notStarted': 2, 'draft': 1});

  @override
  Future<Response> createTask(Map<String, dynamic> body) async => _ok({
        'idSchedule': 's1',
        'idScheduleEvents': ['e1'],
      });

  @override
  Future<Response> createTaskFromSchedule(Map<String, dynamic> body) async =>
      _ok({
        'task': {'id': 't1', 'name': 'Limpeza'},
        'event': {'id': 'e1', 'name': 'Evento'},
      });

  @override
  Future<Response> getCalendarDays(
    int month,
    int year,
    String dtStart,
    String untilDate,
    List<String>? typeTask,
    List<String>? status,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? responsibleIds,
  ) async {
    if (calendarBody is Exception) {
      return _fail(detail: calendarBody.toString());
    }
    return _ok(calendarBody);
  }

  @override
  Future<Response> getTaskDetails(String taskId) async => _ok({
        'id': taskId,
        'name': 'Limpeza',
        'status': 'PENDING',
        'type_task': 'ROTINA',
      });

  @override
  Future<Response> getTaskFormularies(String taskId) async => _ok({
        'formularies': [
          {'name': 'Form', 'status': 'DONE', 'position': 1, 'can_start': true}
        ],
      });

  @override
  Future<Response> getTaskFiles(String taskId) async => _ok({
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
      });

  @override
  Future<Response> editScheduleEvent(
          bool isLogQuery, Map<String, dynamic> body) async =>
      _ok({'success': true});

  @override
  Future<Response> deleteScheduleEvent(
          bool isLogQuery, String scheduleEventId, String mode) async =>
      _ok({'success': true});

  @override
  Future<Response> getEventDetails(String eventId) async => _ok({'id': eventId});

  @override
  Future<Response> getTaskflowEvent(String eventId) async =>
      _ok(taskflowBody ?? _taskflow());

  @override
  Future<Response> submitForm(bool isLogQuery, Map<String, dynamic> body) async =>
      _ok({'success': true, 'detail': 'ok', 'data': 'd1'});

  @override
  Future<Response> getScheduleEventHistory(String eventId) async =>
      _ok(scheduleHistoryBody ??
          {
            'success': true,
            'message': 'ok',
            'data': {
              'time_description': 'manhã',
              'time_start': '08:00',
              'name': 'Limpeza',
              'items': const [],
            },
          });

  @override
  Future<Response> getChannels({
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
  }) async =>
      _ok(_channels());

  @override
  Future<Response> filterChatChannels(Map<String, dynamic> body) async =>
      _ok(_channels());

  @override
  Future<Response> getChatMessages(
    String channelId, {
    String? before,
    String? after,
    int? limit,
  }) async =>
      _ok({
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
      });

  @override
  Future<Response> sendChatMessage(Map<String, dynamic> body) async =>
      _ok({'data': 'msg-1'});

  @override
  Future<Response> createChatChannel(Map<String, dynamic> body) async =>
      _ok({'data': 'ch1'});

  @override
  Future<Response> resetScheduleEvent(String scheduleEventId) async =>
      _ok({'success': true});
}

class _NotifyApi extends _FakeApi {
  _NotifyApi(this.body);

  final dynamic body;

  @override
  Future<Response> notifyLegalObligationPartner(String type) async =>
      body is Response ? body as Response : _ok(body);
}

class _LegalApi extends _FakeApi {
  _LegalApi({this.success = true});

  final bool success;

  @override
  Future<Response> getLegalObligations(
          String type, String sessionVersion) async =>
      _ok({
        'success': success,
        'message': 'falhou',
        'data': const [],
      });
}

class _JsonErrorApi extends _FakeApi {
  @override
  Future<Response> getCondominiumInfo() async => _fail(bodyString: 'not-json');

  @override
  Future<Response> getCondominiumInfoV2(String sessionVersion) async =>
      _fail(bodyString: 'not-json');

  @override
  Future<Response> uploadLegalObligationFile(Map<String, dynamic> body) async =>
      _fail(bodyString: 'not-json');
}

class _CodedUploadApi extends _FakeApi {
  @override
  Future<Response> uploadLegalObligationFile(Map<String, dynamic> body) async =>
      _fail(bodyString: '{"error_code":"E1","message":"nope"}');
}

class _RenewalApi extends _FakeApi {
  _RenewalApi(this.response);
  final Response response;

  @override
  Future<Response> requestLegalObligationRenewal(
          String id, String type) async =>
      response;
}

class _EmailListErrorApi extends _FakeApi {
  @override
  Future<Response> sendTechnicalInspectionEmail(
          Map<String, dynamic> body) async =>
      _fail(bodyString: '[]', detail: 'timeout');
}

class _ScheduleErrorApi extends _FakeApi {
  @override
  Future<Response> getScheduleEvents({
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
      Response(
        http.Response(
          '{}',
          400,
          request: http.Request('GET', Uri.parse('https://example.com')),
        ),
        {},
        error: 'raw',
      );
}

MaintenanceTaskEventsRequestModel _eventsRequest({
  List<String> assets = const [],
}) {
  return MaintenanceTaskEventsRequestModel(
    dtstart: '01/01/2026',
    untilDate: '07/01/2026',
    pageName: 'agenda',
    filters: MaintenanceTaskEventsRequestFiltersModel(
      typeTask: const ['ROTINA'],
      procedureGroupLabels: const [],
      displayBy: 'GRUPO',
      status: const ['PENDENTE'],
      dayCurrent: '03/01/2026',
      assetIds: assets,
      localIds: assets.isEmpty ? const [] : const ['l1'],
      responsibleIds: assets.isEmpty ? const [] : const ['r1'],
    ),
  );
}

EfficiencyRequestModel _efficiencyRequest() => EfficiencyRequestModel(
      dtStart: '01/01/2026',
      untilDate: '31/01/2026',
      filters: EfficiencyFiltersModel(
        typeTask: const ['ROTINA'],
        dayCurrent: '10/01/2026',
        procedureGroupLabels: const [],
        procedureGroupIds: const [],
        responsibleIds: const [],
        displayBy: 'GRUPO',
        status: const [],
      ),
    );

FormularyByMonthRequestModel _formularyRequest() => FormularyByMonthRequestModel(
      dtStart: '01/01/2026',
      untilDate: '31/01/2026',
      filters: const FormularyByMonthFiltersModel(
        typeTask: ['ROTINA'],
        status: [],
        dayCurrent: '10/01/2026',
        responsibleIds: [],
        localIds: [],
        assetIds: [],
      ),
    );

void main() {
  late _FakeApi api;
  late MaintenanceManagementRemoteDataSourceImpl ds;

  setUp(() {
    _apiFail = false;
    api = _FakeApi();
    ds = MaintenanceManagementRemoteDataSourceImpl(api);
  });

  test('getCondominiumInfo e V2 mapeiam sucesso', () async {
    final info = await ds.getCondominiumInfo();
    expect(info.condominiumName, 'Edifício');
    final v2 = await ds.getCondominiumInfoV2();
    expect(v2.id, 'c1');
  });

  test('getMaintenanceTaskEvents com e sem filtros de id', () async {
    final empty = await ds.getMaintenanceTaskEvents(_eventsRequest());
    expect(empty.taskSummaryDay.total, 2);
    final withIds =
        await ds.getMaintenanceTaskEvents(_eventsRequest(assets: ['a1']));
    expect(withIds.taskFormulary, isEmpty);
  });

  test('agenda, eficiência, filtros e obrigações', () async {
    final schedule = await ds.getScheduleEvents(
      dtStart: '01/01/2026',
      untilDate: '07/01/2026',
      dayCurrent: '03/01/2026',
      typeTask: const ['ROTINA'],
    );
    expect(schedule.success, isTrue);

    final detail = await ds.getScheduleEventsDetail(
      dtStart: '01/01/2026',
      untilDate: '07/01/2026',
      dayCurrent: '03/01/2026',
    );
    expect(detail.message, 'ok');

    final efficiency = await ds.getMaintenanceTasksEfficiency(_efficiencyRequest());
    expect(efficiency.toJson(), isNotEmpty);

    final filters = await ds.getMaintenanceTasksFilterOptions();
    expect(filters.locals.single.name, 'Hall');

    final legal = await ds.getLegalObligations('PDF');
    expect(legal.success, isTrue);
  });

  test('upload S3, renovação, histórico e e-mail técnico', () async {
    final url = await ds.getLegalObligationUploadUrl('c1');
    expect(url.fileName, 'a.pdf');

    final upload = await ds.uploadLegalObligationFile(
      UploadLegalObligationRequestModel(
        type: 'PDF',
        id: '1',
        fileName: 'a.pdf',
        fileUrl: 'https://s3',
        date: '2026-01-10',
      ),
    );
    expect(upload.success, isTrue);

    expect(
      await ds.requestLegalObligationRenewal(id: '1', type: 'PDF'),
      isTrue,
    );

    final history = await ds.getLegalObligationActivityHistory(
      id: '1',
      type: 'PDF',
    );
    expect(history.data, isNotEmpty);

    expect(
      await ds.sendTechnicalInspectionEmail(
        const SendTechnicalInspectionEmailRequestModel(
          type: 'TECHNICAL',
          id: 'abc',
          email: 'a@b.com',
        ),
      ),
      isTrue,
    );
  });

  test('notify partner usa metadata request_partner', () async {
    final result = await ds.notifyLegalObligationPartner(type: 'PDF');
    expect(result.success, isTrue);
    expect(result.shouldLockButton, isFalse);
  });

  test('notify partner sem metadata bloqueia botão', () async {
    final local = MaintenanceManagementRemoteDataSourceImpl(
      _NotifyApi({'success': true, 'message': 'ok'}),
    );
    final result = await local.notifyLegalObligationPartner(type: 'PDF');
    expect(result.shouldLockButton, isTrue);
  });

  test('notify partner em falha usa mensagem da API', () async {
    final local = MaintenanceManagementRemoteDataSourceImpl(
      _NotifyApi(_fail(detail: 'parceiro indisponível')),
    );
    final result = await local.notifyLegalObligationPartner(type: 'PDF');
    expect(result.success, isFalse);
    expect(result.message, 'parceiro indisponível');
  });

  test('getLegalObligations lança quando success é false', () async {
    final local = MaintenanceManagementRemoteDataSourceImpl(
      _LegalApi(success: false),
    );
    expect(local.getLegalObligations('PDF'), throwsA(isA<Exception>()));
  });

  test('procedimentos, lookups, resumo e CRUD de tarefa', () async {
    final procedures = await ds.getProcedureOptions('ROTINA');
    expect(procedures.toJson()['procedure_options'], isNotEmpty);

    expect((await ds.getLocalsLookup('p1')).locals.single.name, 'Hall');
    expect((await ds.getAssetsLookup('p1')).assets.single.name, 'Bomba');
    expect((await ds.getTaskSummary('01/01/2026', '31/01/2026')).total, 4);

    final created = await ds.createTask(CreateTaskRequestModel(
      procedureGroupId: 'g1',
      procedureId: 'p1',
      allDay: true,
      dtStart: '2026-01-10',
      repeat: false,
    ));
    expect(created.idSchedule, 's1');

    final fromSchedule = await ds.createTaskFromSchedule(
      CreateTaskFromScheduleRequestModel(
        scheduleId: 's1',
        scheduleEventId: 'e1',
      ),
    );
    expect(fromSchedule.task.name, 'Limpeza');
  });

  test('gráficos de sucesso e toJson dos requests', () async {
    expect((await ds.getFormularyByMonth(_formularyRequest())).totalGeral, 1);
    expect(
      (await ds.getTaskByMonth(const TaskByMonthRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskByMonthFiltersModel(
          typeTask: ['ROTINA'],
          status: [],
          responsibleIds: [],
          localIds: [],
          assetIds: [],
        ),
      )))
          .toJson(),
      isNotEmpty,
    );
    expect(
      (await ds.getTaskBySector(const TaskBySectorRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskBySectorFiltersModel(),
      )))
          .data,
      isNotEmpty,
    );
    expect(
      (await ds.getTaskByLocal(const TaskByLocalRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      )))
          .data,
      isNotEmpty,
    );
    expect(
      (await ds.getTaskByAsset(const TaskByAssetRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      )))
          .toJson(),
      isNotEmpty,
    );
  });

  test('gráficos cobrem ramo de erro com JSON técnico', () async {
    api.failCharts = true;
    expect(ds.getFormularyByMonth(_formularyRequest()), throwsA(isA<Exception>()));
    expect(
      ds.getTaskByMonth(const TaskByMonthRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskByMonthFiltersModel(
          typeTask: [],
          status: [],
          responsibleIds: [],
          localIds: [],
          assetIds: [],
        ),
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getTaskBySector(const TaskBySectorRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getTaskByLocal(const TaskByLocalRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getTaskByAsset(const TaskByAssetRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      )),
      throwsA(isA<Exception>()),
    );
  });

  test('calendário cobre formatos de body', () async {
    Future<CalendarDaysResponseModel> parse(dynamic body) async {
      api.calendarBody = body;
      return ds.getCalendarDays(1, 2026);
    }

    expect(
      (await parse(<String, dynamic>{
        'days': <Map<String, dynamic>>[
          <String, dynamic>{'day': 8, 'size': 3}
        ]
      }))
          .days
          .single
          .taskCount,
      3,
    );
    expect(
      (await parse(<String, dynamic>{
        'days': <Map<String, dynamic>>[
          <String, dynamic>{'day': 5, 'size': 2}
        ]
      }))
          .days
          .single
          .day,
      5,
    );
    expect(
      (await parse(<String, dynamic>{
        'data': <String, dynamic>{
          'days': <Map<String, dynamic>>[
            <String, dynamic>{'day': 2, 'tasks': <int>[1]}
          ]
        }
      }))
          .days
          .single
          .day,
      2,
    );
    expect(
      (await parse(<String, dynamic>{
        'data': <Map<String, dynamic>>[
          <String, dynamic>{'day': 3, 'size': 4}
        ]
      }))
          .days
          .single
          .day,
      3,
    );
    expect(
      (await parse(<Map<String, dynamic>>[
        <String, dynamic>{'dtStart': '10/01/2026'}
      ]))
          .month,
      1,
    );
    expect(
      (await parse(<String, dynamic>{
        'tasks': <Map<String, dynamic>>[
          <String, dynamic>{'date': '12/01/2026'}
        ]
      }))
          .month,
      1,
    );
    expect(
      (await parse(<String, dynamic>{
        'events': <Map<String, dynamic>>[
          <String, dynamic>{'dtStart': '15/01/2026'}
        ]
      }))
          .month,
      1,
    );
    expect(
      (await parse(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          <String, dynamic>{'until': '20/01/2026'}
        ]
      }))
          .month,
      1,
    );
    expect(
      (await parse(<String, dynamic>{'dtStart': '22/01/2026'})).month,
      1,
    );
    expect((await parse(<String, dynamic>{'foo': 1})).days, isEmpty);
  });

  test('calendário lança em formato inesperado e em HTTP de erro', () async {
    api.calendarBody = 'nao-mapa';
    expect(ds.getCalendarDays(1, 2026), throwsA(isA<Exception>()));
    api.calendarBody = Exception('http');
    expect(ds.getCalendarDays(1, 2026), throwsA(isA<Exception>()));
  });

  test('detalhes, arquivos, edição, chat e reset', () async {
    final details = await ds.getTaskDetails('t1');
    expect(details.name, 'Limpeza');
    expect((await ds.getTaskFormularies('t1')).formularies.single.name, 'Form');
    expect((await ds.getTaskFiles('t1')).files.single.extension, 'png');

    expect(
      (await ds.editScheduleEvent(EditScheduleEventRequestModel(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '2026-01-10',
        allDay: true,
        repeat: false,
        updateType: 'THIS',
      )))['success'],
      isTrue,
    );
    expect(
      (await ds.deleteScheduleEvent(const DeleteScheduleEventRequestModel(
        scheduleEventId: 'e1',
        mode: 'THIS',
      )))['success'],
      isTrue,
    );

    expect((await ds.getEventDetails('e1')).id, 'e1');
    expect((await ds.getTaskflowEvent('e1')).formulary.name, 'Form');
    expect(
      (await ds.submitForm(SubmitFormRequestModel(
        eventId: 'e1',
        answers: {
          'q1': AnswerModel(type: 'TEXT', questionId: 'q1', content: 'ok'),
          'q2': AnswerModel(
            type: 'FILE',
            questionId: 'q2',
            content: FileContentModel(
              contentType: 'image/png',
              localUri: 'file://a',
              name: 'a.png',
              uploadTaskId: 'u1',
              firebaseRef: 'ref',
              deviceId: 'd1',
              bucket: 'b',
              failCount: 0,
              size: 10,
              url: 'https://s3',
            ),
          ),
        },
      )))
          .success,
      isTrue,
    );
    expect((await ds.getScheduleEventHistory('e1')).success, isTrue);

    final channels = await ds.getChannels(dayCurrent: '10/01/2026', first: 10);
    expect(channels.data, isNotEmpty);
    expect(
      (await ds.filterChatChannels(const FilterChatChannelsRequestModel()))
          .success,
      isTrue,
    );
    expect(
      (await ds.getChatMessages(channelId: 'ch1', limit: 20)).data.single.id,
      'm1',
    );
    expect(
      (await ds.sendChatMessage(const SendChatMessageRequestModel(
        channelId: 'ch1',
        content: 'oi',
        sentAt: '2026-01-10',
      )))
          .id,
      'msg-1',
    );
    expect(
      (await ds.createChatChannel(
        const CreateChatChannelRequestModel(taskId: 't1'),
      ))
          .channelId,
      'ch1',
    );
    expect((await ds.resetScheduleEvent('e1')).isSuccessful, isTrue);
  });

  test('HTTP de erro cobre ramos else dos endpoints', () async {
    _apiFail = true;
    expect(ds.getCondominiumInfo(), throwsA(isA<Exception>()));
    expect(ds.getCondominiumInfoV2(), throwsA(isA<Exception>()));
    expect(ds.getMaintenanceTaskEvents(_eventsRequest()), throwsA(isA<Exception>()));
    expect(
      ds.getScheduleEvents(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      throwsA(isA<Exception>()),
    );
    expect(ds.getMaintenanceTasksFilterOptions(), throwsA(isA<Exception>()));
    expect(ds.getLegalObligations('PDF'), throwsA(isA<Exception>()));
    expect(ds.getProcedureOptions('ROTINA'), throwsA(isA<Exception>()));
    expect(ds.getLocalsLookup('p1'), throwsA(isA<Exception>()));
    expect(ds.getAssetsLookup('p1'), throwsA(isA<Exception>()));
    expect(ds.getTaskSummary('a', 'b'), throwsA(isA<Exception>()));
    expect(ds.getTaskDetails('t1'), throwsA(isA<Exception>()));
    expect(ds.getTaskFormularies('t1'), throwsA(isA<Exception>()));
    expect(ds.getTaskFiles('t1'), throwsA(isA<Exception>()));
    expect(ds.getEventDetails('e1'), throwsA(isA<Exception>()));
    expect(ds.getTaskflowEvent('e1'), throwsA(isA<Exception>()));
    expect(ds.getScheduleEventHistory('e1'), throwsA(isA<Exception>()));
    expect(ds.getChannels(), throwsA(isA<Exception>()));
    expect(
      ds.filterChatChannels(const FilterChatChannelsRequestModel()),
      throwsA(isA<Exception>()),
    );
    expect(ds.getChatMessages(channelId: 'ch1'), throwsA(isA<Exception>()));
    expect(
      ds.sendChatMessage(const SendChatMessageRequestModel(
        channelId: 'ch1',
        content: 'oi',
        sentAt: 'a',
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.createChatChannel(const CreateChatChannelRequestModel(taskId: 't1')),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.createTask(CreateTaskRequestModel(
        procedureGroupId: 'g1',
        procedureId: 'p1',
        allDay: true,
        dtStart: '2026-01-10',
        repeat: false,
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.submitForm(SubmitFormRequestModel(eventId: 'e1', answers: const {})),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getMaintenanceTasksEfficiency(_efficiencyRequest()),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getLegalObligationActivityHistory(id: '1', type: 'PDF'),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.sendTechnicalInspectionEmail(
        const SendTechnicalInspectionEmailRequestModel(
          type: 'PDF',
          id: '1',
          email: 'a@b.com',
        ),
      ),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.createTaskFromSchedule(
        CreateTaskFromScheduleRequestModel(
          scheduleId: 's1',
          scheduleEventId: 'e1',
        ),
      ),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.getScheduleEventsDetail(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.editScheduleEvent(EditScheduleEventRequestModel(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '2026-01-10',
        allDay: true,
        repeat: false,
        updateType: 'THIS',
      )),
      throwsA(isA<Exception>()),
    );
    expect(
      ds.deleteScheduleEvent(const DeleteScheduleEventRequestModel(
        scheduleEventId: 'e1',
        mode: 'single',
      )),
      throwsA(isA<Exception>()),
    );
    expect(ds.downloadLegalObligationFile('1', 'PDF'), throwsA(isA<Exception>()));
  });

  test('histórico legal com success false e parse inválido', () async {
    api.legalHistoryBody = {'success': false, 'message': 'sem histórico'};
    expect(
      ds.getLegalObligationActivityHistory(id: '1', type: 'PDF'),
      throwsA(isA<Exception>()),
    );

    api.taskflowBody = {'success': true};
    expect(ds.getTaskflowEvent('e1'), throwsA(isA<Exception>()));

    api.scheduleHistoryBody = {'success': true};
    expect(ds.getScheduleEventHistory('e1'), throwsA(isA<Exception>()));
  });

  test('calendário com days que não é lista usa fromJson', () async {
    api.calendarBody = <String, dynamic>{
      'month': 1,
      'year': 2026,
      'days': 'nao-lista',
    };
    expect(ds.getCalendarDays(1, 2026), throwsA(isA<TypeError>()));
  });

  test('e-mail de inspeção cobre fallback de erro não-Exception', () {
    final emailDs =
        MaintenanceManagementRemoteDataSourceImpl(_EmailListErrorApi());
    expect(
      emailDs.sendTechnicalInspectionEmail(
        const SendTechnicalInspectionEmailRequestModel(
          type: 'PDF',
          id: '1',
          email: 'a@b.com',
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('download da obrigação grava bytes, base64 e erro de decode', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.path,
    );

    final file = await ds.downloadLegalObligationFile('1', 'PDF');
    expect(file.path.contains('legal-obligation-1-PDF'), isTrue);

    api.downloadPayload = {
      'data': base64Encode(const [1, 2, 3, 4]),
    };
    final encoded = await ds.downloadLegalObligationFile('2', 'PDF');
    expect(File(encoded.path).existsSync(), isTrue);

    api.downloadPayload = {'data': '!!!'};
    expect(
      ds.downloadLegalObligationFile('3', 'PDF'),
      throwsA(isA<Exception>()),
    );
  });

  test('erros JSON inválido e renovação cobrem fallbacks', () async {
    final jsonDs = MaintenanceManagementRemoteDataSourceImpl(_JsonErrorApi());
    expect(jsonDs.getCondominiumInfo(), throwsA(isA<Exception>()));
    expect(jsonDs.getCondominiumInfoV2(), throwsA(isA<Exception>()));
    expect(
      jsonDs.uploadLegalObligationFile(
        UploadLegalObligationRequestModel(
          type: 'PDF',
          id: '1',
          fileName: 'a.pdf',
          fileUrl: 'https://s3',
          date: '2026-01-10',
        ),
      ),
      throwsA(isA<Exception>()),
    );

    final coded = MaintenanceManagementRemoteDataSourceImpl(_CodedUploadApi());
    expect(
      coded.uploadLegalObligationFile(
        UploadLegalObligationRequestModel(
          type: 'PDF',
          id: '1',
          fileName: 'a.pdf',
          fileUrl: 'https://s3',
          date: '2026-01-10',
        ),
      ),
      throwsA(isA<MaintenanceManagementApiException>()),
    );

    final messageDs = MaintenanceManagementRemoteDataSourceImpl(
      _RenewalApi(_ok({'success': false, 'message': 'não renovou'})),
    );
    expect(
      messageDs.requestLegalObligationRenewal(id: '1', type: 'PDF'),
      throwsA(isA<Exception>()),
    );

    final detailDs = MaintenanceManagementRemoteDataSourceImpl(
      _RenewalApi(_fail(detail: 'timeout')),
    );
    expect(
      detailDs.requestLegalObligationRenewal(id: '1', type: 'PDF'),
      throwsA(isA<Exception>()),
    );

    final genericDs = MaintenanceManagementRemoteDataSourceImpl(
      _RenewalApi(_fail(detail: '')),
    );
    expect(
      genericDs.requestLegalObligationRenewal(id: '1', type: 'PDF'),
      throwsA(isA<Exception>()),
    );

    final scheduleDs =
        MaintenanceManagementRemoteDataSourceImpl(_ScheduleErrorApi());
    expect(
      scheduleDs.getScheduleEvents(
        dtStart: '01/01/2026',
        untilDate: '07/01/2026',
        dayCurrent: '03/01/2026',
      ),
      throwsA(isA<TypeError>()),
    );
  });
}
