import 'package:essentials/modal/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('escolher um dia e confirmar devolve a nova data', (tester) async {
    await pumpApp(tester, const Text('home'), surface: const Size(500, 900));
    final context = tester.element(find.text('home'));
    final futuro = datePicker(context,
        selectedDate: DateTime(2024, 1, 10),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    await tester.pumpAndSettle();

    expect(find.text('PICK_A_DATE'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    await expectLater(find.byType(DatePickerDialog),
        matchesGoldenFile('goldens/date_picker.png'));

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(await futuro, DateTime(2024, 1, 15));
  });

  testWidgets('cancelar devolve a data selecionada', (tester) async {
    await pumpApp(tester, const Text('home'), surface: const Size(500, 900));
    final context = tester.element(find.text('home'));
    final futuro = datePicker(context, selectedDate: DateTime(2024, 1, 10));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
    expect(await futuro, DateTime(2024, 1, 10));
  });

  testWidgets('confirmar a mesma data devolve a data selecionada',
      (tester) async {
    await pumpApp(tester, const Text('home'), surface: const Size(500, 900));
    final context = tester.element(find.text('home'));
    final futuro = datePicker(context, selectedDate: DateTime(2024, 1, 10));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(await futuro, DateTime(2024, 1, 10));
  });

  testWidgets('sem data selecionada usa hoje', (tester) async {
    await pumpApp(tester, const Text('home'), surface: const Size(500, 900));
    final context = tester.element(find.text('home'));
    final antes = DateTime.now();
    final futuro = datePicker(context);
    await tester.pumpAndSettle();
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
    final resultado = await futuro;
    expect(resultado.difference(antes).inSeconds, lessThan(5));
  });

  testWidgets('CalendarTheme deriva do tema atual', (tester) async {
    await pumpApp(tester, const Text('home'));
    final context = tester.element(find.text('home'));
    final ThemeData tema = CalendarTheme(context);
    expect(tema.colorScheme.primary, Theme.of(context).primaryColor);
    expect(tema.colorScheme.onSurface, Colors.black);
    expect(tema.datePickerTheme.headerBackgroundColor,
        Theme.of(context).primaryColor);
    expect(tema.datePickerTheme.dividerColor, Colors.transparent);
  });
}
