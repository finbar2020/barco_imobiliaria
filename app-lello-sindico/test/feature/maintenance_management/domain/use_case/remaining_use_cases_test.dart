import 'package:cross_file/cross_file.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_from_schedule_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/edit_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/formulary_by_month_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_upload_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_history_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_asset_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_local_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_sector_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/create_task_from_schedule_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/download_legal_obligation_file_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/edit_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_formulary_by_month_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_event_history_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_by_asset_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_by_local_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_by_sector_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_summary_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/upload_legal_obligation_file_use_case.dart';

ScheduleEventsDetailResponseEntity _emptySchedule() {
  return const ScheduleEventsDetailResponseEntity(
    success: true,
    message: 'ok',
    data: ScheduleEventsDetailDataEntity(
      taskSummaryDay: [],
      obligations: [],
    ),
    legacyStatusCode: 200,
  );
}

class _FakeRepo extends Fake implements MaintenanceManagementRepository {
  Object? last;

  @override
  Future<Try<TaskSummaryEntity>> getTaskSummary(
      String dtStart, String untilDate) async {
    last = [dtStart, untilDate];
    return Success(TaskSummaryEntity(
      total: 3,
      done: 1,
      notStarted: 1,
      draft: 1,
    ));
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
    last = {'dtStart': dtStart, 'sectorIds': sectorIds};
    return Success(const TaskBySectorResponseEntity(data: []));
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
    last = {'dtStart': dtStart, 'localIds': localIds};
    return Success(const TaskByLocalResponseEntity(data: []));
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
    last = {'dtStart': dtStart, 'assetIds': assetIds};
    return Success(const TaskByAssetResponseEntity(dataTaskByAssetResponse: []));
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
    last = {
      'dtStart': dtStart,
      'untilDate': untilDate,
      'dayCurrent': dayCurrent,
      'pageName': pageName,
    };
    return Success(_emptySchedule());
  }

  @override
  Future<Try<ScheduleEventHistoryEntity>> getScheduleEventHistory(
      String eventId) async {
    last = eventId;
    return Success(ScheduleEventHistoryEntity(
      timeDescription: '',
      timeStart: '',
      name: 'evt',
      localOrAsset: '',
      dtStart: '',
      until: '',
      items: const [],
      allDay: false,
    ));
  }

  @override
  Future<Try<EditScheduleEventResponseEntity>> editScheduleEvent(
      EditScheduleEventRequestEntity request) async {
    last = request.idScheduleEvent;
    return Success(EditScheduleEventResponseEntity(success: true));
  }

  @override
  Future<Try<CreateTaskFromScheduleResponseEntity>> createTaskFromSchedule(
      CreateTaskFromScheduleRequestEntity request) async {
    last = request.scheduleEventId;
    return Success(CreateTaskFromScheduleResponseEntity(
      task: TaskCreatedEntity(id: 't1', name: 'tarefa'),
      event: EventCreatedEntity(id: 'e1'),
    ));
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
    last = {'dtStart': dtStart, 'untilDate': untilDate};
    return Success(const FormularyByMonthResponseEntity(
      formularyByMonthDto: [],
      totalConcluidos: 0,
      totalNaoConcluidos: 0,
      totalGeral: 0,
    ));
  }

  @override
  Future<Try<LegalObligationUploadResponseEntity>> uploadLegalObligationFile({
    required String type,
    required String id,
    required String fileName,
    required String fileUrl,
    required String date,
  }) async {
    last = {'id': id, 'fileName': fileName};
    return Success(LegalObligationUploadResponseEntity(success: true));
  }

