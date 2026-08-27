import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_category_partners_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partners_list_view_horizontal_scrolling.dart';
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

  Future<ComfortPartnersController> pumpCategory(
    WidgetTester tester, {
    ComfortPartnerCategory category = ComfortPartnerCategory.toYou,
    bool loadPartners = true,
    bool settle = true,
  }) async {
    harness.mockPartners([
      partnerJson('P1', title: 'Alfa', category: 'toYou', discount: 0),
      partnerJson('P2', title: 'Beta', category: 'toYourPet'),
      partnerJson('P3', title: 'Gama', category: 'toYou', discount: 25),
    ]);
    final controller = harness.controller();
    if (loadPartners) {
      await controller.getAllPartners(ComfortPageOriginEnum.homePage);
    }
    await pumpPage(
      tester,
      ComfortCategoryPartnersPage(
        category: category,
        comfortPartnersController: controller,
        appContainer: harness.container,
        appOriginEnum: AppOriginEnum.owner,
        reference: 'R1',
        unit: '101',
      ),
      observer: observer,
      settle: settle,
    );
    return controller;
  }

  testWidgets('lista os parceiros da categoria', (tester) async {
    final controller = await pumpCategory(tester);

    expect(find.text('comfort'), findsOneWidget);
    expect(find.byType(ComfortPartnersListViewHorizontalScrolling),
        findsOneWidget);
    expect(find.text('comfort_to_you'), findsOneWidget);
    expect(find.text('comfort_to_you_description'), findsOneWidget);
    expect(find.byType(ComfortPartnerCard), findsNWidgets(2));
    expect(find.text('Alfa'), findsOneWidget);
    expect(find.text('Gama'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
    // Subtítulo com e sem desconto.
    expect(find.text('comfort_cleaning'), findsOneWidget);
    expect(find.text('comfort_cleaning\ncomfort_discount_of_up'),
        findsOneWidget);
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);
    expect(controller.comfortPartnerAnalyticsTimer!.otherParameters['category'],
        'toYou');

    await expectLater(
      find.byType(ComfortCategoryPartnersPage),
      matchesGoldenFile('goldens/comfort_category_partners_page.png'),
    );
  });

  testWidgets('tocar em um parceiro abre a página do parceiro',
      (tester) async {
    final controller = await pumpCategory(tester);

    await tester.tap(find.text('Gama'));
    await tester.pumpAndSettle();

    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(controller.selectedPartner?.id, 'P3');
    final args = observer.pushed.last.settings.arguments as ComfortPartnerPageArgs;
    expect(args.reference, 'R1');
    expect(args.unit, '101');
    expect(args.appOriginEnum, AppOriginEnum.owner);
    expect(fakeAnalytics.events['comodidades_parceiro_acessar']?['origem_acesso'],
        'coupon');
  });

  testWidgets('"voltar às categorias" e o botão da AppBar fecham a página',
      (tester) async {
    final controller = await pumpCategory(tester);

    await tester.tap(find.text('comfort_back_to_categories'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortCategoryPartnersPage), findsNothing);
    expect(observer.popped, hasLength(1));
    // No dispose a página registra a saída da categoria e para o timer.
    expect(controller.comfortPartnerAnalyticsTimer, isNull);
    expect(fakeAnalytics.events['comodidades_categoria_voltar']?['category'],
        'toYou');
  });

  testWidgets('categoria sem parceiros não renderiza a lista', (tester) async {
    final controller =
        await pumpCategory(tester, category: ComfortPartnerCategory.toYourVehicle);

    expect(find.byType(ComfortPartnerCard), findsNothing);
    expect(find.text('comfort_back_to_categories'), findsNothing);

    /// Defeito: ao sair da lista vazia o `dispose` da lista horizontal acessa
    /// `partners.first` e lança `StateError`. Removemos só a lista (estado de
    /// carregamento) para o erro não interromper o desmonte do resto da
    /// árvore (o Tooltip do botão voltar vazaria para o próximo teste).
    await emitState(tester, controller.comfortPartnersBloc,
        const LoadingComfortPartnersState(),
        settle: false);
    expect(tester.takeException(), isA<StateError>());
    await tester.pumpWidget(const SizedBox());
  });

  /// Defeito: `partners` é calculado uma única vez no `build` do
  /// StatelessWidget (antes do carregamento); quando a lista chega, só o
  /// `builder` do BlocConsumer reconstrói e a página continua sem parceiros.
  testWidgets('aberta antes do carregamento mostra o loading e depois vazio',
      (tester) async {
    // O LoadingWidget anima para sempre: sem pumpAndSettle.
    final controller =
        await pumpCategory(tester, loadPartners: false, settle: false);
    await tester.pump();

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(ComfortPartnerCard), findsNothing);

    await controller.getAllPartners(ComfortPageOriginEnum.homePage);
    await tester.pumpAndSettle();
    expect(find.byType(LoadingWidget), findsNothing);
    expect(controller.allPartnersList, hasLength(3));
    expect(find.byType(ComfortPartnerCard), findsNothing);

    // Lista vazia: o dispose da lista horizontal lança (ver defeito acima).
    await emitState(tester, controller.comfortPartnersBloc,
        const LoadingComfortPartnersState(),
        settle: false);
    expect(tester.takeException(), isA<StateError>());
    await tester.pumpWidget(const SizedBox());
  });

  /// Defeito: a verificação `state is! LoadedComfortPartnersState` vem antes
  /// da de erro, e `ErrorComfortPartnersState` não estende o estado carregado,
  /// então o `ErrorHandlingWidget` da página nunca é exibido — erros aparecem
  /// como carregamento infinito.
  testWidgets('estado de erro mostra o loading em vez do widget de erro',
      (tester) async {
    final controller = await pumpCategory(tester);

    await emitState(
      tester,
      controller.comfortPartnersBloc,
      const ErrorComfortPartnersState(
          errorMessageKey: 'k', errorCode: null, errorDescription: null),
      settle: false,
    );

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    // Desmonta ainda no teste: o loading anima para sempre.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ciclo de vida do app para e reinicia o timer da categoria',
      (tester) async {
    final controller = await pumpCategory(tester);

    // Com outra rota por cima o ciclo de vida é ignorado.
    controller.comfortCategoryAnalyticsStopTimer();
    await tester.tap(find.text('Alfa'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);

    // Ao voltar, a página real do parceiro reemite a lista (sem isso a
    // página de categoria ficaria no loading infinito).
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await controller
        .backToLoadedComfortPartnersState(ComfortPageOriginEnum.coupon);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortPartnerCard), findsNWidgets(2));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
  });
}
