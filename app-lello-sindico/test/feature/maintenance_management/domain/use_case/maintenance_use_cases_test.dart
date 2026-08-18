import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/assets_lookup_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/delete_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/event_details_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/locals_lookup_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/submit_form_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/create_task_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/delete_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_assets_lookup_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_calendar_days_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_condominium_info_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_event_details_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_locals_lookup_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_details_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/submit_form_use_case.dart';

class _FakeRepo extends Fake implements MaintenanceManagementRepository {
  Object? last;
  bool fail = false;

  Try<T> _ok<T>(T value) =>
      fail ? Rejection(UnknownFailure('boom')) : Success(value);

  @override
  Future<Try<TaskDetailsEntity>> getTaskDetails(String taskId) async {
    last = taskId;
    return _ok(TaskDetailsEntity(
      id: taskId,
      name: 'Tarefa',
      status: 'PENDENTE',
      typeTask: 'ROTINA',
      allDay: false,
    ));
  }

  @override
  Future<Try<EventDetailsEntity>> getEventDetails(String eventId) async {
    last = eventId;
    return _ok(EventDetailsEntity(id: eventId));
  }

  @override
  Future<Try<CreateTaskResponseEntity>> createTask(
      CreateTaskRequestEntity request) async {
    last = request;
    return _ok(CreateTaskResponseEntity(
      idSchedule: 's1',
      idScheduleEvents: const ['e1'],
    ));
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
    last = '$month/$year';
    return _ok(CalendarDaysResponseEntity(month: month, year: year, days: const []));
  }

  @override
  Future<Try<DeleteScheduleEventResponseEntity>> deleteScheduleEvent(
      DeleteScheduleEventRequestEntity params) async {
    last = params;
    return _ok(const DeleteScheduleEventResponseEntity(success: true));
  }

  @override
  Future<Try<SubmitFormResponseEntity>> submitForm(
      SubmitFormRequestEntity request) async {
    last = request;
    return _ok(SubmitFormResponseEntity(success: true, data: 'ok'));
  }

  @override
  Future<Try<CondominiumInfoEntity>> getCondominiumInfoV2() async {
    last = 'v2';
    return _ok(const CondominiumInfoEntity(
      id: 'c1',
      assets: 0,
      floor: '',
      localsCount: 0,
      workflowUsers: '',
      condominiumName: 'Condo',
      blocksCount: 0,
      unitsCount: 0,
      references: [],
    ));
  }

  @override
  Future<Try<LocalsLookupEntity>> getLocalsLookup(String procedureIds) async {
    last = procedureIds;
    return _ok(LocalsLookupEntity(locals: const []));
  }

  @override
  Future<Try<AssetsLookupEntity>> getAssetsLookup(String procedureIds) async {
    last = procedureIds;
    return _ok(AssetsLookupEntity(assets: const []));
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  test('GetTaskDetails encaminha o taskId', () async {
    final result = await GetTaskDetailsUseCaseImpl(repo)(
      GetTaskDetailsRequest(taskId: 't-9'),
    );
    expect(result, isA<Success<TaskDetailsEntity>>());
    expect(repo.last, 't-9');
    expect((result as Success<TaskDetailsEntity>).get().name, 'Tarefa');
  });

  test('GetEventDetails encaminha o eventId', () async {
    final result = await GetEventDetailsUseCaseImpl(repo)(
      GetEventDetailsRequest(eventId: 'e-2'),
    );
    expect((result as Success<EventDetailsEntity>).get().id, 'e-2');
  });

  test('CreateTask encaminha o request', () async {
    final request = CreateTaskRequestEntity(
      procedureGroupId: 'g1',
      procedureId: 'p1',
      allDay: true,
      dtStart: '15/01/2026',
      repeat: false,
    );
    final result = await CreateTaskUseCaseImpl(repo)(request);
    expect(result, isA<Success<CreateTaskResponseEntity>>());
    expect(repo.last, request);
  });

  test('GetCalendarDays encaminha mês e ano', () async {
    final result = await GetCalendarDaysUseCaseImpl(repo)(
      GetCalendarDaysParams(month: 8, year: 2026),
    );
    expect(repo.last, '8/2026');
    expect((result as Success<CalendarDaysResponseEntity>).get().month, 8);
  });

  test('DeleteScheduleEvent encaminha params', () async {
    const params = DeleteScheduleEventRequestEntity(
      scheduleEventId: 'ev1',
      mode: 'THIS_SCHEDULE_EVENT',
    );
    final result = await DeleteScheduleEventUseCaseImpl(repo)(params);
    expect((result as Success<DeleteScheduleEventResponseEntity>).get().success, isTrue);
  });

  test('SubmitForm encaminha o request', () async {
    final request = SubmitFormRequestEntity(eventId: 'e1', answers: {});
    final result = await SubmitFormUseCase(repo)(request);
    expect((result as Success<SubmitFormResponseEntity>).get().success, isTrue);
  });

  test('GetCondominiumInfo usa o endpoint V2', () async {
    final result = await GetCondominiumInfoUseCaseImpl(repo)();
    expect(repo.last, 'v2');
    expect((result as Success<CondominiumInfoEntity>).get().id, 'c1');
  });

  test('GetLocalsLookup e GetAssetsLookup encaminham procedureIds', () async {
    await GetLocalsLookupUseCase(repo)('p1,p2');
    expect(repo.last, 'p1,p2');
    await GetAssetsLookupUseCase(repo)('p3');
    expect(repo.last, 'p3');
  });

  test('propaga Rejection quando o repositório falha', () async {
    repo.fail = true;
    final result = await GetTaskDetailsUseCaseImpl(repo)(
      GetTaskDetailsRequest(taskId: 'x'),
    );
    expect(result, isA<Rejection<TaskDetailsEntity>>());
  });
}
