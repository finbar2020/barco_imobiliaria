import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_best_offers_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_offer_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/disfavor_partner_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/favorite_partner_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner.dart/comfort_partner_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_result_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/partner_general_rating_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupon_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupons_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_no_coupon_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_list_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partners_list_view_horizontal_scrolling.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view_vertical_scrolling/comfort_partners_list_view_vertical_scrolling.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/review_request_dialog.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_partners_test_support.dart';

const _allCategories = ComfortPartnerCategory.values;

void main() {
  late ComfortHarness harness;

  setUp(() async {
    harness = await installComfortHarness();
  });

  group('ComfortBestOffersListView / ComfortOfferCard', () {
    testWidgets('sem cupons não renderiza nada', (tester) async {
      await pumpApp(tester,
          ComfortBestOffersListView(coupons: const [], onPressed: (_) {}));
      expect(find.text('comfort_top_offers'), findsNothing);
      expect(find.byType(ComfortOfferCard), findsNothing);
    });

    testWidgets('lista os cupons (ignorando nulos) e chama onPressed',
        (tester) async {
      ComfortPartnerCoupon? pressed;
      final coupons = <ComfortPartnerCoupon?>[
        buildCoupon('C1', discount: 15),
        null,
      ];
      await pumpApp(
        tester,
        ComfortBestOffersListView(
            coupons: coupons, onPressed: (c) => pressed = c),
      );

      expect(find.text('comfort_top_offers'), findsOneWidget);
      expect(find.byType(ComfortOfferCard), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('COMFORT_OTHERS'), findsOneWidget);

      await tester.tap(find.text('15'));
      expect(pressed?.id, 'C1');

      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/comfort_best_offers.png'));
    });

    testWidgets('mostra o tipo do cupom', (tester) async {
      final coupon = buildCoupon('C1')..comfortType = ComfortType.laundry;
      await pumpApp(tester, ComfortOfferCard(coupon: coupon, onPressed: (_) {}));
      expect(find.text('COMFORT_LAUNDRY'), findsOneWidget);
    });
  });

  group('ComfortPartnerCard', () {
    testWidgets('parceiro nulo não renderiza nada', (tester) async {
      await pumpApp(
        tester,
        ComfortPartnerCard(
            partner: null,
            onPressed: (_) {},
            applicationContainer: harness.container),
      );
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('mostra o botão de detalhes e chama onPressed', (tester) async {
      final taps = <String>[];
      await pumpApp(
        tester,
        SizedBox(
          height: 260,
          child: ComfortPartnerCard(
            partner: buildPartner('P1', title: 'Alfa', discount: 0),
            onPressed: (p) => taps.add(p.id),
            applicationContainer: harness.container,
            showCardDetailsButton: true,
          ),
        ),
      );

      expect(find.text('Alfa'), findsOneWidget);
      expect(find.text('comfort_cleaning'), findsOneWidget);
      expect(find.text('details'), findsOneWidget);

      await tester.tap(find.text('details'));
      await tester.tap(find.text('Alfa'));
      expect(taps, ['P1', 'P1']);
      await tester.pumpAndSettle();

      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/comfort_partner_card.png'));
    });
  });

  group('ComfortPartnerListCard', () {
    testWidgets('parceiro nulo não renderiza nada', (tester) async {
      await pumpApp(
        tester,
        ComfortPartnerListCard(
            partner: null,
            onPressed: (_) {},
            applicationContainer: harness.container),
      );
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('mostra o título e chama onPressed', (tester) async {
      ComfortPartner? pressed;
      harness.authStore.header = {'Authorization': 'Bearer t'};
      await pumpApp(
        tester,
        ComfortPartnerListCard(
            partner: buildPartner('P1', title: 'Alfa'),
            onPressed: (p) => pressed = p,
            applicationContainer: harness.container),
      );
      expect(find.text('Alfa'), findsOneWidget);
      await tester.tap(find.text('Alfa'));
      expect(pressed?.id, 'P1');
    });
  });

  group('ComfortPartnersListViewVerticalScrolling', () {
    testWidgets('sem parceiros não renderiza nada', (tester) async {
      await pumpApp(
        tester,
        ComfortPartnersListViewVerticalScrolling(
            partners: const [],
            onPressed: (_) {},
            applicationContainer: harness.container),
      );
      expect(find.byType(ComfortPartnerListCard), findsNothing);
    });

    for (final category in _allCategories) {
      testWidgets('mostra o título e o ícone da categoria $category',
          (tester) async {
        ComfortPartner? pressed;
        await pumpApp(
          tester,
          ComfortPartnersListViewVerticalScrolling(
            partners: [
              buildPartner('P1', category: category.name),
              buildPartner('P2', category: category.name),
            ],
            onPressed: (p) => pressed = p,
            applicationContainer: harness.container,
          ),
        );
        expect(find.byType(ComfortPartnerListCard), findsNWidgets(2));
        expect(find.textContaining('comfort_'), findsOneWidget);
        await tester.tap(find.text('Parceiro P2'));
        expect(pressed?.id, 'P2');
      });
    }
  });

  group('ComfortPartnersListViewHorizontalScrolling', () {
    Widget build(
      List<ComfortPartner> partners, {
      VoidCallback? onInit,
      VoidCallback? onStop,
      VoidCallback? onBack,
      void Function(ComfortPartnerCategory)? onDispose,
      void Function(ComfortPartner)? onPressed,
    }) =>
        SingleChildScrollView(
          child: ComfortPartnersListViewHorizontalScrolling(
            partners: partners,
            onPressed: onPressed ?? (_) {},
            initializeAnalyticsTimer: onInit ?? () {},
            stopAnalyticsTimer: onStop ?? () {},
            backPressed: onBack ?? () {},
            applicationContainer: harness.container,
            onCategoryDispose: onDispose ?? (_) {},
          ),
        );

    for (final category in _allCategories) {
      testWidgets('título e descrição da categoria $category',
          (tester) async {
        await pumpApp(
          tester,
          build([buildPartner('P1', category: category.name)]),
          surface: const Size(400, 900),
          shrinkWrap: false,
        );
        expect(find.textContaining('_description'), findsOneWidget);
        expect(find.byType(ComfortPartnerCard), findsOneWidget);
      });
    }

    testWidgets('callbacks de voltar, seleção, ciclo de vida e dispose',
        (tester) async {
      var inits = 0, stops = 0, backs = 0;
      ComfortPartnerCategory? disposed;
      ComfortPartner? pressed;
      await pumpApp(
        tester,
        build(
          [buildPartner('P1', category: 'toYourPet')],
          onInit: () => inits++,
          onStop: () => stops++,
          onBack: () => backs++,
          onDispose: (c) => disposed = c,
          onPressed: (p) => pressed = p,
        ),
        surface: const Size(400, 900),
        shrinkWrap: false,
      );
      expect(inits, 1);

      await tester.tap(find.text('comfort_back_to_categories'));
      expect(backs, 1);
      await tester.tap(find.text('Parceiro P1'));
      expect(pressed?.id, 'P1');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(stops, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(inits, 2);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
      await tester.pump();
      expect(stops, 2);
      // Sem "resumed" após "detached" os frames ficam desabilitados.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(inits, 3);

      await tester.pumpWidget(const SizedBox());
      expect(disposed, ComfortPartnerCategory.toYourPet);
      expect(stops, 3);
    });

    testWidgets('sem parceiros não renderiza nada', (tester) async {
      await pumpApp(tester, build(const []), shrinkWrap: false);
      expect(find.text('comfort_back_to_categories'), findsNothing);
      // Desmonta dentro do teste para capturar o erro do dispose (abaixo).
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isA<StateError>());
    });

    /// Defeito: no `dispose` o widget acessa `widget.partners.first` sem
    /// verificar a lista; com a lista vazia lança `StateError` ("No element").
    testWidgets('dispose com lista vazia lança StateError', (tester) async {
      await pumpApp(tester, build(const []), shrinkWrap: false);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isA<StateError>());
    });
  });

  group('ComfortPartnerMenu / ComfortMenuItem', () {
    Widget menu({
      required AppOriginEnum origin,
      required List<ComfortPartnerCategory> categories,
      void Function(ComfortPartnerCategory)? onTap,
    }) =>
        ComfortPartnerMenu(
          categories: categories,
          onTap: onTap ?? (_) {},
          appOriginEnum: origin,
          comfortPartnersController:
              harness.buildController(appOriginEnum: origin),
          appContainer: harness.container,
        );

    testWidgets('síndico mostra todas as categorias com o selo de novo',
        (tester) async {
      final taps = <ComfortPartnerCategory>[];
      await pumpApp(
        tester,
        menu(
          origin: AppOriginEnum.manager,
          categories: _allCategories.toList(),
          onTap: taps.add,
        ),
        surface: const Size(1400, 300),
      );

      expect(find.byType(ComfortMenuItem), findsNWidgets(7));
      expect(find.byType(CircuitBreakerWidget), findsNothing);
      expect(find.text('lello_hub_badge_new'), findsOneWidget);
      for (final key in [
        'comfort_to_your_home',
        'comfort_to_you',
        'comfort_to_your_pet',
        'comfort_to_your_vehicle',
        'comfort_to_your_condo',
        'comfort_to_your_family',
        'comfort_others',
      ]) {
        expect(find.text(key), findsOneWidget, reason: key);
      }

      await tester.tap(find.text('comfort_others'));
      expect(taps, [ComfortPartnerCategory.others]);

      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/comfort_partner_menu.png'));
    });

    testWidgets('morador envolve os itens no circuit breaker', (tester) async {
      final taps = <ComfortPartnerCategory>[];
      await pumpApp(
        tester,
        menu(
          origin: AppOriginEnum.owner,
          categories: _allCategories.toList(),
          onTap: taps.add,
        ),
        surface: const Size(1400, 300),
      );

      expect(find.byType(CircuitBreakerWidget), findsNWidgets(7));
      expect(find.byType(ComfortMenuItem), findsNWidgets(7));
      expect(harness.session.rbacChecked, isNotEmpty);

      await tester.tap(find.text('comfort_to_your_pet'));
      expect(taps, [ComfortPartnerCategory.toYourPet]);
    });

    testWidgets('morador sem rbac não vê as categorias', (tester) async {
      harness.session.rbacAllowed = false;
      await pumpApp(
        tester,
        menu(
          origin: AppOriginEnum.owner,
          categories: [
            ComfortPartnerCategory.toYou,
            ComfortPartnerCategory.toYourHome,
          ],
        ),
      );

      expect(find.byType(ComfortMenuItem), findsNothing);
    });
  });

  group('ComfortPartnerViewWidget', () {
    testWidgets('sem categoria atual mostra o menu; com categoria, a lista',
        (tester) async {
      final controller = harness.buildController(
        appOriginEnum: AppOriginEnum.employee,
        allPartnersList: [buildPartner('P1', category: 'toYourHome')],
      );
      final categories = [
        ComfortPartnerCategory.toYourHome,
        ComfortPartnerCategory.toYourCondo,
      ];
      var backs = 0;
      ComfortPartner? pressed;
      Widget view() => SingleChildScrollView(
            child: ComfortPartnerViewWidget(
              comfortPartnersController: controller,
              categories: categories,
              onTap: (_) {},
              onPartnerSelected: (p) => pressed = p,
              backPressed: () => backs++,
              applicationContainer: harness.container,
              checkYourCondo: false,
              appOriginEnum: AppOriginEnum.employee,
              appContainer: harness.container,
            ),
          );

      await pumpApp(tester, view(),
          surface: const Size(400, 900), shrinkWrap: false);
      expect(find.byType(ComfortPartnerMenu), findsOneWidget);
      // checkYourCondo falso remove "para seu condomínio" da lista.
      expect(categories, [ComfortPartnerCategory.toYourHome]);
      expect(find.byType(ComfortMenuItem), findsOneWidget);

      controller.changeCategory(ComfortPartnerCategory.toYourHome);
      await pumpApp(tester, view(),
          surface: const Size(400, 900), shrinkWrap: false);
      expect(find.byType(ComfortPartnersListViewHorizontalScrolling),
          findsOneWidget);
      expect(controller.comfortPartnerAnalyticsTimer, isNotNull);

      await tester.tap(find.text('comfort_back_to_categories'));
      expect(backs, 1);
      await tester.tap(find.text('Parceiro P1'));
      expect(pressed?.id, 'P1');
    });
  });

  group('PartnerCouponsListView / PartnerCouponCard', () {
    testWidgets('sem cupons não renderiza nada', (tester) async {
      await pumpApp(
        tester,
        PartnerCouponsListView(
          partner: buildPartner('P1'),
          coupons: const [],
          onPressed: (_, {coupon}) {},
          analyticsLgpdAcessar: (_, __) {},
          analyticsOptIn: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          applicationContainer: harness.container,
        ),
      );
      expect(find.byType(PartnerCouponCard), findsNothing);
    });

    /// Defeito: `onShowDialog`/`onDialogDismissed` são CHAMADOS durante o
    /// build (`widget.onShowDialog!(...) ?? () {}`) e o RETORNO deles é
    /// passado como callback do card (um retorno não-função quebra o build
    /// com TypeError); com `onShowDialog` nulo o build lança erro de null
    /// check.
    testWidgets('callbacks de diálogo são disparados no build', (tester) async {
      var shown = 0, dismissed = 0;
      await pumpApp(
        tester,
        PartnerCouponsListView(
          partner: buildPartner('P1'),
          coupons: [buildCoupon('C1'), buildCoupon('C2')],
          onPressed: (_, {coupon}) {},
          onShowDialog: (_, {coupon}) {
            shown++;
          },
          onDialogDismissed: (_, {coupon}) {
            dismissed++;
          },
          analyticsLgpdAcessar: (_, __) {},
          analyticsOptIn: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          applicationContainer: harness.container,
        ),
        shrinkWrap: false,
      );

      expect(find.byType(PartnerCouponCard), findsNWidgets(2));
      expect(shown, 2);
      expect(dismissed, 2);

      // Abrir um cupom não chama de novo o onShowDialog original.
      await tester.tap(find.byType(PartnerCouponCard).first);
      await tester.pumpAndSettle();
      expect(find.byType(CouponRequestDialog), findsOneWidget);
      expect(shown, 2);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(dismissed, 2);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pump();
    });

    testWidgets('callback que devolve valor não-função quebra o build',
        (tester) async {
      await pumpApp(
        tester,
        PartnerCouponsListView(
          partner: buildPartner('P1'),
          coupons: [buildCoupon('C1')],
          onPressed: (_, {coupon}) {},
          onShowDialog: (_, {coupon}) => 1,
          onDialogDismissed: (_, {coupon}) => 2,
          analyticsLgpdAcessar: (_, __) {},
          analyticsOptIn: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          applicationContainer: harness.container,
        ),
        shrinkWrap: false,
      );
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('sem onShowDialog o build falha com null check', (tester) async {
      await pumpApp(
        tester,
        PartnerCouponsListView(
          partner: buildPartner('P1'),
          coupons: [buildCoupon('C1')],
          onPressed: (_, {coupon}) {},
          analyticsLgpdAcessar: (_, __) {},
          analyticsOptIn: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          applicationContainer: harness.container,
        ),
        shrinkWrap: false,
      );
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('cupom nulo não renderiza o card', (tester) async {
      await pumpApp(
        tester,
        PartnerCouponCard(
          partner: buildPartner('P1'),
          coupon: null,
          onPressed: (_, {coupon}) {},
          onShowDialog: () {},
          onDialogDismissed: () {},
          applicationContainer: harness.container,
          analyticsLgpdAcessar: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          analyticsOptIn: (_, __) {},
        ),
      );
      expect(find.byType(Material), findsNWidgets(1));
    });

    testWidgets('card abre o diálogo e avisa ao fechar', (tester) async {
      var shown = 0, dismissed = 0;
      await pumpApp(
        tester,
        PartnerCouponCard(
          partner: buildPartner('P1'),
          coupon: buildCoupon('C1', title: 'Promo'),
          onPressed: (_, {coupon}) {},
          onShowDialog: () => shown++,
          onDialogDismissed: () => dismissed++,
          applicationContainer: harness.container,
          analyticsLgpdAcessar: (_, __) {},
          analyticsRedirectButton: (_, __) {},
          analyticsOptIn: (_, __) {},
        ),
      );
      expect(find.text('PROMO'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(find.byType(CouponRequestDialog), findsOneWidget);
      expect(shown, 1);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.byType(CouponRequestDialog), findsNothing);
      expect(dismissed, 1);
    });
  });

  group('CouponRequestDialog', () {
    Future<void> pumpDialog(
      WidgetTester tester, {
      required ComfortPartner partner,
      ComfortPartnerCoupon? coupon,
      void Function(ComfortPartner, {ComfortPartnerCoupon? coupon})? onPressed,
      VoidCallback? onGoToPartnerPage,
      VoidCallback? onResumed,
      VoidCallback? onPaused,
      VoidCallback? onDetached,
      List<String>? analytics,
    }) async {
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => CouponRequestDialog(
                partner: partner,
                coupon: coupon,
                onPressed: onPressed ?? (_, {coupon}) {},
                onGoToPartnerPage: onGoToPartnerPage,
                onLifecycleResumed: onResumed,
                onLifecyclePaused: onPaused,
                onLifecycleDetached: onDetached,
                analyticsLgpdAcessar: (_, __) => analytics?.add('lgpd'),
                analyticsRedirectButton: (_, __) => analytics?.add('redirect'),
                analyticsOptIn: (_, __) => analytics?.add('optin'),
              ),
            ),
            child: const Text('abrir'),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
    }

    testWidgets('botão de ir só funciona com o aceite marcado', (tester) async {
      final analytics = <String>[];
      var pressed = 0, goTo = 0;
      await pumpDialog(
        tester,
        partner: buildPartner('P1', cta: 'link'),
        coupon: buildCoupon('C1', reusable: true),
        onPressed: (_, {coupon}) => pressed++,
        onGoToPartnerPage: () => goTo++,
        analytics: analytics,
      );

      expect(find.text('comfort_get_coupon_almost_there!'), findsOneWidget);
      expect(find.text('comfort_get_coupon_single_use'), findsNothing);
      expect(find.text('comfort_get_coupon_description_1'), findsOneWidget);

      await tester.tap(find.text('comfort_get_coupon_description_go'));
      await tester.pumpAndSettle();
      expect(pressed, 0);
      expect(find.byType(CouponRequestDialog), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      // Desmarcar e marcar de novo: opt-in só é registrado ao marcar.
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(analytics.where((a) => a == 'optin'), hasLength(2));

      await expectLater(find.byType(Dialog),
          matchesGoldenFile('goldens/coupon_request_dialog.png'));

      await tester.tap(find.text('comfort_get_coupon_description_go'));
      await tester.pumpAndSettle();
      expect(pressed, 1);
      expect(goTo, 1);
      expect(analytics, contains('redirect'));
      expect(find.byType(CouponRequestDialog), findsNothing);
    });

    testWidgets('links da LGPD abrem o launcher e registram analytics',
        (tester) async {
      final analytics = <String>[];
      await pumpDialog(
        tester,
        partner: buildPartner('P1'),
        coupon: buildCoupon('C1'),
        analytics: analytics,
      );

      await tester.tap(find.textContaining('comfort_get_coupon_lgpd_one',
          findRichText: true));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining(
          'comfort_get_coupon_description_lgpd_1',
          findRichText: true));
      await tester.pumpAndSettle();

      expect(analytics, ['lgpd', 'lgpd']);
      expect(harness.launcher.launched, hasLength(2));
      expect(harness.launcher.launched.first,
          contains('lellocondominios.com.br'));
    });

    testWidgets('ciclo de vida dispara os callbacks', (tester) async {
      var resumed = 0, paused = 0, detached = 0;
      await pumpDialog(
        tester,
        partner: buildPartner('P1', cta: 'email'),
        onResumed: () => resumed++,
        onPaused: () => paused++,
        onDetached: () => detached++,
      );

      expect(find.text('comfort_get_coupon_email_description_1'),
          findsOneWidget);
      expect(find.text('comfort_request_email'), findsOneWidget);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
      await tester.pump();

      expect(paused, 1);
      expect(resumed, 1);
      expect(detached, 1);

      // Com outra rota por cima o ciclo de vida é ignorado.
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .push(MaterialPageRoute(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(paused, 1);
    });
  });

  group('ComfortCupomRequesResultPage', () {
    testWidgets('sucesso mostra concluir e fecha', (tester) async {
      await pumpPage(
        tester,
        const ComfortCupomRequesResultPage(
            isSucces: true, title: 'Título', subtitle: 'Sub'),
      );
      expect(find.text('Título'), findsOneWidget);
      expect(find.text('Sub'), findsOneWidget);
      expect(find.text('comfort_disfavor_conclude'), findsOneWidget);
      expect(find.text('cancel'), findsNothing);

      await expectLater(find.byType(ComfortCupomRequesResultPage),
          matchesGoldenFile('goldens/coupon_request_result_success.png'));

      await tester.tap(find.text('comfort_disfavor_conclude'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
    });

    testWidgets('erro com retryAction chama a ação e fecha', (tester) async {
      var retries = 0;
      await pumpPage(
        tester,
        ComfortCupomRequesResultPage(
          isSucces: false,
          title: 'Erro',
          subtitle: 'Sub',
          retryAction: () => retries++,
        ),
      );
      expect(find.text('try_again'), findsOneWidget);
      expect(find.text('cancel'), findsOneWidget);

      await expectLater(find.byType(ComfortCupomRequesResultPage),
          matchesGoldenFile('goldens/coupon_request_result_error.png'));

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
    });

    testWidgets('erro sem retryAction: cancelar fecha', (tester) async {
      await pumpPage(
        tester,
        const ComfortCupomRequesResultPage(
            isSucces: false, title: 'Erro', subtitle: 'Sub'),
      );
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
    });
  });

  group('ReviewRequestDialog', () {
    Future<List<Map<String, Object?>>> pumpReview(
      WidgetTester tester, {
      DateTime? purchaseDate,
      bool withDate = true,
    }) async {
      final sent = <Map<String, Object?>>[];
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ReviewRequestDialog(
                applicationContainer: harness.container,
                partner: buildPartner('P1', title: 'Alfa'),
                requestPurchase: buildPurchase(
                    purchaseDate: withDate ? purchaseDate : null)
                  ..purchaseDate = withDate
                      ? (purchaseDate ?? DateTime(2026, 2, 10))
                      : null,
                sendRequestReview: (
                        {required String requestId,
                        required double rate,
                        String? comment}) =>
                    sent.add({
                  'requestId': requestId,
                  'rate': rate,
                  'comment': comment,
                }),
              ),
            ),
            child: const Text('abrir'),
          ),
        ),
        surface: const Size(400, 900),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      return sent;
    }

    testWidgets('mostra a data da compra e envia a nota sem comentário',
        (tester) async {
      final sent = await pumpReview(tester);

      expect(find.text('Alfa'), findsOneWidget);
      expect(find.text('comfort_purchase_completed_date'), findsOneWidget);
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.onPressed, isNull);
      // Sem nota o toque no botão não envia nada.
      await tester.tap(find.text('comfort_purchase_completed_rate'));
      await tester.pumpAndSettle();
      expect(sent, isEmpty);

      await rateStars(tester, find.byType(RatingBar), 4);
      expect(
          tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
          isNotNull);
      await tester.tap(find.text('comfort_purchase_completed_rate'));
      await tester.pumpAndSettle();

      expect(sent.single['requestId'], 'REQ1');
      expect(sent.single['rate'], 4.0);
      expect(sent.single['comment'], isNull);
      expect(find.byType(ReviewRequestDialog), findsNothing);
    });

    testWidgets('sem data de compra esconde a linha da data e permite adiar',
        (tester) async {
      final sent = await pumpReview(tester, withDate: false);

      expect(find.text('comfort_purchase_completed_date'), findsNothing);
      // Tocar fora do campo com ele focado tira o foco.
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasPrimaryFocus, isTrue);
      await tester.tap(find.text('Alfa'));
      await tester.pumpAndSettle();
      expect(editable.focusNode.hasPrimaryFocus, isFalse);
      await tester.tap(find.text('comfort_purchase_completed_rate_after'));
      await tester.pumpAndSettle();

      expect(sent, isEmpty);
      expect(find.byType(ReviewRequestDialog), findsNothing);
    });
  });

  group('outros widgets', () {
    testWidgets('DisfavorPartnerDialog confirma e cancela', (tester) async {
      final disfavored = <String>[];
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => DisfavorPartnerDialog(
                disfavorPartnerFunction: (p) => disfavored.add(p.id),
                partner: buildPartner('P1', title: 'Alfa'),
                applicationContainer: harness.container,
              ),
            ),
            child: const Text('abrir'),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.text('Alfa'), findsOneWidget);

      await expectLater(find.byType(Dialog),
          matchesGoldenFile('goldens/disfavor_partner_dialog.png'));

      await tester.tap(find.text('comfort_disfavor_dialog_confirmation'));
      await tester.pumpAndSettle();
      expect(disfavored, ['P1']);
      expect(find.byType(DisfavorPartnerDialog), findsNothing);
    });

    testWidgets('FavoritePartnerCard seleciona e abre o diálogo',
        (tester) async {
      final selected = <String>[];
      await pumpApp(
        tester,
        SizedBox(
          height: 340,
          child: FavoritePartnerCard(
            partner: buildPartner('P1', title: 'Alfa'),
            onPartnerSelectFunction: (p) => selected.add(p.id),
            disfavorPartnerFunction: (_) {},
            applicationContainer: harness.container,
          ),
        ),
      );

      await tester.tap(find.text('Alfa'));
      expect(selected, ['P1']);

      await tester.tap(find.text('comfort_disfavor_partner'));
      await tester.pumpAndSettle();
      expect(find.byType(DisfavorPartnerDialog), findsOneWidget);
      await tester.tap(find.text('comfort_disfavor_dialog_cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(DisfavorPartnerDialog), findsNothing);
    });

    testWidgets('PartnerGeneralRatingWidget mostra a nota e o total',
        (tester) async {
      await pumpApp(
        tester,
        PartnerGeneralRatingWidget(
            partner: buildPartner('P1', rating: 3.5, ratingsNumber: 12)),
        locOverrides: {'comfort_ratings_total': '### avaliações'},
      );
      expect(find.text('comfort_ratings'), findsOneWidget);
      expect(find.text('12 avaliações'), findsOneWidget);
      expect(find.byType(RatingBar), findsOneWidget);

      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/partner_general_rating.png'));
    });

    testWidgets('PartnerNoCouponWidget com e sem site', (tester) async {
      final pressed = <String>[];
      await pumpApp(
        tester,
        PartnerNoCouponWidget(
          partner: buildPartner('P1'),
          onPressed: (p, {coupon}) => pressed.add(p.id),
        ),
      );
      expect(find.text('comfort_partner_no_coupon'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      expect(pressed, ['P1']);

      await pumpApp(
        tester,
        PartnerNoCouponWidget(
          partner: buildPartner('P2', site: ''),
          onPressed: (p, {coupon}) => pressed.add(p.id),
        ),
      );
      expect(find.byType(PrimaryButton), findsNothing);
    });
  });
}
