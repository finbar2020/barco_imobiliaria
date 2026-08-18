import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_summary/schedule_events_summary_card_widget.dart';

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

ScheduleEventTaskFormularyEntity _task({
  required String id,
  required String status,
}) {
  return ScheduleEventTaskFormularyEntity(
    idSchedule: 's$id',
    idScheduleEvent: id,
    name: 'Tarefa $id',
    dtStart: '2026-01-10T08:00:00',
    dtEnd: '2026-01-10T08:00:00',
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
    typeTask: 'ROTINA',
  );
}

ScheduleEventsDetailResponseEntity _response(
  List<ScheduleEventTaskFormularyEntity> tasks,
) {
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

const _labels = {
  'schedule_events_day_total': 'Total do dia',
  'schedule_events_events': 'eventos',
  'task_summary_by_status': 'Por status',
  'concluded': 'Concluída',
  'not_started': 'Não iniciada',
  'task_status_in_progress': 'Em andamento',
};

Future<void> _pump(
  WidgetTester tester, {
  required ScheduleEventsBloc bloc,
  DateTime? selectedDate,
  bool settle = true,
}) async {
  addTearDown(bloc.close);
  await pumpApp(
    tester,
    BlocProvider.value(
      value: bloc,
      child: ScheduleEventsSummaryCard(
        selectedDate: selectedDate ?? DateTime(2026, 1, 10),
      ),
    ),
    shrinkWrap: false,
    surface: const Size(400, 240),
    localized: true,
    locOverrides: _labels,
    settle: settle,
  );
}

void main() {
  testWidgets('golden — resumo em carregamento', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response([]))),
      resetScheduleEventUseCase: _FakeReset(),
    );
    await _pump(tester, bloc: bloc, settle: false);
    await tester.pump(const Duration(milliseconds: 16));
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_summary_loading.png'),
    );
  });

  testWidgets('golden — resumo vazio', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(Success(_response([]))),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_summary_empty.png'),
    );
  });

  testWidgets('golden — resumo com status', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Success(
          _response([
            _task(id: '1', status: 'DONE'),
            _task(id: '2', status: 'NOT_STARTED'),
            _task(id: '3', status: 'DRAFT'),
          ]),
        ),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));
    await _pump(tester, bloc: bloc);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/schedule_events_summary_loaded.png'),
    );
  });

  testWidgets('golden — resumo com erro', (tester) async {
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
      matchesGoldenFile('goldens/schedule_events_summary_error.png'),
    );
  });
}
