import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/reset_schedule_event_button.dart';

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
  testWidgets('golden — botão de reset padrão', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(),
      resetScheduleEventUseCase: _FakeReset(),
    );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const ResetScheduleEventButton(scheduleEventId: 'e1'),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reset_schedule_event_button.png'),
    );
  });

  testWidgets('golden — botão compacto de reset', (tester) async {
    final bloc = ScheduleEventsBloc(
      getScheduleEventsUseCase: _FakeGetSchedule(),
      resetScheduleEventUseCase: _FakeReset(),
    );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const CompactResetScheduleEventButton(scheduleEventId: 'e1'),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reset_schedule_event_button_compact.png'),
    );
  });
}
