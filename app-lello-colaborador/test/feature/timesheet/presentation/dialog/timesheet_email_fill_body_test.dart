import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_fill_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

Future<List<String>> _pumpBody(
  WidgetTester tester, {
  String? emailPrevious,
}) async {
  final sent = <String>[];
  await installTestValidator();

  await pumpApp(
    tester,
    TimesheetEmailFillBody(
      emailPrevious: emailPrevious,
      sendEmail: sent.add,
    ),
    localized: true,
    shrinkWrap: false,
    surface: const Size(420, 600),
  );
  return sent;
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('TimesheetEmailFillBody', () {
    testWidgets('exibe descrição e ações do envio por email', (tester) async {
      await _pumpBody(tester);

      expect(find.text('timesheet_send_email_description'), findsOneWidget);
      expect(find.text('SEND'), findsOneWidget);
      expect(find.text('CLOSE'), findsOneWidget);
    });

    testWidgets('preenche o campo com o email já cadastrado', (tester) async {
      await _pumpBody(tester, emailPrevious: 'ana@lello.com');

      expect(find.text('ana@lello.com'), findsOneWidget);
    });

    testWidgets('envia o email digitado quando é válido', (tester) async {
      final sent = await _pumpBody(tester);

      await tester.enterText(find.byType(TextFormField), 'ana@lello.com');
      await tester.tap(find.text('SEND'));
      await tester.pump();

      expect(sent, ['ana@lello.com']);
    });

    testWidgets('não envia quando o email é inválido', (tester) async {
      final sent = await _pumpBody(tester);

      await tester.enterText(find.byType(TextFormField), 'ana-lello');
      await tester.tap(find.text('SEND'));
      await tester.pump();

      expect(sent, isEmpty);
    });

    testWidgets('não envia quando o campo está vazio', (tester) async {
      final sent = await _pumpBody(tester, emailPrevious: '');

      await tester.tap(find.text('SEND'));
      await tester.pump();

      expect(sent, isEmpty);
    });
  });
}
