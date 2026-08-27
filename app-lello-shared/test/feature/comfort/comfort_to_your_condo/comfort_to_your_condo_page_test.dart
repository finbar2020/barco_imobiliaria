import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_my_requests_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'to_your_condo_harness.dart';

void main() {
  late RecordingNavigatorObserver observer;
  late ToYourCondoHarness harness;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    observer = RecordingNavigatorObserver();
    fakeAnalytics.reset();
  });

  tearDown(() async {
    tester_lifecycle_reset();
    await harness.dispose();
  });

  /// Base -> página do condomínio (com botão de voltar).
  Future<void> pumpCondo(WidgetTester tester) async {
    await pumpPage(
      tester,
      basePage(),
      observer: observer,
      routes: {condoRouteName: (_) => harness.condoPage()},
    );
    await pushRoute(tester, condoRouteName, settle: false);
  }

  Finder categoryTitle(String title) => find.text(title);

  testWidgets('sem parceiros carregados mostra o loading', (tester) async {
    harness = ToYourCondoHarness.create();
    await pumpCondo(tester);

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('Para seu condomínio'), findsNothing);
  });

  testWidgets('lista só as categorias com parceiros e expande a de limpeza',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);

    expect(find.text('Para seu condomínio'), findsOneWidget);
    expect(find.text('Minhas Solicitações'), findsOneWidget);
    // Categorias ordenadas por título; lavanderia não tem parceiro.
    expect(categoryTitle('Limpeza'), findsOneWidget);
    expect(categoryTitle('Manutenção'), findsOneWidget);
    expect(categoryTitle('Lavanderia'), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(2));
    expect(find.text('Limpa Tudo'), findsNothing);

    await tester.tap(categoryTitle('Limpeza'));
    await pumpFrames(tester);

    expect(harness.controller.categoriesToYourCondoExpanded['cleaning'], isTrue);
    expect(harness.controller.categoriesToYourCondoExpanded['maintenance'],
        isFalse);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    // 3 parceiros de limpeza em 2 linhas; o de outra categoria fica de fora.
    expect(find.text('Limpa Tudo'), findsOneWidget);
    expect(find.text('Brilho Fácil'), findsOneWidget);
    expect(find.text('Clean Condo'), findsOneWidget);
    expect(find.text('Faxina Casa'), findsNothing);
    expect(find.text('Conserta Já'), findsNothing);
    expect(find.text('details'), findsNWidgets(3));
    expect(fakeAnalytics.eventNames, isNotEmpty);
    final acessoSubcategoria = fakeAnalytics.events.values
        .any((p) => p?['sub_categorias'] == 'cleaning');
    expect(acessoSubcategoria, isTrue);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/to_your_condo_page_expanded.png'));

    // Recolhe.
    await tester.tap(categoryTitle('Limpeza'));
    await pumpFrames(tester);
    expect(harness.controller.categoriesToYourCondoExpanded['cleaning'], isFalse);
    expect(find.text('Limpa Tudo'), findsNothing);
  });

  testWidgets('categoria já expandida no controller abre aberta e some ao sair',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    harness.controller.categoriesToYourCondoExpanded['maintenance'] = true;
    await pumpCondo(tester);

    expect(find.text('Conserta Já'), findsOneWidget);
    expect(find.text('details'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await pumpFrames(tester);

    expect(findBasePage(), findsOneWidget);
    // dispose zera o mapa de expansão.
    expect(harness.controller.categoriesToYourCondoExpanded.values,
        everyElement(isFalse));
    // WillPopScope: evento de voltar da categoria.
    final voltou = fakeAnalytics.events.values
        .any((p) => p?['category'] == 'toYourCondo');
    expect(voltou, isTrue);
  });

  testWidgets('detalhes do parceiro navega com os argumentos e restaura o timer',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);
    await tester.tap(categoryTitle('Manutenção'));
    await pumpFrames(tester);

    await tester.tap(find.text('details'));
    await pumpFrames(tester);

    expect(observer.pushedNames.last, SharedApplicationRoute.comfortPartner);
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    final args = observer.pushed.last.settings.arguments as ComfortPartnerPageArgs;
    expect(args.reference, 'R1');
    expect(args.unit, '101');
    expect(args.comfortPartnersController, same(harness.controller));
    expect(args.applicationContainer, same(harness.container));

    /// Defeito: `onPartnerSelected` envia `AppOriginEnum.manager` fixo nos
    /// argumentos em vez de `widget.appOriginEnum`; a página do parceiro
    /// sempre recebe origem "síndico". Comportamento atual documentado.
    expect(args.appOriginEnum, AppOriginEnum.manager);

    expect(harness.controller.selectedPartner!.id, 'p4');
    expect(harness.bloc.state, isA<LoadedComfortPartnerDetailsState>());
    harness.controller.comfortPartnerAnalyticsTimer = null;

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpFrames(tester);

    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);
    // Estado de detalhes não é "loaded" da lista: a página mostra loading.
    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('tocar no card do parceiro também abre os detalhes', (tester) async {
    harness = ToYourCondoHarness.create(origin: AppOriginEnum.owner);
    // Morador não recebe categorias do remote config: usa as do síndico.
    await harness.loadPartners();
    expect(harness.controller.categoriesToYourCondo, isEmpty);

    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);
    await tester.tap(categoryTitle('Limpeza'));
    await pumpFrames(tester);

    await tester.tap(find.text('Brilho Fácil'));
    await pumpFrames(tester);

    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(harness.controller.selectedPartner!.partnerIntro.title, 'Brilho Fácil');
  });

  testWidgets('minhas solicitações navega com o controller', (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);

    await tester.tap(find.text('Minhas Solicitações'));
    await pumpFrames(tester);

    expect(observer.pushedNames.last, SharedApplicationRoute.comfortMyRequests);
    final args =
        observer.pushed.last.settings.arguments as ComfortMyRequestsPageArgs;
    expect(args.comfortPartnersController, same(harness.controller));

    harness.controller.comfortPartnerAnalyticsTimer = null;
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpFrames(tester);
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);
    expect(find.text('Para seu condomínio'), findsOneWidget);
  });

  testWidgets('ícone informativo abre o onboarding e voltar restaura a página',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);

    // O ícone é o único InkWell cujo filho direto é o SVG informativo.
    final info = find.byWidgetPredicate(
        (w) => w is InkWell && w.child is SvgPicture);
    expect(info, findsOneWidget);
    // O SVG não existe neste pacote (é do app hospedeiro), então o InkWell
    // tem tamanho zero: aciona o onTap diretamente.
    tester.widget<InkWell>(info).onTap!();
    await pumpFrames(tester);

    expect(find.byType(ComfortToYourCondoOnboarding), findsOneWidget);
    final onboarding = tester.widget<ComfortToYourCondoOnboarding>(
        find.byType(ComfortToYourCondoOnboarding));
    expect(onboarding.fromIcon, isTrue);
    expect(onboarding.reference, 'R1');

    harness.controller.comfortPartnerAnalyticsTimer = null;
    await tester.tap(find.text('skip').first);
    await pumpFrames(tester);

    expect(find.byType(ComfortToYourCondoOnboarding), findsNothing);
    expect(find.text('Para seu condomínio'), findsOneWidget);
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);
  });

  testWidgets('ciclo de vida do app para e reinicia o timer de analytics',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNull);

    // Com outra rota por cima, a página ignora o ciclo de vida.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await pushRoute(tester, '/outra', settle: false);
    harness.controller.comfortPartnerAnalyticsTimer = null;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(harness.controller.comfortPartnerAnalyticsTimer, isNull);
  });

  testWidgets('rolar a lista não quebra (indicador de rolagem desativado)',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);
    await tester.tap(categoryTitle('Limpeza'));
    await pumpFrames(tester);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await pumpFrames(tester);

    expect(find.text('Para seu condomínio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a página agenda um frame novo a cada frame', (tester) async {
    /// Defeito: `ToYourCondoPage.build` registra um `addPostFrameCallback`
    /// que chama `setState` incondicionalmente; cada frame agenda outro, e a
    /// tela fica sendo reconstruída para sempre (`pumpAndSettle` estoura e,
    /// no app, o widget é reconstruído a cada frame enquanto estiver visível).
    /// Comportamento atual documentado.
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);

    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 1));
      expect(tester.binding.hasScheduledFrame, isTrue);
    }
    expect(find.text('Para seu condomínio'), findsOneWidget);
  });

  testWidgets('estado de erro não chega ao widget de erro', (tester) async {
    /// Defeito: em `ToYourCondoPage.build` o teste `state is!
    /// LoadedComfortPartnersState` vem antes de `state is
    /// ErrorComfortPartnersState`, então o ramo de erro (com
    /// `ErrorHandlingWidget` e "tentar novamente") nunca executa: qualquer
    /// erro fica preso no loading. Comportamento atual documentado.
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpCondo(tester);

    harness.bloc
        // ignore: invalid_use_of_visible_for_testing_member
        .emit(const ErrorComfortPartnersState(
            errorMessageKey: 'comfort_error_message',
            errorCode: '500',
            errorDescription: ''));
    await tester.pump();
    await tester.pump();

    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(observer.popped, isEmpty);
  });
}

/// Garante que o ciclo de vida volte a "resumed" para os próximos testes.
void tester_lifecycle_reset() {
  TestWidgetsFlutterBinding.instance
      .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
}
