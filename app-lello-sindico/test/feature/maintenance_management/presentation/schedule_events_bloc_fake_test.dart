import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/reset_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_state.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

class _FakeGetSchedule extends Fake implements GetScheduleEventsUseCase {
  _FakeGetSchedule(this.result, {this.calendarResult});

  Try<ScheduleEventsDetailResponseEntity> result;
  Try<ScheduleEventsDetailResponseEntity>? calendarResult;
  final calls = <GetScheduleEventsParams>[];

  @override
  Future<Try<ScheduleEventsDetailResponseEntity>> call(
    GetScheduleEventsParams params,
  ) async {
    calls.add(params);
    if (params.pageName == 'CALENDAR' && calendarResult != null) {
      return calendarResult!;
    }
    return result;
  }
}

class _FakeReset extends Fake implements ResetScheduleEventUseCase {
  _FakeReset(this.result);

  Try<ResetScheduleEventEntity> result;
  bool throwError = false;

  @override
  Future<Try<ResetScheduleEventEntity>> call(String scheduleEventId) async {
    if (throwError) throw Exception('falhou');
    return result;
  }
}

ScheduleEventTaskFormularyEntity _task({
  String timeStart = '08:00',
  String timeDescription = 'manhã',
  bool allDay = false,
  String dtStart = '2026-01-10T08:00:00',
  String rrule = '',
  String name = 'Limpeza',
}) {
  return ScheduleEventTaskFormularyEntity(
    idSchedule: 's1',
    idScheduleEvent: 'e1',
    name: name,
    dtStart: dtStart,
    dtEnd: dtStart,
    allDay: allDay,
    percentDone: '0',
    description: 'desc',
    procedureGroupLabel: '',
    localsLabel: '',
    createdAt: '',
    effectiveDate: '',
    updatedAt: '',
    status: 'DONE',
    rrule: rrule,
    color: '',
    icon: '',
    timeStart: timeStart,
    timeEnd: '09:00',
    timeDescription: timeDescription,
    typeTask: 'ROTINA',
  );
}

ScheduleEventsDetailResponseEntity _response({
  List<ScheduleEventTaskFormularyEntity> tasks = const [],
  List<ScheduleEventObligationEntity> obligations = const [],
}) {
  return ScheduleEventsDetailResponseEntity(
    success: true,
    message: 'ok',
    data: ScheduleEventsDetailDataEntity(
      taskSummaryDay: tasks.isEmpty
          ? const []
          : [
              ScheduleEventTaskSummaryDayEntity(
                date: '2026-01-10',
                taskFormulary: tasks,
              ),
            ],
      obligations: obligations,
    ),
    legacyStatusCode: 200,
  );
}

const _obligation = ScheduleEventObligationEntity(
  id: 'o1',
  collectionCode: 'c',
  reference: 1,
  partnerType: 'p',
  legalObligationType: 'PDF',
  name: 'AVCB',
  expirationDescription: '',
  expirationDate: '2026-01-10',
  expirationStatus: 'ok',
);

