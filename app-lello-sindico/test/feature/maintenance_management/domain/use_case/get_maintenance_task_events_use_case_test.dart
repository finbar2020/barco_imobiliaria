import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';

class _FakeRepo extends Fake implements MaintenanceManagementRepository {
  String? dtstart;
  String? untilDate;
  String? dayCurrent;
  List<String>? typeTask;
  List<String>? status;
  List<String>? assetIds;
  List<String>? localIds;
  List<String>? responsibleIds;
  bool throwError = false;

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
    this.dtstart = dtstart;
    this.untilDate = untilDate;
    this.dayCurrent = dayCurrent;
    this.typeTask = typeTask;
    this.status = status;
    this.assetIds = assetIds;
    this.localIds = localIds;
    this.responsibleIds = responsibleIds;
    if (throwError) {
      return Rejection(UnknownFailure('boom'));
    }
    return Success(
      MaintenanceTaskEventsResponseEntity(
        taskSummaryDay: TaskSummaryEntity(
          total: 1,
          done: 0,
          notStarted: 1,
          draft: 0,
        ),
        taskFormulary: [
          MaintenanceTaskEventEntity(
            typeTask: 'ROTINA',
            name: 'Inspeção',
            fullDescription: 'desc',
            responsibleUserable: 'João',
            timeStart: '08:00',
            timeEnd: '09:00',
            timeDescription: '08:00 - 09:00',
            dtstart: '2026-01-15T00:00:00Z',
            dtend: '2026-01-15T00:00:00Z',
            dtstartFormatted: '15/01/2026',
            dtendFormatted: '15/01/2026',
            status: 'PENDENTE',
            allDay: false,
          ),
        ],
      ),
    );
  }
}

void main() {
  late _FakeRepo repo;
  late GetMaintenanceTaskEventsUseCaseImpl useCase;

  setUp(() {
    repo = _FakeRepo();
    useCase = GetMaintenanceTaskEventsUseCaseImpl(repo);
  });

  test('formata datas para dd/MM/yyyy e encaminha filtros ao repositório',
      () async {
    final result = await useCase(
      GetMaintenanceTaskEventsParams(
        dtStart: DateTime(2026, 1, 1),
        untilDate: DateTime(2026, 1, 7),
        typeTask: const ['ROTINA'],
        status: const ['PENDENTE'],
        dayCurrent: DateTime(2026, 1, 3),
        assetIds: const ['a1'],
        localIds: const ['l1'],
        responsibleIds: const ['r1'],
      ),
    );

    expect(result, isA<Success<MaintenanceTaskEventsResponseEntity>>());
    expect(repo.dtstart, '01/01/2026');
    expect(repo.untilDate, '07/01/2026');
    expect(repo.dayCurrent, '03/01/2026');
    expect(repo.typeTask, ['ROTINA']);
    expect(repo.status, ['PENDENTE']);
    expect(repo.assetIds, ['a1']);
    expect(repo.localIds, ['l1']);
    expect(repo.responsibleIds, ['r1']);
  });

  test('propaga Rejection quando o repositório falha', () async {
    repo.throwError = true;
    final result = await useCase(
      GetMaintenanceTaskEventsParams(
        dtStart: DateTime(2026, 1, 1),
        untilDate: DateTime(2026, 1, 7),
        typeTask: const ['ROTINA'],
        status: const ['PENDENTE'],
        dayCurrent: DateTime(2026, 1, 3),
      ),
    );
    expect(result, isA<Rejection<MaintenanceTaskEventsResponseEntity>>());
  });
}
