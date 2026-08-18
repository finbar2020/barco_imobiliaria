import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_approved_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_declined_dialog.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — home request approved dialog', (tester) async {
    await pumpApp(
      tester,
      const HomeRequestApprovedDialog(),
      localized: true,
      surface: const Size(400, 480),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_request_approved.png'),
    );
  });

  testWidgets('golden — home request declined dialog', (tester) async {
    await pumpApp(
      tester,
      const HomeRequestDeclinedDialog(
        status: DigitalTimesheetStatusEnum.declined,
        isOnline: false,
      ),
      localized: true,
      surface: const Size(400, 560),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_request_declined.png'),
    );
  });
}
