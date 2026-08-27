import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_features/core/modal/month_picker.dart';

import '../../helpers/pump_app.dart';

const _locale = 'pt_BR';

class _Host extends StatefulWidget {
  const _Host({required this.initialDate, this.firstDate, this.lastDate});

  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final results = <DateTime?>[];

  @override
  Widget build(BuildContext context) => TextButton(
        key: const Key('abrir'),
        onPressed: () async {
          results.add(await showMonthPicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          ));
        },
        child: const Text('abrir'),
      );
}

Future<_HostState> _open(
  WidgetTester tester, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Size surface = const Size(500, 800),
}) async {
  await pumpApp(
    tester,
    _Host(
      initialDate: initialDate ?? DateTime(2026, 3, 15),
      firstDate: firstDate,
      lastDate: lastDate,
    ),
    surface: surface,
  );
  await tester.tap(find.byKey(const Key('abrir')));
  await tester.pumpAndSettle();
  return tester.state<_HostState>(find.byType(_Host));
}

String _header(DateTime d) => DateFormat.yMMM(_locale).format(d);
String _month(DateTime d) => DateFormat.MMM(_locale).format(d);
String _year(int y) => DateFormat.y(_locale).format(DateTime(y));

/// Botão de mês (texto pode se repetir entre anos; o pager mostra um ano).
Finder _monthButton(DateTime d) => find.ancestor(
    of: find.text(_month(d)), matching: find.byType(TextButton));

