// Suporte compartilhado pelos testes de comfort_my_requests,
// comfort_my_request_item_actions, comfort_partner_reviews e widgets:
// sessão falsa, token falso, store de autenticação falsa, harness com as
// classes REAIS de dados (api chopper -> data source -> repositório -> use
// cases -> controllers) ligadas ao [FakeHttp], e construtores de JSON/entidades.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/repository/comfort_repository_impl.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request_impl.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/controller/comfort_partner_reviews_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/fake_http.dart';
import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/test_container.dart';

const condoId = 'condo-1';
const condoName = 'Condomínio Teste';
const condoReference = 'R123';

// ---------------------------------------------------------------------------
// Sessão falsa (os controllers recebem `dynamic sessionBloc`).
// ---------------------------------------------------------------------------
class FakeCondominium {
  FakeCondominium({this.id, this.name, this.reference});
  final String? id;
  final String? name;
  final String? reference;
}

class FakeMe {
  FakeMe(this.id);
  final String? id;
}

class FakeUnity {
  FakeUnity(this.title);
  final String? title;
}

class FakeSession {
  FakeSession({
    this.condominium,
    this.selectedCondominium,
    this.me,
    this.unity,
    this.condominiumId,
  });
  final FakeCondominium? condominium;
  final FakeCondominium? selectedCondominium;
  final FakeMe? me;
  final FakeUnity? unity;
  final String? condominiumId;
}

class FakeSessionState {
  FakeSessionState(this.session);
  final FakeSession? session;
}

class FakeSessionBloc {
  FakeSessionBloc(FakeSession? session) : state = FakeSessionState(session);
  FakeSessionState state;

  List<dynamic> getComfortToYourCondo() => [];
}

/// Sessão com condomínio e condomínio selecionado (síndico) preenchidos.
FakeSessionBloc buildSession({
  String? id = condoId,
  String? name = condoName,
  String? reference = condoReference,
  String? meId = 'me-1',
  String? unityTitle = 'Ap 101',
}) =>
    FakeSessionBloc(FakeSession(
      condominium: FakeCondominium(id: id, name: name, reference: reference),
      selectedCondominium:
          FakeCondominium(id: id, name: name, reference: reference),
      me: FakeMe(meId),
      unity: FakeUnity(unityTitle),
      condominiumId: id,
    ));

/// Sessão sem nada preenchido (todos os `??` viram vazio).
FakeSessionBloc emptySession() => FakeSessionBloc(null);

// ---------------------------------------------------------------------------
// Token / store de autenticação.
// ---------------------------------------------------------------------------
class FakeGetToken implements GetToken {
  FakeGetToken({this.role = 'owner', this.fail = false});
  final String? role;
  final bool fail;
  int calls = 0;

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async {
    calls++;
    if (fail) return Rejection(UnknownFailure('sem token'));
    return Success(AccessToken()..selectedRole = role);
  }
}

/// A `CustomCachedNetworkImage` só pede o header ao store; sem header ela
/// cai no SVG local (sem cache manager/IO nos testes).
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  FakeAuthenticationStore({this.header});
  final Map<String, String>? header;

  @override
  Map<String, String>? getCustomHeader() => header;
}

// ---------------------------------------------------------------------------
// Toast (fluttertoast usa MethodChannel).
// ---------------------------------------------------------------------------
const _toastChannel = MethodChannel('PonnamKarthik/fluttertoast');

/// Instala um handler para o canal do fluttertoast e devolve a lista de
/// mensagens exibidas.
List<String> installFakeToast() {
  final messages = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_toastChannel, (call) async {
    if (call.method == 'showToast') {
      messages.add((call.arguments as Map)['msg'] as String);
    }
    return true;
  });
  addTearDown(() => TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_toastChannel, null));
  return messages;
}

