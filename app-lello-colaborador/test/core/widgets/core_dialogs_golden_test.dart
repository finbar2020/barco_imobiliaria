import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_clock_in_range_out_dialog.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — afastamento dialog', (tester) async {
    await pumpApp(
      tester,
      const AfastamentoDialog(workLeaveDescription: 'Licença médica'),
      localized: true,
      surface: const Size(400, 560),
    );
    await expectLater(
      find.byType(Dialog),
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
      find.byType(Dialog),
      matchesGoldenFile('goldens/device_type_tablet_dialog.png'),
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
      find.byType(Dialog),
      matchesGoldenFile('goldens/device_type_phone_dialog.png'),
    );
  });

  testWidgets('golden — clock in range out dialog', (tester) async {
    await pumpApp(
      tester,
      const HomeClockInRangeOutDialog(
        registerPointStatusEnum: DigitalTimesheetStatusEnum.approved,
        isOnline: true,
      ),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      find.byType(Dialog),
      matchesGoldenFile('goldens/clock_in_range_out_dialog.png'),
    );
  });
}
