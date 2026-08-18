import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/agenda_task_list_widget.dart';

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

ScheduleEventsDetailResponseEntity _response({
  List<ScheduleEventTaskFormularyEntity> tasks = const [],
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
      obligations: const [],
    ),
    legacyStatusCode: 200,
  );
}

const _osTask = ScheduleEventTaskFormularyEntity(
  idSchedule: 's1',
  idScheduleEvent: 'e1',
  name: 'Troca da bomba',
  dtStart: '2026-01-10T08:00:00',
  dtEnd: '2026-01-10T09:00:00',
  allDay: false,
  percentDone: '0',
  description: 'Verificar a bomba da garagem do bloco A.',
  procedureGroupLabel: 'Grupo',
  localsLabel: 'Garagem',
  createdAt: 'a',
  effectiveDate: 'b',
  updatedAt: 'c',
  status: 'pending',
  rrule: '',
  color: '#fff',
  icon: 'i',
  timeStart: '08:00',
  timeEnd: '09:00',
  timeDescription: 'manhã',
  typeTask: 'ORDEM_SERVICO',
);

Future<void> _pumpList(
  WidgetTester tester, {
  required ScheduleEventsBloc bloc,
  DateTime? selectedDate,
  String order = 'data',
  bool settle = true,
}) async {
  addTearDown(bloc.close);
  await pumpApp(
    tester,
    BlocProvider.value(
      value: bloc,
      child: AgendaTaskListWidget(
        selectedOrder: order,
        onOrderChanged: (_) {},
        selectedDate: selectedDate,
      ),
    ),
    shrinkWrap: false,
    surface: const Size(400, 640),
    settle: settle,
  );
}

void main() {
  testWidgets('golden — agenda sem dia selecionado', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response())),
      resetScheduleEventUseCase: _FakeReset(),
    );
    await _pumpList(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agenda_task_list_initial.png'),
    );
  });

  testWidgets('golden — agenda vazia', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response())),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pumpList(
      tester,
      bloc: bloc,
      selectedDate: DateTime(2026, 1, 10),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agenda_task_list_empty.png'),
    );
  });

  testWidgets('golden — agenda com ordem de serviço', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Success(_response(tasks: [_osTask])),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pumpList(
      tester,
      bloc: bloc,
      selectedDate: DateTime(2026, 1, 10),
      order: 'tipo',
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agenda_task_list_loaded.png'),
    );
  });

  testWidgets('golden — agenda com erro', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Rejection(UnknownFailure('timeout')),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pumpList(
      tester,
      bloc: bloc,
      selectedDate: DateTime(2026, 1, 10),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agenda_task_list_error.png'),
    );
  });
}
