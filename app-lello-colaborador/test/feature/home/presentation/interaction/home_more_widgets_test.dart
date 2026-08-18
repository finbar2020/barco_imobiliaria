import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_fill_condo_code_widget.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/widget/airplane_mode_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_unsychronized_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_declined_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/whatsapp_icon.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('LoginTabletFillCondoCodeWidget dispara signByCode', (tester) async {
    final controller = TextEditingController(text: '123456');
    addTearDown(controller.dispose);
    var code = '';
    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (value) => code = value,
      ),
      localized: true,
    );
    await tester.tap(find.text('login_tablet_sign_sign'));
    await tester.pump();
    expect(code, '123456');
  });

  testWidgets('LoginTabletFillCondoCodeWidget mostra erro', (tester) async {
    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: TextEditingController(),
        signByCodeFunction: (_) {},
        isFailure: true,
      ),
      localized: true,
    );
    expect(find.text('login_tablet_invalid_code'), findsOneWidget);
  });

  testWidgets('golden — pontos não sincronizados', (tester) async {
    await pumpApp(
      tester,
      DigitalPointsUnsynchronizedWidget(digitalPoints: [testPoint()]),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    expect(find.text('digital_point_sync_points_to_sync'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/unsync_points.png'),
    );
  });

  testWidgets('golden — WhatsappIcon', (tester) async {
    await pumpApp(
      tester,
      const WhatsappIcon(),
      localized: true,
      surface: const Size(120, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/whatsapp_icon.png'),
    );
  });

  testWidgets('AirplaneModeDialog.show exibe descrição', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () => AirplaneModeDialog.show(context),
            child: const Text('abrir'),
          );
        },
      ),
      localized: true,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('airplane_mode_dialog_description'), findsOneWidget);
  });

  testWidgets('golden — HomeDashboardItem sem tap', (tester) async {
    await pumpApp(
      tester,
      const HomeDashboardItem(homeItem: HomeItemEnum.proof),
      localized: true,
      shrinkWrap: false,
      surface: const Size(220, 180),
    );
    expect(find.text('digital_point_page_proof'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_dashboard_item.png'),
    );
  });

  testWidgets('golden — HomeRequestDeclinedDialog sem tap', (tester) async {
    await pumpApp(
      tester,
      const HomeRequestDeclinedDialog(
        status: DigitalTimesheetStatusEnum.declined,
        isOnline: true,
      ),
      localized: true,
    );
    expect(find.text('home_request_denied_dialog_subtitle1'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_request_declined.png'),
    );
  });
}
