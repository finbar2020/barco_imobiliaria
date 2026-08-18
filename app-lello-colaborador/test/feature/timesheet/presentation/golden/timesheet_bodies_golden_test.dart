import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_fill_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_success_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_success_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — timesheet sign fill', (tester) async {
    await pumpApp(
      tester,
      TimesheetSignFillBody(timesheetSign: () {}),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_sign_fill.png'),
    );
  });

  testWidgets('golden — timesheet sign failed', (tester) async {
    await pumpApp(
      tester,
      TimesheetSignFailedBody(tryAgain: () {}),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_sign_failed.png'),
    );
  });

  testWidgets('golden — timesheet sign success', (tester) async {
    await pumpApp(
      tester,
      const TimesheetSignSuccessBody(),
      localized: true,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_sign_success.png'),
    );
  });

  testWidgets('golden — timesheet email success', (tester) async {
    await pumpApp(
      tester,
      const TimesheetEmailSuccessBody(),
      localized: true,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_email_success.png'),
    );
  });
}