  @override
  Future<Try<XFile>> downloadLegalObligationFile(String id, String type) async {
    last = {'id': id, 'type': type};
    return Success(XFile.fromData(Uint8List(0), name: 'arquivo.pdf'));
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  test('GetTaskSummary encaminha o intervalo', () async {
    final result = await GetTaskSummaryUseCaseImpl(repo)(
      GetTaskSummaryRequest(dtStart: '01/01/2026', untilDate: '31/01/2026'),
    );
    expect(result, isA<Success<TaskSummaryEntity>>());
    expect(repo.last, ['01/01/2026', '31/01/2026']);
  });

  test('GetTaskBySector encaminha filtros', () async {
    final result = await GetTaskBySectorUseCaseImpl(repo).execute(
      dtStart: '01/01/2026',
      untilDate: '31/01/2026',
      sectorIds: const ['s1'],
    );
    expect(result, isA<Success<TaskBySectorResponseEntity>>());
    expect((repo.last as Map)['sectorIds'], ['s1']);
  });

  test('GetTaskByLocal encaminha filtros', () async {
    final result = await GetTaskByLocalUseCaseImpl(repo).execute(
      dtStart: '01/01/2026',
      untilDate: '31/01/2026',
      localIds: const ['l1'],
    );
    expect(result, isA<Success<TaskByLocalResponseEntity>>());
    expect((repo.last as Map)['localIds'], ['l1']);
  });

  test('GetTaskByAsset encaminha filtros', () async {
    final result = await GetTaskByAssetUseCaseImpl(repo).execute(
      dtStart: '01/01/2026',
      untilDate: '31/01/2026',
      assetIds: const ['a1'],
    );
    expect(result, isA<Success<TaskByAssetResponseEntity>>());
    expect((repo.last as Map)['assetIds'], ['a1']);
  });

  test('GetScheduleEvents formata a data para dd/MM/yyyy', () async {
    final result = await GetScheduleEventsUseCaseImpl(repo)(
      GetScheduleEventsParams(
        date: DateTime(2026, 1, 15),
        pageName: 'agenda',
      ),
    );
    expect(result, isA<Success<ScheduleEventsDetailResponseEntity>>());
    expect((repo.last as Map)['dtStart'], '15/01/2026');
    expect((repo.last as Map)['pageName'], 'agenda');
  });

  test('GetScheduleEventHistory encaminha o eventId', () async {
    final result = await GetScheduleEventHistoryUseCase(repo)('evt-9');
    expect(result, isA<Success<ScheduleEventHistoryEntity>>());
    expect(repo.last, 'evt-9');
  });

  test('EditScheduleEvent encaminha o request', () async {
    final result = await EditScheduleEventUseCaseImpl(repo)(
      EditScheduleEventRequestEntity(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '15/01/2026',
        allDay: true,
        repeat: false,
        updateType: 'THIS',
      ),
    );
    expect(result, isA<Success<EditScheduleEventResponseEntity>>());
    expect(repo.last, 'e1');
  });

  test('CreateTaskFromSchedule encaminha o request', () async {
    final result = await CreateTaskFromScheduleUseCaseImpl(repo)(
      CreateTaskFromScheduleRequestEntity(
        scheduleId: 's1',
        scheduleEventId: 'e2',
      ),
    );
    expect(result, isA<Success<CreateTaskFromScheduleResponseEntity>>());
    expect(repo.last, 'e2');
  });

  test('GetFormularyByMonth encaminha o intervalo', () async {
    final result = await GetFormularyByMonthUseCaseImpl(repo)(
      const GetFormularyByMonthParams(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
      ),
    );
    expect(result, isA<Success<FormularyByMonthResponseEntity>>());
    expect((repo.last as Map)['dtStart'], '01/01/2026');
  });

  test('UploadLegalObligationFile encaminha o arquivo', () async {
    final result = await UploadLegalObligationFileUseCaseImpl(repo)(
      UploadLegalObligationFileRequest(
        type: 'AVCB',
        id: 'ob-1',
        fileName: 'laudo.pdf',
        fileUrl: 'https://s3/laudo.pdf',
        date: '15/01/2026',
      ),
    );
    expect(result, isA<Success<LegalObligationUploadResponseEntity>>());
    expect((repo.last as Map)['fileName'], 'laudo.pdf');
  });

  test('DownloadLegalObligationFile encaminha id e tipo', () async {
    final result = await DownloadLegalObligationFileUseCaseImpl(repo)(
      DownloadLegalObligationFileRequest(id: 'ob-1', type: 'AVCB'),
    );
    expect(result, isA<Success<XFile>>());
    expect((repo.last as Map)['id'], 'ob-1');
  });
}
