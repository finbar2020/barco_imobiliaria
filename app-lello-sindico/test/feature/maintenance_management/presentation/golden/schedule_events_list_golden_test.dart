import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_state.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_list_widget.dart';

import '../../../../helpers/pump_app.dart';

class _FakeGetSchedule extends Fake implements GetScheduleEventsUseCase {
  _FakeGetSchedule(this.result);
  final Try<ScheduleEventsDetailResponseEntity> result;

  @override
  Future<Try<ScheduleEventsDetailResponseEntity>> call(
    GetScheduleEventsParams params,
  ) async =>
      result;
}

class _FakeReset extends Fake implements ResetScheduleEventUseCase {}

class _SeededBloc extends ScheduleEventsBloc {
  _SeededBloc()
      : super(
          getScheduleEventsUseCase: _FakeGetSchedule(Success(_response([]))),
          resetScheduleEventUseCase: _FakeReset(),
        );

  void seed(ScheduleEventsState state) => emit(state);
}

ScheduleEventTaskFormularyEntity _task({
  required String id,
  String name = 'Limpeza',
  String type = 'ROTINA',
  String status = 'DONE',
  String dtStart = '2026-01-10T08:00:00',
}) {
  return ScheduleEventTaskFormularyEntity(
    idSchedule: 's$id',
    idScheduleEvent: id,
    name: name,
    dtStart: dtStart,
    dtEnd: dtStart,
    allDay: false,
    percentDone: '0',
    description: '',
    procedureGroupLabel: '',
    localsLabel: '',
    createdAt: '',
    effectiveDate: '',
    updatedAt: '',
    status: status,
    rrule: '',
    color: '',
    icon: '',
    timeStart: '08:00',
    timeEnd: '09:00',
    timeDescription: 'manhã',
    typeTask: type,
  );
}

ScheduleEventsDetailResponseEntity _response(
  List<ScheduleEventTaskFormularyEntity> tasks,
) {
  return ScheduleEventsDetailResponseEntity(
    success: true,
    message: 'ok',
    data: ScheduleEventsDetailDataEntity(
      taskSummaryDay: [
        ScheduleEventTaskSummaryDayEntity(
          date: '2026-01-10',
          taskFormulary: tasks,
        ),
      ],
      obligations: const [],
    ),
    legacyStatusCode: 200,
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required ScheduleEventsBloc bloc,
  bool settle = true,
}) async {
  addTearDown(bloc.close);
  await pumpApp(
    tester,
    BlocProvider.value(
      value: bloc,
      child: ScheduleEventsListWidget(
        selectedDate: DateTime(2026, 1, 10),
        shrinkWrap: true,
      ),
    ),
    shrinkWrap: false,
    surface: const Size(400, 640),
    localized: true,
    locOverrides: const {
      'task_type_routine': 'Rotina',
      'task_type_service_order': 'Ordem de serviço',
      'concluded': 'Concluída',
      'pending': 'Pendente',
      'task_status_in_progress': 'Em andamento',
    },
    settle: settle,
  );
}

void main() {
  testWidgets('golden — lista sem data selecionada', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response([]))),
      resetScheduleEventUseCase: _FakeReset(),
    );
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_initial.png'),
    );
  });

  testWidgets('golden — lista vazia', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response([]))),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_empty.png'),
    );
  });

  testWidgets('golden — lista com rotina e OS', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Success(
          _response([
            _task(id: '1', name: 'Limpeza do hall'),
            _task(
              id: '2',
              name: '',
              type: 'ORDEM_SERVICO',
              status: 'DRAFT',
              dtStart: '10/01/2026 08:00:00',
            ),
          ]),
        ),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_loaded.png'),
    );
  });

  testWidgets('golden — lista com erro', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Rejection(UnknownFailure('timeout')),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_error.png'),
    );
  });

  testWidgets('golden — lista em carregamento', (tester) async {
    final bloc = _SeededBloc()..seed(ScheduleEventsLoadingState());
    await _pump(tester, bloc: bloc, settle: false);
    await tester.pump(const Duration(milliseconds: 16));
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_loading.png'),
    );
  });

  testWidgets('golden — detalhe vazio', (tester) async {
    final bloc = _SeededBloc()
      ..seed(
        ScheduleEventsDetailEmptyState(
          dtStart: DateTime(2026, 1, 1),
          untilDate: DateTime(2026, 1, 7),
          dayCurrent: DateTime(2026, 1, 3),
        ),
      );
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_detail_empty.png'),
    );
  });

  testWidgets('golden — detalhe com tarefas do dia', (tester) async {
    final bloc = _SeededBloc()
      ..seed(
        ScheduleEventsDetailLoadedState(
          detailResponse: _response([
            _task(id: '1', name: 'Limpeza do hall'),
            _task(id: '2', name: '', type: 'OS', status: 'COMPLETED'),
          ]),
          dtStart: DateTime(2026, 1, 1),
          untilDate: DateTime(2026, 1, 7),
          dayCurrent: DateTime(2026, 1, 10),
        ),
      );
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_list_detail_loaded.png'),
    );
  });
}
