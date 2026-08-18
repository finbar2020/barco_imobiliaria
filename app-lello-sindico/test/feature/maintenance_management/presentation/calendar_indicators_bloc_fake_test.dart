import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_calendar_days_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_state.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

class _FakeGetDays extends Fake implements GetCalendarDaysUseCase {
  _FakeGetDays(this.result);

  Try<CalendarDaysResponseEntity> result;
  bool throwError = false;
  final calls = <GetCalendarDaysParams>[];

  @override
  Future<Try<CalendarDaysResponseEntity>> call(
    GetCalendarDaysParams params,
  ) async {
    calls.add(params);
    if (throwError) throw Exception('falhou');
    return result;
  }
}

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

const _days = CalendarDaysResponseEntity(
  month: 1,
  year: 2026,
  days: [
    CalendarDayEntity(day: 10, hasEvents: true, taskCount: 3),
    CalendarDayEntity(day: 11, hasEvents: false, taskCount: 0),
  ],
);

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 50));

  test('carrega, usa cache, refresh e limpa', () async {
    final get = _FakeGetDays(Success(_days));
    final bloc = CalendarIndicatorsBloc(getCalendarDaysUseCase: get);
    addTearDown(bloc.close);

    bloc.add(LoadCalendarIndicatorsEvent(month: 1, year: 2026, appliedFilters: _filters()));
    await wait();
    expect(bloc.state, isA<CalendarIndicatorsLoadedState>());
    expect(get.calls.single.typeTask, ['ROTINA', 'ORDEM_SERVICO']);
    expect(get.calls.single.status, ['NOT_STARTED', 'DRAFT', 'DONE']);
    expect(bloc.hasTasksOnDay(10), isTrue);
    expect(bloc.hasTasksOnDay(12), isFalse);
    expect(bloc.getTaskCountOnDay(10), 3);
    expect(bloc.getTaskCountOnDay(99), 0);
    expect(bloc.state.toString(), contains('days: 2'));

    bloc.add(LoadCalendarIndicatorsEvent(month: 1, year: 2026));
    await wait();
    expect(get.calls.length, 1);

    bloc.add(RefreshCalendarIndicatorsEvent(month: 1, year: 2026));
    await wait();
    expect(get.calls.length, 2);

    bloc.add(ClearCalendarIndicatorsCacheEvent());
    await wait();
  });

  test('emite vazio, erro conhecido, erro genérico e exceção', () async {
    final get = _FakeGetDays(
      Success(const CalendarDaysResponseEntity(month: 2, year: 2026, days: [])),
    );
    final bloc = CalendarIndicatorsBloc(getCalendarDaysUseCase: get);
    addTearDown(bloc.close);

    bloc.add(LoadCalendarIndicatorsEvent(month: 2, year: 2026));
    await wait();
    expect(bloc.state, isA<CalendarIndicatorsEmptyState>());
    expect(bloc.hasTasksOnDay(1), isFalse);
    expect(bloc.getTaskCountOnDay(1), 0);
    expect(bloc.state.toString(), contains('month: 2'));

    get.result = Rejection(UnknownFailure('boom'));
    bloc.add(LoadCalendarIndicatorsEvent(month: 3, year: 2026));
    await wait();
    expect(
      (bloc.state as CalendarIndicatorsErrorState).message,
      contains('boom'),
    );

    get.result = Rejection(ServerConnectionFailure());
    bloc.add(LoadCalendarIndicatorsEvent(month: 4, year: 2026));
    await wait();
    expect(
      (bloc.state as CalendarIndicatorsErrorState).message,
      contains('ServerConnectionFailure'),
    );

    get.throwError = true;
    bloc.add(LoadCalendarIndicatorsEvent(month: 5, year: 2026));
    await wait();
    expect(
      (bloc.state as CalendarIndicatorsErrorState).message,
      contains('inesperado'),
    );
  });
}