// ---------------------------------------------------------------------------
// Harness com as classes reais ligadas ao FakeHttp.
// ---------------------------------------------------------------------------
class ComfortRequestsHarness {
  ComfortRequestsHarness({
    this.origin = AppOriginEnum.owner,
    FakeSessionBloc? session,
    FakeGetToken? getToken,
  })  : session = session ?? buildSession(),
        getToken = getToken ?? FakeGetToken() {
    final api = ComfortApi.create(buildChopperClient(http));
    repository = ComfortRepositoryImpl(
        remoteDataSource: ComfortRemoteDataSourceImpl(api: api));

    container.register<AuthenticationStore>(FakeAuthenticationStore());
    container.registerLazy<ComfortMyRequestsController>(buildMyRequestsController);
    container.registerFactory<ComfortMyRequestItemActionsController>(
        buildItemActionsController);
    container.registerLazy<ComfortPartnerReviewsController>(
        buildPartnerReviewsController);
    container.registerLazy<ComfortPartnersController>(buildPartnersController);
  }

  final AppOriginEnum origin;
  final FakeSessionBloc session;
  final FakeGetToken getToken;
  final http = FakeHttp();
  final container = TestSharedContainer();
  late final ComfortRepository repository;

  ComfortMyRequestsController buildMyRequestsController() =>
      ComfortMyRequestsController(
        comfortMyRequestsBloc: ComfortMyRequestsBloc(),
        getMyRequestsUseCase: GetMyRequestsUseCaseImpl(repository: repository),
        changePartnerFavoriteStatusUseCase:
            ChangePartnerFavoriteStatusUseCaseImpl(repository: repository),
        postRateRequestUseCase:
            SendReviewRequestUseCaseImpl(repository: repository),
        resendRequestUseCase: ResendRequestUseCaseImpl(repository: repository),
        subcategoriesUseCase:
            GetSubcategoriesUseCaseImpl(repository: repository),
        sessionBloc: session,
        getToken: getToken,
        appOriginEnum: origin,
      );

  ComfortMyRequestItemActionsController buildItemActionsController() =>
      ComfortMyRequestItemActionsController(
        resendRequestUseCase: ResendRequestUseCaseImpl(repository: repository),
        cancelRequestUseCase: CancelRequestUseCaseImpl(repository: repository),
        updateRequestUseCase: UpdateRequestUseCaseImpl(repository: repository),
        bloc: ComfortMyRequestItemActionsBloc(),
        sessionBloc: session,
        appOriginEnum: origin,
      );

  ComfortPartnerReviewsController buildPartnerReviewsController() =>
      ComfortPartnerReviewsController(
        sessionBloc: session,
        getAllPartnerReviewsUseCase:
            GetAllPartnerReviewsUseCaseImpl(repository: repository),
        appOriginEnum: origin,
        comfortPartnerReviewsBloc: ComfortPartnerReviewsBloc(),
      );

  ComfortPartnersController buildPartnersController() =>
      ComfortPartnersController(
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
        appOriginEnum: origin,
        getToken: getToken,
      );

  ComfortMyRequestsController get myRequests =>
      container.resolve<ComfortMyRequestsController>();
  ComfortPartnerReviewsController get partnerReviews =>
      container.resolve<ComfortPartnerReviewsController>();
  ComfortPartnersController get partners =>
      container.resolve<ComfortPartnersController>();

  // Caminhos da ComfortApi.
  String get subcategoriesPath =>
      '/condominiums/$condoId/comfort/myRequestsV2/listComfortServiceType';
  String get myRequestsPath => '/condominiums/$condoId/comfort/myRequestsV2';
  String get reviewRequestPath =>
      '/condominiums/$condoId/comfort/myRequests/reviewRequest';
  String resendPath(String id) =>
      '/condominiums/$condoId/comfort/myRequests/resend/$id';
  String cancelPath(String id) =>
      '/condominiums/$condoId/comfort/myRequests/cancel/$id';
  String updatePath(String id) =>
      '/condominiums/$condoId/comfort/myRequests/update/$id';
  String favoritePath(String partnerId) =>
      '/condominiums/$condoId/comfort/favorite/$partnerId';
  String reviewsPath(String partnerId) =>
      '/condominiums/$condoId/comfort/allReviews/partner/$partnerId';
  String get allPartnersPath => '/condominiums/$condoId/comfort/v2';

