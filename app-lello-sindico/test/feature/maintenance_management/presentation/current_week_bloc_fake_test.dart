import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/enums/efficiency_scope_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_bloc_impl.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_state.dart';

class _FakeGet extends Fake implements GetMaintenanceTaskEventsUseCase {
  _FakeGet(this.result);
  Try<MaintenanceTaskEventsResponseEntity> result;
  bool throwError = false;

  @override
  Future<Try<MaintenanceTaskEventsResponseEntity>> call(
    GetMaintenanceTaskEventsParams params,
  ) async {
    if (throwError) throw Exception('falhou');
    return result;
  }
}

MaintenanceTaskEventEntity _task() {
  return MaintenanceTaskEventEntity(
    typeTask: 'ROTINA',
    name: 'Limpeza',
    fullDescription: '',
    responsibleUserable: 'Ana',
    timeStart: '08:00',
    timeEnd: '09:00',
    timeDescription: 'manhã',
    dtstart: '2026-01-10T08:00:00',
    dtend: '2026-01-10T09:00:00',
    dtstartFormatted: '10/01/2026',
    dtendFormatted: '10/01/2026',
    status: 'DONE',
    allDay: false,
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 40));

  FetchMaintenanceTaskEventsEvent _event() {
    return FetchMaintenanceTaskEventsEvent(
      dtStart: DateTime(2026, 1, 5),
      untilDate: DateTime(2026, 1, 11),
      typeTask: const ['ROTINA'],
      status: const ['DONE'],
      dayCurrent: DateTime(2026, 1, 10),
    );
  }

  test('carrega, troca escopo, erro e exceção', () async {
    final get = _FakeGet(
      Success(
        MaintenanceTaskEventsResponseEntity(
          taskSummaryDay: TaskSummaryEntity(
            total: 1,
            done: 1,
            notStarted: 0,
            draft: 0,
          ),
          taskFormulary: [_task()],
        ),
      ),
    );
    final bloc = MaintenanceManagementCurrentWeekBlocImpl(get);
    addTearDown(bloc.close);

    bloc.add(_event());
    await wait();
    expect(bloc.state, isA<MaintenanceManagementCurrentWeekLoadedState>());

    bloc.changeScope(EfficiencyScope.groups);
    await wait();
    expect(
      (bloc.state as MaintenanceManagementCurrentWeekLoadedState).currentScope,
      EfficiencyScope.groups,
    );

    get.result = Rejection(UnknownFailure('boom'));
    bloc.add(_event());
    await wait();
    expect(bloc.state, isA<MaintenanceManagementCurrentWeekErrorState>());

    get.throwError = true;
    bloc.add(_event());
    await wait();
    expect(
      (bloc.state as MaintenanceManagementCurrentWeekErrorState).message,
      contains('falhou'),
    );
  });
}
