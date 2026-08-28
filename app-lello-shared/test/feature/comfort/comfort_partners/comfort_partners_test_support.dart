// Apoio compartilhado pelos testes de `presentation/comfort_partners`:
// sessão falsa (o controller recebe `dynamic sessionBloc`), token falso,
// container de teste com as classes REAIS de dados ligadas ao `FakeHttp`
// e construtores de JSON/entidades dos parceiros e cupons.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_coupon_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_model.dart';
import 'package:shared_features/feature/comfort/data/repository/comfort_repository_impl.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request_param.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
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
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/test_container.dart';

/// Id do condomínio usado nas rotas da API (`/condominiums/C1/comfort/...`).
const condoId = 'C1';

/// Canal do fallback nativo do `UrlLauncherNative`.
const nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

// ---------------------------------------------------------------------------
// Sessão falsa (acessada dinamicamente pelo controller/páginas)
// ---------------------------------------------------------------------------

class FakeCondominium {
  FakeCondominium({
    this.id = condoId,
    this.reference = 'R1',
    this.name = 'Condomínio Teste',
    this.address = 'Rua Um, 10',
  });
  final String id;
  final String reference;
  final String name;
  final String address;
}

class FakeUnity {
  FakeUnity({this.id = 'U1', this.title = '101'});
  final String id;
  final String title;
}

class FakeMe {
  FakeMe({
    this.id = 'ME1',
    this.name = 'Maria',
    this.email = 'maria@teste.com',
    this.nameFormatted = 'Maria S.',
  });
  final String id;
  final String name;
  final String email;
  final String nameFormatted;
}

class FakeSession {
  FakeSession({
    FakeCondominium? condominium,
    FakeCondominium? selectedCondominium,
    FakeUnity? unity,
    FakeMe? me,
    this.withCondominium = true,
    this.withUnity = true,
    this.withMe = true,
  })  : _condominium = condominium ?? FakeCondominium(),
        _selectedCondominium = selectedCondominium ?? FakeCondominium(),
        _unity = unity ?? FakeUnity(),
        _me = me ?? FakeMe();

  final FakeCondominium _condominium;
  final FakeCondominium _selectedCondominium;
  final FakeUnity _unity;
  final FakeMe _me;
  final bool withCondominium;
  final bool withUnity;
  final bool withMe;

  FakeCondominium? get condominium => withCondominium ? _condominium : null;
  FakeCondominium? get selectedCondominium =>
      withCondominium ? _selectedCondominium : null;
  FakeUnity? get unity => withUnity ? _unity : null;
  FakeMe? get me => withMe ? _me : null;
}

class FakeSessionState {
  FakeSessionState(this.session);

  /// Dinâmico de propósito: permite sessões parciais (ex.: só o
  /// `selectedCondominium` do síndico).
  final dynamic session;
}

/// `sessionBloc` dinâmico: `state.session`, `checkRback`,
/// `getHortaRemoteConfig` e `getComfortToYourCondo` (síndico).
class FakeSessionBloc {
  FakeSessionBloc({
    FakeSession? session,
    this.rbacAllowed = true,
    this.toYourCondo = const [],
  }) : state = FakeSessionState(session ?? FakeSession());

  FakeSessionState state;
  bool rbacAllowed;
  List<ComfortYourCondoRemoteConfig> toYourCondo;
  final rbacChecked = <String>[];

  bool checkRback(String rbac) {
    rbacChecked.add(rbac);
    return rbacAllowed;
  }

  dynamic getHortaRemoteConfig() => null;

  List<ComfortYourCondoRemoteConfig> getComfortToYourCondo() => toYourCondo;
}

/// Sessão sem condomínio/unidade/usuário (para os `?? ""`).
FakeSessionBloc emptySessionBloc() => FakeSessionBloc(
      session: FakeSession(
        withCondominium: false,
        withUnity: false,
        withMe: false,
      ),
    );

// ---------------------------------------------------------------------------
// Fakes de infraestrutura
// ---------------------------------------------------------------------------

class FakeGetToken extends GetToken {
  FakeGetToken({this.role = 'OWNER'});
  String? role;
  bool fail = false;
  bool nullToken = false;
  int calls = 0;

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async {
    calls++;
    if (fail) return Rejection(UnknownFailure('sem token'));
    if (nullToken) return Success(null);
    return Success(AccessToken()..selectedRole = role);
  }
}

