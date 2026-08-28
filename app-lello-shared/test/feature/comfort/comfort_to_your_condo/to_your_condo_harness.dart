// Harness da área "Para seu condomínio": controller REAL de parceiros ligado
// a blocs, use cases, repositório e data source reais sobre um HTTP falso.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/repository/comfort_repository_impl.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request_impl.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_contact_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import '../comfort_core_fixtures.dart';

/// Sem cabeçalho de autenticação: `CustomCachedNetworkImage` cai no
/// placeholder SVG em vez de buscar a imagem na rede.
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

/// Rota base usada para empilhar a página sob teste e poder voltar.
const baseRouteName = pageRouteName;
const condoRouteName = '/to-your-condo';
const contactRouteName = '/to-your-condo-contact';
const onboardingRouteName = '/to-your-condo-onboarding';

class ToYourCondoHarness {
  ToYourCondoHarness._({
    required this.http,
    required this.container,
    required this.session,
    required this.controller,
    required this.origin,
  });

  final FakeHttp http;
  final TestSharedContainer container;
  final FakeSessionBloc session;
  final ComfortPartnersController controller;
  final AppOriginEnum origin;

  ComfortPartnersBloc get bloc => controller.comfortPartnersBloc;

  /// Deve ser chamado DENTRO do `testWidgets` (os blocs precisam nascer na
  /// zona do teste).
  static ToYourCondoHarness create({
    AppOriginEnum origin = AppOriginEnum.manager,
    FakeSession? session,
    List<ComfortYourCondoRemoteConfig>? categories,
  }) {
    final http = FakeHttp();
    final ComfortRepository repository = ComfortRepositoryImpl(
      remoteDataSource: ComfortRemoteDataSourceImpl(
          api: ComfortApi.create(buildChopperClient(http))),
    );
    final sessionBloc = FakeSessionBloc(
      session: session,
      comfortToYourCondo: categories ?? defaultCategories(),
    );
    final controller = ComfortPartnersController(
      comfortPartnersBloc: ComfortPartnersBloc(),
      comfortPartnerCouponsBloc: ComfortPartnerCouponsBloc(),
      getPartnerCouponsUseCase: GetPartnerCouponsUseCaseImpl(repository: repository),
      getAllPartnersUseCase: GetAllPartnersUseCaseImpl(repository: repository),
      getPartnerIsFavoriteUseCase:
          GetPartnerIsFavoriteUseCaseImpl(repository: repository),
      changePartnerFavoriteStatusUseCase:
          ChangePartnerFavoriteStatusUseCaseImpl(repository: repository),
      createCouponRequestUseCase:
          CreateCouponRequestUseCaseImpl(repository: repository),
      findRequestPurchaseUseCase:
          FindRequestPurchaseUseCaseImpl(repository: repository),
      postRateRequestUseCase: SendReviewRequestUseCaseImpl(repository: repository),
      sessionBloc: sessionBloc,
      appOriginEnum: origin,
      getToken: FakeGetToken(),
      requestPartnersUseCase: RequestPartnersUseCaseImpl(repository: repository),
    );
    final container = TestSharedContainer()
      ..register<AuthenticationStore>(FakeAuthenticationStore())
      ..register<Validator>(ValidatorImpl());
    return ToYourCondoHarness._(
      http: http,
      container: container,
      session: sessionBloc,
      controller: controller,
      origin: origin,
    );
  }

  static List<ComfortYourCondoRemoteConfig> defaultCategories() => [
        buildRemoteCategory(type: 'maintenance', title: 'Manutenção'),
        buildRemoteCategory(type: 'cleaning', title: 'Limpeza'),
        buildRemoteCategory(type: 'laundry', title: 'Lavanderia'),
      ];

  /// Parceiros padrão: três de limpeza e um de manutenção "para seu
  /// condomínio" e um de limpeza de outra categoria (não deve aparecer).
  static List<Map<String, dynamic>> defaultPartners() => [
        partnerJson(id: 'p1', title: 'Limpa Tudo'),
        partnerJson(id: 'p2', title: 'Brilho Fácil'),
        partnerJson(id: 'p3', title: 'Clean Condo'),
        partnerJson(id: 'p4', title: 'Conserta Já', comfortType: 'maintenance'),
        partnerJson(id: 'p5', title: 'Faxina Casa', category: 'toYou'),
      ];

  /// Fluxo real: cadastra a resposta e pede os parceiros ao controller.
  Future<void> loadPartners([List<Map<String, dynamic>>? partners]) async {
    http.on('GET', '/condominiums/C1/comfort/v2',
        body: partners ?? defaultPartners());
    await controller.getAllPartners(ComfortPageOriginEnum.toYourCondoPage);
  }

  ToYourCondoPage condoPage({Key? key}) => ToYourCondoPage(
        key: key,
        comfortPartnersController: controller,
        appContainer: container,
        appOriginEnum: origin,
        reference: 'R1',
        unit: '101',
      );

  ComfortToYourCondoContactPage contactPage(
          {List<String> partners = const ['p1', 'p4']}) =>
      ComfortToYourCondoContactPage(
        comfortPartnersController: controller,
        partners: partners,
        appContainer: container,
      );

  ComfortToYourCondoOnboarding onboarding({bool fromIcon = false}) =>
      ComfortToYourCondoOnboarding(
        comfortPartnersController: controller,
        fromIcon: fromIcon,
        appContainer: container,
        appOriginEnum: origin,
        reference: 'R1',
        unit: '101',
      );

  Future<void> dispose() async {
    await controller.comfortPartnersBloc.close();
    await controller.comfortPartnerCouponsBloc.close();
    await container.reset();
  }
}

/// Página base (rota inicial) sobre a qual as páginas sob teste são
/// empilhadas, para que tenham botão de voltar e `Navigator.pop` funcione.
Widget basePage() => const Scaffold(
      key: Key('base-page'),
      body: Center(child: Text('base')),
    );

/// Empilha a rota [name] por cima da página base e aguarda a transição.
Future<void> pushRoute(WidgetTester tester, String name,
    {Object? arguments, bool settle = true}) async {
  tester
      .state<NavigatorState>(find.byType(Navigator))
      .pushNamed(name, arguments: arguments);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await pumpFrames(tester);
  }
}

/// Avança alguns frames (600 ms) em vez de `pumpAndSettle`: o `LoadingWidget`
/// da página anima para sempre, então nem toda tela "assenta".
Future<void> pumpFrames(WidgetTester tester, {int frames = 6}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Finder findBasePage() => find.byKey(const Key('base-page'));
