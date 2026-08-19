import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/presentation/widgets/sick_note_document_form.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAE'
    'hQGAhKmMIQAAAABJRU5ErkJggg==';

File _imageFile() {
  final file = File('${Directory.systemTemp.path}/colaborador_sick_note.png');
  file.writeAsBytesSync(base64Decode(_pngBase64));
  return file;
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<int> _pumpForm(WidgetTester tester, SickNoteEntity sickNote) async {
  var sendCalls = 0;
  await pumpApp(
    tester,
    // O Material próprio evita o aviso do CheckboxListTile sobre o
    // ColoredBox do helper de pump.
    Material(
      child: SickNoteDocumentForm(
        sickNote: sickNote,
        sendSickNoteFunction: () => sendCalls++,
        maxFileSizePermitted: 10,
      ),
    ),
    localized: true,
    shrinkWrap: false,
    // O formulário mantém uma animação em loop: pumpAndSettle não estabiliza.
    settle: false,
    surface: const Size(500, 900),
  );
  await tester.pump();
  return sendCalls;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('SickNoteDocumentForm', () {
    testWidgets('sem data e sem arquivo o envio fica bloqueado',
        (tester) async {
      await _pumpForm(tester, SickNoteEntity());

      expect(find.text('sick_note_subtitle'), findsOneWidget);
      expect(find.text('sick_note_document_date'), findsOneWidget);
      expect(find.text('sick_note_add'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('exibe a data escolhida no campo', (tester) async {
      await _pumpForm(
        tester,
        SickNoteEntity(date: DateTime(2026, 1, 15)),
      );

      expect(find.text('15/01/2026'), findsOneWidget);
      expect(find.text('sick_note_document_date'), findsNothing);
    });

    testWidgets('com data e arquivo o envio fica liberado', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpForm(
        tester,
        SickNoteEntity(date: DateTime(2026, 1, 15), file: file),
      );

      expect(find.text('sick_note_send'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('envia o atestado ao tocar no botão', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });
      var sendCalls = 0;

      await pumpApp(
        tester,
        Material(
          child: SickNoteDocumentForm(
            sickNote: SickNoteEntity(date: DateTime(2026, 1, 15), file: file),
            sendSickNoteFunction: () => sendCalls++,
            maxFileSizePermitted: 10,
          ),
        ),
        localized: true,
        shrinkWrap: false,
        settle: false,
        surface: const Size(500, 900),
      );
      await tester.pump();

      await tester.tap(find.text('sick_note_send'));
      await tester.pump();

      expect(sendCalls, 1);
    });

    testWidgets('marcar afastamento exibe a escolha de dias', (tester) async {
      final sickNote = SickNoteEntity();
      await _pumpForm(tester, sickNote);

      expect(find.byType(DropdownButtonFormField<int>), findsNothing);

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();

      expect(sickNote.isChecked, isTrue);
      expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
      expect(find.text('sick_note_how_many_days'), findsOneWidget);
    });

    testWidgets('afastamento marcado sem dias bloqueia o envio',
        (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpForm(
        tester,
        SickNoteEntity(
          date: DateTime(2026, 1, 15),
          file: file,
          isChecked: true,
        ),
      );

      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('afastamento marcado com dias libera o envio', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpForm(
        tester,
        SickNoteEntity(
          date: DateTime(2026, 1, 15),
          file: file,
          isChecked: true,
          sickNoteDays: 15,
        ),
      );

      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('escolher a data preenche o atestado', (tester) async {
      final sickNote = SickNoteEntity();
      await _pumpForm(tester, sickNote);

      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(sickNote.date, isNotNull);
    });

    testWidgets('cancelar o calendário mantém o atestado sem data',
        (tester) async {
      final sickNote = SickNoteEntity();
      await _pumpForm(tester, sickNote);

      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // O rótulo do botão vem das localizações padrão do Material.
      await tester.tap(find.byType(TextButton).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(sickNote.date, isNull);
    });

    testWidgets('escolher a quantidade de dias atualiza o atestado',
        (tester) async {
      final sickNote = SickNoteEntity(isChecked: true);
      await _pumpForm(tester, sickNote);

      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('10').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(sickNote.sickNoteDays, 10);
    });

    testWidgets('quantidade de dias fora da lista não quebra o formulário',
        (tester) async {
      // A lista começa em 10 dias; um valor menor vindo de um rascunho antigo
      // não pode estourar o DropdownButton.
      final sickNote = SickNoteEntity(isChecked: true, sickNoteDays: 3);

      await _pumpForm(tester, sickNote);

      expect(tester.takeException(), isNull);
      expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
      expect(find.text('sick_note_how_many_days'), findsOneWidget);
    });

    testWidgets('a animação do formulário fica em looping', (tester) async {
      await _pumpForm(tester, SickNoteEntity());

      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('desmarcar afastamento limpa os dias informados',
        (tester) async {
      final sickNote = SickNoteEntity(isChecked: true, sickNoteDays: 15);
      await _pumpForm(tester, sickNote);

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();

      expect(sickNote.isChecked, isFalse);
      expect(sickNote.sickNoteDays, isNull);
      expect(find.byType(DropdownButtonFormField<int>), findsNothing);
    });
  });
}
