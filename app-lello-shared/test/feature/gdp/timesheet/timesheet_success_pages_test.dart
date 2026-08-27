import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_request_success.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_sign_success.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('sucesso da assinatura mostra a mensagem e fecha ao tocar',
      (tester) async {
    final observer = RecordingNavigatorObserver();
    await pumpPage(tester, TimesheetSignSuccessSuccess(), observer: observer);
    expect(find.text('Espelhos de ponto assinados com sucesso'), findsOneWidget);
    expect(find.text('close'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_sign_success.png'));

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
  });

  testWidgets('sucesso da solicitação mostra a mensagem e fecha ao tocar',
      (tester) async {
    final observer = RecordingNavigatorObserver();
    await pumpPage(tester, TimesheetRequestSuccess(), observer: observer);
    expect(find.text('Email enviado com sucesso'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_request_success.png'));

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
  });
}
