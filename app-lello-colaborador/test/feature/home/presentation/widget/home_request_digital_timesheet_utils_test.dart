import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_approved_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_declined_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_digital_timesheet_utils.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeRequestsDigitalTimesheetUtils', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('exibe dialog declined após pending', (tester) async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.employeeDigitalTimesheetStatus:
            DigitalTimesheetStatusEnum.pending.toString(),
      });

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            HomeRequestsDigitalTimesheetUtils.show(
              context,
              DigitalTimesheetStatusEnum.declined,
              false,
            );
            return const SizedBox.shrink();
          },
        ),
        localized: true,
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HomeRequestDeclinedDialog), findsOneWidget);
    });

    testWidgets('exibe dialog approved após pending', (tester) async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.employeeDigitalTimesheetStatus:
            DigitalTimesheetStatusEnum.pending.toString(),
      });

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            HomeRequestsDigitalTimesheetUtils.show(
              context,
              DigitalTimesheetStatusEnum.approved,
              true,
            );
            return const SizedBox.shrink();
          },
        ),
        localized: true,
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HomeRequestApprovedDialog), findsOneWidget);
    });

    testWidgets('não exibe dialog sem transição de pending', (tester) async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.employeeDigitalTimesheetStatus:
            DigitalTimesheetStatusEnum.approved.toString(),
      });

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            HomeRequestsDigitalTimesheetUtils.show(
              context,
              DigitalTimesheetStatusEnum.declined,
              false,
            );
            return const SizedBox.shrink();
          },
        ),
        localized: true,
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HomeRequestDeclinedDialog), findsNothing);
      expect(find.byType(HomeRequestApprovedDialog), findsNothing);
    });

    testWidgets('persiste novo status nas preferências', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            HomeRequestsDigitalTimesheetUtils.show(
              context,
              DigitalTimesheetStatusEnum.approved,
              true,
            );
            return const SizedBox.shrink();
          },
        ),
        localized: true,
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(
        SharedPreferencesKeys.employeeDigitalTimesheetStatus,
      );
      expect(saved, contains('approved'));
    });
  });
}
