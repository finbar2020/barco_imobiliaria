import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';

import '../../../helpers/firebase_mocks.dart';
import 'comfort_partners_test_support.dart';

/// Dá tempo aos handlers do bloc e aos `void ... async` de analytics.
Future<void> flush() async {
  for (var i = 0; i < 6; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Map<String, Object?>? lastEventParams() => fakeAnalytics.eventNames.isEmpty
    ? null
    : fakeAnalytics.events[fakeAnalytics.eventNames.last];

void main() {
  late ComfortHarness harness;

  setUp(() async {
    harness = await installComfortHarness();
  });

  group('getAllPartners', () {
    test('erro da api emite ErrorComfortPartnersState', () async {
      harness.http.failAll();
      final controller = harness.buildController();

      await controller.getAllPartners(ComfortPageOriginEnum.dashboard);
      await flush();

      final state = controller.comfortPartnersBloc.state;
      expect(state, isA<ErrorComfortPartnersState>());
      expect((state as ErrorComfortPartnersState).errorMessageKey,
          'comfort_error_message');
      expect(state.errorCode, 'UNKNOWN');
      expect(controller.lastLoadedComfortPartnersState, isNull);
    });

    test('ordena parceiros e categorias e remove "para seu condomínio"',
        () async {
      harness.mockPartners([
        partnerJson('P2', title: 'Zeta', category: 'toYourPet'),
        partnerJson('P1', title: 'Alfa', category: 'toYou'),
        partnerJson('P3', title: 'Beta', category: 'toYourCondo'),
        partnerJson('P4', title: 'Gama', category: 'toYou'),
      ]);
      final controller = harness.buildController();

      await controller.getAllPartners(ComfortPageOriginEnum.homePage);
      await flush();

      expect(controller.allPartnersList.map((p) => p.partnerIntro.title),
          ['Alfa', 'Beta', 'Gama', 'Zeta']);
      expect(controller.categories,
          [ComfortPartnerCategory.toYou, ComfortPartnerCategory.toYourPet]);
      expect(controller.getPartnersList(), controller.categories);
      expect(controller.categoriesToYourCondo, isEmpty);
      final state =
          controller.comfortPartnersBloc.state as LoadedComfortPartnersState;
      expect(state.comfortPartnerCategoryIsFilter, isTrue);
      expect(controller.getLastLoadedComfortPartnersState(), state);
      expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
      expect(lastEventParams()?['origem_acesso'], 'homePage');
      expect(lastEventParams()?['userType'], 'OWNER');
      expect(lastEventParams()?['unidade'], '101');
      expect(lastEventParams()?['referencia'], 'R1');
    });

    test('síndico monta as categorias "para seu condomínio" do remote config',
        () async {
      harness.session.toYourCondo = [
        yourCondoConfig('maintenance', title: 'Zeladoria'),
        yourCondoConfig('cleaning', title: 'Limpeza'),
        yourCondoConfig('laundry', title: 'Lavanderia'),
      ];
      harness.mockPartners([
        partnerJson('P1', category: 'toYourCondo', comfortType: 'cleaning'),
        partnerJson('P2', category: 'toYourCondo', comfortType: 'maintenance'),
        partnerJson('P3', category: 'toYou', comfortType: 'laundry'),
      ]);
      final controller =
          harness.buildController(appOriginEnum: AppOriginEnum.manager);

      await controller.getAllPartners(ComfortPageOriginEnum.hub);
      await flush();

      expect(controller.categoriesToYourCondo.map((c) => c.title),
          ['Limpeza', 'Zeladoria']);
      expect(controller.categoriesToYourCondoExpanded,
          {'cleaning': false, 'maintenance': false});
      expect(controller.categories.first, ComfortPartnerCategory.toYourCondo);
      expect(controller.categories,
          [ComfortPartnerCategory.toYourCondo, ComfortPartnerCategory.toYou]);
      expect(controller.getLastLoadedComfortPartnersState().categoriesToYourCondo,
          controller.categoriesToYourCondo);
    });

    test('síndico sem remote config não adiciona "para seu condomínio"',
        () async {
      harness.mockPartners([
        partnerJson('P1', category: 'toYourCondo', comfortType: 'cleaning'),
      ]);
      final controller =
          harness.buildController(appOriginEnum: AppOriginEnum.manager);

      await controller.getAllPartners(ComfortPageOriginEnum.hub);
      await flush();

      expect(controller.categories, isEmpty);
      expect(controller.categoriesToYourCondo, isEmpty);
    });
  });

  group('getPartnerCoupons', () {
    test('sem parceiro selecionado emite erro', () async {
      final controller = harness.buildController();
      await controller.getPartnerCoupons();
      await flush();
      final state =
          controller.comfortPartnerCouponsBloc.state as CouponsErrorState;
      expect(state.errorMessageKey, 'comfort_go_to_partner_page_error');
      expect(state.errorDescription, 'Nenhum parceiro selecionado');
      expect(harness.http.requests, isEmpty);
    });

    test('carrega os cupons do parceiro selecionado', () async {
      final partner = buildPartner('P1');
      harness.mockCoupons('P1', [couponJson('C1'), couponJson('C2')]);
      final controller = harness.buildController(selectedPartner: partner);
      final states = <ComfortPartnerCouponsState>[];
      final sub = controller.comfortPartnerCouponsBloc.stream.listen(states.add);

      await controller.getPartnerCoupons();
      await flush();
      await sub.cancel();

      expect(states.first, const LoadingCouponsState());
      expect(states.last, isA<LoadedCouponsState>());
      expect(controller.coupons.map((c) => c.id), ['C1', 'C2']);
      expect(controller.coupons.first.imageLink,
          '/condominiums/C1/comfort/coupon/C1/image/chash');
    });

    test('falha da api emite erro com código', () async {
      harness.http.failAll(status: 404);
      final controller =
          harness.buildController(selectedPartner: buildPartner('P1'));

      await controller.getPartnerCoupons();
      await flush();

      final state =
          controller.comfortPartnerCouponsBloc.state as CouponsErrorState;
      expect(state.errorMessageKey, 'comfort_get_partner_coupons_error');
      expect(state.errorCode, 'UNKNOWN');
    });
  });

  group('getTopCouponsList e partnersList', () {
    test('devolve só os cupons em destaque ordenados por desconto', () {
      final controller = harness.buildController();
      expect(controller.getTopCouponsList(), isEmpty);
      controller.coupons = [
        buildCoupon('C1', discount: 10, highlight: true),
        buildCoupon('C2', discount: 50, highlight: false),
        buildCoupon('C3', discount: 30, highlight: true),
      ];
      expect(controller.getTopCouponsList().map((c) => c!.id), ['C3', 'C1']);
      controller.coupons = [buildCoupon('C2', highlight: false)];
      expect(controller.getTopCouponsList(), isEmpty);
    });

    test('filtra por categoria e encontra parceiro por id', () {
      final controller = harness.buildController(allPartnersList: [
        buildPartner('P1', category: 'toYou'),
        buildPartner('P2', category: 'toYourPet'),
      ]);
      expect(controller.partnersList(), hasLength(2));
      expect(
          controller
              .partnersList(category: ComfortPartnerCategory.toYourPet)
              .single
              .id,
          'P2');
      expect(controller.findPartner('P1')?.id, 'P1');
      expect(controller.findPartner('X'), isNull);
    });
  });

  group('findRequestPurchase', () {
    test('requestId nulo não faz nada', () async {
      final controller = harness.buildController();
      await controller.findRequestPurchase(null);
      expect(harness.http.requests, isEmpty);
      expect(controller.comfortPartnersBloc.state,
          const EmptyComfortPartnersState());
    });

    test('sem parceiro selecionado emite erro após consultar', () async {
      harness.mockPurchase('REQ1', purchaseJson());
      final controller = harness.buildController();
      await controller.findRequestPurchase('REQ1');
      await flush();
      expect(
          (controller.comfortPartnersBloc.state as ErrorComfortPartnersState)
              .errorMessageKey,
          'comfort_go_to_partner_page_error');
    });

    test('falha da api volta aos detalhes sem compra', () async {
      harness.http.failAll();
      final controller =
          harness.buildController(selectedPartner: buildPartner('P1'));
      await controller.findRequestPurchase('REQ1');
      await flush();
      final state = controller.comfortPartnersBloc.state
          as LoadedComfortPartnerDetailsState;
      expect(state.requestPurchase, isNull);
      expect(state.selectedPartner.id, 'P1');
    });

    test('compra concluída registra analytics e devolve a compra', () async {
      harness.mockPurchase('REQ1', purchaseJson(purchaseDone: true));
      final controller =
          harness.buildController(selectedPartner: buildPartner('P1'));
      await controller.findRequestPurchase('REQ1');
      await flush();
      final state = controller.comfortPartnersBloc.state
          as LoadedComfortPartnerDetailsState;
      expect(state.requestPurchase?.purchaseDone, isTrue);
      expect(lastEventParams()?['nome_parceiro'], 'Parceiro P1');
      expect(lastEventParams()?['nome_condominio'], 'Condomínio Teste');
      expect(lastEventParams()?['endereco_condominio'], 'Rua Um, 10');
    });

    test('compra não concluída não registra analytics', () async {
      harness.mockPurchase('REQ1', purchaseJson(purchaseDone: false));
      final controller =
          harness.buildController(selectedPartner: buildPartner('P1'));
      await controller.findRequestPurchase('REQ1');
      await flush();
      expect(fakeAnalytics.eventNames, isEmpty);
      expect(
          (controller.comfortPartnersBloc.state
                  as LoadedComfortPartnerDetailsState)
              .requestPurchase
              ?.purchaseDone,
          isFalse);
    });
  });

  group('changePartnerFavoriteStatus', () {
    test('sem parceiro selecionado emite erro', () async {
      harness.mockFavorite('P1', isFavorite: true);
      final controller = harness.buildController();
      await controller.changePartnerFavoriteStatus('P1', 'Nome', true);
      await flush();
      expect(controller.comfortPartnersBloc.state,
          isA<ErrorComfortPartnersState>());
    });

    test('falha da api mantém os detalhes com mensagem de erro', () async {
      harness.http.failAll();
      final partner = buildPartner('P1');
      final controller = harness.buildController(
          selectedPartner: partner, allPartnersList: [partner]);
      await controller.changePartnerFavoriteStatus('P1', 'Nome', true);
      await flush();
      final state = controller.comfortPartnersBloc.state
          as LoadedComfortPartnerDetailsState;
      expect(state.error, 'comfort_change_partner_favorite_status_error');
    });

    test('sucesso atualiza o parceiro selecionado e a lista', () async {
      harness.mockFavorite('P1', isFavorite: true);
      final partner = buildPartner('P1');
      final controller = harness.buildController(
          selectedPartner: partner, allPartnersList: [partner]);
      await controller.changePartnerFavoriteStatus('P1', 'Nome', true);
      await flush();
      expect(controller.selectedPartner!.partnerIntro.favorite, isTrue);
      expect(controller.allPartnersList.single.partnerIntro.favorite, isTrue);
      expect(harness.http.requests.single.url.queryParameters['is_favorite'],
          'true');
      expect(controller.comfortPartnersBloc.state,
          isA<LoadedComfortPartnerDetailsState>());
      expect(lastEventParams()?['id_parceiro'], 'np_P1');
    });
  });

  group('disfavorPartner', () {
    test('falha devolve a lista com mensagem para o flushbar', () async {
      harness.http.failAll();
      final partner = buildPartner('P1', favorite: true);
      final controller = harness.buildController(allPartnersList: [partner]);
      await controller.disfavorPartner(partner);
      await flush();
      expect(controller.comfortPartnersBloc.state,
          isA<LoadedComfortPartnersState>());
      expect(partner.partnerIntro.favorite, isTrue);
    });

    test('sucesso emite SuccessComfortPartnersState', () async {
      harness.mockFavorite('P1', isFavorite: false);
      final partner = buildPartner('P1', favorite: true);
      final controller = harness.buildController(allPartnersList: [partner]);
      await controller.disfavorPartner(partner);
      await flush();
      final state = controller.comfortPartnersBloc.state
          as SuccessComfortPartnersState;
      expect(state.selectedPartner.id, 'P1');
      expect(partner.partnerIntro.favorite, isFalse);
      expect(harness.http.requests.single.url.queryParameters['is_favorite'],
          'false');
    });
  });

  group('createCouponRequest', () {
    test('sucesso emite SuccessComfortPartnerCupomState com a solicitação',
        () async {
      harness.mockCouponRequest(couponRequestJson());
      final partner = buildPartner('P1');
      final controller = harness.buildController();
      await controller.createCouponRequest(partner,
          coupon: buildCoupon('C1'));
      await flush();
      final state = controller.comfortPartnersBloc.state
          as SuccessComfortPartnerCupomState;
      expect(state.couponRequest?.idRequest, 'REQ1');
      expect(state.couponRequest?.urlAndQueries.toString(),
          'https://www.parceiro.com/promo?cupom=ABC');
      expect(state.couponRequest?.headers, {'x-token': 't1'});
      final query = harness.http.requests.single.url.queryParameters;
      expect(query['partner_id'], 'P1');
      expect(query['coupon_id'], 'C1');
      expect(query['unit_id'], 'U1');
      expect(lastEventParams()?['email'], 'maria@teste.com');
    });

    test('falha emite os detalhes com erro da solicitação', () async {
      harness.http.failAll();
      final controller = harness.buildController();
      await controller.createCouponRequest(buildPartner('P1'));
      await flush();
      final state = controller.comfortPartnersBloc.state
          as LoadedComfortPartnerDetailsState;
      expect(state.error, 'comfort_get_coupon_request_error');
      expect(state, isNot(isA<SuccessComfortPartnerCupomState>()));
    });

    test('sessão sem unidade envia unit_id vazio', () async {
      harness.mockCouponRequest(couponRequestJson());
      final controller = harness.buildController();
      harness.session.state =
          FakeSessionState(FakeSession(withUnity: false));
      await controller.createCouponRequest(buildPartner('P1'));
      await flush();
      // O chopper omite parâmetros de query vazios.
      expect(harness.http.requests.single.url.queryParameters['unit_id'],
          anyOf(isNull, ''));
      expect(harness.http.requests.single.url.queryParameters['coupon_id'],
          isNull);
    });
  });

  group('reviewRequest', () {
    test('falha emite erro de avaliação', () async {
      harness.http.failAll();
      final controller = harness.buildController();
      await controller.reviewRequest(requestId: 'REQ1', rate: 4, comment: 'c');
      await flush();
      expect(
          (controller.comfortPartnersBloc.state as ErrorComfortPartnersState)
              .errorMessageKey,
          'comfort_send_review_request_error');
    });

    for (final origin in AppOriginEnum.values) {
      test('sucesso para $origin emite SuccessReviewSentState', () async {
        harness.mockReview();
        final controller = harness.buildController(appOriginEnum: origin);
        await controller.reviewRequest(requestId: 'REQ1', rate: 5);
        await flush();
        expect(controller.comfortPartnersBloc.state,
            const SuccessReviewSentState());
        expect(fakeAnalytics.eventNames, hasLength(1));
        expect(lastEventParams()?['referencia'], 'R1');
        expect(harness.http.requests.single.body, contains('"rating":5.0'));
      });
    }
  });

  group('requestPartners', () {
    test('sem use case não faz nada', () async {
      final controller = harness.buildController(withRequestPartners: false);
      await controller.requestPartners(RequestPartnersEntity(email: 'a@b'));
      expect(harness.http.requests, isEmpty);
    });

    test('sucesso marca isSuccessYourCondoPartners', () async {
      harness.mockPartners([partnerJson('P1')]);
      harness.mockRequestPartners();
      final controller = harness.buildController();
      await controller.getAllPartners(ComfortPageOriginEnum.hub);
      await flush();
      await controller.requestPartners(
          RequestPartnersEntity(email: 'a@b', partners: ['P1']));
      await flush();
      final state =
          controller.comfortPartnersBloc.state as LoadedComfortPartnersState;
      expect(state.isSuccessYourCondoPartners, isTrue);
      expect(state.isFailedCondoPartners, isFalse);
    });

    test('falha marca isFailedCondoPartners', () async {
      harness.mockPartners([partnerJson('P1')]);
      harness.mockRequestPartners(status: 500);
      final controller = harness.buildController();
      await controller.getAllPartners(ComfortPageOriginEnum.hub);
      await flush();
      await controller.requestPartners(RequestPartnersEntity(email: 'a@b'));
      await flush();
      final state =
          controller.comfortPartnersBloc.state as LoadedComfortPartnersState;
      expect(state.isFailedCondoPartners, isTrue);
    });
  });

  group('navegação de estados', () {
    test('goToPartnerDetailsPage seleciona o parceiro e registra analytics',
        () async {
      final partner = buildPartner('P1');
      final controller = harness.buildController();
      await controller.goToPartnerDetailsPage(
          partner, ComfortPageOriginEnum.banner, true, false);
      await flush();
      expect(controller.selectedPartner, partner);
      expect(controller.comfortPartnersBloc.state,
          LoadedComfortPartnerDetailsState(selectedPartner: partner));
      expect(lastEventParams()?['origem_acesso'], 'banner');
      expect(lastEventParams()?['category'], 'toYou');
    });

    test('backToLoadedComfortPartnersState recarrega quando a lista está vazia',
        () async {
      harness.mockPartners([partnerJson('P1')]);
      final controller = harness.buildController();
      await controller.backToLoadedComfortPartnersState(
          ComfortPageOriginEnum.myFavoritesPage);
      await flush();
      expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
      expect(controller.allPartnersList, hasLength(1));
    });

    test('backToLoadedComfortPartnersState reemite a lista com foco',
        () async {
      final partner = buildPartner('P1');
      final controller = harness.buildController(
          allPartnersList: [partner], selectedPartner: partner);
      await controller.backToLoadedComfortPartnersState(
          ComfortPageOriginEnum.disfavorSuccessPage);
      await flush();
      final state =
          controller.comfortPartnersBloc.state as LoadedComfortPartnersState;
      expect(state.partnerFocus, partner);
      expect(harness.http.requests, isEmpty);
    });

    test('changeCategory guarda a categoria atual', () {
      final controller = harness.buildController();
      expect(controller.currentCategory, isNull);
      controller.changeCategory(ComfortPartnerCategory.toYourPet);
      expect(controller.currentCategory, ComfortPartnerCategory.toYourPet);
      expect(controller.getSessionBloc(), harness.session);
    });
  });

  group('getters de sessão', () {
    test('morador', () {
      final controller =
          harness.buildController(appOriginEnum: AppOriginEnum.owner);
      expect(controller.getCondoReference, 'R1');
      expect(controller.getUnityId, '101');
      expect(controller.getCondoName, 'Condomínio Teste');
      expect(controller.getCondoAddress, 'Rua Um, 10');
      expect(controller.getUserName, 'Maria');
      expect(controller.getUserEmail, 'maria@teste.com');
    });

    test('colaborador', () {
      final controller =
          harness.buildController(appOriginEnum: AppOriginEnum.employee);
      expect(controller.getCondoReference, 'R1');
      expect(controller.getUnityId, '');
      expect(controller.getCondoName, 'Condomínio Teste');
      expect(controller.getCondoAddress, '');
    });

    test('síndico usa o condomínio selecionado', () {
      final session = FakeSessionBloc(
        session: FakeSession(
          selectedCondominium: FakeCondominium(
              id: 'C9', reference: 'R9', name: 'Sel', address: 'Av 9'),
        ),
      );
      final controller = ComfortHarnessSession(harness, session)
          .buildController(AppOriginEnum.manager);
      expect(controller.getCondoReference, 'R9');
      expect(controller.getUnityId, '');
      expect(controller.getCondoName, 'Sel');
      expect(controller.getCondoAddress, 'Av 9');
    });

    test('sessão vazia devolve strings vazias', () {
      final session = emptySessionBloc();
      for (final origin in AppOriginEnum.values) {
        final controller =
            ComfortHarnessSession(harness, session).buildController(origin);
        expect(controller.getCondoReference, '');
        expect(controller.getUnityId, '');
        expect(controller.getCondoName, '');
        expect(controller.getCondoAddress, '');
        expect(controller.getUserName, '');
        expect(controller.getUserEmail, '');
      }
    });

    test('getUserType vem do token (ou vazio sem token)', () async {
      final controller = harness.buildController();
      expect(await controller.getUserType, 'OWNER');
      harness.getToken.nullToken = true;
      expect(await controller.getUserType, '');
      harness.getToken.nullToken = false;
      harness.getToken.fail = true;
      expect(await controller.getUserType, '');
    });
  });

  group('analytics por origem', () {
    for (final origin in AppOriginEnum.values) {
      test('eventos de clique para $origin', () async {
        final partner = buildPartner('P1');
        final coupon = buildCoupon('C1');
        final controller = harness.buildController(
            appOriginEnum: origin, selectedPartner: partner);

        controller.analyticsPartnerPageBack();
        controller.analyticsComfortCategoryPageBack(
            ComfortPartnerCategory.toYourHome);
        controller.analyticsComfortPageBack();
        controller.analyticsCtaOptIn(partner, coupon);
        controller.analyticsCtaRedirectButton(partner, null);
        controller.analyticsCtaCardDismissed(partner, coupon);
        controller.analyticsLgpdAcessar(partner, coupon);
        controller.analyticsClickCta(partner, coupon);
        controller.analyticsPurchased(null);
        controller.analyticsChangeFavorite(null);
        controller.analyticsEnableCoupon(partner);
        controller.analyticsPartnerAccessed(
            null, ComfortPageOriginEnum.pushNotification);
        controller.analyticsComfortAccessed(ComfortPageOriginEnum.coupon);
        controller.analyticsSubcategorieAccessed(
            subcategories: 'a,b', category: ComfortPartnerCategory.others);
        controller.analyticsRequestButton();
        await flush();

        expect(fakeAnalytics.eventNames, hasLength(15));
        expect(fakeAnalytics.events.values.every((p) => p != null), isTrue);
      });

      test('temporizadores para $origin', () async {
        final controller = harness.buildController(
            appOriginEnum: origin, selectedPartner: buildPartner('P1'));

        controller.comfortRedirectDialogAnalyticsTimerStart(
            debugEventIdentifier: 'a');
        controller.comfortCardAnalyticsTimerStart(debugEventIdentifier: 'b');
        controller.comfortPartnerPageAnalyticsTimerStart(
            debugEventIdentifier: 'c');
        controller.comfortCategoryAnalyticsTimerStart(
            ComfortPartnerCategory.toYou,
            debugEventIdentifier: 'd');
        controller.comfortHomeAnalyticsTimerStart(debugEventIdentifier: 'e');
        await flush();

        expect(controller.comfortRedirectDialogAnalyticsTimer, isNotNull);
        expect(controller.comfortPartnerAnalyticsTimer, isNotNull);
        expect(controller.comfortPartnerPageAnalyticsTimer, isNotNull);
        expect(controller.comfortHomeAnalyticsTimer, isNotNull);
        expect(
            controller.comfortPartnerAnalyticsTimer!.otherParameters['category'],
            'toYou');

        controller.comfortRedirectDialogAnalyticsStopTimer();
        controller.comfortCardAnalyticsStopTimer();
        controller.comfortPartnerPageAnalyticsStopTimer();
        controller.comfortCategoryAnalyticsStopTimer();
        controller.comfortHomeAnalyticsStopTimer();

        expect(controller.comfortRedirectDialogAnalyticsTimer, isNull);
        expect(controller.comfortPartnerAnalyticsTimer, isNull);
        expect(controller.comfortPartnerPageAnalyticsTimer, isNull);
        expect(controller.comfortHomeAnalyticsTimer, isNull);
        // Parar de novo sem timer é inofensivo.
        controller.comfortCategoryAnalyticsStopTimer();
      });
    }
  });
}

/// Constrói controllers com outra sessão reaproveitando o `FakeHttp` do
/// harness.
class ComfortHarnessSession {
  ComfortHarnessSession(this.harness, this.session);
  final ComfortHarness harness;
  final FakeSessionBloc session;

  ComfortPartnersController buildController(AppOriginEnum origin) {
    final base = harness.buildController(appOriginEnum: origin);
    return ComfortPartnersController(
      comfortPartnersBloc: base.comfortPartnersBloc,
      comfortPartnerCouponsBloc: base.comfortPartnerCouponsBloc,
      getPartnerCouponsUseCase: base.getPartnerCouponsUseCase,
      getAllPartnersUseCase: base.getAllPartnersUseCase,
      getPartnerIsFavoriteUseCase: base.getPartnerIsFavoriteUseCase,
      changePartnerFavoriteStatusUseCase:
          base.changePartnerFavoriteStatusUseCase,
      createCouponRequestUseCase: base.createCouponRequestUseCase,
      findRequestPurchaseUseCase: base.findRequestPurchaseUseCase,
      postRateRequestUseCase: base.postRateRequestUseCase,
      sessionBloc: session,
      appOriginEnum: origin,
      getToken: harness.getToken,
    );
  }
}
