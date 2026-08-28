import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_body_widget.dart';
import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

/// O fluxo feliz usa `T = dynamic`; o caso com `T` tipado fica no fim do
/// arquivo.
List<DropdownBottomSheetElement<dynamic>> _elementos() => [
      DropdownBottomSheetElement<dynamic>(text: 'Apartamento', value: 1),
      DropdownBottomSheetElement<dynamic>(text: 'Casa', value: 2),
      DropdownBottomSheetElement<dynamic>(text: 'Sala comercial', value: 3),
      DropdownBottomSheetElement<dynamic>(text: 'Terreno', value: 4),
    ];

void main() {
  /// Monta o corpo dentro de uma rota empurrada por cima da home, para
  /// que `Navigator.pop` tenha efeito observável.
  Future<RecordingNavigatorObserver> pumpCorpo(
    WidgetTester tester, {
    List<DropdownBottomSheetElement<dynamic>>? elementos,
    required void Function(DropdownBottomSheetElement<dynamic>) done,
    bool showFilter = true,
  }) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: 'corpo'),
              builder: (_) => Scaffold(
                body: DropdownBottomSheetBodyWidget<dynamic>(
                  title: 'Tipo de imóvel',
                  dropDownElements: elementos ?? _elementos(),
                  doneFunction: done,
                  showFilter: showFilter,
                ),
              ),
            ),
          ),
          child: const Text('abrir'),
        ),
      ),
      navigatorObserver: observer,
      surface: const Size(400, 700),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    return observer;
  }

  testWidgets('mostra título, voltar/feito, filtro e todas as opções',
      (tester) async {
    await pumpCorpo(tester, done: (_) {});

    expect(find.text('Tipo de imóvel'), findsOneWidget);
    expect(find.text('back'), findsOneWidget);
    expect(find.text('done'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(
        tester.widget<TextField>(find.byType(TextField)).decoration!.hintText,
        'filter');
    expect(find.byType(CupertinoPicker), findsOneWidget);
    for (final e in _elementos()) {
      expect(find.text(e.text), findsOneWidget);
    }
  });

  testWidgets('"feito" devolve o primeiro elemento e fecha', (tester) async {
    DropdownBottomSheetElement? escolhido;
    final observer = await pumpCorpo(tester, done: (e) => escolhido = e);

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();

    expect(escolhido?.value, 1);
    expect(observer.popped.map((r) => r.settings.name), ['corpo']);
    expect(find.text('Tipo de imóvel'), findsNothing);
  });

  testWidgets('"voltar" fecha sem chamar doneFunction', (tester) async {
    var chamadas = 0;
    final observer = await pumpCorpo(tester, done: (_) => chamadas++);

    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();

    expect(chamadas, 0);
    expect(observer.popped, hasLength(1));
  });

  testWidgets('rolar o picker muda o elemento selecionado', (tester) async {
    DropdownBottomSheetElement? escolhido;
    await pumpCorpo(tester, done: (e) => escolhido = e);

    await tester.drag(find.byType(CupertinoPicker), const Offset(0, -56 * 2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();

    expect(escolhido?.text, 'Sala comercial');
  });

  testWidgets('filtro reduz as opções ignorando maiúsculas', (tester) async {
    await pumpCorpo(tester, done: (_) {});

    await tester.enterText(find.byType(TextField), 'CASA');
    await tester.pumpAndSettle();

    expect(find.text('Casa'), findsOneWidget);
    expect(find.text('Apartamento'), findsNothing);
    expect(find.text('Terreno'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Apartamento'), findsOneWidget);
    expect(find.text('Terreno'), findsOneWidget);
  });

  /// Corrigido: ao filtrar, o picker volta ao primeiro item visível e
  /// `selectedElement` acompanha — "feito" devolve o que está na tela.
  testWidgets('após filtrar, "feito" devolve o elemento visível no picker',
      (tester) async {
    DropdownBottomSheetElement? escolhido;
    await pumpCorpo(tester, done: (e) => escolhido = e);

    await tester.enterText(find.byType(TextField), 'terreno');
    await tester.pumpAndSettle();
    expect(find.text('Terreno'), findsOneWidget);

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(escolhido?.text, 'Terreno');
  });

  testWidgets('rolar, filtrar e limpar o filtro volta ao primeiro elemento',
      (tester) async {
    DropdownBottomSheetElement? escolhido;
    await pumpCorpo(tester, done: (e) => escolhido = e);

    await tester.drag(find.byType(CupertinoPicker), const Offset(0, -56 * 2));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(escolhido?.text, 'Apartamento');
  });

  testWidgets('filtro sem resultado: "feito" só fecha, sem chamar doneFunction',
      (tester) async {
    var chamadas = 0;
    final observer = await pumpCorpo(tester, done: (_) => chamadas++);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(find.text('Apartamento'), findsNothing);

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(chamadas, 0);
    expect(observer.popped, hasLength(1));
  });

  testWidgets('lista vazia: "feito" só fecha, sem chamar doneFunction',
      (tester) async {
    var chamadas = 0;
    final observer =
        await pumpCorpo(tester, elementos: [], done: (_) => chamadas++);

    expect(find.byType(CupertinoPicker), findsOneWidget);
    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(chamadas, 0);
    expect(observer.popped, hasLength(1));
  });

  /// Corrigido: `showFilter: false` esconde o campo de filtro; o picker e
  /// as ações continuam funcionando.
  testWidgets('showFilter=false esconde o filtro', (tester) async {
    DropdownBottomSheetElement? escolhido;
    await pumpCorpo(tester, done: (e) => escolhido = e, showFilter: false);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(CupertinoPicker), findsOneWidget);

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(escolhido?.value, 1);
  });

  /// Corrigido: o `State` repassa `T` (`State<DropdownBottomSheetBodyWidget<T>>`),
  /// então `widget.doneFunction` tem o tipo certo para qualquer `T` (ex.:
  /// `int`) e "feito" chama o callback com o elemento tipado e fecha.
  testWidgets('com T tipado, "feito" chama doneFunction e fecha',
      (tester) async {
    DropdownBottomSheetElement<int>? escolhido;
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Scaffold(
                body: DropdownBottomSheetBodyWidget<int>(
                  title: 'Tipado',
                  dropDownElements: [
                    DropdownBottomSheetElement<int>(text: 'Um', value: 1),
                  ],
                  doneFunction: (DropdownBottomSheetElement<int> e) =>
                      escolhido = e,
                  showFilter: true,
                ),
              ),
            ),
          ),
          child: const Text('abrir'),
        ),
      ),
      navigatorObserver: observer,
      surface: const Size(400, 700),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(escolhido?.value, 1);
    expect(observer.popped, hasLength(1));
    expect(find.text('Tipado'), findsNothing);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      DropdownBottomSheetBodyWidget<dynamic>(
        title: 'Tipo de imóvel',
        dropDownElements: _elementos(),
        doneFunction: (_) {},
        showFilter: true,
      ),
      shrinkWrap: false,
      surface: const Size(400, 500),
      locOverrides: const {
        'back': 'Voltar',
        'done': 'Feito',
        'filter': 'Filtro',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/dropdown_bottom_sheet_body.png'),
    );
  });
}