  void mockSubcategories([List<String> types = const ['gym', 'cleaning']]) =>
      http.on('GET', subcategoriesPath, body: types);

  void mockMyRequests(List<Map<String, dynamic>> items, {int? total}) =>
      http.on('GET', myRequestsPath, body: {
        'data': items,
        'meta': {'total_items': total ?? items.length},
      });

  void mockAllPartners() => http.on('GET', allPartnersPath, body: []);

  /// Requisições feitas a [path] (sem query).
  List<String> get paths => http.requests.map((r) => r.url.path).toList();
  Map<String, String> queryOf(String path) => http.requests
      .lastWhere((r) => r.url.path == path)
      .url
      .queryParameters;

  Future<void> dispose() => container.reset();
}

/// Firebase falso + harness: use em `setUp`.
Future<ComfortRequestsHarness> installComfortHarness({
  AppOriginEnum origin = AppOriginEnum.owner,
  FakeSessionBloc? session,
  FakeGetToken? getToken,
}) async {
  await setUpFakeFirebase();
  // Sem `reset()` no tearDown: o get_it é próprio do harness e um reset antes
  // do unmount da árvore quebraria o `resetLazySingleton` do dispose da página.
  return ComfortRequestsHarness(origin: origin, session: session, getToken: getToken);
}

// ---------------------------------------------------------------------------
// JSON das APIs.
// ---------------------------------------------------------------------------
Map<String, dynamic> partnerJson({
  String id = 'p1',
  String title = 'Academia Lello',
  String comfortType = 'gym',
  String category = 'toYou',
  double rating = 4.5,
  int ratingsNumber = 12,
  String imageHash = 'hash-p1',
}) =>
    {
      'id': id,
      'title': title,
      'comfort_type': comfortType,
      'category': category,
      'rating': rating,
      'ratings_number': ratingsNumber,
      'image_hash': imageHash,
      'cta': 'cupom',
      'site': 'https://www.lello.com.br',
      'email': 'contato@lello.com.br',
    };

Map<String, dynamic> requestJson(
  String id, {
  String partnerId = 'p1',
  String partnerTitle = 'Academia Lello',
  String comfortType = 'gym',
  String dateRequest = '2026-01-10T10:30:00',
  double? rating,
  bool purchased = true,
  bool isCanCancel = true,
  bool isCanResend = true,
  String? resendDate,
  String? comment,
  String? messageType,
  String status = 'sended',
  String? messageDate,
  String? canceledDate,
  String imageHash = 'hash-r',
}) =>
    {
      'id_request': id,
      'date_request': dateRequest,
      'rating': rating,
      'purchased': purchased,
      'image_hash': imageHash,
      'comfort_type': comfortType,
      'partner': partnerJson(
          id: partnerId, title: partnerTitle, comfortType: comfortType),
      'id_partner': partnerId,
      'is_can_cancel': isCanCancel,
      'is_can_resend': isCanResend,
      'resend_date': resendDate,
      'comment': comment,
      'message_type': messageType,
      'status': status,
      'message_date': messageDate,
      'canceled_date': canceledDate,
    };

Map<String, dynamic> reviewJson({
  String? name = 'Maria',
  double review = 4,
  String? comment = 'Muito bom',
  String? reviewDate = '2026-02-03T00:00:00',
}) =>
    {
      'name': name,
      'review': review,
      'comment': comment,
      'review_date': reviewDate,
    };

