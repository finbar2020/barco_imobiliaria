import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/reset_schedule_event_entity.dart';
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

class _FakeReset extends Fake implements ResetScheduleEventUseCase {
  _FakeReset(this.result);

  Try<ResetScheduleEventEntity> result;
  Completer<Try<ResetScheduleEventEntity>>? pending;

  @override
  Future<Try<ResetScheduleEventEntity>> call(String scheduleEventId) async {
    if (pending != null) return pending!.future;
    return result;
  }
}

ScheduleEventsBloc _bloc(_FakeReset reset) {
  return ScheduleEventsBloc(
    getScheduleEventsUseCase: _FakeGetSchedule(),
    resetScheduleEventUseCase: reset,
  );
}

void main() {
  testWidgets('cancela o diálogo de confirmação', (tester) async {
    final bloc = _bloc(
      _FakeReset(Success(const ResetScheduleEventEntity(success: true))),
    );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const ResetScheduleEventButton(
          scheduleEventId: 'e1',
          buttonText: 'Reiniciar',
        ),
      ),
    );

    await tester.tap(find.text('Reiniciar'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar Reset'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar Reset'), findsNothing);
  });

  testWidgets('confirma o reset e dispara o callback de sucesso',
      (tester) async {
    var success = false;
    final bloc = _bloc(
      _FakeReset(Success(const ResetScheduleEventEntity(success: true))),
    );
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: ResetScheduleEventButton(
          scheduleEventId: 'e1',
          onResetSuccess: () => success = true,
        ),
      ),
    );

    await tester.tap(find.text('Resetar'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Resetar'));
    await tester.pumpAndSettle();
    expect(success, isTrue);
  });

  testWidgets('dispara callback de erro no reset compacto', (tester) async {
    String? error;
    final bloc = _bloc(_FakeReset(Rejection(UnknownFailure('nope'))));
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: CompactResetScheduleEventButton(
          scheduleEventId: 'e1',
          onResetError: (message) => error = message,
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(error, contains('UnknownFailure'));
  });

  testWidgets('mostra indicador enquanto o reset compacto carrega',
      (tester) async {
    final pending = Completer<Try<ResetScheduleEventEntity>>();
    final reset = _FakeReset(
      Success(const ResetScheduleEventEntity(success: true)),
    )..pending = pending;
    final bloc = _bloc(reset);
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider.value(
        value: bloc,
        child: const CompactResetScheduleEventButton(scheduleEventId: 'e1'),
      ),
      settle: false,
    );
    await tester.pump();

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(Success(const ResetScheduleEventEntity(success: true)));
    await tester.pump();
  });
}
