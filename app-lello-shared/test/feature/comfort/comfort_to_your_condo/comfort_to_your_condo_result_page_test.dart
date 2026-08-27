import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_result_page.dart';

import '../../../helpers/pump_app.dart';
import 'to_your_condo_harness.dart';

void main() {
  late RecordingNavigatorObserver observer;

  setUp(() {
    observer = RecordingNavigatorObserver();
  });

  /// Empilha base -> intermediária -> resultado, para verificar os "pop"
  /// duplos da página de resultado.
  Future<void> pumpResult(WidgetTester tester,
      {required bool success, VoidCallback? tryAgain}) async {
    await pumpPage(
      tester,
      basePage(),
      observer: observer,
      routes: {
        '/meio': (_) => const Scaffold(key: Key('meio'), body: Text('meio')),
        '/resultado': (_) =>
            ComfortToYourCondoResultPage(isSucces: success, tryAgain: tryAgain),
      },
    );
    await pushRoute(tester, '/meio');
    await pushRoute(tester, '/resultado');
  }

  testWidgets('sucesso mostra textos e concluir volta duas telas',
      (tester) async {
    await pumpResult(tester, success: true);

    expect(find.text('Solicitação enviada com sucesso!'), findsOneWidget);
    expect(find.text('Em até dois dias úteis nosso concierge entrará em contato.'),
        findsOneWidget);
    expect(find.text('comfort_disfavor_conclude'), findsOneWidget);
    expect(find.text('try_again'), findsNothing);
    expect(find.text('cancel'), findsNothing);
    expect(find.byType(SvgPicture), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/to_your_condo_result_success.png'));

    await tester.tap(find.text('comfort_disfavor_conclude'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(2));
    expect(findBasePage(), findsOneWidget);
    expect(find.byKey(const Key('meio')), findsNothing);
  });

  testWidgets('falha com tentar novamente chama o callback e volta uma tela',
      (tester) async {
    var tentativas = 0;
    await pumpResult(tester, success: false, tryAgain: () => tentativas++);

    expect(find.text('Falha no envio da solicitação'), findsOneWidget);
    expect(find.text('Tente novamente mais tarde.'), findsOneWidget);
    expect(find.text('try_again'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/to_your_condo_result_failure.png'));

    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();

    expect(tentativas, 1);
    expect(observer.popped, hasLength(1));
    expect(find.byKey(const Key('meio')), findsOneWidget);
  });

  testWidgets('falha: cancelar volta duas telas', (tester) async {
    await pumpResult(tester, success: false, tryAgain: () {});

    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(2));
    expect(findBasePage(), findsOneWidget);
  });

  testWidgets('falha sem callback: tentar novamente apenas volta duas telas',
      (tester) async {
    await pumpResult(tester, success: false);

    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(2));
    expect(findBasePage(), findsOneWidget);
  });
}
