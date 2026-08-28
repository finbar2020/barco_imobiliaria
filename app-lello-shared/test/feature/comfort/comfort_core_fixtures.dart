// Fixtures (JSON, entidades e fakes de sessão) usadas pelos testes de
// domínio, dados e da página "Para seu condomínio" da feature comfort.
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_details.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

// ---------------------------------------------------------------------------
// JSON (snake_case, como os `*.g.dart` esperam)
// ---------------------------------------------------------------------------

Map<String, dynamic> partnerDetailsJson({String id = 'd1'}) => {
      'id': id,
      'company_name': 'Empresa $id',
      'cnpj': '12.345.678/0001-90',
    };

Map<String, dynamic> couponJson({
  String id = 'c1',
  int discount = 10,
  bool highlight = false,
}) =>
    {
      'id': id,
      'code': 'COD$id',
      'title': 'Cupom $id',
      'discount_percentage': discount,
      'highlight': highlight,
      'description': 'Descrição $id',
      'sale_type': 'online',
      'date_insertion': '2026-01-10T00:00:00.000',
      'date_removal': '2026-12-31T00:00:00.000',
      'image_hash': 'hash$id',
      'reusable': false,
      'use_limit': 3,
      'notification_parameter': 'np$id',
    };

Map<String, dynamic> partnerJson({
  String id = 'p1',
  String title = 'Parceiro 1',
  String comfortType = 'cleaning',
  String category = 'toYourCondo',
  String imageHash = 'img1',
  bool favorite = false,
  int biggestDiscount = 20,
  String cta = 'cupom',
  List<Map<String, dynamic>?>? coupons,
  Map<String, dynamic>? details,
}) =>
    {
      'id': id,
      'target_public': 'todos',
      'title': title,
      'image_hash': imageHash,
      'clob_content': '<p>conteúdo</p>',
      'email': 'contato@$id.com',
      'instagram': '@$id',
      'instagram_link': 'https://instagram.com/$id',
      'site': 'https://www.$id.com.br',
      'comfort_type': comfortType,
      'category': category,
      'biggest_discount_percentage': biggestDiscount,
      'redirect': 'https://$id.com/redirect',
      'cta': cta,
      'partner_coupons': coupons ?? [couponJson()],
      'partner_details': details ?? partnerDetailsJson(),
      'rating': 4.5,
      'ratings_number': 12,
      'favorite': favorite,
      'category_order': 1.0,
      'partner_order': 2.0,
      'notification_parameter': 'np_$id',
    };

Map<String, dynamic> completedRequestJson({
  String id = 'r1',
  String status = 'sended',
  String? messageType = 'doubt',
  String imageHash = 'img1',
  String idPartner = 'p1',
  Map<String, dynamic>? partner,
  bool includePartner = true,
}) =>
    {
      'id_request': id,
      'date_request': '2026-02-03T10:00:00.000',
      'rating': 4.0,
      'purchased': true,
      'image_hash': imageHash,
      'comfort_type': 'cleaning',
      if (includePartner) 'partner': partner ?? partnerJson(id: idPartner),
      'id_partner': idPartner,
      'is_favorite': false,
      'is_can_cancel': true,
      'is_can_resend': false,
      'resend_date': '2026-02-04T10:00:00.000',
      'comment': 'comentário',
      'message_type': messageType,
      'status': status,
      'message_date': '2026-02-05T10:00:00.000',
      'canceled_date': null,
    };

Map<String, dynamic> requestPurchaseJson({
  String id = 'r1',
  bool purchaseDone = true,
}) =>
    {
      'request_id': id,
      'user_id': 'u1',
      'unit_id': 'un1',
      'purchase_done': purchaseDone,
      'used_coupon': 1,
      'rating': 3.5,
      'comment': 'ok',
      'purchase_date': '2026-03-01T00:00:00.000',
      'date_resend': '2026-03-02T00:00:00.000',
      'type_c_t_a': 'cupom',
      'can_cancel': true,
      'can_resend': true,
      'status': 'sended',
      'type_subject': 'doubt',
    };

Map<String, dynamic> reviewJson({
  String? name = 'Maria',
  String? date = '2026-01-20T00:00:00.000',
  double review = 5,
}) =>
    {
      'image': 'img',
      'name': name,
      'review': review,
      'comment': 'ótimo',
      'review_date': date,
      'redirect_image': 'https://img',
    };

Map<String, dynamic> couponRequestJson({
  String link = 'https://parceiro.com/oferta',
  List<Map<String, dynamic>?>? params,
}) =>
    {
      'id_request': 'req1',
      'params': params ??
          [
            {'type': 'QUERY', 'name_param': 'token', 'param': 'abc'},
            {'type': 'HEADER', 'name_param': 'x-api', 'param': 'k'},
            {'type': 'QUERY', 'name_param': 'url-callback', 'param': 'cb'},
          ],
      'link_redirect_partner': link,
      'redirect_external': true,
      'cta': 'link',
    };

Map<String, dynamic> favoriteJson({bool isFavorite = true}) => {
      'comfort_owner_id': 'owner1',
      'is_favorite': isFavorite,
    };

Map<String, dynamic> myRequestsPageJson(List<Map<String, dynamic>> data) => {
      'meta': {
        'currentPage': 1,
        'totalPages': 1,
        'itemCount': data.length,
        'itemPerPage': 10,
        'totalItems': data.length,
      },
      'data': data,
    };