/// `CustomCachedNetworkImage` só usa `getCustomHeader()`; sem header a imagem
/// vira o placeholder SVG (evita o cache manager com IO real).
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  Map<String, String>? header;

  @override
  Map<String, String>? getCustomHeader() => header;
}

class TestEnvironment extends Environment {
  TestEnvironment()
      : super(isProduction: false, apiUrl: 'http://localhost', name: 'test');
}

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

/// Container de teste com `CircuitBreakerController`, `AuthenticationStore`,
/// `Environment` e o `ComfortPartnersController` REAL (lazy) ligado ao
/// [http] falso.
class ComfortHarness {
  ComfortHarness._(this.appOrigin, this.session, this.getToken);

  /// Origem usada pela factory lazy do controller (mutável por teste).
  AppOriginEnum appOrigin;
  final FakeSessionBloc session;
  final FakeGetToken getToken;
  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  final FakeAuthenticationStore authStore = FakeAuthenticationStore();
  late final CircuitBreakerController circuit;
  late final FakeUrlLauncherPlatform launcher;

  /// Último controller criado pela factory lazy (ou por [buildController]).
  ComfortPartnersController? lastController;

  /// Resolve (criando se preciso) o controller registrado no container.
  ComfortPartnersController controller() =>
      container.resolve<ComfortPartnersController>();

  ComfortRepository buildRepository() => ComfortRepositoryImpl(
        remoteDataSource: ComfortRemoteDataSourceImpl(
          api: ComfortApi.create(buildChopperClient(http)),
        ),
      );

  ComfortPartnersController buildController({
    AppOriginEnum? appOriginEnum,
    bool withRequestPartners = true,
    ComfortPartner? selectedPartner,
    List<ComfortPartner> allPartnersList = const [],
  }) {
    final repository = buildRepository();
    final controller = ComfortPartnersController(
      comfortPartnersBloc: ComfortPartnersBloc(),
      comfortPartnerCouponsBloc: ComfortPartnerCouponsBloc(),
      getPartnerCouponsUseCase:
          GetPartnerCouponsUseCaseImpl(repository: repository),
      getAllPartnersUseCase: GetAllPartnersUseCaseImpl(repository: repository),
      getPartnerIsFavoriteUseCase:
          GetPartnerIsFavoriteUseCaseImpl(repository: repository),
      changePartnerFavoriteStatusUseCase:
          ChangePartnerFavoriteStatusUseCaseImpl(repository: repository),
      createCouponRequestUseCase:
          CreateCouponRequestUseCaseImpl(repository: repository),
      findRequestPurchaseUseCase:
          FindRequestPurchaseUseCaseImpl(repository: repository),
      postRateRequestUseCase:
          SendReviewRequestUseCaseImpl(repository: repository),
      sessionBloc: session,
      appOriginEnum: appOriginEnum ?? appOrigin,
      getToken: getToken,
      requestPartnersUseCase: withRequestPartners
          ? RequestPartnersUseCaseImpl(repository: repository)
          : null,
      selectedPartner: selectedPartner,
      allPartnersList: List.of(allPartnersList),
    );
    lastController = controller;
    return controller;
  }

  // Rotas HTTP mais usadas -------------------------------------------------

  void mockPartners(List<Map<String, dynamic>> partners) =>
      http.on('GET', '/condominiums/$condoId/comfort/v2', body: partners);

  void mockCoupons(String partnerId, List<Map<String, dynamic>> coupons) =>
      http.on('GET', '/condominiums/$condoId/comfort/v2/Coupons/$partnerId',
          body: coupons);

  void mockFavorite(String partnerId, {required bool isFavorite}) =>
      http.on('PUT', '/condominiums/$condoId/comfort/favorite/$partnerId',
          body: {'comfort_owner_id': 'OWN', 'is_favorite': isFavorite});

  void mockCouponRequest(Map<String, dynamic> body) =>
      http.on('POST', '/condominiums/$condoId/comfort/couponResponse',
          body: body);

  void mockReview() => http.on(
      'PUT', '/condominiums/$condoId/comfort/myRequests/reviewRequest',
      body: {'request_id': 'REQ1', 'rating': 4.0, 'comment': 'ok'});

  void mockPurchase(String requestId, Map<String, dynamic> body) => http.on(
      'GET', '/condominiums/$condoId/comfort/findPurchase/$requestId',
      body: body);

