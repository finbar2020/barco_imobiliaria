import 'package:colaborador/feature/proof/presentation/widgets/proof_select_date_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_failed_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_widget.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_loading_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_info_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_list_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_loading_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — timesheet info page', (tester) async {
    await pumpApp(
      tester,
      const TimesheetInfoPage(),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_info_page.png'),
    );
  });

  testWidgets('golden — timesheet email failed', (tester) async {
    await pumpApp(
      tester,
      TimesheetEmailFailedBody(email: 'ana@lello.com', tryAgain: (_) {}),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_email_failed.png'),
    );
  });

  testWidgets('golden — timesheet sign loading', (tester) async {
    await pumpApp(
      tester,
      const TimesheetSignLoadingBody(),
      localized: true,
      settle: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_sign_loading.png'),
    );
  });

  testWidgets('golden — timesheet email loading', (tester) async {
    await pumpApp(
      tester,
      const TimesheetEmailLoadingBody(),
      localized: true,
      settle: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_email_loading.png'),
    );
  });

  testWidgets('golden — timesheet detail list', (tester) async {
    await pumpApp(
      tester,
      TimesheetDetailListWidget(
        timesheetDetail: {
          DateTime(2026, 1, 10): [
            TimesheetElementDetail(
              time: '08:00',
              timesheetFlag: TimesheetPointFlagEnum.inserted,
              date: DateTime(2026, 1, 10, 8),
            ),
            TimesheetElementDetail(
              time: '12:00',
              timesheetFlag: TimesheetPointFlagEnum.preInsert,
              date: DateTime(2026, 1, 10, 12),
            ),
          ],
        },
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_detail_list.png'),
    );
  });

  testWidgets('golden — proof select date', (tester) async {
    final controller = TextEditingController(text: '10/01/2026');
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      ProofSelectDateWidget(onTap: (_) {}, controller: controller),
      localized: true,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_select_date.png'),
    );
  });

  testWidgets('golden — sync widget', (tester) async {
    await pumpApp(
      tester,
      SyncWidget(digitalPoints: [testPoint()], syncFunction: (_) {}),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sync_widget.png'),
    );
  });

  testWidgets('golden — sync failed', (tester) async {
    await pumpApp(
      tester,
      SyncFailedWidget(
        digitalPoints: [testPoint()],
        syncFunction: (_) {},
        message: 'licença',
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 400),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sync_failed.png'),
    );
  });
}
