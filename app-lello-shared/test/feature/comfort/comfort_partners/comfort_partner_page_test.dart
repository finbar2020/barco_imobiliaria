import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/pages/comfort_partner_reviews_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_review_sent_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_result_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/partner_general_rating_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupon_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupons_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_no_coupon_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/review_request_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_info_widget.dart';
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

  /// Cria o controller com [partner] selecionado (estado de detalhes) e
  /// monta a página com os argumentos de rota.
  Future<ComfortPartnersController> pumpPartner(
    WidgetTester tester,
    ComfortPartner partner, {
    AppOriginEnum origin = AppOriginEnum.owner,
    List<ComfortPartner>? allPartners,
    Size surface = const Size(400, 800),
  }) async {
    harness.appOrigin = origin;
    final controller = harness.controller();
    controller.allPartnersList = allPartners ?? [partner];
    await controller.goToPartnerDetailsPage(
        partner, ComfortPageOriginEnum.coupon);
    await pumpPage(
      tester,
      // ignore: prefer_const_constructors
      ComfortPartnerPage(),
      arguments: ComfortPartnerPageArgs(
        comfortPartnersController: controller,
        reference: 'R1',
        unit: '101',
        appOriginEnum: origin,
        applicationContainer: harness.container,
      ),
      observer: observer,
      surface: surface,
    );
    return controller;
  }

  /// Exercita o ciclo de vida e o link da LGPD com o diálogo do cupom aberto.
  Future<void> exerciseDialog(
      WidgetTester tester, ComfortPartnersController controller) async {
    expect(find.byType(CouponRequestDialog), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(controller.comfortRedirectDialogAnalyticsTimer, isNull);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortRedirectDialogAnalyticsTimer, isNotNull);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();
    expect(controller.comfortRedirectDialogAnalyticsTimer, isNull);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('comfort_get_coupon_lgpd_one',
        findRichText: true));
    await tester.pumpAndSettle();
    expect(fakeAnalytics.eventNames, contains('comodidades_lgpd_acessar'));
    expect(harness.launcher.launched.last, contains('lgpd'));
  }

  Future<void> acceptCouponDialog(WidgetTester tester, String buttonKey) async {
    expect(find.byType(CouponRequestDialog), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(CouponRequestDialog),
      matching: find.text(buttonKey),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os detalhes do parceiro com CTA de cupom',
      (tester) async {
    harness.mockCoupons('P1', [couponJson('C1'), couponJson('C2')]);
    final partner = buildPartner('P1', title: 'Alfa');

    final controller = await pumpPartner(tester, partner);

    expect(find.text('comfort'), findsOneWidget);
    expect(find.byType(PartnerIntroWidget), findsOneWidget);
    expect(find.text('Alfa'), findsOneWidget);
    expect(find.text('comfort_cleaning'), findsOneWidget);
    expect(find.byType(PartnerGeneralRatingWidget), findsOneWidget);
    expect(find.text('www.parceiro.com/loja'), findsOneWidget);
    expect(find.text('@parceiro'), findsOneWidget);
    expect(find.text('contato@parceiro.com'), findsOneWidget);
    expect(find.byType(HtmlWidget), findsOneWidget);
    expect(find.byType(PartnerCouponsListView), findsOneWidget);
    expect(find.byType(PartnerCouponCard), findsNWidgets(2));
    expect(find.text('CUPOM C1'), findsOneWidget);
    expect(harness.requestedPaths,
        ['/condominiums/C1/comfort/v2/Coupons/P1']);
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);

    await expectLater(
      find.byType(ComfortPartnerPage),
      matchesGoldenFile('goldens/comfort_partner_page.png'),
    );
  });

  testWidgets('parceiro sem avaliações suficientes e sem contatos',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1',
        ratingsNumber: 3, site: '', instagramLink: '', email: '');

    await pumpPartner(tester, partner);

    expect(find.byType(PartnerGeneralRatingWidget), findsNothing);
    expect(find.byType(SvgPicture), findsWidgets);
    expect(find.text('@parceiro'), findsNothing);
    expect(find.byType(PartnerNoCouponWidget), findsOneWidget);
    // Sem site não há botão para a página do parceiro.
    expect(find.text('comfort_go_to_partner_page'), findsNothing);
  });

  testWidgets('links de site, instagram e e-mail abrem o launcher',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1', site: 'http://www.parceiro.com/loja');

    await pumpPartner(tester, partner);

    await tester.tap(find.text('www.parceiro.com/loja'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('@parceiro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('contato@parceiro.com'));
    await tester.pumpAndSettle();

    expect(harness.launcher.launched, [
      'https://www.parceiro.com/loja',
      'https://instagram.com/parceiro',
      'mailto:contato@parceiro.com',
    ]);
  });

  testWidgets('tocar nas avaliações abre a página de avaliações',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');

    await pumpPartner(tester, partner);
    await tester.tap(find.text('comfort_ratings'));
    await tester.pumpAndSettle();

    expect(findRoute(SharedApplicationRoute.comfortPartnerReviews),
        findsOneWidget);
    expect(observer.pushed.last.settings.arguments,
        isA<ComfortPartnerReviewsPageArgs>());
  });

  testWidgets('estados dos cupons: carregando e vazio', (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');

    final controller = await pumpPartner(tester, partner);
    await emitState(tester, controller.comfortPartnerCouponsBloc,
        const LoadingCouponsState(),
        settle: false);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await emitState(tester, controller.comfortPartnerCouponsBloc,
        const EmptyCouponsState());
    expect(find.byType(PartnerCouponsListView), findsNothing);
    expect(find.byType(PartnerNoCouponWidget), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  /// Defeito: o erro dos cupons é renderizado com `ErrorMessageWidget`
  /// (Column + Expanded) dentro do `SingleChildScrollView` da página, o que
  /// quebra o layout ("RenderFlex children have non-zero flex but incoming
  /// height constraints are unbounded").
  testWidgets('erro dos cupons quebra o layout da página', (tester) async {
    harness.http.failAll();
    final partner = buildPartner('P1');
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      final controller = harness.controller();
      controller.allPartnersList = [partner];
      await controller.goToPartnerDetailsPage(
          partner, ComfortPageOriginEnum.coupon);
      await pumpPage(
        tester,
        const ComfortPartnerPage(),
        arguments: ComfortPartnerPageArgs(
          comfortPartnersController: controller,
          reference: 'R1',
          unit: '101',
          appOriginEnum: AppOriginEnum.owner,
          applicationContainer: harness.container,
        ),
        settle: false,
      );
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(controller.comfortPartnerCouponsBloc.state,
          isA<CouponsErrorState>());
      expect(find.byType(ErrorMessageWidget), findsOneWidget);
      expect(find.text('comfort_get_partner_coupons_error'), findsOneWidget);
      expect(
        errors.map((e) => e.exceptionAsString()),
        anyElement(contains('non-zero flex')),
      );
      await tester.pumpWidget(const SizedBox());
    } finally {
      FlutterError.onError = previous;
    }
  });

  testWidgets('sem cupons o botão da página do parceiro abre o diálogo',
      (tester) async {
    harness.mockCoupons('P1', []);
    harness.mockCouponRequest(couponRequestJson());
    final partner = buildPartner('P1');

    final controller = await pumpPartner(tester, partner);
    await tester.tap(find.text('comfort_go_to_partner_page'));
    await tester.pumpAndSettle();

    expect(find.byType(CouponRequestDialog), findsOneWidget);
    expect(controller.comfortRedirectDialogAnalyticsTimer, isNotNull);
    expect(controller.comfortPartnerAnalyticsTimer, isNull);
    await exerciseDialog(tester, controller);

    await acceptCouponDialog(tester, 'comfort_get_coupon_description_go');

    expect(find.byType(CouponRequestDialog), findsNothing);
    expect(harness.launcher.launched.last,
        'https://www.parceiro.com/promo?cupom=ABC');
    expect(harness.launcher.headers.last, {'x-token': 't1'});
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);
    expect(controller.comfortRedirectDialogAnalyticsTimer, isNull);
    expect(fakeAnalytics.eventNames, contains('comodidades_cta_fechar_card'));
  });

  testWidgets('cupom da lista abre o diálogo e ativa o cupom', (tester) async {
    harness.mockCoupons('P1', [couponJson('C1', reusable: false)]);
    harness.mockCouponRequest(couponRequestJson());
    final partner = buildPartner('P1');

    final controller = await pumpPartner(tester, partner);
    await tester.tap(find.byType(PartnerCouponCard));
    await tester.pumpAndSettle();

    expect(find.byType(CouponRequestDialog), findsOneWidget);
    expect(find.text('comfort_get_coupon_single_use'), findsOneWidget);
    await exerciseDialog(tester, controller);

    await acceptCouponDialog(tester, 'comfort_get_coupon_description_go');

    expect(controller.comfortPartnersBloc.state,
        isA<SuccessComfortPartnerCupomState>());
    final query = harness.http.requests.last.url.queryParameters;
    expect(query['coupon_id'], 'C1');
    expect(harness.launcher.launched.last,
        'https://www.parceiro.com/promo?cupom=ABC');
    expect(fakeAnalytics.eventNames, contains('comodidades_cupom_ativar'));
    expect(fakeAnalytics.eventNames, contains('comodidades_cta_opt_in'));
    expect(fakeAnalytics.eventNames, contains('comodidades_cta_redirect'));
  });

  /// Defeito: quando a criação da solicitação falha o controller emite
  /// `LoadedComfortPartnerDetailsState(error: ...)`, mas a página só reage a
  /// `SuccessComfortPartnerCupomState`; o usuário não recebe feedback.
  testWidgets('falha ao ativar o cupom não mostra nenhuma mensagem',
      (tester) async {
    harness.mockCoupons('P1', [couponJson('C1')]);
    harness.http.on('POST', '/condominiums/C1/comfort/couponResponse',
        status: 500, body: {'message': 'erro'});
    final partner = buildPartner('P1');

    final controller = await pumpPartner(tester, partner);
    await tester.tap(find.byType(PartnerCouponCard));
    await tester.pumpAndSettle();
    await acceptCouponDialog(tester, 'comfort_get_coupon_description_go');

    final state =
        controller.comfortPartnersBloc.state as LoadedComfortPartnerDetailsState;
    expect(state.error, 'comfort_get_coupon_request_error');
    expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
    expect(find.byType(PartnerCouponsListView), findsOneWidget);
  });

  testWidgets('erro na solicitação abre a página de resultado com erro',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');

    final controller = await pumpPartner(tester, partner);
    await emitState(
      tester,
      controller.comfortPartnersBloc,
      SuccessComfortPartnerCupomState(
          selectedPartner: partner, error: 'falhou'),
    );

    expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);
    expect(find.text('comfort_request_error_title'), findsOneWidget);
    expect(find.text('comfort_request_error_subtitle'), findsOneWidget);

    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);
  });

  testWidgets('CTA de e-mail abre o diálogo e a página de e-mail enviado',
      (tester) async {
    harness.mockCouponRequest(couponRequestJson(cta: 'email', link: ''));
    final partner = buildPartner('P1', cta: 'email');

    await pumpPartner(tester, partner);
    expect(harness.http.requests, isEmpty);

    await tester.tap(find.text('comfort_request_email'));
    await tester.pumpAndSettle();
    expect(find.byType(CouponRequestDialog), findsOneWidget);
    expect(find.text('comfort_get_coupon_email_description_1'),
        findsOneWidget);
    expect(find.text('comfort_get_coupon_email_description_2'),
        findsOneWidget);

    await acceptCouponDialog(tester, 'comfort_request_email');

    expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);
    expect(find.text('comfort_request_email_sent'), findsOneWidget);
    expect(harness.launcher.launched, isEmpty);

    await tester.tap(find.text('comfort_disfavor_conclude'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
  });

  testWidgets('CTA de link abre o diálogo e redireciona', (tester) async {
    harness.mockCouponRequest(couponRequestJson(cta: 'link', params: []));
    final partner = buildPartner('P1', cta: 'link');

    final controller = await pumpPartner(tester, partner);
    await tester.tap(find.text('comfort_request_link'));
    await tester.pumpAndSettle();
    await acceptCouponDialog(tester, 'comfort_get_coupon_description_go');

    expect(controller.comfortPartnerPageAnalyticsTimer, isNotNull);
    // Sem parâmetros de query o `Uri` ainda termina com "?".
    expect(harness.launcher.launched.last, 'https://www.parceiro.com/promo?');
  });

  testWidgets('solicitação sem link abre "null" no launcher', (tester) async {
    harness.mockCouponRequest(couponRequestJson(link: '', params: []));
    final partner = buildPartner('P1', cta: 'link');

    await pumpPartner(tester, partner);
    await tester.tap(find.text('comfort_request_link'));
    await tester.pumpAndSettle();
    await acceptCouponDialog(tester, 'comfort_get_coupon_description_go');

    /// Defeito: `urlAndQueries` nulo vira a string "null" no `openUrl`.
    expect(harness.launcher.launched.last, 'null');
  });

  group('diálogo de avaliação da compra', () {
    Future<ComfortPartnersController> openReviewDialog(
      WidgetTester tester, {
      AppOriginEnum origin = AppOriginEnum.owner,
    }) async {
      harness.mockCoupons('P1', []);
      final partner = buildPartner('P1', title: 'Alfa');
      final controller = await pumpPartner(tester, partner, origin: origin);
      await emitState(
        tester,
        controller.comfortPartnersBloc,
        SuccessComfortPartnerCupomState(
            selectedPartner: partner, requestPurchase: buildPurchase()),
      );
      expect(find.byType(ReviewRequestDialog), findsOneWidget);
      return controller;
    }

    for (final origin in AppOriginEnum.values) {
      testWidgets('"avaliar depois" fecha o diálogo e a página ($origin)',
          (tester) async {
        harness.mockPartners([partnerJson('P1')]);
        final controller = await openReviewDialog(tester, origin: origin);

        expect(find.text('Alfa'), findsNWidgets(2));
        expect(find.text('comfort_purchase_completed_date'), findsOneWidget);

        await tester.tap(find.text('comfort_purchase_completed_rate_after'));
        await tester.pumpAndSettle();

        expect(find.byType(ReviewRequestDialog), findsNothing);
        expect(find.byType(ComfortPartnerPage), findsNothing);
        expect(harness.requestedPaths, contains('/condominiums/C1/comfort/v2'));
        expect(controller.comfortPartnersBloc.state,
            isA<LoadedComfortPartnersState>());
        expect(fakeAnalytics.eventNames.contains(
                'comodidades_parceiro_avaliacoes_acessar'),
            origin != AppOriginEnum.manager);
      });
    }

    testWidgets('enviar avaliação navega para a página de sucesso',
        (tester) async {
      harness.mockReview();
      final controller = await openReviewDialog(tester);

      // Sem nota o botão fica desabilitado.
      await tester.tap(find.text('comfort_purchase_completed_rate'));
      await tester.pumpAndSettle();
      expect(find.byType(ReviewRequestDialog), findsOneWidget);

      await rateStars(
        tester,
        find.descendant(
          of: find.byType(ReviewRequestDialog),
          matching: find.byType(RatingBar),
        ),
        5,
      );
      await tester.enterText(find.byType(TextField), '  ótimo  ');
      await tester.tap(find.text('comfort_purchase_completed_rate'));
      await tester.pumpAndSettle();

      expect(find.byType(ReviewRequestDialog), findsNothing);
      expect(controller.comfortPartnersBloc.state,
          const SuccessReviewSentState());
      expect(harness.http.requests.last.body, contains('"comment":"ótimo"'));
      expect(findRoute(SharedApplicationRoute.comfortReviewSentSuccess),
          findsOneWidget);
      expect(observer.pushed.last.settings.arguments,
          isA<ComfortReviewSentSuccessPageArgs>());
    });

    testWidgets('o diálogo só é mostrado uma vez', (tester) async {
      final controller = await openReviewDialog(tester);
      await tester.tap(find.text('comfort_purchase_completed_rate_after'));
      await tester.pumpAndSettle();

      // Segunda emissão não reabre o diálogo.
      await emitState(
        tester,
        controller.comfortPartnersBloc,
        SuccessComfortPartnerCupomState(
            selectedPartner: controller.selectedPartner!,
            requestPurchase: buildPurchase()),
      );
      expect(find.byType(ReviewRequestDialog), findsNothing);
    });
  });

  testWidgets('estados de carregamento, erro e vazio do corpo', (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');
    final controller = await pumpPartner(tester, partner);

    await emitState(tester, controller.comfortPartnersBloc,
        const LoadingComfortPartnersState(),
        settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(
        tester,
        controller.comfortPartnersBloc,
        const ErrorComfortPartnersState(
            errorMessageKey: 'comfort_error_message',
            errorCode: null,
            errorDescription: null));
    expect(find.text('comfort_error_message'), findsOneWidget);

    await emitState(
        tester, controller.comfortPartnersBloc, const EmptyComfortPartnersState());
    expect(find.byType(PartnerIntroWidget), findsNothing);
    expect(find.byType(ErrorMessageWidget), findsNothing);
  });

  testWidgets('voltar reemite a lista de parceiros e registra analytics',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');
    final controller = await pumpPartner(tester, partner);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortPartnerPage), findsNothing);
    expect(controller.comfortPartnersBloc.state,
        isA<LoadedComfortPartnersState>());
    expect(controller.comfortPartnerAnalyticsTimer, isNull);
    expect(fakeAnalytics.eventNames, contains('comodidades_parceiro_voltar'));
  });

  testWidgets('ciclo de vida do app controla os temporizadores',
      (tester) async {
    harness.mockCoupons('P1', []);
    final partner = buildPartner('P1');
    final controller = await pumpPartner(tester, partner);
    controller.comfortPartnerPageAnalyticsTimerStart(debugEventIdentifier: 'x');
    await tester.pumpAndSettle();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortPartnerAnalyticsTimer, isNotNull);
    expect(controller.comfortPartnerPageAnalyticsTimer, isNull);

    controller.comfortPartnerPageAnalyticsTimerStart(debugEventIdentifier: 'y');
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump();
    // Sem "resumed" após "detached" os frames ficam desabilitados.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    controller.comfortCardAnalyticsStopTimer();

    // Com outra rota por cima o ciclo de vida é ignorado.
    await tester.tap(find.text('comfort_ratings'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.comfortPartnerReviews),
        findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(controller.comfortPartnerAnalyticsTimer, isNull);
  });
}
