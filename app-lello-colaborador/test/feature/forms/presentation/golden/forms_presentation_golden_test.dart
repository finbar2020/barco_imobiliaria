import 'dart:async';

import 'package:colaborador/feature/digital_point/presentation/page/face_register_error_page.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/presentation/widgets/employee_referral_page_body_widget.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/widgets/manual_timesheet_document_form.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/presentation/widgets/sick_note_document_form.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_intro_widget.dart';
import 'package:colaborador/core/stores/session_store.dart';
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

FaceRegisterErrorPageArgs _faceArgs() => FaceRegisterErrorPageArgs(
      statusEnum: DigitalTimesheetStatusEnum.approved,
      isOnline: true,
      employee: null,
      condoRef: 'R1',
      knowException: TimeoutException('loc'),
    );

void main() {
  testWidgets('golden — sick note form', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.white,
        child: SickNoteDocumentForm(
          sendSickNoteFunction: () {},
          sickNote: SickNoteEntity(date: DateTime(2026, 1, 10)),
          maxFileSizePermitted: 5,
        ),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(480, 720),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sick_note_form.png'),
    );
  });

  testWidgets('golden — employee referral form', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.white,
        child: SizedBox(
          height: 720,
          child: EmployeeReferralPageBodyWidget(
            registerEmployeeReferral: () {},
            employeeReferral: EmployeeReferralEntity(description: 'dev'),
            fileMaxSizePermitted: 5,
            cities: [CityEntity(name: 'SP', regions: ['zona sul'])],
          ),
        ),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(480, 720),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_referral_form.png'),
    );
  });

  testWidgets('golden — manual timesheet form', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.white,
        child: SizedBox(
          height: 520,
          width: 360,
          child: ManualTimeSheetWidget(
            sendManualTimeSheetFunction: () {},
            manualTimeSheet: ManualTimeSheetEntity(),
            maxFileSizePermitted: 5,
            availableDates: [DateTime(2026, 1, 1), DateTime(2026, 2, 1)],
          ),
        ),
      ),
      localized: true,
      shrinkWrap: false,
      locOverrides: const {'manual_timesheet_document_date': 'Data'},
      surface: const Size(480, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/manual_timesheet_form.png'),
    );
  });

  testWidgets('golden — timesheet intro', (tester) async {
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
          timesheetStatus: TimesheetStatusEnum.notAssigned,
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(560, 300),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_intro.png'),
    );
  });

  testWidgets('golden — sick note form com dias', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.white,
        child: SickNoteDocumentForm(
          sendSickNoteFunction: () {},
          sickNote: SickNoteEntity(
            date: DateTime(2026, 1, 10),
            isChecked: true,
            sickNoteDays: 10,
          ),
          maxFileSizePermitted: 5,
        ),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(480, 720),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sick_note_form_checked.png'),
    );
  });

  testWidgets('golden — employee referral com região', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.white,
        child: SizedBox(
          height: 780,
          child: EmployeeReferralPageBodyWidget(
            registerEmployeeReferral: () {},
            employeeReferral: EmployeeReferralEntity(
              description: 'dev flutter',
              city: 'SP',
              hasRegion: true,
              regions: ['zona sul', 'centro'],
              region: 'zona sul',
            ),
            fileMaxSizePermitted: 5,
            cities: [
              CityEntity(name: 'SP', regions: ['zona sul', 'centro']),
            ],
          ),
        ),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(480, 780),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_referral_region.png'),
    );
  });

  testWidgets('golden — face register error', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          settings: RouteSettings(arguments: _faceArgs()),
          builder: (_) => const FaceRegisterErrorPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/face_register_error.png'),
    );
  });
}
