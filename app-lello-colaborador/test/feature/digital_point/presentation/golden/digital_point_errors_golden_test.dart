import 'package:colaborador/feature/digital_point/presentation/page/location_timeout_error_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

LocationTimeoutErrorPageArgs _args() => LocationTimeoutErrorPageArgs(
      statusEnum: DigitalTimesheetStatusEnum.approved,
      isOnline: true,
      employee: null,
      condoRef: 'R1',
    );

void main() {
  testWidgets('golden — location timeout error', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          settings: RouteSettings(arguments: _args()),
          builder: (_) => const LocationTimeoutErrorPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/location_timeout_error.png'),
    );
  });
}
