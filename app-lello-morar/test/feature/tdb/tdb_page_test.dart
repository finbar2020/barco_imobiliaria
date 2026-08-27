import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_state.dart';
import 'package:morar/feature/tdb/presentation/controllers/tdb_controller.dart';
import 'package:morar/feature/tdb/presentation/pages/tdb_page.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_on_boarding.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_on_boarding_page.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_redirect_dialog.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

const _tdbBody = {
  'redirect_link': 'https://parceiro.com/app/entrar',
  'information': [
    {'name_param': 'token', 'param': 'abc', 'type': 'QUERY'},
    {'name_param': 'X-Auth', 'param': 'h1', 'type': 'HEADER'},
  ],
};

void main() {
  late PageHarness harness;
  late FakeUrlLauncherPlatform launcher;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    launcher = installFakeUrlLauncher();
    observer = RecordingNavigatorObserver();
  });

  Future<void> pump(WidgetTester tester) => pumpPage(
        tester,
        const TdbPage(),
        observer: observer,
        surface: const Size(500, 1000),
      );

  Future<void> goToLastPage(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('tdb_next'));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('onboarding avança página a página até o cadastro',
      (tester) async {
    await pump(tester);

    expect(find.text('tdb_skip'), findsOneWidget);
    expect(find.text('tdb_next'), findsOneWidget);
    expect(find.text('tdb_on_boarding_1_description'), findsOneWidget);
    await expectLater(
      find.byType(TdbPage),
      matchesGoldenFile('goldens/tdb_on_boarding_page.png'),
    );

    await goToLastPage(tester);

    expect(find.text('tdb_on_boarding_4_description'), findsOneWidget);
    expect(find.text('tdb_next'), findsNothing);
    expect(find.text('tdb_skip'), findsNothing);
    expect(find.text('tdb_sign_up'), findsOneWidget);
    expect(find.text('tdb_not_now'), findsOneWidget);
  });

  testWidgets('pular vai direto para a última página', (tester) async {
    await pump(tester);

    await tester.tap(find.text('tdb_skip'));
    await tester.pumpAndSettle();

    expect(find.text('tdb_sign_up'), findsOneWidget);
    expect(find.byType(TdbOnBoardingPage), findsWidgets);
  });

  testWidgets('"agora não" volta para a tela anterior', (tester) async {
    await pump(tester);
    await goToLastPage(tester);

    await tester.tap(find.text('tdb_not_now'));
    await tester.pumpAndSettle();

    expect(observer.popped, isNotEmpty);
    expect(find.byType(TdbPage), findsNothing);
  });

  testWidgets('cadastro abre o diálogo, exige o aceite e abre o parceiro',
      (tester) async {
    harness.http.on('GET', '/condominiums/c1/tdb', body: _tdbBody);
    await pump(tester);
    await goToLastPage(tester);

    await tester.tap(find.text('tdb_sign_up'));
    await tester.pumpAndSettle();
    expect(find.byType(TdbRedirectDialog), findsOneWidget);

    // Sem marcar o aceite o botão não faz nada.
    await tester.tap(find.text('tdb_dialog_go_to_page'));
    await tester.pumpAndSettle();
    expect(find.byType(TdbRedirectDialog), findsOneWidget);
    expect(harness.http.requests, isEmpty);

    // O link da LGPD abre no navegador.
    await tester.tap(find.byWidgetPredicate((w) =>
        w is RichText && w.text.toPlainText().contains('tdb_dialog_checkbox_one')));
    await tester.pumpAndSettle();
    expect(launcher.launched, hasLength(1));

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('tdb_dialog_go_to_page'));
    await tester.pumpAndSettle();

    expect(find.byType(TdbRedirectDialog), findsNothing);
    expect(harness.http.requests.last.url.path, '/condominiums/c1/tdb');
    final state = harness.resolve<TDBController>().bloc.state;
    expect(state, isA<LoadedTDBState>());
    expect((state as LoadedTDBState).tdbInfo, isNotNull);
    // A tela abre o parceiro com query e header montados a partir do retorno.
    expect(launcher.launched.last, 'https://parceiro.com/app/entrar?token=abc');
    expect(launcher.headers.last, {'X-Auth': 'h1'});
    // Com o tdbInfo carregado o onboarding já começa na última página.
    expect(find.text('tdb_sign_up'), findsOneWidget);
  });

  testWidgets('retorno sem link abre o redirect_link cru', (tester) async {
    harness.http.on('GET', '/condominiums/c1/tdb', body: {
      'redirect_link': '',
      'information': <Map<String, dynamic>>[],
    });
    await pump(tester);
    await goToLastPage(tester);
    await tester.tap(find.text('tdb_sign_up'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('tdb_dialog_go_to_page'));
    await tester.pumpAndSettle();

    expect(launcher.launched.last, '');
  });

  testWidgets('erro na api mostra o widget de erro e permite tentar de novo',
      (tester) async {
    harness.http.failAll();
    await pump(tester);
    await goToLastPage(tester);
    await tester.tap(find.text('tdb_sign_up'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('tdb_dialog_go_to_page'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    harness.http.on('GET', '/condominiums/c1/tdb', body: _tdbBody);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(find.byType(TdbOnBoardingWidget), findsOneWidget);
    expect(launcher.launched, isNotEmpty);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pump(tester);
    final bloc = harness.resolve<TDBController>().bloc;

    await emitState(tester, bloc, const LoadingTDBState(), settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
