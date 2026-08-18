import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_error_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_success_page.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — employee referral success', (tester) async {
    await pumpApp(
      tester,
      BlocProvider<SessionBloc>.value(
        value: FakeSessionBloc(),
        child: const EmployeeReferralSuccessPage(),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_referral_success.png'),
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
}