// ---------------------------------------------------------------------------
// Entidades
// ---------------------------------------------------------------------------

ComfortPartner buildPartner({
  String id = 'p1',
  String title = 'Parceiro 1',
  ComfortType comfortType = ComfortType.cleaning,
  ComfortPartnerCategory category = ComfortPartnerCategory.toYourCondo,
  int biggestDiscount = 20,
  String site = 'https://www.p1.com.br',
  bool favorite = false,
  String imageHash = 'img1',
  ComfortCTA cta = ComfortCTA.cupom,
}) =>
    ComfortPartner(
      id: id,
      partnerIntro: ComfortPartnerIntro(
        id: id,
        title: title,
        comfortType: comfortType,
        partnerDetails: ComfortPartnerDetails(
            id: 'd$id', companyName: 'Empresa $id', cnpj: '123'),
        favorite: favorite,
      ),
      targetPublic: 'todos',
      imageHash: imageHash,
      clobContent: 'conteúdo',
      category: category,
      biggestDiscountPercentage: biggestDiscount,
      redirect: 'https://$id.com',
      rating: 4.25,
      ratingsNumber: 3,
      categoryOrder: 1,
      partnerOrder: 2,
      notificationParameter: 'np_$id',
      email: 'contato@$id.com',
      instagram: '@$id',
      instagramLink: 'https://instagram.com/$id',
      site: site,
      cta: cta,
    );

ComfortPartnerCoupon buildCoupon({
  String id = 'c1',
  int discount = 10,
  bool highlight = false,
  ComfortType? comfortType,
}) =>
    ComfortPartnerCoupon(
      id: id,
      code: 'COD$id',
      title: 'Cupom $id',
      discountPercentage: discount,
      highlight: highlight,
      description: 'desc',
      saleType: 'online',
      dateInsertion: DateTime(2026, 1, 10),
      dateRemoval: DateTime(2026, 12, 31),
      imageHash: 'hash$id',
      reusable: true,
      useLimit: 5,
      notificationParameter: 'np$id',
      comfortType: comfortType,
    );

ComfortCompletedRequest buildCompletedRequest({
  String id = 'r1',
  ComfortRequestStatus status = ComfortRequestStatus.sended,
  ComfortRequestMessageType? messageType = ComfortRequestMessageType.doubt,
  ComfortPartner? partner,
  DateTime? dateRequest,
}) =>
    ComfortCompletedRequest(
      idRequest: id,
      dateRequest: dateRequest ?? DateTime(2026, 2, 3, 10),
      rating: 4,
      purchased: true,
      imageHash: 'img1',
      idPartner: 'p1',
      partner: partner ?? buildPartner(),
      isCanCancel: true,
      isCanResend: false,
      resendDate: DateTime(2026, 2, 4),
      comment: 'comentário',
      messageType: messageType,
      status: status,
      messageDate: DateTime(2026, 2, 5),
      canceledDate: null,
    );

ComfortYourCondoRemoteConfig buildRemoteCategory({
  String type = 'cleaning',
  String title = 'Limpeza',
  String iconType = 'asset',
}) =>
    ComfortYourCondoRemoteConfig.fromRemote({
      'type': type,
      'iconType': iconType,
      'iconPath': 'ic_$type.svg',
      'title': title,
      'body': 'Soluções de $title para as áreas comuns.',
    });

// ---------------------------------------------------------------------------
// Sessão falsa (o controller recebe `dynamic sessionBloc`)
// ---------------------------------------------------------------------------

class FakeCondo {
  FakeCondo({
    this.id = 'C1',
    this.reference = 'R1',
    this.name = 'Condomínio Teste',
    this.address = 'Rua A, 1',
  });
  final String? id;
  final String? reference;
  final String? name;
  final String? address;
}

class FakeMe {
  FakeMe({
    this.id = 'u1',
    this.name = 'Usuário',
    this.email = 'user@lello.com',
    this.phone = '11999998888',
  });
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
}

class FakeUnity {
  FakeUnity({this.id = 'un1', this.title = '101'});
  final String? id;
  final String? title;
}

class FakeSession {
  FakeSession({
    this.condominium,
    this.selectedCondominium,
    this.me,
    this.unity,
  });
  final FakeCondo? condominium;
  final FakeCondo? selectedCondominium;
  final FakeMe? me;
  final FakeUnity? unity;
}

class FakeSessionState {
  FakeSessionState({this.session});
  final FakeSession? session;
}

class FakeSessionBloc {
  FakeSessionBloc({
    FakeSession? session,
    this.comfortToYourCondo = const [],
  }) : state = FakeSessionState(
            session: session ??
                FakeSession(
                  condominium: FakeCondo(),
                  selectedCondominium: FakeCondo(id: 'C1', reference: 'R1'),
                  me: FakeMe(),
                  unity: FakeUnity(),
                ));

  FakeSessionState state;
  List<ComfortYourCondoRemoteConfig> comfortToYourCondo;

  List<ComfortYourCondoRemoteConfig> getComfortToYourCondo() =>
      comfortToYourCondo;
}

/// `GetToken` sem token: `getUserType` do controller vira `""`.
class FakeGetToken extends Fake implements GetToken {
  FakeGetToken({this.selectedRole});
  final String? selectedRole;

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async =>
      Success<AccessToken?>(
          selectedRole == null ? null : (AccessToken()..selectedRole = selectedRole));
}
