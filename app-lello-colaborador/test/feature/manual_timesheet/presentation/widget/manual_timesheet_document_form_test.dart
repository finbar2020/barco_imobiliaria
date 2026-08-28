import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/widgets/manual_timesheet_document_form.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAE'
    'hQGAhKmMIQAAAABJRU5ErkJggg==';

final _dates = [DateTime(2026, 1, 1), DateTime(2026, 2, 1)];

File _imageFile() {
  final file = File('${Directory.systemTemp.path}/colaborador_manual_ts.png');
  file.writeAsBytesSync(base64Decode(_pngBase64));
  return file;
}

String _monthLabel(DateTime date) {
  final label = DateFormat('MMMM').format(date);
  return label.substring(0, 1).toUpperCase() + label.substring(1).toLowerCase();
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<void> _pumpForm(
  WidgetTester tester,
  ManualTimeSheetEntity manualTimeSheet, {
  void Function()? onSend,
  List<DateTime>? availableDates,
}) async {
  await pumpApp(
    tester,
    Material(
      child: ManualTimeSheetWidget(
        manualTimeSheet: manualTimeSheet,
        availableDates: availableDates ?? _dates,
        sendManualTimeSheetFunction: onSend ?? () {},
        maxFileSizePermitted: 10,
      ),
    ),
    localized: true,
    shrinkWrap: false,
    settle: false,
    // A chave crua estoura a largura de 230px do seletor.
    locOverrides: const {'manual_timesheet_document_date': 'Periodo'},
    surface: const Size(500, 900),
  );
  await tester.pump();
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('ManualTimeSheetWidget', () {
    testWidgets('sem período e sem arquivo o envio fica bloqueado',
        (tester) async {
      await _pumpForm(tester, ManualTimeSheetEntity());

      expect(find.text('manual_timesheet_subtitle'), findsOneWidget);
      expect(find.text('Periodo'), findsOneWidget);
      expect(find.text('manual_timesheet_add'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('exibe o período já selecionado', (tester) async {
      await _pumpForm(
        tester,
        ManualTimeSheetEntity(date: _dates.first),
      );

      expect(find.text(_monthLabel(_dates.first)), findsOneWidget);
      expect(find.text('Periodo'), findsNothing);
    });

    testWidgets('lista os períodos disponíveis no seletor', (tester) async {
      await _pumpForm(tester, ManualTimeSheetEntity());

      await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      for (final date in _dates) {
        expect(find.text(_monthLabel(date)), findsWidgets);
      }
    });

    testWidgets('com período e arquivo o envio fica liberado', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpForm(
        tester,
        ManualTimeSheetEntity(date: _dates.first, file: file),
      );

      expect(find.text('manual_timesheet_send'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('envia a solicitação ao tocar no botão', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });
      var sendCalls = 0;

      await _pumpForm(
        tester,
        ManualTimeSheetEntity(date: _dates.first, file: file),
        onSend: () => sendCalls++,
      );

      await tester.tap(find.text('manual_timesheet_send'));
      await tester.pump();

      expect(sendCalls, 1);
    });

    testWidgets('remover o anexo bloqueia o envio novamente', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });
      final manualTimeSheet =
          ManualTimeSheetEntity(date: _dates.first, file: file);

      await _pumpForm(tester, manualTimeSheet);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(manualTimeSheet.file, isNull);
      expect(find.text('manual_timesheet_add'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });
  });
}
