import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/home/presentation/widget/home_bottom_navigation_bar_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_failed_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tap em tentar novamente dispara callback do e-mail', (tester) async {
    var email = '';
    await pumpApp(
      tester,
      TimesheetEmailFailedBody(
        email: 'ana@lello.com',
        tryAgain: (value) => email = value,
      ),
      localized: true,
    );
    await tester.tap(find.text('TIMESHEET_SEND_EMAIL_ERROR_TRY_AGAIN'));
    await tester.pump();
    expect(email, 'ana@lello.com');
  });

  testWidgets('tap em sincronizar dispara callback', (tester) async {
    var synced = false;
    await pumpApp(
      tester,
      SyncWidget(
        digitalPoints: [testPoint()],
        syncFunction: (_) => synced = true,
      ),
      localized: true,
      shrinkWrap: false,
    );
    await tester.tap(find.text('DIGITAL_POINT_SYNC_DIALOG_SYNC'));
    await tester.pump();
    expect(synced, isTrue);
  });

  testWidgets('bottom nav vazio não renderiza barra', (tester) async {
    await pumpApp(
      tester,
      HomeBottomNavigationBarWidget(
        changePage: (_) {},
        currentPage: 0,
        navigationItems: const [],
      ),
      localized: true,
    );
    expect(find.byType(HomeBottomNavigationBarWidget), findsOneWidget);
    expect(find.text('home_navigation_home'), findsNothing);
  });
}
