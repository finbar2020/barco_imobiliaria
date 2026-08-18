import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_register_point_button.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

void main() {
  testWidgets('renderiza botão aprovado', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const HomeRegisterPointButton(
        registerPointStatusEnum: DigitalTimesheetStatusEnum.approved,
        isOnline: true,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 120),
    );

    expect(find.byType(HomeRegisterPointButton), findsOneWidget);
    expect(find.text('home_page_register_point'), findsOneWidget);
  });

  testWidgets('golden — botão registrar ponto aprovado', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const HomeRegisterPointButton(
        registerPointStatusEnum: DigitalTimesheetStatusEnum.approved,
        isOnline: true,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 120),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_register_point_button.png'),
    );
  });
}
