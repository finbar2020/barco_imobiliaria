import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_category_partners_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_best_offers_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_offer_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_list_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partners_list_view_horizontal_scrolling.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view_vertical_scrolling/comfort_partners_list_view_vertical_scrolling.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'comfort_partners_test_support.dart';

void main() {
  late ComfortHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  ComfortPageArgs args({
    AppOriginEnum origin = AppOriginEnum.owner,
    String? partnerId,
    dynamic route,
    String? context,
    bool checkOffers = true,
    bool checkYourCondo = true,
  }) =>
      ComfortPageArgs(
        appOriginEnum: origin,
        reference: 'R1',
        unit: '101',
        accessRouteOrigin: ComfortPageOriginEnum.homePage,
        partnerId: partnerId,
        route: route,
        comfortNotificationContext: context,
        checkOffers: checkOffers,
        checkYourCondo: checkYourCondo,
        isProduction: false,
      );

  void mockDefaultPartners() => harness.mockPartners([
        partnerJson('P1', title: 'Alfa', category: 'toYou'),
        partnerJson('P2', title: 'Beta', category: 'toYourPet'),
        partnerJson('P3', title: 'Gama', category: 'toYou'),
      ]);

  Future<void> pumpComfort(
    WidgetTester tester, {
    ComfortPageArgs? arguments,
    AppOriginEnum origin = AppOriginEnum.owner,
    bool settle = true,
    Map<String, WidgetBuilder> routes = const {},
  }) =>
      pumpPage(
        tester,
        ComfortPage(appContainer: harness.container, appOriginEnum: origin),
        arguments: arguments,
        observer: observer,
        settle: settle,
        routes: routes,
      );

  testWidgets('carrega os parceiros e mostra o menu de categorias',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester);

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(find.byType(ComfortMenuItem), findsNWidgets(2));
    expect(find.text('comfort_to_you'), findsOneWidget);
    expect(find.text('comfort_to_your_pet'), findsOneWidget);
    expect(find.byType(ComfortBestOffersListView), findsOneWidget);
    expect(find.text('comfort_top_offers'), findsNothing);
    expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
    // Sem argumentos de rota a origem de acesso é "dashboard".
    expect(fakeAnalytics.events['comodidades_acessar']?['origem_acesso'],
        'dashboard');
    expect(harness.lastController!.comfortHomeAnalyticsTimer, isNotNull);

    await expectLater(
      find.byType(ComfortPage),
      matchesGoldenFile('goldens/comfort_page_menu.png'),
    );
  });

  testWidgets('estado de carregamento mostra o LoadingWidget', (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args());
    await emitState(tester, harness.lastController!.comfortPartnersBloc,
        const LoadingComfortPartnersState(),
        settle: false);

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(ComfortPartnerMenu), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('erro da api mostra o widget de erro e permite tentar de novo',
      (tester) async {
    harness.http.failAll();

    await pumpComfort(tester, arguments: args());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.byType(ComfortPartnerMenu), findsNothing);

    mockDefaultPartners();
    await tester.tap(find.text('error_handling_widget_button_reTry'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(fakeAnalytics.events['comodidades_acessar']?['origem_acesso'],
        'comfortPageTryAgain');
  });

  testWidgets('botão voltar do erro fecha a página', (tester) async {
    harness.http.failAll();

    await pumpComfort(tester, arguments: args());
    await tester.tap(find.text('error_handling_widget_button_back'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(find.byType(ComfortPage), findsNothing);
  });

  for (final origin in AppOriginEnum.values) {
    testWidgets('tocar em uma categoria abre a página da categoria ($origin)',
        (tester) async {
      mockDefaultPartners();

      harness.appOrigin = origin;
      await pumpComfort(tester,
          arguments: args(origin: origin), origin: origin);
      await tester.tap(find.text('comfort_to_you'));
      await tester.pumpAndSettle();

      expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
      expect(find.byType(ComfortPartnerCard), findsNWidgets(2));
      expect(find.text('Alfa'), findsOneWidget);
      expect(find.text('Gama'), findsOneWidget);
      expect(fakeAnalytics.events['comodidades_categoria_acessar']?['category'],
          'PARA_VOCE');
      expect(harness.lastController!.comfortHomeAnalyticsTimer, isNull);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCategoryPartnersPage), findsNothing);
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      expect(harness.lastController!.comfortHomeAnalyticsTimer, isNotNull);
    });
  }

  testWidgets('partnerId nos argumentos abre direto a página do parceiro',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args(partnerId: 'P2'));

    expect(observer.pushedNames, contains(SharedApplicationRoute.comfortPartner));
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(find.byType(ComfortPage), findsNothing);
    expect(harness.lastController!.selectedPartner?.id, 'P2');
    final pushed = observer.pushed.last.settings.arguments;
    expect(pushed, isA<ComfortPartnerPageArgs>());
    expect((pushed as ComfortPartnerPageArgs).reference, 'R1');
    expect(fakeAnalytics.events['comodidades_parceiro_acessar']
        ?['origem_acesso'], 'banner');
  });

  testWidgets(
      'partnerId com nome de categoria (banner) seleciona a categoria e volta',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args(partnerId: 'PARA_SEU_PET'));

    expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(harness.lastController!.currentCategory,
        ComfortPartnerCategory.toYourPet);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // A categoria continua selecionada: a lista aparece no lugar do menu.
    expect(find.byType(ComfortPartnersListViewHorizontalScrolling),
        findsOneWidget);
    expect(find.byType(ComfortPartnerMenu), findsNothing);

    // Tocar num parceiro da lista em linha abre a página do parceiro.
    await tester.tap(find.text('Beta'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(harness.lastController!.selectedPartner?.id, 'P2');
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await harness.lastController!
        .backToLoadedComfortPartnersState(ComfortPageOriginEnum.coupon);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortPartnersListViewHorizontalScrolling),
        findsOneWidget);

    await tester.tap(find.text('comfort_back_to_categories'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(harness.lastController!.currentCategory, isNull);
  });

  testWidgets('banner com o nome interno da categoria "para sua família"',
      (tester) async {
    harness.mockPartners([
      partnerJson('P1', title: 'Alfa', category: 'toYourFamily'),
    ]);

    await pumpComfort(tester, arguments: args(partnerId: 'toYourFamily'));

    expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
    expect(find.text('comfort_to_your_family'), findsOneWidget);
    expect(fakeAnalytics.events['comodidades_categoria_acessar']?['category'],
        'PARA_SUA_FAMILIA');
  });

  testWidgets('sem argumentos e sem "condominium" na sessão usa o selecionado',
      (tester) async {
    mockDefaultPartners();
    // Só o síndico lê `selectedCondominium` em todos os pontos (o controller
    // do morador acessa `condominium` diretamente e lançaria).
    harness.appOrigin = AppOriginEnum.manager;
    harness.session.state = FakeSessionState(_ManagerOnlySession());

    await pumpComfort(tester, origin: AppOriginEnum.manager);

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    await tester.tap(find.text('comfort_to_you'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
    final page = tester.widget<ComfortCategoryPartnersPage>(
        find.byType(ComfortCategoryPartnersPage));
    expect(page.reference, 'R9');
  });

  testWidgets('partnerId com categoria sem parceiros não redireciona',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args(partnerId: 'PARA_SEU_VEICULO'));

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(observer.pushedNames, isNot(contains('comfort_partner')));
    expect(harness.lastController!.currentCategory, isNull);
  });

  testWidgets('notificação de categoria (enum) abre a categoria',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester,
        arguments: args(
            route: FeaturesRoutesEnum.COMODIDADES_CATEGORIA,
            context: 'PARA_VOCE'));

    expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
    expect(find.text('Alfa'), findsOneWidget);
  });

  testWidgets('notificação de categoria (texto) sem parceiros não abre nada',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester,
        arguments:
            args(route: 'COMODIDADES_CATEGORIA', context: 'PARA_SUA_FAMILIA'));

    expect(find.byType(ComfortCategoryPartnersPage), findsNothing);
    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
  });

  testWidgets('notificação de parceiro abre a página do parceiro',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester,
        arguments:
            args(route: FeaturesRoutesEnum.COMODIDADES_PARCEIRO, context: 'np_P3'));

    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(harness.lastController!.selectedPartner?.id, 'P3');
    expect(fakeAnalytics.events['comodidades_parceiro_acessar']
        ?['origem_acesso'], 'inAppNotification');
  });

  testWidgets('notificação de parceiro por id e parceiro inexistente',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester,
        arguments: args(route: 'COMODIDADES_PARCEIRO', context: 'P1'));
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(harness.lastController!.selectedPartner?.id, 'P1');

    // Volta (a página real do parceiro reemite a lista ao fechar) e confirma
    // que o redirecionamento só acontece uma vez.
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await harness.lastController!
        .backToLoadedComfortPartnersState(ComfortPageOriginEnum.myRequestsPage);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(observer.pushedNames
        .where((n) => n == SharedApplicationRoute.comfortPartner), hasLength(1));
  });

  testWidgets('notificação de parceiro inexistente mantém o menu',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester,
        arguments: args(route: 'COMODIDADES_PARCEIRO', context: 'nada'));

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
    expect(observer.pushedNames, isNot(contains('comfort_partner')));
  });

  testWidgets('rota de notificação desconhecida é ignorada', (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args(route: 'BOLETOS'));

    expect(find.byType(ComfortPartnerMenu), findsOneWidget);
  });

  testWidgets('cupom em destaque abre o parceiro do cupom', (tester) async {
    mockDefaultPartners();
    final controller = harness.controller();
    controller.coupons = [
      buildCoupon('C1', discount: 30, partnerId: 'P1'),
      buildCoupon('C2', discount: 50, partnerId: 'inexistente'),
    ];

    await pumpComfort(tester, arguments: args());

    expect(find.text('comfort_top_offers'), findsOneWidget);
    expect(find.byType(ComfortOfferCard), findsNWidgets(2));
    expect(find.text('50'), findsOneWidget);

    await tester.tap(find.text('30'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(controller.selectedPartner?.id, 'P1');
    expect(fakeAnalytics.events['comodidades_parceiro_acessar']
        ?['origem_acesso'], 'coupon');
  });

  /// Corrigido: quando o parceiro do cupom não está na lista o toque é
  /// ignorado (antes o `firstWhere(..., orElse: null)` lançava `StateError`).
  testWidgets('cupom de parceiro fora da lista é ignorado', (tester) async {
    mockDefaultPartners();
    harness.controller().coupons = [
      buildCoupon('C2', discount: 50, partnerId: 'inexistente'),
    ];

    await pumpComfort(tester, arguments: args());
    await tester.tap(find.text('50'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsNothing);
  });

  testWidgets('checkOffers falso esconde as melhores ofertas', (tester) async {
    mockDefaultPartners();
    harness.controller().coupons = [buildCoupon('C1', partnerId: 'P1')];

    await pumpComfort(tester, arguments: args(checkOffers: false));

    expect(find.byType(ComfortBestOffersListView), findsNothing);
  });

  testWidgets('estado sem filtro por categoria lista os parceiros na vertical',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args());
    await emitState(
      tester,
      harness.lastController!.comfortPartnersBloc,
      const LoadedComfortPartnersState(
        comfortPartnerCategoryIsFilter: false,
        comfortPartnersIsRandomic: false,
        categoriesToYourCondo: [],
      ),
    );

    expect(find.byType(ComfortPartnersListViewVerticalScrolling),
        findsNWidgets(2));
    expect(find.byType(ComfortPartnerMenu), findsNothing);

    await tester.tap(find.byType(ComfortPartnerListCard).first);
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
  });

  testWidgets('estados vazio e de detalhes não renderizam conteúdo',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args());
    final bloc = harness.lastController!.comfortPartnersBloc;

    await emitState(tester, bloc, const EmptyComfortPartnersState());
    expect(find.byType(ComfortPartnerMenu), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);

    await emitState(
        tester,
        bloc,
        LoadedComfortPartnerDetailsState(
            selectedPartner: harness.lastController!.allPartnersList.first));
    expect(find.byType(ComfortPartnerMenu), findsNothing);
  });

  group('voltar (WillPopScope)', () {
    testWidgets('sem categoria selecionada volta até a home', (tester) async {
      mockDefaultPartners();

      await pumpPage(
        tester,
        _PushOnStart(SharedApplicationRoute.home),
        observer: observer,
        routes: {
          SharedApplicationRoute.home: (_) => _PushOnStart(
                SharedApplicationRoute.comfort,
                arguments: args(),
                key: const Key('home'),
              ),
          SharedApplicationRoute.comfort: (_) => ComfortPage(
                appContainer: harness.container,
                appOriginEnum: AppOriginEnum.owner,
              ),
        },
      );
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);

      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();

      expect(find.byType(ComfortPage), findsNothing);
      expect(find.byKey(const Key('home')), findsOneWidget);
      expect(fakeAnalytics.eventNames, contains('comodidades_voltar'));
    });

    testWidgets('com categoria selecionada volta ao menu de categorias',
        (tester) async {
      mockDefaultPartners();

      await pumpComfort(tester, arguments: args(partnerId: 'PARA_VOCE'));
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortPartnersListViewHorizontalScrolling),
          findsOneWidget);

      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();

      expect(find.byType(ComfortPage), findsOneWidget);
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      expect(harness.lastController!.currentCategory, isNull);
      expect(fakeAnalytics.eventNames, isNot(contains('comodidades_voltar')));
    });
  });

  testWidgets('ciclo de vida do app para e reinicia o temporizador',
      (tester) async {
    mockDefaultPartners();

    await pumpComfort(tester, arguments: args());
    final controller = harness.lastController!;
    expect(controller.comfortHomeAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(controller.comfortHomeAnalyticsTimer, isNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortHomeAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(controller.comfortHomeAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();
    expect(controller.comfortHomeAnalyticsTimer, isNull);

    // Com outra rota por cima, o ciclo de vida é ignorado.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_to_you'));
    await tester.pumpAndSettle();
    controller.comfortHomeAnalyticsStopTimer();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortHomeAnalyticsTimer, isNull);
  });

  group('para seu condomínio (síndico)', () {
    void mockManagerPartners() {
      harness.appOrigin = AppOriginEnum.manager;
      harness.session.toYourCondo = [yourCondoConfig('cleaning')];
      harness.mockPartners([
        partnerJson('P1', title: 'Alfa', category: 'toYou'),
        partnerJson('P5',
            title: 'Condo', category: 'toYourCondo', comfortType: 'cleaning'),
      ]);
    }

    testWidgets('primeiro acesso abre o onboarding', (tester) async {
      mockManagerPartners();

      await pumpComfort(tester,
          arguments: args(origin: AppOriginEnum.manager),
          origin: AppOriginEnum.manager);

      expect(find.text('comfort_to_your_condo'), findsOneWidget);
      expect(find.text('lello_hub_badge_new'), findsOneWidget);

      await tester.tap(find.text('comfort_to_your_condo'));
      await tester.pumpAndSettle();

      expect(find.byType(ComfortToYourCondoOnboarding), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SharedPreferencesKeys.comfortToYourCondoOnboarding),
          '{"onboarding":false}');
      expect(fakeAnalytics.events['comodidades_categoria_acessar']?['category'],
          'PARA_SEU_CONDOMINIO');

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      expect(harness.lastController!.comfortHomeAnalyticsTimer, isNotNull);
    });

    testWidgets('onboarding já visto abre a página "para seu condomínio"',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.comfortToYourCondoOnboarding:
            '{"onboarding":false}',
      });
      mockManagerPartners();

      await pumpComfort(tester,
          arguments: args(origin: AppOriginEnum.manager),
          origin: AppOriginEnum.manager);
      // A ToYourCondoPage agenda um setState a cada frame (nunca "assenta").
      await tester.tap(find.text('comfort_to_your_condo'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(ToYourCondoPage), findsOneWidget);
      expect(harness.lastController!.comfortHomeAnalyticsTimer, isNull);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      for (var i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(ToYourCondoPage), findsNothing);
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      expect(harness.lastController!.comfortHomeAnalyticsTimer, isNotNull);
    });

    testWidgets('checkYourCondo falso esconde a categoria', (tester) async {
      mockManagerPartners();

      await pumpComfort(tester,
          arguments:
              args(origin: AppOriginEnum.manager, checkYourCondo: false),
          origin: AppOriginEnum.manager);

      expect(find.text('comfort_to_your_condo'), findsNothing);
      expect(find.text('comfort_to_you'), findsOneWidget);
    });
  });

  group('modo embutido', () {
    Future<void> pumpEmbedded(
      WidgetTester tester, {
      Widget? middle,
      VoidCallback? backFunction,
    }) =>
        pumpPage(
          tester,
          Scaffold(
            body: SingleChildScrollView(
              child: ComfortPage(
                appContainer: harness.container,
                appOriginEnum: AppOriginEnum.owner,
                embedded: true,
                embeddedMiddleWidget: middle,
                backFunction: backFunction,
              ),
            ),
          ),
          observer: observer,
        );

    testWidgets('mostra menu, ofertas e listas por categoria', (tester) async {
      mockDefaultPartners();
      harness.controller().coupons = [buildCoupon('C1', partnerId: 'P1')];

      await pumpEmbedded(tester);

      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      expect(find.byType(ComfortBestOffersListView), findsOneWidget);
      expect(find.byType(ComfortPartnersListViewVerticalScrolling),
          findsNWidgets(2));
      expect(find.byType(ComfortPartnerListCard), findsNWidgets(3));
      expect(find.byType(Scaffold), findsOneWidget);

      await expectLater(
        find.byType(ComfortPage),
        matchesGoldenFile('goldens/comfort_page_embedded.png'),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
      expect(harness.lastController!.selectedPartner?.id, 'P2');

      // Voltando, a oferta em destaque também abre o parceiro do cupom.
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await harness.lastController!
          .backToLoadedComfortPartnersState(ComfortPageOriginEnum.coupon);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ComfortOfferCard));
      await tester.pumpAndSettle();
      expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
      expect(harness.lastController!.selectedPartner?.id, 'P1');
    });

    testWidgets('widget do meio substitui as ofertas e categoria navega',
        (tester) async {
      mockDefaultPartners();
      harness.controller().coupons = [buildCoupon('C1', partnerId: 'P1')];

      await pumpEmbedded(tester, middle: const Text('meio'));

      expect(find.text('meio'), findsOneWidget);
      expect(find.byType(ComfortBestOffersListView), findsNothing);

      await tester.tap(find.descendant(
        of: find.byType(ComfortPartnerMenu),
        matching: find.text('comfort_to_your_pet'),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCategoryPartnersPage), findsOneWidget);
    });

    testWidgets('carregando mostra o LoadingWidget embutido', (tester) async {
      mockDefaultPartners();
      await pumpEmbedded(tester);
      await emitState(tester, harness.lastController!.comfortPartnersBloc,
          const LoadingComfortPartnersState(),
          settle: false);
      expect(find.byType(LoadingWidget), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('erro embutido com função de voltar', (tester) async {
      harness.http.failAll();
      var backCalls = 0;

      await pumpEmbedded(tester, backFunction: () {
        backCalls++;
      });

      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('error_handling_widget_button_back'));
      await tester.pumpAndSettle();
      expect(backCalls, 1);
    });

    testWidgets('erro embutido sem função de voltar esconde o botão',
        (tester) async {
      harness.http.failAll();

      await pumpEmbedded(tester);

      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.text('error_handling_widget_button_back'), findsNothing);
    });
  });
}

/// Sessão de síndico sem o getter `condominium`: o acesso dinâmico lança e a
/// página cai no `selectedCondominium`.
class _ManagerOnlySession {
  final selectedCondominium = FakeCondominium(reference: 'R9');
  final FakeUnity? unity = FakeUnity();
  final FakeMe? me = FakeMe();
}

/// Empurra [route] assim que é montado (para montar uma pilha de rotas).
class _PushOnStart extends StatefulWidget {
  const _PushOnStart(this.route, {this.arguments, super.key});
  final String route;
  final Object? arguments;

  @override
  State<_PushOnStart> createState() => _PushOnStartState();
}

class _PushOnStartState extends State<_PushOnStart> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, widget.route, arguments: widget.arguments);
    });
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Text('rota ${widget.route}'));
}
