import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/agenda_tasks_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/agenda_tasks_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/agenda_tasks_state.dart';

class _FakeGetTasks extends Fake implements GetMaintenanceTaskEventsUseCase {
  _FakeGetTasks(this.result);

  Try<MaintenanceTaskEventsResponseEntity> result;
  bool throwError = false;
  final calls = <GetMaintenanceTaskEventsParams>[];

  @override
  Future<Try<MaintenanceTaskEventsResponseEntity>> call(
    GetMaintenanceTaskEventsParams params,
  ) async {
    calls.add(params);
    if (throwError) throw Exception('falhou');
    return result;
  }
}

MaintenanceTaskEventEntity _task({
  String name = 'Limpeza',
  String type = 'ROTINA',
  String dtstart = '2026-01-10T08:00:00',
}) {
  return MaintenanceTaskEventEntity(
    typeTask: type,
    name: name,
    fullDescription: 'desc',
    responsibleUserable: 'Ana',
    timeStart: '08:00',
    timeEnd: '09:00',
    timeDescription: 'manhã',
    dtstart: dtstart,
    dtend: dtstart,
    dtstartFormatted: '10/01/2026',
    dtendFormatted: '10/01/2026',
    status: 'DONE',
    allDay: false,
  );
}

MaintenanceTaskEventsResponseEntity _response(
  List<MaintenanceTaskEventEntity> tasks,
) {
  return MaintenanceTaskEventsResponseEntity(
    taskSummaryDay: TaskSummaryEntity(
      total: tasks.length,
      done: tasks.length,
      notStarted: 0,
      draft: 0,
    ),
    taskFormulary: tasks,
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 50));

  test('carrega, ordena, usa cache e refresh', () async {
    final get = _FakeGetTasks(
      Success(
        _response([
          _task(name: 'Tarde', type: 'ORDEM_SERVICO', dtstart: '2026-01-10T14:00:00'),
          _task(name: 'Manhã', type: 'ROTINA', dtstart: '2026-01-10T08:00:00'),
        ]),
      ),
    );
    final bloc = AgendaTasksBloc(getMaintenanceTaskEventsUseCase: get);
    addTearDown(bloc.close);
    final date = DateTime(2026, 1, 10);

    bloc.add(LoadAgendaTasksEvent(selectedDate: date, orderBy: 'data'));
    await wait();
    final byDate = bloc.state as AgendaTasksLoadedState;
    expect(byDate.tasks.first.name, 'Manhã');
    expect(byDate.copyWith(totalTasks: 9).totalTasks, 9);

    bloc.add(LoadAgendaTasksEvent(selectedDate: date, orderBy: 'tipo'));
    await wait();
    expect(get.calls.length, 1);
    expect((bloc.state as AgendaTasksLoadedState).tasks.first.typeTask, 'ORDEM_SERVICO');

    bloc.add(RefreshAgendaTasksEvent(selectedDate: date, orderBy: 'data'));
    await wait();
    expect(get.calls.length, 2);

    bloc.add(ClearAgendaTasksCacheEvent());
    await wait();
  });

  test('emite vazio, erro, exceção e ignora dia diferente', () async {
    final get = _FakeGetTasks(Success(_response([])));
    final bloc = AgendaTasksBloc(getMaintenanceTaskEventsUseCase: get);
    addTearDown(bloc.close);

    bloc.add(LoadAgendaTasksEvent(selectedDate: DateTime(2026, 1, 10), orderBy: 'data'));
    await wait();
    expect(bloc.state, isA<AgendaTasksEmptyState>());

    get.result = Success(_response([_task(dtstart: '2026-01-11T08:00:00')]));
    bloc.add(LoadAgendaTasksEvent(selectedDate: DateTime(2026, 1, 12), orderBy: 'data'));
    await wait();
    expect(bloc.state, isA<AgendaTasksEmptyState>());

    get.result = Rejection(UnknownFailure('boom'));
    bloc.add(LoadAgendaTasksEvent(selectedDate: DateTime(2026, 1, 13), orderBy: 'data'));
    await wait();
    expect(bloc.state, isA<AgendaTasksErrorState>());

    get.throwError = true;
    bloc.add(LoadAgendaTasksEvent(selectedDate: DateTime(2026, 1, 14), orderBy: 'data'));
    await wait();
    expect(
      (bloc.state as AgendaTasksErrorState).message,
      contains('inesperado'),
    );
  });
}
