import 'package:essentials/ui/widget/gesture/scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  setUp(() => Lottie.cache.clear());
  tearDown(resetPalletes);

  Widget comAsset(Widget child, FakeAssetBundle bundle) =>
      DefaultAssetBundle(bundle: bundle, child: child);

  testWidgets('carrega a animação do asset com o tamanho padrão',
      (tester) async {
    final bundle =
        FakeAssetBundle({'assets/an_scroll_tutorial.json': minimalLottieJson});
    await pumpApp(tester, comAsset(const ScrollIndicator(), bundle),
        settle: false);
    await tester.pump(const Duration(milliseconds: 100));
    expect(bundle.requested, contains('assets/an_scroll_tutorial.json'));

    final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    expect(lottie.height, 100);
    expect(lottie.width, 100);
    expect(lottie.animate, isTrue);
    expect(lottie.repeat, isTrue);
    expect(find.byType(Lottie), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('altura e largura customizadas', (tester) async {
    final bundle =
        FakeAssetBundle({'assets/an_scroll_tutorial.json': minimalLottieJson});
    final altura = 40.0; // não-const para executar o construtor em runtime
    await pumpApp(
      tester,
      comAsset(
          Center(child: ScrollIndicator(height: altura, width: 60)), bundle),
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(ScrollIndicator)), const Size(60, 40));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('golden do indicador de rolagem', (tester) async {
    final bundle =
        FakeAssetBundle({'assets/an_scroll_tutorial.json': minimalLottieJson});
    await pumpApp(
      tester,
      comAsset(const Center(child: ScrollIndicator()), bundle),
      settle: false,
      surface: const Size(200, 200),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/scroll_indicator.png'));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('asset ausente renderiza vazio via errorBuilder', (tester) async {
    /// Corrigido: o asset `assets/an_scroll_tutorial.json` continua a cargo
    /// do app hospedeiro (o pacote não o declara), mas agora o Lottie tem um
    /// `errorBuilder` que devolve `SizedBox.shrink()` — sem o asset nada é
    /// renderizado (em vez do ErrorWidget) e nenhuma exceção é lançada.
    final bundle = FakeAssetBundle({});
    await pumpApp(tester, comAsset(const ScrollIndicator(), bundle),
        settle: false);
    await tester.pump(const Duration(milliseconds: 100));
    expect(bundle.requested, ['assets/an_scroll_tutorial.json']);
    expect(find.byType(Lottie), findsNothing);
    expect(find.byType(ErrorWidget), findsNothing);
    final vazio = tester.widget<SizedBox>(find.descendant(
        of: find.byType(LottieBuilder), matching: find.byType(SizedBox)));
    expect(vazio.width, 0);
    expect(vazio.height, 0);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