// ---------------------------------------------------------------------------
// Entidades.
// ---------------------------------------------------------------------------
ComfortPartner buildPartner({
  String id = 'p1',
  String title = 'Academia Lello',
  ComfortType comfortType = ComfortType.gym,
  bool favorite = false,
  String? imageLink,
  double rating = 4.5,
  int ratingsNumber = 12,
}) =>
    ComfortPartner(
      id: id,
      partnerIntro: ComfortPartnerIntro(
        id: id,
        title: title,
        comfortType: comfortType,
        partnerDetails: null,
        favorite: favorite,
        partnerImageLink: imageLink,
      ),
      targetPublic: '',
      imageHash: 'hash-$id',
      clobContent: '',
      category: ComfortPartnerCategory.toYou,
      biggestDiscountPercentage: 10,
      redirect: '',
      rating: rating,
      ratingsNumber: ratingsNumber,
      categoryOrder: 1,
      partnerOrder: 1,
      notificationParameter: '',
      email: 'contato@lello.com.br',
      instagram: '',
      instagramLink: '',
      site: 'https://www.lello.com.br',
      cta: ComfortCTA.cupom,
    );

ComfortCompletedRequest buildRequest({
  String id = 'r1',
  DateTime? dateRequest,
  double? rating,
  bool purchased = true,
  bool isCanCancel = true,
  bool isCanResend = true,
  DateTime? resendDate,
  String? comment,
  ComfortRequestMessageType? messageType,
  ComfortRequestStatus status = ComfortRequestStatus.sended,
  DateTime? messageDate,
  DateTime? canceledDate,
  ComfortPartner? partner,
}) =>
    ComfortCompletedRequest(
      idRequest: id,
      dateRequest: dateRequest ?? DateTime(2026, 1, 10, 10, 30),
      rating: rating,
      purchased: purchased,
      imageHash: 'hash-$id',
      idPartner: partner?.id ?? 'p1',
      partner: partner ?? buildPartner(),
      isCanCancel: isCanCancel,
      isCanResend: isCanResend,
      resendDate: resendDate,
      comment: comment,
      messageType: messageType,
      status: status,
      messageDate: messageDate,
      canceledDate: canceledDate,
    );

/// Chama `fetchNextPage()` (que é `void async`) e aguarda; erros relançados
/// pelo PagingController são capturados e devolvidos.
Future<Object?> fetchPageGuarded(PagingController controller) async {
  Object? caught;
  await runZonedGuarded(() async {
    controller.fetchNextPage();
    await flush();
  }, (error, _) => caught = error);
  await flush();
  return caught;
}

/// Espera microtarefas/futures reais (para os testes unitários fora do
/// testWidgets).
Future<void> flush([int rounds = 5]) async {
  for (var i = 0; i < rounds; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Página hospedeira com um botão "abrir" que executa [onOpen] com um
/// contexto abaixo do Navigator (para bottom sheets, diálogos e pushes).
class PushHost extends StatelessWidget {
  const PushHost({super.key, required this.onOpen});
  final void Function(BuildContext context) onOpen;

  @override
  Widget build(BuildContext context) => Scaffold(
        key: const Key('push-host'),
        body: Center(
          child: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => onOpen(ctx),
              child: const Text('abrir'),
            ),
          ),
        ),
      );
}

/// Aplica uma nota pela [RatingBar] encontrada por [bar], chamando o
/// `onRatingUpdate` que o widget registra. Os SVGs das estrelas não são
/// decodificados no teste (a decodificação roda em isolate), então a área de
/// toque das estrelas tem tamanho zero e o gesto real não é testável.
Future<void> setRating(WidgetTester tester, double value, {Finder? bar}) async {
  tester.widget<RatingBar>(bar ?? find.byType(RatingBar)).onRatingUpdate(value);
  await tester.pump();
}

/// Textos curtos para chaves longas que estouram a largura dos sheets/diálogos
/// (na app as traduções reais são curtas).
const sheetLoc = <String, String>{
  'comfort_request_cancel_button_confirm': 'Confirmar',
  'comfort_message_subject_did_not_receive_return': 'Sem retorno',
};

/// SvgPicture de um asset específico.
Finder svgAsset(String assetName) => find.byWidgetPredicate((w) =>
    w is SvgPicture &&
    w.bytesLoader is SvgAssetLoader &&
    (w.bytesLoader as SvgAssetLoader).assetName == assetName);
