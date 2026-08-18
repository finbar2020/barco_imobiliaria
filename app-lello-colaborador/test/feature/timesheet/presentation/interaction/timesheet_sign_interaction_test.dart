import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_fill_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tap em assinar dispara callback', (tester) async {
    var signed = false;
    await pumpApp(
      tester,
      TimesheetSignFillBody(timesheetSign: () => signed = true),
      localized: true,
    );
    await tester.tap(find.text('TIMESHEET_SIGN_OK'));
    await tester.pump();
    expect(signed, isTrue);
  });

  testWidgets('tap em tentar novamente dispara callback', (tester) async {
    var again = false;
    await pumpApp(
      tester,
      TimesheetSignFailedBody(tryAgain: () => again = true),
      localized: true,
    );
    await tester.tap(find.text('TIMESHEET_SIGN_ERROR_TRY_AGAIN'));
    await tester.pump();
    expect(again, isTrue);
  });
}
