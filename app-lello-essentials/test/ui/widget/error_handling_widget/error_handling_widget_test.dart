import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helpers/pump_app.dart';

/// Textos com data/hora (`dd/MM/yyyy HH:mm`, `26/08/2026`, `14:05`) mudam a
/// cada execução: nos goldens eles são cobertos por uma máscara branca.
final _padraoDataHora = RegExp(r'\d{2}[/:]\d{2}');

const _maskStackKey = Key('mask-stack');

Widget _comMascaras(Widget child, List<Rect> rects) {
  return Stack(
    key: _maskStackKey,
    children: [
      child,
      for (final r in rects)
        Positioned.fromRect(
          rect: r,
          child: const ColoredBox(color: Colors.white),
        ),
    ],
  );
}

/// Calcula os retângulos (relativos ao Stack de máscara) dos textos com
/// data/hora atualmente renderizados.
List<Rect> _retangulosDeDataHora(WidgetTester tester) {
  final origem = tester.getTopLeft(find.byKey(_maskStackKey));
  return [
    for (final e in find.textContaining(_padraoDataHora).evaluate())
      tester.getRect(find.byWidget(e.widget)).shift(-origem).inflate(2),
  ];
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    PackageInfo.setMockInitialValues(
      appName: 'essentials',
      packageName: 'br.com.lello.essentials',
      version: '9.8.7',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  Finder painelOffstage() => find
      .ancestor(
        of: find.byType(ExpandableNotifier, skipOffstage: false),
        matching: find.byType(Offstage, skipOffstage: false),
      )
      .first;

  testWidgets('em produção mostra textos padrão, data e esconde detalhes',
      (tester) async {
    var tentativas = 0;
    var voltas = 0;
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        isProduction: true,
        reTryFunction: () => tentativas++,
        backFunction: () => voltas++,
      ),
      shrinkWrap: false,
    );

    expect(find.text('error_handling_widget_title'), findsOneWidget);
    expect(find.text('error_handling_widget_subtitle'), findsOneWidget);
    expect(find.text('error_handling_widget_button_reTry'), findsOneWidget);
    expect(find.text('error_handling_widget_button_back'), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$')),
      findsOneWidget,
      reason: 'data formatada em dd/MM/yyyy HH:mm',
    );
    expect(tester.widget<Offstage>(painelOffstage()).offstage, isTrue);
    expect(find.byIcon(Icons.more_horiz), findsNothing,
        reason: 'painel de detalhes fora da tela');
    expect(find.byIcon(Icons.more_horiz, skipOffstage: false), findsOneWidget);

    await tester.tap(find.text('error_handling_widget_button_reTry'));
    expect(tentativas, 1);
    expect(voltas, 0);
    await tester.tap(find.text('error_handling_widget_button_back'));
    expect(voltas, 1);
  });

  testWidgets('usa título, subtítulo e texto do botão de voltar customizados',
      (tester) async {
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        isProduction: true,
        title: 'meu_titulo',
        subTitle: 'meu_subtitulo',
        textReturnButton: 'meu_voltar',
        reTryFunction: () {},
        backFunction: () {},
      ),
      shrinkWrap: false,
      locOverrides: const {
        'meu_titulo': 'Título custom',
        'meu_subtitulo': 'Subtítulo custom',
        'meu_voltar': 'Sair',
      },
    );

    expect(find.text('Título custom'), findsOneWidget);
    expect(find.text('Subtítulo custom'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);
    expect(find.text('error_handling_widget_title'), findsNothing);
    expect(find.text('error_handling_widget_button_back'), findsNothing);
  });

  testWidgets('message tem prioridade sobre subTitle e showBackButton esconde o botão',
      (tester) async {
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        isProduction: true,
        subTitle: 'meu_subtitulo',
        message: 'Mensagem já traduzida',
        showBackButton: false,
        reTryFunction: () {},
        backFunction: () {},
      ),
      shrinkWrap: false,
    );

    expect(find.text('Mensagem já traduzida'), findsOneWidget);
    expect(find.text('meu_subtitulo'), findsNothing);
    expect(find.text('error_handling_widget_button_back'), findsNothing);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('fora de produção expande os detalhes com código, erro e versão',
      (tester) async {
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        isProduction: false,
        errorCode: 'E-500',
        error: 'Falha de rede',
        reTryFunction: () {},
        backFunction: () {},
      ),
      shrinkWrap: false,
      surface: const Size(400, 900),
    );

    expect(tester.widget<Offstage>(painelOffstage()).offstage, isFalse);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    expect(find.byIcon(Icons.expand_less), findsNothing);
    // Os detalhes ficam colapsados até tocar no cabeçalho.
    expect(find.text('E-500').hitTestable(), findsNothing);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.expand_less), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsNothing);
    expect(find.text('error_handling_widget_date'), findsOneWidget);
    expect(find.text('error_handling_widget_hour'), findsOneWidget);
    expect(find.text('error_handling_widget_app_version'), findsOneWidget);
    expect(find.text('error_handling_widget_code_error'), findsOneWidget);
    expect(find.text('error_handling_widget_error'), findsOneWidget);
    expect(find.text('E-500'), findsOneWidget);
    expect(find.text('Falha de rede'), findsOneWidget);
    expect(find.text('9.8.7'), findsOneWidget,
        reason: 'versão vinda do PackageInfo');
    expect(find.text(DateFormat.yMd('pt_BR').format(DateTime.now())),
        findsOneWidget);
    expect(find.text(DateFormat.Hm('pt_BR').format(DateTime.now())),
        findsOneWidget);

    // Colapsa de novo.
    await tester.tap(find.byIcon(Icons.expand_less));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);
  });

  testWidgets('sem errorCode e error mostra campos vazios', (tester) async {
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        isProduction: false,
        reTryFunction: () {},
        backFunction: () {},
      ),
      shrinkWrap: false,
      surface: const Size(400, 900),
    );
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    final vazios = find.byWidgetPredicate(
      (w) => w is Text && w.data == '',
    );
    expect(vazios, findsNWidgets(2), reason: 'código e erro vazios');
  });

  testWidgets('golden: produção (colapsado)', (tester) async {
    Widget build(List<Rect> rects) => _comMascaras(
          ErrorHandlingWidget(
            isProduction: true,
            reTryFunction: () {},
            backFunction: () {},
          ),
          rects,
        );

    await pumpApp(tester, build(const []), shrinkWrap: false);
    final rects = _retangulosDeDataHora(tester);
    expect(rects, hasLength(1));
    await pumpApp(tester, build(rects), shrinkWrap: false);

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/error_handling_widget_producao.png'),
    );
  });

  testWidgets('golden: detalhes expandidos', (tester) async {
    Widget build(List<Rect> rects) => _comMascaras(
          ErrorHandlingWidget(
            isProduction: false,
            errorCode: 'E-500',
            error: 'Falha de rede',
            reTryFunction: () {},
            backFunction: () {},
          ),
          rects,
        );

    await pumpApp(tester, build(const []),
        shrinkWrap: false, surface: const Size(400, 900));
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    final rects = _retangulosDeDataHora(tester);
    expect(rects, hasLength(3), reason: 'data/hora, data e hora dos detalhes');

    // Reinicia o State (senão o painel já nasce expandido).
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester, build(rects),
        shrinkWrap: false, surface: const Size(400, 900));
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/error_handling_widget_expandido.png'),
    );
  });
}
