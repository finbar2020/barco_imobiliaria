import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/agenda_task_list_widget.dart';

import '../../../../helpers/pump_app.dart';

class _FakeGetSchedule extends Fake implements GetScheduleEventsUseCase {
  @override
  Future<Try<ScheduleEventsDetailResponseEntity>> call(
    GetScheduleEventsParams params,
  ) async =>
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
      );
}

class _FakeReset extends Fake implements ResetScheduleEventUseCase {}

void main() {
  testWidgets('alterna a ordenação Data/Tipo', (tester) async {
    String? order;
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(),
      resetScheduleEventUseCase: _FakeReset(),
    );
    addTearDown(bloc.close);

    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: AgendaTaskListWidget(
          selectedOrder: 'data',
          onOrderChanged: (value) => order = value,
          selectedDate: DateTime(2026, 1, 11),
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 400),
    );

    await tester.tap(find.text('Tipo'));
    await tester.pump();
    expect(order, 'tipo');
    await tester.tap(find.text('Data'));
    await tester.pump();
    expect(order, 'data');
    expect(find.text('11/1/2026'), findsOneWidget);
  });
}