void main() {
  setUpAll(() async {
    await initializeDateFormatting(_locale);
  });

  testWidgets('mostra o mês inicial selecionado, o ano e os 12 meses',
      (tester) async {
    await _open(tester);
    expect(find.text(_header(DateTime(2026, 3))), findsOneWidget);
    expect(find.text(_year(2026)), findsOneWidget);
    for (var m = 1; m <= 12; m++) {
      expect(find.text(_month(DateTime(2026, m))), findsOneWidget);
    }
    final selected = tester.widget<TextButton>(_monthButton(DateTime(2026, 3)));
    expect(selected.style?.backgroundColor?.resolve({}),
        LelloTheme.light.colorScheme.primary);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    await expectLater(
        find.byType(Dialog), matchesGoldenFile('goldens/month_picker.png'));
  });

  testWidgets('tocar em um mês seleciona e OK devolve a data', (tester) async {
    final host = await _open(tester);
    await tester.tap(_monthButton(DateTime(2026, 6)));
    await tester.pumpAndSettle();
    expect(find.text(_header(DateTime(2026, 6))), findsOneWidget);
    await tester.tap(find.text(MaterialLocalizations.of(
            tester.element(find.byType(Dialog)))
        .okButtonLabel));
    await tester.pumpAndSettle();
    expect(host.results.single, DateTime(2026, 6));
  });

  testWidgets('cancelar devolve null', (tester) async {
    final host = await _open(tester);
    await tester.tap(find.text(MaterialLocalizations.of(
            tester.element(find.byType(Dialog)))
        .cancelButtonLabel));
    await tester.pumpAndSettle();
    expect(host.results.single, isNull);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('setas mudam o ano exibido e a seleção segue o novo ano',
      (tester) async {
    final host = await _open(tester);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.text(_year(2027)), findsOneWidget);
    // o mês selecionado continua sendo mar/2026: nenhum botão destacado em 2027
    final march = tester.widget<TextButton>(_monthButton(DateTime(2027, 3)));
    expect(march.style?.backgroundColor?.resolve({}), isNull);

    await tester.tap(_monthButton(DateTime(2027, 1)));
    await tester.pumpAndSettle();
    expect(find.text(_header(DateTime(2027, 1))), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();
    expect(find.text(_year(2025)), findsOneWidget);

    await tester.tap(find.text(MaterialLocalizations.of(
            tester.element(find.byType(Dialog)))
        .okButtonLabel));
    await tester.pumpAndSettle();
    expect(host.results.single, DateTime(2027, 1));
  });

  testWidgets('tocar no ano abre a seleção de anos e escolher um volta aos meses',
      (tester) async {
    await _open(tester);
    await tester.tap(find.text(_year(2026)));
    await tester.pumpAndSettle();
    // cabeçalho "2026 - 2037" e grade com 12 anos
    expect(find.text('-'), findsOneWidget);
    expect(find.text(_year(2037)), findsWidgets);
    for (var y = 2027; y <= 2037; y++) {
      expect(find.text(_year(y)), findsWidgets);
    }
    final yearButton = tester.widget<TextButton>(find.ancestor(
        of: find.text(_year(2026)).last, matching: find.byType(TextButton)));
    expect(yearButton.style?.backgroundColor?.resolve({}),
        LelloTheme.light.colorScheme.primary);

    // setas na seleção de anos pulam 11 anos
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.text(_year(2037)), findsWidgets);
    expect(find.text(_year(2048)), findsWidgets);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();

    await tester.tap(find.ancestor(
        of: find.text(_year(2029)).last, matching: find.byType(TextButton)));
    await tester.pumpAndSettle();
    expect(find.text('-'), findsNothing);
    expect(find.text(_year(2029)), findsOneWidget);
    expect(find.text(_month(DateTime(2029, 1))), findsOneWidget);
  });

  testWidgets('firstDate e lastDate desabilitam os meses fora do intervalo',
      (tester) async {
    await _open(
      tester,
      initialDate: DateTime(2026, 3),
      firstDate: DateTime(2026, 2, 10),
      lastDate: DateTime(2026, 5, 20),
    );
    bool enabled(int m) =>
        tester.widget<TextButton>(_monthButton(DateTime(2026, m))).onPressed !=
        null;
    expect(enabled(1), isFalse);
    expect(enabled(2), isTrue);
    expect(enabled(5), isTrue);
    expect(enabled(6), isFalse);
    await tester.tap(_monthButton(DateTime(2026, 4)));
    await tester.pumpAndSettle();
    expect(find.text(_header(DateTime(2026, 4))), findsOneWidget);
  });

  testWidgets('só firstDate desabilita os meses anteriores', (tester) async {
    await _open(tester, firstDate: DateTime(2026, 3));
    bool enabled(int m) =>
        tester.widget<TextButton>(_monthButton(DateTime(2026, m))).onPressed !=
        null;
    expect(enabled(2), isFalse);
    expect(enabled(3), isTrue);
    expect(enabled(12), isTrue);
    await tester.tap(_monthButton(DateTime(2026, 12)));
    await tester.pumpAndSettle();
    expect(find.text(_header(DateTime(2026, 12))), findsOneWidget);
  });

  testWidgets('só lastDate desabilita os meses posteriores', (tester) async {
    await _open(tester, lastDate: DateTime(2026, 3));
    bool enabled(int m) =>
        tester.widget<TextButton>(_monthButton(DateTime(2026, m))).onPressed !=
        null;
    expect(enabled(1), isTrue);
    expect(enabled(3), isTrue);
    expect(enabled(4), isFalse);
    await tester.tap(_monthButton(DateTime(2026, 1)));
    await tester.pumpAndSettle();
    expect(find.text(_header(DateTime(2026, 1))), findsOneWidget);
  });

  testWidgets('mês atual é destacado com a cor primária', (tester) async {
    final now = DateTime.now();
    final other = DateTime(now.year, now.month == 1 ? 2 : 1);
    await _open(tester, initialDate: other);
    final current = tester.widget<Text>(find.text(_month(now)));
    expect(current.style?.color, LelloTheme.light.colorScheme.primary);
    await tester.tap(find.text(_year(now.year)));
    await tester.pumpAndSettle();
    final currentYear = tester.widget<Text>(find.descendant(
        of: find.byType(TextButton), matching: find.text(_year(now.year))));
    expect(currentYear.style?.color, Colors.white); // selecionado
  });

  testWidgets('ano atual não selecionado é destacado na seleção de anos',
      (tester) async {
    final now = DateTime.now();
    await _open(tester, initialDate: DateTime(now.year - 3, 1));
    await tester.tap(find.text(_year(now.year - 3)));
    await tester.pumpAndSettle();
    final currentYear = tester.widget<Text>(find.descendant(
        of: find.byType(TextButton), matching: find.text(_year(now.year))));
    expect(currentYear.style?.color, LelloTheme.light.colorScheme.primary);
  });

  testWidgets('em paisagem o cabeçalho fica ao lado do pager', (tester) async {
    await _open(tester, surface: const Size(900, 450));
    expect(find.byType(IntrinsicWidth), findsNothing);
    expect(find.byType(IntrinsicHeight), findsWidgets);
    final header = tester.getTopLeft(find.text(_header(DateTime(2026, 3))));
    final pager = tester.getTopLeft(find.byType(PageView));
    expect(pager.dx, greaterThan(header.dx)); // lado a lado
    expect(find.text(_header(DateTime(2026, 3))), findsOneWidget);
    await expectLater(find.byType(Dialog),
        matchesGoldenFile('goldens/month_picker_landscape.png'));
  });
}
