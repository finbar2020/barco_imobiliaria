import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/meta_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_paginated_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_coupon_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_coupon_request_param_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_coupon_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_details_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_favorite_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_review_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_request_purchase_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_requests_filter_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_review_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_subcategories_model.dart';
import 'package:shared_features/feature/comfort/data/model/request_partners_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request_param.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_details.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';

import '../comfort_core_fixtures.dart';

/// Serializa e desserializa de novo para garantir que `toJson` produz JSON
/// válido (listas/objetos aninhados inclusos).
Map<String, dynamic> roundTrip(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  group('ComfortPartnerModel', () {
    test('fromJson lê todos os campos e toEntity converte enums', () {
      final model = ComfortPartnerModel.fromJson(partnerJson(
          coupons: [couponJson(), null], cta: 'link', favorite: true));
      expect(model.id, 'p1');
      expect(model.partnerCoupons, hasLength(2));
      expect(model.partnerCoupons.last, isNull);
      expect(model.partnerDetails!.companyName, 'Empresa d1');
      expect(model.rating, 4.5);

      final entity = model.toEntity();
      expect(entity.id, 'p1');
      expect(entity.partnerIntro.title, 'Parceiro 1');
      expect(entity.partnerIntro.comfortType, ComfortType.cleaning);
      expect(entity.partnerIntro.favorite, isTrue);
      expect(entity.partnerIntro.partnerDetails!.cnpj, '12.345.678/0001-90');
      expect(entity.partnerIntro.partnerImageLink, isNull);
      expect(entity.category, ComfortPartnerCategory.toYourCondo);
      expect(entity.cta, ComfortCTA.link);
      expect(entity.biggestDiscountPercentage, 20);
      expect(entity.notificationParameter, 'np_p1');
    });

    test('fromJson vazio usa padrões e enums desconhecidos caem em others/cupom',
        () {
      final model = ComfortPartnerModel.fromJson({
        'comfort_type': 'inexistente',
        'category': 'inexistente',
        'cta': 'inexistente',
      });
      expect(model.id, '');
      expect(model.partnerCoupons, isEmpty);
      expect(model.partnerDetails, isNull);
      final entity = model.toEntity();
      expect(entity.partnerIntro.comfortType, ComfortType.others);
      expect(entity.category, ComfortPartnerCategory.others);
      expect(entity.cta, ComfortCTA.cupom);
      expect(entity.partnerIntro.partnerDetails, isNull);
    });

    test('toJson e fromEntity', () {
      final json = roundTrip(ComfortPartnerModel.fromJson(partnerJson()).toJson());
      expect(json['id'], 'p1');
      expect(json['partner_coupons'], hasLength(1));
      expect(json['partner_details']['company_name'], 'Empresa d1');

      final model = ComfortPartnerModel.fromEntity(buildPartner(
          category: ComfortPartnerCategory.toYourPet, cta: ComfortCTA.email))!;
      expect(model.title, 'Parceiro 1');
      expect(model.comfortType, 'cleaning');
      expect(model.category, 'toYourPet');
      expect(model.cta, 'email');
      expect(model.partnerDetails!.id, 'dp1');
      expect(model.email, 'contato@p1.com');
      expect(ComfortPartnerModel.fromEntity(null), isNull);
    });
  });

  group('ComfortPartnerCouponModel', () {
    test('fromJson/toEntity/fromEntity/toJson', () {
      final model = ComfortPartnerCouponModel.fromJson(couponJson(highlight: true));
      expect(model.dateInsertion, DateTime(2026, 1, 10));
      final entity = model.toEntity();
      expect(entity.id, 'c1');
      expect(entity.highlight, isTrue);
      expect(entity.reusable, isFalse);
      expect(entity.useLimit, 3);
      expect(entity.dateRemoval, DateTime(2026, 12, 31));

      final back = ComfortPartnerCouponModel.fromEntity(entity)!;
      expect(roundTrip(back.toJson()), roundTrip(model.toJson()));
      expect(ComfortPartnerCouponModel.fromEntity(null), isNull);
    });

    test('padrões quando o JSON está vazio', () {
      final model = ComfortPartnerCouponModel.fromJson({});
      expect(model.reusable, isTrue);
      expect(model.useLimit, 999);
      expect(model.dateInsertion, isNull);
      expect(model.toEntity().discountPercentage, 0);
    });
  });

  group('ComfortPartnerDetailsModel', () {
    test('conversões', () {
      final model = ComfortPartnerDetailsModel.fromJson(partnerDetailsJson());
      expect(model.toEntity().companyName, 'Empresa d1');
      expect(model.toJson()['cnpj'], '12.345.678/0001-90');
      final fromEntity = ComfortPartnerDetailsModel.fromEntity(
          ComfortPartnerDetails(id: 'x', companyName: 'y', cnpj: 'z'))!;
      expect(fromEntity.id, 'x');
      expect(ComfortPartnerDetailsModel.fromEntity(null), isNull);
      expect(ComfortPartnerDetailsModel.fromJson({}).id, '');
    });
  });

  group('ComfortPartnerFavoriteModel', () {
    test('conversões', () {
      final model = ComfortPartnerFavoriteModel.fromJson(favoriteJson());
      expect(model.toEntity().isFavorite, isTrue);
      expect(model.toEntity().comfortOwnerId, 'owner1');
      expect(model.toJson(), {'comfort_owner_id': 'owner1', 'is_favorite': true});
      expect(
          ComfortPartnerFavoriteModel.fromEntity(
                  ComfortPartnerFavorite(comfortOwnerId: 'a', isFavorite: false))!
              .isFavorite,
          isFalse);
      expect(ComfortPartnerFavoriteModel.fromEntity(null), isNull);
      expect(ComfortPartnerFavoriteModel.fromJson({}).isFavorite, isFalse);
    });
  });

  group('ComfortCompletedRequestModel', () {
    test('fromJson e toEntity convertem datas e enums', () {
      final model = ComfortCompletedRequestModel.fromJson(
          completedRequestJson(status: 'resent', messageType: 'complaint'));
      expect(model.dateRequest, DateTime(2026, 2, 3, 10));
      expect(model.canceledDate, isNull);
      final entity = model.toEntity();
      expect(entity.idRequest, 'r1');
      expect(entity.status, ComfortRequestStatus.resent);
      expect(entity.messageType, ComfortRequestMessageType.complaint);
      expect(entity.partner.id, 'p1');
      expect(entity.isCanCancel, isTrue);
      expect(entity.resendDate, DateTime(2026, 2, 4, 10));
      expect(entity.messageDate, DateTime(2026, 2, 5, 10));
    });

    test('status/assunto desconhecidos e data nula usam padrões', () {
      final model = ComfortCompletedRequestModel.fromJson(
          completedRequestJson(status: 'xpto', messageType: null)
            ..['date_request'] = null);
      final before = DateTime.now();
      final entity = model.toEntity();
      expect(entity.status, ComfortRequestStatus.sended);
      expect(entity.messageType, ComfortRequestMessageType.other);
      expect(entity.dateRequest.isBefore(before), isFalse);
    });

    test('toEntity sem parceiro lança erro', () {
      /// Defeito: `ComfortCompletedRequestModel.toEntity` usa `partner!`;
      /// uma solicitação sem `partner` no JSON derruba a conversão
      /// (TypeError) em vez de tratar o nulo. Comportamento atual documentado.
      final model = ComfortCompletedRequestModel.fromJson(
          completedRequestJson(includePartner: false));
      expect(model.partner, isNull);
      expect(() => model.toEntity(), throwsA(isA<TypeError>()));
    });

    test('fromEntity e toJson', () {
      final entity = buildCompletedRequest(
          status: ComfortRequestStatus.canceled, messageType: null);
      final model = ComfortCompletedRequestModel.fromEntity(entity)!;
      expect(model.idRequest, 'r1');
      expect(model.status, 'canceled');
      expect(model.messageType, '');
      expect(model.comfortType, 'cleaning');
      expect(model.isFavorite, isFalse);
      expect(model.partner!.title, 'Parceiro 1');
      final json = roundTrip(model.toJson());
      expect(json['date_request'], '2026-02-03T10:00:00.000');
      expect(json['partner']['id'], 'p1');
      expect(json['canceled_date'], isNull);
      expect(ComfortCompletedRequestModel.fromEntity(null), isNull);
      // Volta para entidade: assunto vazio vira "outros".
      expect(model.toEntity().messageType, ComfortRequestMessageType.other);
    });
  });

  group('ComfortCompletedRequestPaginatedModel', () {
    test('fromJson/toEntity com e sem dados', () {
      final model = ComfortCompletedRequestPaginatedModel.fromJson(
          myRequestsPageJson([completedRequestJson(), completedRequestJson(id: 'r2')]));
      expect(model.meta!.totalItems, 2);
      final entity = model.toEntity();
      expect(entity.data.map((e) => e.idRequest), ['r1', 'r2']);
      expect(entity.meta.totalPages, 1);

      final vazio = ComfortCompletedRequestPaginatedModel.fromJson({});
      expect(vazio.toEntity().data, isEmpty);
      expect(vazio.toEntity().meta.totalItems, isNull);
      expect(
          ComfortCompletedRequestPaginatedModel(data: []).toEntity().data, isEmpty);
    });

    test('fromEntity e toJson', () {
      final entity = ComfortCompletedRequestPaginated(
          meta: Meta(currentPage: 2), data: [buildCompletedRequest()]);
      final model = ComfortCompletedRequestPaginatedModel.fromEntity(entity)!;
      expect(model.meta!.currentPage, 2);
      expect(model.data, hasLength(1));
      final json = roundTrip(model.toJson());
      expect(json['data'][0]['id_request'], 'r1');
      expect(json['meta']['currentPage'], 2);

      final semDados = ComfortCompletedRequestPaginatedModel.fromEntity(
          ComfortCompletedRequestPaginated(meta: Meta(), data: []))!;
      expect(semDados.data, isEmpty);
      expect(ComfortCompletedRequestPaginatedModel.fromEntity(null), isNull);
      expect(MetaModel.fromEntity(null), isNull);
    });
  });

  group('ComfortCouponRequestModel / ParamModel', () {
    test('fromJson/toEntity com parâmetros nulos', () {
      final model = ComfortCouponRequestModel.fromJson(
          couponRequestJson(params: [
        {'type': 'QUERY', 'name_param': 'a', 'param': '1'},
        null,
      ]));
      final entity = model.toEntity();
      expect(entity.idRequest, 'req1');
      expect(entity.params, hasLength(2));
      expect(entity.params.first!.nameParam, 'a');
      expect(entity.params.last, isNull);
      expect(entity.redirectExternal, isTrue);
      expect(entity.cta, ComfortCTA.link);
      expect(entity.linkRedirectPartner, 'https://parceiro.com/oferta');
    });

    test('padrões do JSON vazio', () {
      final entity = ComfortCouponRequestModel.fromJson({}).toEntity();
      expect(entity.params, isEmpty);
      expect(entity.cta, ComfortCTA.cupom);
      expect(entity.redirectExternal, isFalse);
      expect(ComfortCouponRequestModel.fromJson({'cta': 'zzz'}).toEntity().cta,
          ComfortCTA.cupom);
    });

    test('fromEntity e toJson', () {
      /// Defeito: `ComfortCouponRequestModel.fromEntity` não copia
      /// `redirectExternal` nem `cta` (ficam nos padrões `false`/`"cupom"`),
      /// então a conversão entidade -> modelo perde esses dados.
      final entity = ComfortCouponRequest(
        idRequest: 'x',
        params: [
          ComfortCouponRequestParam(type: 'HEADER', nameParam: 'h', param: 'v'),
          null,
        ],
        linkRedirectPartner: 'https://l',
        redirectExternal: true,
        cta: ComfortCTA.email,
      );
      final model = ComfortCouponRequestModel.fromEntity(entity)!;
      expect(model.idRequest, 'x');
      expect(model.params, hasLength(2));
      expect(model.params.first!.nameParam, 'h');
      expect(model.params.last, isNull);
      expect(model.redirectExternal, isFalse);
      expect(model.cta, 'cupom');
      final json = roundTrip(model.toJson());
      expect(json['params'][0]['name_param'], 'h');
      expect(json['link_redirect_partner'], 'https://l');

      expect(ComfortCouponRequestModel.fromEntity(null), isNull);
      expect(
          ComfortCouponRequestModel.fromEntity(ComfortCouponRequest(
                  idRequest: 'y',
                  params: [],
                  linkRedirectPartner: '',
                  redirectExternal: false,
                  cta: ComfortCTA.cupom))!
              .params,
          isEmpty);
    });

    test('ComfortCouponRequestParamModel', () {
      final model = ComfortCouponRequestParamModel.fromJson(
          {'type': 'QUERY', 'name_param': 'n', 'param': 'p'});
      expect(model.toEntity().param, 'p');
      expect(model.toJson(), {'type': 'QUERY', 'name_param': 'n', 'param': 'p'});
      expect(ComfortCouponRequestParamModel.fromEntity(null), isNull);
      expect(ComfortCouponRequestParamModel.fromJson({}).type, '');
    });
  });

  group('ComfortPartnerReviewModel', () {
    test('conversões', () {
      final model = ComfortPartnerReviewModel.fromJson(reviewJson());
      final entity = model.toEntity();
      expect(entity.name, 'Maria');
      expect(entity.review, 5);
      expect(entity.reviewDate, DateTime(2026, 1, 20));
      final back = ComfortPartnerReviewModel.fromEntity(entity);
      expect(roundTrip(back.toJson()), roundTrip(model.toJson()));
      final semData = ComfortPartnerReviewModel.fromJson(
          reviewJson(name: null, date: null, review: 2));
      expect(semData.toEntity().reviewDate, isNull);
      expect(semData.toEntity().name, isNull);
      expect(ComfortPartnerReviewModel.fromEntity(ComfortPartnerReview(review: 1))
          .review, 1);
    });
  });

  group('ComfortRequestPurchaseModel', () {
    test('fromJson/toEntity', () {
      final model = ComfortRequestPurchaseModel.fromJson(requestPurchaseJson());
      final entity = model.toEntity();
      expect(entity.requestId, 'r1');
      expect(entity.purchaseDone, isTrue);
      expect(entity.usedCoupon, 1);
      expect(entity.purchaseDate, DateTime(2026, 3, 1));
      expect(entity.dateResend, DateTime(2026, 3, 2));
      expect(entity.typeCTA, 'cupom');
      expect(entity.canCancel, isTrue);
      expect(entity.typeSubject, 'doubt');
      final vazio = ComfortRequestPurchaseModel.fromJson({}).toEntity();
      expect(vazio.purchaseDone, isFalse);
      expect(vazio.canCancel, isFalse);
      expect(vazio.purchaseDate, isNull);
    });

    test('fromEntity e toJson', () {
      /// Defeito: `ComfortRequestPurchaseModel.fromEntity` não copia
      /// `purchaseDate` (fica nulo), embora `toEntity` o leia.
      final entity = ComfortRequestPurchase(
        requestId: 'r',
        userId: 'u',
        unitId: 'un',
        purchaseDone: true,
        usedCoupon: 2,
        rating: 4,
        comment: 'c',
        purchaseDate: DateTime(2026, 3, 1),
        dateResend: DateTime(2026, 3, 2),
        typeCTA: 'link',
        canCancel: true,
        canResend: false,
        status: 's',
        typeSubject: 't',
      );
      final model = ComfortRequestPurchaseModel.fromEntity(entity)!;
      expect(model.requestId, 'r');
      expect(model.usedCoupon, 2);
      expect(model.dateResend, DateTime(2026, 3, 2));
      expect(model.purchaseDate, isNull);
      expect(model.typeSubject, 't');
      final json = roundTrip(model.toJson());
      expect(json['type_c_t_a'], 'link');
      expect(json['date_resend'], '2026-03-02T00:00:00.000');
      expect(ComfortRequestPurchaseModel.fromEntity(null), isNull);
    });
  });

  group('ComfortRequestsFilterModel', () {
    test('fromEntity/toEntity/json', () {
      final entity = ComfortRequestsFilter(
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          status: ComfortFilterRequestStatus.resent,
          subcategories: ComfortType.laundry);
      final model = ComfortRequestsFilterModel.fromEntity(entity);
      expect(model.status, 'resent');
      expect(model.subcategories, 'laundry');
      final json = roundTrip(model.toJson());
      expect(json['start_date'], '2026-01-01T00:00:00.000');
      final back = ComfortRequestsFilterModel.fromJson(json).toEntity();
      expect(back.isEqualTo(entity), isTrue);

      final vazio = ComfortRequestsFilterModel.fromJson({}).toEntity();
      expect(vazio.status, isNull);
      expect(vazio.subcategories, isNull);
      expect(vazio.startDate, isNull);
      final semEnums = ComfortRequestsFilterModel.fromEntity(ComfortRequestsFilter());
      expect(semEnums.status, isNull);
      expect(semEnums.subcategories, isNull);
    });
  });

  group('ComfortReviewRequestModel', () {
    test('conversões', () {
      final model = ComfortReviewRequestModel.fromJson(
          {'request_id': 'r1', 'rating': 4, 'comment': 'bom'});
      expect(model.rating, 4.0);
      expect(model.toEntity().rating, 4.0);
      expect(model.toEntity().comment, 'bom');
      expect(ComfortReviewRequestModel.fromJson({}).toEntity().rating, 0.0);
      final fromEntity = ComfortReviewRequestModel.fromEntity(
          ComfortReviewRequest(requestId: 'x', rating: 2.5, comment: null));
      expect(fromEntity.toJson(), {'request_id': 'x', 'rating': 2.5, 'comment': null});
    });
  });

  group('ComfortSubcategoriesModel', () {
    test('conversões', () {
      final model = ComfortSubcategoriesModel.fromJson({'comfort_type': 'gym'});
      expect(model.toEntity().comfortType, ComfortType.gym);
      expect(model.toJson(), {'comfort_type': 'gym'});
      expect(ComfortSubcategoriesModel.fromJson({}).toEntity().comfortType,
          ComfortType.others);
      expect(
          ComfortSubcategoriesModel(comfortType: 'nada').toEntity().comfortType,
          ComfortType.others);
      expect(
          ComfortSubcategoriesModel.fromEntity(
                  ComfortSubcategories(comfortType: ComfortType.laundry))!
              .comfortType,
          'laundry');
      expect(ComfortSubcategoriesModel.fromEntity(ComfortSubcategories())!
          .comfortType, isNull);
      expect(ComfortSubcategoriesModel.fromEntity(null), isNull);
    });
  });

  group('RequestPartnersModel', () {
    test('conversões', () {
      final entity = RequestPartnersEntity(
          email: 'a@b.c', whatsapp: '11', phone: '22', partners: ['p1', 'p2']);
      final model = RequestPartnersModel.fromEntity(entity)!;
      expect(model.toJson(), {
        'email': 'a@b.c',
        'whatsapp': '11',
        'phone': '22',
        'partners': ['p1', 'p2'],
      });
      final back = RequestPartnersModel.fromJson(roundTrip(model.toJson())).toEntity();
      expect(back.partners, ['p1', 'p2']);
      expect(back.email, 'a@b.c');
      expect(RequestPartnersModel.fromJson({}).toEntity().partners, isNull);
      expect(RequestPartnersModel.fromEntity(null), isNull);
    });
  });
}