  void mockRequestPartners({int status = 200}) => http.on(
      'POST', '/condominiums/$condoId/comfort/requestPartners',
      status: status, body: {'ok': true});

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Sobe Firebase/Adjust/Datadog falsos, SharedPreferences e PackageInfo
/// mockados, `AppInfo`, url_launcher falso e o container de teste. Chame no
/// `setUp` (fora do fake async do `testWidgets`).
Future<ComfortHarness> installComfortHarness({
  AppOriginEnum appOrigin = AppOriginEnum.owner,
  FakeSessionBloc? session,
  FakeGetToken? getToken,
  Map<String, Object> preferences = const {},
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await setUpFakeFirebase();
  SharedPreferences.setMockInitialValues(Map<String, Object>.of(preferences));
  PackageInfo.setMockInitialValues(
    appName: 'lello',
    packageName: 'br.com.lello.morar',
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );
  await AppInfo.init();

  final harness = ComfortHarness._(
    appOrigin,
    session ?? FakeSessionBloc(),
    getToken ?? FakeGetToken(),
  );
  harness.launcher = installFakeUrlLauncher();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(nativeUrlChannel,
          (call) async => throw PlatformException(code: 'sem-plugin'));

  harness.circuit = CircuitBreakerController(
    database: FakeFirebaseFirestore(),
    sessionBloc: harness.session,
    environment: TestEnvironment(),
  );
  harness.container
    ..register<CircuitBreakerController>(harness.circuit)
    ..register<AuthenticationStore>(harness.authStore)
    ..register<Environment>(TestEnvironment())
    ..registerLazy<ComfortPartnersController>(harness.buildController);

  // O container NÃO é resetado no tearDown: a árvore de widgets de um teste
  // que falhou só é desmontada no `pumpWidget` seguinte, e o `dispose` da
  // `ComfortPage` ainda chama `resetLazySingleton` nele.
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(nativeUrlChannel, null);
    harness.circuit.dispose();
  });
  return harness;
}

/// Emite [state] direto no [bloc] e espera a tela reagir.
Future<void> emitState(
  WidgetTester tester,
  Bloc bloc,
  Object state, {
  bool settle = true,
}) async {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  bloc.emit(state);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // O stream do bloc entrega o estado num microtask: um pump para o
    // BlocBuilder receber e outro para reconstruir.
    await tester.pump();
    await tester.pump();
  }
}

