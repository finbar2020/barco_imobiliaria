import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_intro_widget.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

class _FakeGetTimesheet extends Fake implements GetTimesheetUsecase {
  @override
  Future<Try<Timesheet>> call(GetTimesheetParam params) async =>
      Success(Timesheet(
        dateFrom: DateTime(2026, 1, 1),
        dateTo: DateTime(2026, 1, 31),
        timesheetStatus: TimesheetStatusEnum.notAssigned,
        timesheetElements: const [],
      ));
}

class _FakeGetPeriods extends Fake implements GetTimesheetPeriodsUsecase {
  @override
  Future<Try<List<TimesheetPeriods>>> call(
    GetTimesheetPeriodsParam params,
  ) async =>
      Success(const []);
}

TimesheetPeriods _periodo(DateTime mes) => TimesheetPeriods(
      periodMonth: mes,
      startDate: DateTime(mes.year, mes.month, 1),
      endDate: DateTime(mes.year, mes.month, 28),
    );

TimesheetBloc _timesheetBloc() {
  final bloc = TimesheetBloc(
    sessionBloc: FakeSessionBloc(),
    getTimesheetUsecase: _FakeGetTimesheet(),
    getTimesheetPeriodsUsecase: _FakeGetPeriods(),
    store: SessionStore(),
  );
  bloc.availableDates = [DateTime(2026, 1, 1), DateTime(2026, 2, 1)];
  bloc.timesheetPeriods = [
    _periodo(DateTime(2026, 1, 1)),
    _periodo(DateTime(2026, 2, 1)),
  ];
  return bloc;
}

void main() {
  Future<void> pumpIntro(
    WidgetTester tester, {
    required TimesheetStatusEnum status,
    Timesheet? timesheet,
    void Function(DateTime?)? onDateSelected,
    void Function(int, List<TimesheetPeriods>)? setPeriods,
    Size surface = const Size(560, 420),
  }) async {
    final bloc = _timesheetBloc();
    addTearDown(bloc.close);
    await pumpApp(
      tester,
      BlocProvider<TimesheetBloc>.value(
        value: bloc,
        child: TimesheetIntro(
          date: DateTime(2026, 1, 1),
          onDateSelected: onDateSelected ?? (_) {},
          setPeriods: setPeriods ?? (_, __) {},
          periodStartDate: DateTime(2026, 1, 1),
          periodEndDate: DateTime(2026, 1, 31),
          timesheetStatus: status,
          timesheet: timesheet,
        ),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: surface,
    );
    await tester.pump();
  }

  group('TimesheetIntro', () {
    testWidgets('espelho não assinado mostra o título do período',
        (tester) async {
      await pumpIntro(tester, status: TimesheetStatusEnum.notAssigned);

      expect(find.text('timesheet_page_title'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<DateTime>), findsOneWidget);
    });

    testWidgets('espelho assinado mostra o aviso de assinatura',
        (tester) async {
      await pumpIntro(tester, status: TimesheetStatusEnum.assigned);

      expect(find.text('timesheet_page_assigned'), findsOneWidget);
    });

    testWidgets('espelho bloqueado mostra a data de liberação', (tester) async {
      await pumpIntro(
        tester,
        status: TimesheetStatusEnum.notAllowed,
        timesheet: Timesheet(
          dateFrom: DateTime(2026, 1, 1),
          dateTo: DateTime(2026, 1, 31),
          dateLiberation: DateTime(2026, 2, 5),
          timesheetStatus: TimesheetStatusEnum.notAllowed,
          timesheetElements: const [],
        ),
      );

      expect(find.text('Bloqueado'), findsOneWidget);
      expect(
        find.textContaining('timesheet_info_liberation_date'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('bloqueado sem data de liberação esconde o aviso',
        (tester) async {
      await pumpIntro(tester, status: TimesheetStatusEnum.notAllowed);

      expect(find.text('Bloqueado'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('escolher outro período avisa a tela', (tester) async {
      final selecionadas = <DateTime?>[];
      final indices = <int>[];
      await pumpIntro(
        tester,
        status: TimesheetStatusEnum.notAssigned,
        onDateSelected: selecionadas.add,
        setPeriods: (index, _) => indices.add(index),
      );

      await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // O rótulo é o mês por extenso, ex.: "February - 2026".
      await tester.tap(find.textContaining('2026').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(selecionadas, [DateTime(2026, 2, 1)]);
      expect(indices, [1]);
    });
  });
}
