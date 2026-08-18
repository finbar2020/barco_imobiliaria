import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_intro_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      Success([
        TimesheetPeriods(
          periodMonth: DateTime(2026, 1, 1),
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
        ),
      ]);
}

TimesheetBloc _timesheetBloc() {
  final bloc = TimesheetBloc(
    sessionBloc: FakeSessionBloc(),
    getTimesheetUsecase: _FakeGetTimesheet(),
    getTimesheetPeriodsUsecase: _FakeGetPeriods(),
    store: SessionStore(),
  );
  bloc.availableDates = [DateTime(2026, 1, 1)];
  bloc.timesheetPeriods = [
    TimesheetPeriods(
      periodMonth: DateTime(2026, 1, 1),
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 31),
    ),
  ];
  return bloc;
}

Future<void> _pumpIntro(
  WidgetTester tester, {
  required TimesheetStatusEnum status,
  Timesheet? timesheet,
  Size surface = const Size(560, 320),
}) async {
  final bloc = _timesheetBloc();
  addTearDown(bloc.close);
  await pumpApp(
    tester,
    BlocProvider<TimesheetBloc>.value(
      value: bloc,
      child: TimesheetIntro(
        date: DateTime(2026, 1, 1),
        onDateSelected: (_) {},
        setPeriods: (_, __) {},
        periodStartDate: DateTime(2026, 1, 1),
        periodEndDate: DateTime(2026, 1, 31),
        timesheetStatus: status,
        timesheet: timesheet,
      ),
    ),
    localized: true,
    shrinkWrap: false,
    surface: surface,
  );
}

void main() {
  testWidgets('golden — timesheet intro não assinado', (tester) async {
    await _pumpIntro(tester, status: TimesheetStatusEnum.notAssigned);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_intro_not_assigned.png'),
    );
  });

  testWidgets('golden — timesheet intro assinado', (tester) async {
    await _pumpIntro(tester, status: TimesheetStatusEnum.assigned);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_intro_assigned.png'),
    );
  });

  testWidgets('golden — timesheet intro bloqueado', (tester) async {
    await _pumpIntro(
      tester,
      status: TimesheetStatusEnum.notAllowed,
      timesheet: Timesheet(
        dateFrom: DateTime(2026, 1, 1),
        dateTo: DateTime(2026, 1, 31),
        dateLiberation: DateTime(2026, 2, 5),
        timesheetStatus: TimesheetStatusEnum.notAllowed,
        timesheetElements: const [],
      ),
      surface: const Size(560, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_intro_blocked.png'),
    );
  });
}