/// Dá [stars] estrelas no [RatingBar] encontrado por [ratingBar].
///
/// O SVG das estrelas não carrega no teste, então o `GestureDetector` de
/// cada estrela não tem área clicável (`deferToChild`); chamamos o
/// `onTapDown` do detector da estrela diretamente.
Future<void> rateStars(WidgetTester tester, Finder ratingBar, int stars) async {
  final detector = tester.widget<GestureDetector>(
    find
        .descendant(of: ratingBar, matching: find.byType(GestureDetector))
        .at(stars - 1),
  );
  detector.onTapDown!(TapDownDetails(localPosition: const Offset(30, 16)));
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Fixtures de parceiros e cupons
// ---------------------------------------------------------------------------

Map<String, dynamic> partnerJson(
  String id, {
  String? title,
  String category = 'toYou',
  String cta = 'cupom',
  String comfortType = 'cleaning',
  bool favorite = false,
  int discount = 10,
  double rating = 4.5,
  int ratingsNumber = 10,
  String site = 'https://www.parceiro.com/loja',
  String instagram = 'parceiro',
  String instagramLink = 'https://instagram.com/parceiro',
  String email = 'contato@parceiro.com',
  String clob = '<p>Descrição do parceiro</p>',
  String imageHash = 'hash',
  String? notificationParameter,
}) =>
    {
      'id': id,
      'target_public': 'all',
      'title': title ?? 'Parceiro $id',
      'image_hash': imageHash,
      'clob_content': clob,
      'email': email,
      'instagram': instagram,
      'instagram_link': instagramLink,
      'site': site,
      'comfort_type': comfortType,
      'category': category,
      'biggest_discount_percentage': discount,
      'redirect': '',
      'cta': cta,
      'partner_coupons': <Map<String, dynamic>>[],
      'rating': rating,
      'ratings_number': ratingsNumber,
      'favorite': favorite,
      'category_order': 1.0,
      'partner_order': 1.0,
      'notification_parameter': notificationParameter ?? 'np_$id',
    };

Map<String, dynamic> couponJson(
  String id, {
  String? title,
  int discount = 20,
  bool highlight = true,
  bool reusable = true,
  String imageHash = 'chash',
}) =>
    {
      'id': id,
      'code': 'COD$id',
      'title': title ?? 'Cupom $id',
      'discount_percentage': discount,
      'highlight': highlight,
      'description': 'desc',
      'sale_type': 'online',
      'date_insertion': '2026-01-01T00:00:00',
      'date_removal': null,
      'image_hash': imageHash,
      'reusable': reusable,
      'use_limit': 5,
      'notification_parameter': 'npc_$id',
    };

Map<String, dynamic> couponRequestJson({
  String idRequest = 'REQ1',
  String link = 'https://www.parceiro.com/promo',
  String cta = 'cupom',
  List<Map<String, dynamic>>? params,
}) =>
    {
      'id_request': idRequest,
      'params': params ??
          [
            {'type': 'QUERY', 'name_param': 'cupom', 'param': 'ABC'},
            {'type': 'HEADER', 'name_param': 'x-token', 'param': 't1'},
          ],
      'link_redirect_partner': link,
      'redirect_external': true,
      'cta': cta,
    };

Map<String, dynamic> purchaseJson({
  String requestId = 'REQ1',
  bool purchaseDone = true,
  String? purchaseDate = '2026-02-10T10:00:00',
}) =>
    {
      'request_id': requestId,
      'user_id': 'ME1',
      'unit_id': 'U1',
      'purchase_done': purchaseDone,
      'purchase_date': purchaseDate,
    };

ComfortPartner buildPartner(
  String id, {
  String? title,
  String category = 'toYou',
  String cta = 'cupom',
  String comfortType = 'cleaning',
  bool favorite = false,
  int discount = 10,
  double rating = 4.5,
  int ratingsNumber = 10,
  String site = 'https://www.parceiro.com/loja',
  String instagram = 'parceiro',
  String instagramLink = 'https://instagram.com/parceiro',
  String email = 'contato@parceiro.com',
  String clob = '<p>Descrição do parceiro</p>',
  String? notificationParameter,
}) =>
    ComfortPartnerModel.fromJson(partnerJson(
      id,
      title: title,
      category: category,
      cta: cta,
      comfortType: comfortType,
      favorite: favorite,
      discount: discount,
      rating: rating,
      ratingsNumber: ratingsNumber,
      site: site,
      instagram: instagram,
      instagramLink: instagramLink,
      email: email,
      clob: clob,
      notificationParameter: notificationParameter,
    )).toEntity();

ComfortPartnerCoupon buildCoupon(
  String id, {
  String? title,
  int discount = 20,
  bool highlight = true,
  bool reusable = true,
  String? partnerId,
}) =>
    ComfortPartnerCouponModel.fromJson(couponJson(
      id,
      title: title,
      discount: discount,
      highlight: highlight,
      reusable: reusable,
    )).toEntity()
      ..partnerId = partnerId;

ComfortCouponRequest buildCouponRequest({
  String idRequest = 'REQ1',
  String link = 'https://www.parceiro.com/promo',
  ComfortCTA cta = ComfortCTA.cupom,
}) =>
    ComfortCouponRequest(
      idRequest: idRequest,
      params: [
        ComfortCouponRequestParam(
            type: 'QUERY', nameParam: 'cupom', param: 'ABC'),
      ],
      linkRedirectPartner: link,
      redirectExternal: true,
      cta: cta,
    );

ComfortRequestPurchase buildPurchase({
  String requestId = 'REQ1',
  bool purchaseDone = true,
  DateTime? purchaseDate,
}) =>
    ComfortRequestPurchase(
      requestId: requestId,
      userId: 'ME1',
      unitId: 'U1',
      purchaseDone: purchaseDone,
      purchaseDate: purchaseDate ?? DateTime(2026, 2, 10),
    );

ComfortYourCondoRemoteConfig yourCondoConfig(String type,
        {String title = 'Limpeza', String iconType = 'asset'}) =>
    ComfortYourCondoRemoteConfig(
      type: type,
      iconType: iconType,
      iconPath: 'ic_comfort_others.svg',
      title: title,
      body: 'corpo',
    );