FilterOptionsEntity _filters() {
  return FilterOptionsEntity(
    locals: [FilterLocalEntity(id: 'l1', name: 'Hall')],
    assets: [FilterAssetEntity(id: 'a1', name: 'Bomba')],
    responsibles: [FilterResponsibleEntity(id: 'r1', name: 'Ana')],
    employeeGroup: const [],
    taskType: [TaskType.routine, TaskType.serviceOrder],
    taskStatus: [
      TaskStatusType.pending,
      TaskStatusType.inProgress,
      TaskStatusType.completed,
    ],
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 30));

  test('carrega com filtros, usa cache e refresh força nova busca', () async {
    final get = _FakeGetSchedule(Success(_response(tasks: [_task()])));
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: get,
      resetScheduleEventUseCase: _FakeReset(
        Success(const ResetScheduleEventEntity(success: true)),
      ),
    );
    addTearDown(bloc.close);
    final date = DateTime(2026, 1, 10);

    bloc.add(
      LoadScheduleEventsEvent(selectedDate: date, appliedFilters: _filters()),
    );
    await wait();
    expect(bloc.state, isA<ScheduleEventsLoadedState>());
    expect(get.calls.single.typeTask, ['ROTINA', 'ORDEM_SERVICO']);
    expect(get.calls.single.status, ['NOT_STARTED', 'DRAFT', 'DONE']);
    expect(get.calls.single.assetIds, ['a1']);
    expect(get.calls.single.localIds, ['l1']);
    expect(get.calls.single.responsibleIds, ['r1']);

    bloc.add(LoadScheduleEventsEvent(selectedDate: date));
    await wait();
    expect(get.calls.length, 1);

    bloc.add(RefreshScheduleEventsEvent(selectedDate: date));
    await wait();
    expect(get.calls.length, 2);

    bloc.add(ClearScheduleEventsCacheEvent());
    await wait();
  });

  test('emite vazio, erro e obrigação sem tarefa', () async {
    final get = _FakeGetSchedule(Success(_response()));
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: get,
      resetScheduleEventUseCase: _FakeReset(
        Success(const ResetScheduleEventEntity(success: true)),
      ),
    );
    addTearDown(bloc.close);

    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 11)));
    await wait();
    expect(bloc.state, isA<ScheduleEventsEmptyState>());

    get.result = Rejection(UnknownFailure('boom'));
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 12)));
    await wait();
    expect(bloc.state, isA<ScheduleEventsErrorState>());

    get.result = Success(_response(obligations: [_obligation]));
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 13)));
    await wait();
    expect(
      (bloc.state as ScheduleEventsLoadedState).obligations,
      isNotEmpty,
    );
  });

  test('mapeia horário vazio, dia inteiro, rrule e data inválida', () async {
    final get = _FakeGetSchedule(
      Success(
        _response(
          tasks: [
            _task(
              timeStart: '',
              timeDescription: '',
              allDay: true,
              dtStart: '2026-01-10T14:05:00',
              rrule: 'FREQ=DAILY',
            ),
            _task(
              timeStart: '',
              timeDescription: '',
              allDay: false,
              dtStart: 'quebrado',
              name: 'Outra',
            ),
          ],
        ),
      ),
    );
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: get,
      resetScheduleEventUseCase: _FakeReset(
        Success(const ResetScheduleEventEntity(success: true)),
      ),
    );
    addTearDown(bloc.close);
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 2, 1)));
    await wait();
    final loaded = bloc.state as ScheduleEventsLoadedState;
    expect(loaded.events.first.timeDescription, 'Dia Inteiro');
    expect(loaded.events.first.rrule, 'FREQ=DAILY');
    expect(loaded.events.last.timeStart, '00:00');
  });

  test('reset sucesso, falha e exceção', () async {
    final reset = _FakeReset(
      Success(const ResetScheduleEventEntity(success: true, message: 'ok')),
    );
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response())),
      resetScheduleEventUseCase: reset,
    );
    addTearDown(bloc.close);

    bloc.add(ResetScheduleEventEvent(scheduleEventId: 'e1'));
    await wait();
    expect(bloc.state, isA<ResetScheduleEventSuccessState>());
    expect(bloc.state.toString(), contains('ok'));

    reset.result = Rejection(UnknownFailure('nope'));
    bloc.add(ResetScheduleEventEvent(scheduleEventId: 'e2'));
    await wait();
    expect(bloc.state, isA<ResetScheduleEventErrorState>());
    expect(
      (bloc.state as ResetScheduleEventErrorState).message,
      contains('UnknownFailure'),
    );

    reset.throwError = true;
    bloc.add(ResetScheduleEventEvent(scheduleEventId: 'e3'));
    await wait();
    expect(
      (bloc.state as ResetScheduleEventErrorState).message,
      contains('inesperado'),
    );
  });

  test('estados de detalhe expõem props e toString', () {
    const detail = ScheduleEventsDetailResponseEntity(
      success: true,
      message: 'ok',
      data: ScheduleEventsDetailDataEntity(
        taskSummaryDay: [],
        obligations: [],
      ),
      legacyStatusCode: 200,
    );
    final loaded = ScheduleEventsDetailLoadedState(
      detailResponse: detail,
      dtStart: DateTime(2026, 1, 1),
      untilDate: DateTime(2026, 1, 7),
      dayCurrent: DateTime(2026, 1, 3),
    );
    expect(loaded.toString(), contains('days: 0'));
    expect(loaded.props, hasLength(4));

    final empty = ScheduleEventsDetailEmptyState(
      dtStart: DateTime(2026, 1, 1),
      untilDate: DateTime(2026, 1, 7),
      dayCurrent: DateTime(2026, 1, 3),
    );
    expect(empty.toString(), contains('period'));
    expect(
      ScheduleEventsEmptyState(selectedDate: DateTime(2026, 1, 1)).toString(),
      contains('2026'),
    );
  });
}
