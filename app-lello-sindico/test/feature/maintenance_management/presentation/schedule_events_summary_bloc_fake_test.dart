import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_state.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_summary/bloc/schedule_events_summary_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_summary/bloc/schedule_events_summary_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_summary/bloc/schedule_events_summary_state.dart';

class _FakeScheduleBloc extends Fake implements ScheduleEventsBloc {
  _FakeScheduleBloc(this.state);

  @override
  final ScheduleEventsState state;
}

ScheduleEventTaskEntity _event(String status) {
  return ScheduleEventTaskEntity(
    idSchedule: 's1',
    idScheduleEvent: 'e1',
    typeTask: 'ROTINA',
    name: 'Limpeza',
    fullDescription: '',
    responsibleUserable: '',
    procedureGroupId: '',
    responsibleId: '',
    timeStart: '08:00',
    timeDescription: 'manhã',
    dtStart: '2026-01-10',
    dtStartFormatted: '10/01/2026',
    status: status,
    allDay: false,
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 30));

  test('monta resumo a partir dos eventos e usa cache', () async {
    final schedule = _FakeScheduleBloc(
      ScheduleEventsLoadedState(
        events: [
          _event('DONE'),
          _event('NOT_STARTED'),
          _event('DRAFT'),
        ],
        selectedDate: DateTime(2026, 1, 10),
      ),
    );
    final bloc = ScheduleEventsSummaryBloc(scheduleEventsBloc: schedule);
    addTearDown(bloc.close);

    bloc.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    final loaded = bloc.state as ScheduleEventsSummaryLoadedState;
    expect(loaded.taskSummary.total, 3);
    expect(loaded.taskSummary.done, 1);
    expect(loaded.taskSummary.notStarted, 1);
    expect(loaded.taskSummary.draft, 1);

    bloc.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    expect(bloc.state, isA<ScheduleEventsSummaryLoadedState>());

    bloc.add(const ClearScheduleEventsSummaryCacheEvent());
    await wait();
  });

  test('usa taskSummary pronto, vazio, erro e data diferente', () async {
    final withSummary = _FakeScheduleBloc(
      ScheduleEventsLoadedState(
        events: const [],
        taskSummary: TaskSummaryEntity(
          total: 4,
          done: 2,
          notStarted: 1,
          draft: 1,
        ),
        selectedDate: DateTime(2026, 1, 10),
      ),
    );
    final bloc = ScheduleEventsSummaryBloc(scheduleEventsBloc: withSummary);
    addTearDown(bloc.close);
    bloc.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    expect(
      (bloc.state as ScheduleEventsSummaryLoadedState).taskSummary.total,
      4,
    );

    final emptyBloc = ScheduleEventsSummaryBloc(
      scheduleEventsBloc: _FakeScheduleBloc(
        ScheduleEventsEmptyState(selectedDate: DateTime(2026, 1, 10)),
      ),
    );
    addTearDown(emptyBloc.close);
    emptyBloc.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    expect(
      (emptyBloc.state as ScheduleEventsSummaryLoadedState).taskSummary.total,
      0,
    );

    final errorBloc = ScheduleEventsSummaryBloc(
      scheduleEventsBloc: _FakeScheduleBloc(
        ScheduleEventsErrorState(message: 'falhou'),
      ),
    );
    addTearDown(errorBloc.close);
    errorBloc.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    expect(errorBloc.state, isA<ScheduleEventsSummaryErrorState>());

    final otherDate = ScheduleEventsSummaryBloc(
      scheduleEventsBloc: _FakeScheduleBloc(
        ScheduleEventsLoadedState(
          events: [_event('DONE')],
          selectedDate: DateTime(2026, 1, 11),
        ),
      ),
    );
    addTearDown(otherDate.close);
    otherDate.add(LoadScheduleEventsSummaryEvent(selectedDate: DateTime(2026, 1, 10)));
    await wait();
    expect(
      (otherDate.state as ScheduleEventsSummaryLoadedState).taskSummary.total,
      0,
    );
  });
}
