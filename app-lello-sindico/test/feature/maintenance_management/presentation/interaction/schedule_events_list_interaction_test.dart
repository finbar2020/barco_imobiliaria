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
          getScheduleEventsUseCase: _FakeGetSchedule(
            Success(
              const ScheduleEventsDetailResponseEntity(
                success: true,
                message: 'ok',
                data: ScheduleEventsDetailDataEntity(
                  taskSummaryDay: [],
                  obligations: [],
                ),
                legacyStatusCode: 200,
              ),
            ),
          ),
          resetScheduleEventUseCase: _FakeReset(),
        );

  void seed(ScheduleEventsState state) => emit(state);
}

ScheduleEventTaskFormularyEntity _task(
  String id, {
  String dtStart = '2026-01-10T08:00:00',
}) {
  return ScheduleEventTaskFormularyEntity(
    idSchedule: 's$id',
    idScheduleEvent: id,
    name: 'Tarefa $id',
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
    status: 'NOT_STARTED',
    rrule: '',
    color: '',
    icon: '',
    timeStart: '08:00',
    timeEnd: '09:00',
    timeDescription: 'manhã',
    typeTask: 'ROUTINE',
  );
}

ScheduleEventTaskEntity _event({
  required String id,
  String name = 'Limpeza',
  String type = 'ROTINA',
  String status = 'DONE',
  String dtStart = '2026-01-10T08:00:00',
}) {
  return ScheduleEventTaskEntity(
    idSchedule: 's$id',
    idScheduleEvent: id,
    typeTask: type,
    name: name,
    fullDescription: '',
    responsibleUserable: '',
    procedureGroupId: '',
    responsibleId: '',
    timeStart: '08:00',
    timeDescription: 'manhã',
    dtStart: dtStart,
    dtStartFormatted: dtStart,
    status: status,
    allDay: false,
  );
}

const _labels = {
  'task_type_routine': 'Rotina',
  'task_type_service_order': 'Ordem de serviço',
  'concluded': 'Concluída',
  'pending': 'Pendente',
  'task_status_in_progress': 'Em andamento',
};

void main() {
  testWidgets('mostra Ver mais e carrega a próxima página', (tester) async {
    final tasks = List.generate(6, (i) => _task('${i + 1}'));
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(
        Success(
          ScheduleEventsDetailResponseEntity(
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
          ),
        ),
      ),
      resetScheduleEventUseCase: _FakeReset(),
    );
    addTearDown(bloc.close);
    bloc.add(LoadScheduleEventsEvent(selectedDate: DateTime(2026, 1, 10)));

    await pumpApp(
      tester,
      BlocProvider<ScheduleEventsBloc>.value(
        value: bloc,
        child: ScheduleEventsListWidget(
          selectedDate: DateTime(2026, 1, 10),
          shrinkWrap: true,
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 900),
      localized: true,
      locOverrides: _labels,
    );

    expect(find.text('Tarefa 1'), findsOneWidget);
    expect(find.text('Tarefa 6'), findsNothing);
    expect(find.text('Ver mais'), findsOneWidget);

    await tester.tap(find.text('Ver mais'));
    await tester.pump();
    expect(find.text('Tarefa 6'), findsOneWidget);
  });

  testWidgets('mapeia aliases de tipo, status e datas BR', (tester) async {
    final bloc = _SeededBloc()
      ..seed(
        ScheduleEventsLoadedState(
          events: [
            _event(id: '1', type: 'OS', status: 'COMPLETED', name: 'OS ok'),
            _event(id: '2', type: 'OUTRO', status: 'PENDING', name: 'Pendente'),
            _event(
              id: '3',
              type: 'ROUTINE',
              status: 'IN_PROGRESS',
              name: 'Andamento',
              dtStart: '10/01/2026',
            ),
            _event(id: '4', status: 'X', name: '', dtStart: 'quebrado'),
          ],
          selectedDate: DateTime(2026, 1, 10),
        ),
      );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider<ScheduleEventsBloc>.value(
        value: bloc,
        child: ScheduleEventsListWidget(
          selectedDate: DateTime(2026, 1, 10),
          shrinkWrap: true,
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 900),
      localized: true,
      locOverrides: _labels,
    );
    expect(find.text('OS ok'), findsOneWidget);
    expect(find.text('Sem título'), findsOneWidget);
    expect(find.text('Andamento'), findsOneWidget);
  });

  testWidgets('detalhe pagina com Ver mais', (tester) async {
    final bloc = _SeededBloc()
      ..seed(
        ScheduleEventsDetailLoadedState(
          detailResponse: ScheduleEventsDetailResponseEntity(
            success: true,
            message: 'ok',
            data: ScheduleEventsDetailDataEntity(
              taskSummaryDay: [
                ScheduleEventTaskSummaryDayEntity(
                  date: '10/01/2026',
                  taskFormulary: List.generate(6, (i) => _task('${i + 1}')),
                ),
              ],
              obligations: const [],
            ),
            legacyStatusCode: 200,
          ),
          dtStart: DateTime(2026, 1, 1),
          untilDate: DateTime(2026, 1, 7),
          dayCurrent: DateTime(2026, 1, 10),
        ),
      );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider<ScheduleEventsBloc>.value(
        value: bloc,
        child: ScheduleEventsListWidget(
          selectedDate: DateTime(2026, 1, 10),
          shrinkWrap: true,
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 1000),
      localized: true,
      locOverrides: _labels,
    );
    expect(find.text('6 evento(s)'), findsOneWidget);
    expect(find.text('Tarefa 6'), findsNothing);
    await tester.tap(find.text('Ver mais'));
    await tester.pump();
    expect(find.text('Tarefa 6'), findsOneWidget);
  });

  testWidgets('lista carregada sem eventos mostra vazio', (tester) async {
    final bloc = _SeededBloc()
      ..seed(
        ScheduleEventsLoadedState(
          events: const [],
          selectedDate: DateTime(2026, 1, 10),
        ),
      );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider<ScheduleEventsBloc>.value(
        value: bloc,
        child: ScheduleEventsListWidget(
          selectedDate: DateTime(2026, 1, 10),
          shrinkWrap: true,
        ),
      ),
    );
    expect(
      find.text('Nenhum evento encontrado para esta data'),
      findsOneWidget,
    );
  });
}
