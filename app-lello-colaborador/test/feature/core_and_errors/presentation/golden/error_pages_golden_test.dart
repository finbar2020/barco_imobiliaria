import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/core/widgets/inactivity_timer_draggable.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_error_page.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_clock_in_range_out_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_approved_dialog.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/page/manual_timesheet_register_error_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_register_error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — sick note error', (tester) async {
    await pumpApp(
      tester,
      const SickNoteRegisterErrorPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sick_note_error.png'),
    );
  });

  testWidgets('golden — manual timesheet error', (tester) async {
    await pumpApp(
      tester,
      const ManualTimeSheetRegisterErrorPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/manual_timesheet_error.png'),
    );
  });

  testWidgets('golden — employee referral error', (tester) async {
    await pumpApp(
      tester,
      const EmployeeReferralErrorPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_referral_error.png'),
    );
  });

  testWidgets('golden — me delete account error', (tester) async {
    await pumpApp(
      tester,
      const MeDeleteAccountErrorPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_delete_account_error.png'),
    );
  });

  testWidgets('golden — preferences success', (tester) async {
    await pumpApp(
      tester,
      const PreferencesSuccessPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_success.png'),
    );
  });

  testWidgets('golden — afastamento dialog', (tester) async {
    await pumpApp(
      tester,
      const AfastamentoDialog(workLeaveDescription: 'licença médica'),
      localized: true,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/afastamento_dialog.png'),
    );
  });

  testWidgets('golden — device type dialog tablet', (tester) async {
    await pumpApp(
      tester,
      const DeviceTypeDialog(onlyTablet: true, onlyPhone: false),
      localized: true,
      surface: const Size(400, 480),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/device_type_dialog_tablet.png'),
    );
  });

  testWidgets('golden — device type dialog phone', (tester) async {
    await pumpApp(
      tester,
      const DeviceTypeDialog(onlyTablet: false, onlyPhone: true),
      localized: true,
      surface: const Size(400, 480),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/device_type_dialog_phone.png'),
    );
  });

  testWidgets('golden — home request approved', (tester) async {
    await pumpApp(
      tester,
      const HomeRequestApprovedDialog(),
      localized: true,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_request_approved.png'),
    );
  });

  testWidgets('golden — home clock in range out', (tester) async {
    await pumpApp(
      tester,
      const HomeClockInRangeOutDialog(
        registerPointStatusEnum: DigitalTimesheetStatusEnum.approved,
      ),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_clock_in_range_out.png'),
    );
  });

  testWidgets('golden — inactivity timer', (tester) async {
    await pumpApp(
      tester,
      const InactivityTimerDraggable(timer: 30, duration: 60),
      localized: true,
      surface: const Size(120, 120),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/inactivity_timer.png'),
    );
  });
}
