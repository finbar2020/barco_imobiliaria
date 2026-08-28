import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_review_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/request_partners_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

import '../../../helpers/fake_http.dart';
import '../comfort_core_fixtures.dart';

void main() {
  late FakeHttp http;
  late ComfortRemoteDataSourceImpl dataSource;

  setUp(() {
    http = FakeHttp();
    dataSource = ComfortRemoteDataSourceImpl(
        api: ComfortApi.create(buildChopperClient(http)));
  });

  Map<String, dynamic> lastBody() =>
      jsonDecode(http.requests.single.body) as Map<String, dynamic>;

  group('getSubcategories', () {
    test('GET lista de strings vira modelos', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2/listComfortServiceType',
          body: ['cleaning', 'laundry']);
      final result = await dataSource.getSubcategories('C1');
      expect(result.map((e) => e.comfortType), ['cleaning', 'laundry']);
      expect(http.requests.single.method, 'GET');
    });

    test('resposta inesperada lança', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2/listComfortServiceType',
          body: {'nao': 'lista'});
      expect(() => dataSource.getSubcategories('C1'), throwsA(isA<TypeError>()));
    });
  });

  group('getPartnerCoupons', () {
    test('GET e mapeia a lista', () async {
      http.on('GET', '/condominiums/C1/comfort/v2/Coupons/P1',
          body: [couponJson(), couponJson(id: 'c2')]);
      final result = await dataSource.getPartnerCoupons('C1', 'P1');
      expect(result.map((e) => e.id), ['c1', 'c2']);
    });

    test('erro HTTP lança', () async {
      http.failAll();
      expect(() => dataSource.getPartnerCoupons('C1', 'P1'), throwsA(anything));
    });
  });

  group('getAllPartners', () {
    test('GET /comfort/v2', () async {
      http.on('GET', '/condominiums/C1/comfort/v2', body: [partnerJson()]);
      final result = await dataSource.getAllPartners('C1');
      expect(result.single.title, 'Parceiro 1');
      expect(http.requests.single.url.path, '/condominiums/C1/comfort/v2');
    });

    test('404 lança', () async {
      expect(() => dataSource.getAllPartners('C1'), throwsA(anything));
    });
  });

  group('getPartnerIsFavorite / changePartnerFavoriteStatus', () {
    test('GET favorito', () async {
      http.on('GET', '/condominiums/C1/comfort/favorite/P1', body: favoriteJson());
      final result = await dataSource.getPartnerIsFavorite('C1', 'P1');
      expect(result.isFavorite, isTrue);
    });

    test('PUT favorito com query is_favorite', () async {
      http.on('PUT', '/condominiums/C1/comfort/favorite/P1',
          body: favoriteJson(isFavorite: false));
      final result = await dataSource.changePartnerFavoriteStatus('C1', 'P1', false);
      expect(result.isFavorite, isFalse);
      final request = http.requests.single;
      expect(request.method, 'PUT');
      expect(request.url.queryParameters['is_favorite'], 'false');
    });

    test('erros lançam', () async {
      http.failAll();
      expect(() => dataSource.getPartnerIsFavorite('C1', 'P1'), throwsA(anything));
      expect(() => dataSource.changePartnerFavoriteStatus('C1', 'P1', true),
          throwsA(anything));
    });
  });

  group('getMyRequests', () {
    test('GET com paginação e filtros na query', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2',
          body: myRequestsPageJson([completedRequestJson()]));
      final result = await dataSource.getMyRequests(
          'C1',
          2,
          10,
          DateTime(2026, 1, 1),
          DateTime(2026, 1, 31),
          ComfortFilterRequestStatus.sended,
          ComfortType.cleaning);
      expect(result.data!.single.idRequest, 'r1');
      expect(result.meta!.totalItems, 1);
      final query = http.requests.single.url.queryParameters;
      expect(query['page'], '2');
      expect(query['pageSize'], '10');
      expect(query['status'], 'sended');
      expect(query['requestType'], 'cleaning');
      expect(query['startDate'], startsWith('2026-01-01'));
      expect(query['endDate'], startsWith('2026-01-31'));
    });

    test('filtros nulos não vão na query', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2',
          body: myRequestsPageJson([]));
      final result =
          await dataSource.getMyRequests('C1', 1, 5, null, null, null, null);
      expect(result.data, isEmpty);
      final query = http.requests.single.url.queryParameters;
      expect(query.keys, unorderedEquals(['page', 'pageSize']));
    });

    test('erro lança', () async {
      http.failAll();
      expect(() => dataSource.getMyRequests('C1', 1, 5, null, null, null, null),
          throwsA(anything));
    });
  });

  group('findRequestPurchase', () {
    test('GET findPurchase', () async {
      http.on('GET', '/condominiums/C1/comfort/findPurchase/R1',
          body: requestPurchaseJson());
      final result = await dataSource.findRequestPurchase('C1', 'R1');
      expect(result.requestId, 'r1');
      expect(result.purchaseDone, isTrue);
    });

    test('erro lança', () async {
      http.failAll();
      expect(() => dataSource.findRequestPurchase('C1', 'R1'), throwsA(anything));
    });
  });

  group('getAllPartnerReviews', () {
    test('GET allReviews', () async {
      http.on('GET', '/condominiums/C1/comfort/allReviews/partner/P1',
          body: [reviewJson(), reviewJson(name: 'João')]);
      final result = await dataSource.getAllPartnerReviews('C1', 'P1');
      expect(result.map((e) => e.name), ['Maria', 'João']);
    });

    test('erro lança', () async {
      http.failAll();
      expect(() => dataSource.getAllPartnerReviews('C1', 'P1'), throwsA(anything));
    });
  });

  group('createCouponRequest', () {
    test('POST couponResponse com partner_id, coupon_id e unit_id', () async {
      http.on('POST', '/condominiums/C1/comfort/couponResponse',
          body: couponRequestJson());
      final result = await dataSource.createCouponRequest('C1', 'P1', 'CP1', 'U1');
      expect(result.idRequest, 'req1');
      expect(result.params, hasLength(3));
      final request = http.requests.single;
      expect(request.method, 'POST');
      expect(request.url.queryParameters,
          {'partner_id': 'P1', 'coupon_id': 'CP1', 'unit_id': 'U1'});
    });

    test('sem cupom não envia coupon_id', () async {
      http.on('POST', '/condominiums/C1/comfort/couponResponse',
          body: couponRequestJson());
      await dataSource.createCouponRequest('C1', 'P1', null, 'U1');
      expect(http.requests.single.url.queryParameters.containsKey('coupon_id'),
          isFalse);
    });

    test('erro lança', () async {
      http.failAll();
      expect(() => dataSource.createCouponRequest('C1', 'P1', null, 'U1'),
          throwsA(anything));
    });
  });

  group('sendReviewRequest', () {
    test('PUT reviewRequest com o corpo do modelo', () async {
      http.on('PUT', '/condominiums/C1/comfort/myRequests/reviewRequest',
          body: {'request_id': 'R1', 'rating': 5, 'comment': 'top'});
      final result = await dataSource.sendReviewRequest(
          'C1', ComfortReviewRequestModel(requestId: 'R1', rating: 5, comment: 'top'));
      expect(result.requestId, 'R1');
      expect(result.rating, 5);
      expect(http.requests.single.method, 'PUT');
      expect(lastBody(), {'request_id': 'R1', 'rating': 5, 'comment': 'top'});
    });

    test('erro lança', () async {
      http.failAll();
      expect(
          () => dataSource.sendReviewRequest(
              'C1', ComfortReviewRequestModel(requestId: 'R1', rating: 5)),
          throwsA(anything));
    });
  });

  group('requestPartners', () {
    test('POST requestPartners devolve true no sucesso', () async {
      http.on('POST', '/condominiums/C1/comfort/requestPartners', body: {});
      final result = await dataSource.requestPartners(
          'C1', RequestPartnersModel(email: 'a@b.c', partners: ['p1']));
      expect(result, isTrue);
      expect(lastBody(), {
        'email': 'a@b.c',
        'whatsapp': null,
        'phone': null,
        'partners': ['p1'],
      });
    });

    test('falha lança o erro da resposta', () async {
      http.on('POST', '/condominiums/C1/comfort/requestPartners',
          status: 500, body: {'message': 'erro'});
      expect(() => dataSource.requestPartners('C1', RequestPartnersModel()),
          throwsA(anything));
    });
  });

  group('resendRequest / cancelRequest / updateRequest', () {
    test('PUT resend', () async {
      http.on('PUT', '/condominiums/C1/comfort/myRequests/resend/R1',
          body: completedRequestJson(status: 'resent'));
      final result = await dataSource.resendRequest('C1', 'R1');
      expect(result.status, 'resent');
      expect(http.requests.single.method, 'PUT');
    });

    test('DELETE cancel', () async {
      http.on('DELETE', '/condominiums/C1/comfort/myRequests/cancel/R1',
          body: completedRequestJson(status: 'canceled'));
      final result = await dataSource.cancelRequest('C1', 'R1');
      expect(result.status, 'canceled');
      expect(http.requests.single.method, 'DELETE');
    });

    test('POST update envia o modelo no corpo', () async {
      http.on('POST', '/condominiums/C1/comfort/myRequests/update/R1',
          body: completedRequestJson(id: 'R1'));
      final model = ComfortCompletedRequestModel.fromJson(completedRequestJson(id: 'R1'))
        ..comment = 'novo';
      final result = await dataSource.updateRequest('C1', 'R1', model);
      expect(result.idRequest, 'R1');
      expect(http.requests.single.method, 'POST');
      expect(lastBody()['comment'], 'novo');
      expect(lastBody()['partner']['id'], 'p1');
    });

    test('erros lançam', () async {
      http.failAll();
      expect(() => dataSource.resendRequest('C1', 'R1'), throwsA(anything));
      expect(() => dataSource.cancelRequest('C1', 'R1'), throwsA(anything));
      expect(
          () => dataSource.updateRequest('C1', 'R1', ComfortCompletedRequestModel()),
          throwsA(anything));
    });
  });
}
