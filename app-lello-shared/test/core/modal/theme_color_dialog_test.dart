import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';

import '../../helpers/pump_app.dart';

/// Abre o [ThemeColorDialog] a partir de um botão e guarda o resultado.
class _Host extends StatefulWidget {
  const _Host({
    this.primary = const Color(0xFFFF0000),
    this.secondary = const Color(0xFF0000FF),
    this.isDark,
  });

  final Color primary;
  final Color secondary;
  final bool? isDark;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final results = <ThemeColorValue?>[];

  @override
  Widget build(BuildContext context) => TextButton(
        key: const Key('abrir'),
        onPressed: () async {
          final r = await showDialog<ThemeColorValue>(
            context: context,
            builder: (_) => ThemeColorDialog(
              initialPrimaryColor: widget.primary,
              initialSecondaryColor: widget.secondary,
              initialIsDark: widget.isDark,
            ),
          );
          results.add(r);
        },
        child: const Text('abrir'),
      );
}

Future<_HostState> _open(WidgetTester tester, {bool? isDark}) async {
  await pumpApp(tester, _Host(isDark: isDark), surface: const Size(600, 800));
  await tester.tap(find.byKey(const Key('abrir')));
  await tester.pumpAndSettle();
  return tester.state<_HostState>(find.byType(_Host));
}

Finder _field(int index) => find.byType(TextField).at(index);

Color _circleColor(WidgetTester tester, int index) => tester
    .widgetList<Icon>(find.byIcon(Icons.circle))
    .elementAt(index)
    .color!;

void main() {
  testWidgets('mostra as cores iniciais em hexadecimal e o tema', (tester) async {
    await _open(tester);
    expect(find.text('Cores do Tema'), findsOneWidget);
    expect(tester.widget<TextField>(_field(0)).controller!.text, '#FF0000');
    expect(tester.widget<TextField>(_field(1)).controller!.text, '#0000FF');
    expect(_circleColor(tester, 0), const Color(0xFFFF0000));
    expect(_circleColor(tester, 1), const Color(0xFF0000FF));
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await expectLater(
        find.byType(AlertDialog), matchesGoldenFile('goldens/theme_color_dialog.png'));
  });

  testWidgets('initialIsDark true marca o checkbox; toggle altera', (tester) async {
    await _open(tester, isDark: true);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
  });

  testWidgets('digitar hexadecimal válido (6 ou 8 dígitos) atualiza a cor',
      (tester) async {
    await _open(tester);
    await tester.enterText(_field(0), '00FF00');
    await tester.pump();
    expect(_circleColor(tester, 0), const Color(0xFF00FF00));

    await tester.enterText(_field(1), '#80112233');
    await tester.pump();
    expect(_circleColor(tester, 1), const Color(0x80112233));
  });

  testWidgets('hexadecimal inválido não altera a cor', (tester) async {
    await _open(tester);
    await tester.enterText(_field(0), 'zzzzzz'); // tamanho certo, não numérico
    await tester.pump();
    expect(_circleColor(tester, 0), const Color(0xFFFF0000));
    await tester.enterText(_field(0), '#12'); // tamanho errado
    await tester.pump();
    expect(_circleColor(tester, 0), const Color(0xFFFF0000));
  });

  testWidgets('REINICIAR devolve um ThemeColorValue vazio', (tester) async {
    final host = await _open(tester);
    await tester.tap(find.text('REINICIAR'));
    await tester.pumpAndSettle();
    expect(find.byType(ThemeColorDialog), findsNothing);
    final value = host.results.single!;
    expect(value.primaryColor, isNull);
    expect(value.secondaryColor, isNull);
    expect(value.isDark, isNull);
  });

  testWidgets('SALVAR devolve as cores digitadas e o tema escuro', (tester) async {
    final host = await _open(tester);
    await tester.enterText(_field(0), '#123456');
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.text('SALVAR'));
    await tester.pumpAndSettle();
    final value = host.results.single!;
    expect(value.primaryColor, const Color(0xFF123456));
    expect(value.secondaryColor, const Color(0xFF0000FF));
    expect(value.isDark, isTrue);
  });

  testWidgets('SALVAR com cor inválida mostra alerta e mantém o diálogo',
      (tester) async {
    final host = await _open(tester);
    await tester.enterText(_field(1), 'abc');
    await tester.pump();
    await tester.tap(find.text('SALVAR'));
    await tester.pumpAndSettle();
    expect(find.text('Erro'), findsOneWidget);
    expect(find.text('Insira um valor de cor hexadecimal válido!'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Erro'), findsNothing);
    expect(find.byType(ThemeColorDialog), findsOneWidget);
    expect(host.results, isEmpty);
  });

  testWidgets('botão de paleta abre o seletor e escolher uma cor preenche o campo',
      (tester) async {
    await _open(tester);
    await tester.tap(find.byIcon(Icons.palette).first);
    await tester.pumpAndSettle();
    expect(find.text('Selecione uma cor'), findsOneWidget);
    final picker = tester.widget<ColorPicker>(find.byType(ColorPicker));
    expect(picker.pickerColor, const Color(0xFFFF0000));
    expect(picker.enableAlpha, isFalse);

    // Arrasta no seletor de área para mudar a cor.
    final area = find.byType(ColorPickerArea);
    await tester.tapAt(tester.getCenter(area));
    await tester.pumpAndSettle();
    final text = tester.widget<TextField>(_field(0)).controller!.text;
    expect(text, isNot('#FF0000'));
    expect(text, matches(RegExp(r'^#[0-9A-F]{6}$')));

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Selecione uma cor'), findsNothing);
    expect(_circleColor(tester, 0).value, const Color(0xFFFF0000).value == 0
        ? 0
        : int.parse('FF${text.substring(1)}', radix: 16));
  });

  testWidgets('seletor com cor inválida no campo começa branco e CANCELAR fecha',
      (tester) async {
    await _open(tester);
    await tester.enterText(_field(1), 'xx');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.palette).last);
    await tester.pumpAndSettle();
    final picker = tester.widget<ColorPicker>(find.byType(ColorPicker));
    expect(picker.pickerColor, Colors.white);
    await tester.tap(find.text('CANCELAR'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorPicker), findsNothing);
    expect(tester.widget<TextField>(_field(1)).controller!.text, 'xx');
  });
}
