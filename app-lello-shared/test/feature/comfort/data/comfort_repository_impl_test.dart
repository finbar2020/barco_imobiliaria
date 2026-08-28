import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/repository/comfort_repository_impl.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/firebase_mocks.dart';
import '../comfort_core_fixtures.dart';

/// Integração: repositório real + data source real + API chopper real sobre
/// um HTTP falso. Erros passam pelo Crashlytics falso.
void main() {
  late FakeHttp http;
  late ComfortRepositoryImpl repository;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    http = FakeHttp();
    repository = ComfortRepositoryImpl(
      remoteDataSource: ComfortRemoteDataSourceImpl(
          api: ComfortApi.create(buildChopperClient(http))),
    );
  });

  void expectUnknownFailure(Try result) {
    expect(result, isA<Rejection>());
    expect((result as Rejection).get(), isA<UnknownFailure>());
  }

  group('getPartnerCoupons', () {
    test('monta o link da imagem de cada cupom', () async {
      http.on('GET', '/condominiums/C1/comfort/v2/Coupons/P1',
          body: [couponJson(id: 'c1'), couponJson(id: 'c2')]);
      final result = await repository.getPartnerCoupons('C1', 'P1');
      final coupons = (result as Success).get();
      expect(coupons.map((c) => c.imageLink), [
        '/condominiums/C1/comfort/coupon/c1/image/hashc1',
        '/condominiums/C1/comfort/coupon/c2/image/hashc2',
      ]);
    });

    test('falha vira UnknownFailure', () async {
      http.failAll();
      expectUnknownFailure(await repository.getPartnerCoupons('C1', 'P1'));
    });
  });

  group('getAllPartners', () {
    test('monta o link da imagem só de quem tem id e hash', () async {
      http.on('GET', '/condominiums/C1/comfort/v2', body: [
        partnerJson(id: 'p1', imageHash: 'h1'),
        partnerJson(id: 'p2', imageHash: ''),
        partnerJson(id: '', imageHash: 'h3'),
      ]);
      final result = await repository.getAllPartners('C1');
      final partners = (result as Success).get();
      expect(partners, hasLength(3));
      expect(partners[0].partnerIntro.partnerImageLink,
          '/condominiums/C1/comfort/p1/image/h1');
      expect(partners[1].partnerIntro.partnerImageLink, isNull);
      expect(partners[2].partnerIntro.partnerImageLink, isNull);
    });

    test('lista vazia', () async {
      http.on('GET', '/condominiums/C1/comfort/v2', body: []);
      expect((await repository.getAllPartners('C1') as Success).get(), isEmpty);
    });

    test('falha vira UnknownFailure', () async {
      http.failAll();
      expectUnknownFailure(await repository.getAllPartners('C1'));
    });
  });

  group('getPartnerIsFavorite / changePartnerFavoriteStatus', () {
    test('sucesso', () async {
      http.on('GET', '/condominiums/C1/comfort/favorite/P1', body: favoriteJson());
      http.on('PUT', '/condominiums/C1/comfort/favorite/P1',
          body: favoriteJson(isFavorite: false));
      final get = await repository.getPartnerIsFavorite('C1', 'P1');
      expect((get as Success).get().isFavorite, isTrue);
      final change = await repository.changePartnerFavoriteStatus('C1', 'P1', false);
      expect((change as Success).get().isFavorite, isFalse);
    });

    test('falhas', () async {
      http.failAll();
      expectUnknownFailure(await repository.getPartnerIsFavorite('C1', 'P1'));
      expectUnknownFailure(
          await repository.changePartnerFavoriteStatus('C1', 'P1', true));
    });
  });

  group('getMyRequests', () {
    test('monta o link da imagem do parceiro de cada solicitação', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2',
          body: myRequestsPageJson([
            completedRequestJson(id: 'r1', idPartner: 'p1', imageHash: 'h1'),
            completedRequestJson(id: 'r2', idPartner: '', imageHash: 'h2'),
            completedRequestJson(id: 'r3', idPartner: 'p3', imageHash: ''),
          ]));
      final result = await repository.getMyRequests('C1', 1, 10, null, null,
          ComfortFilterRequestStatus.all, ComfortType.all);
      final page = (result as Success).get();
      expect(page.meta.totalItems, 3);
      expect(page.data[0].partner.partnerIntro.partnerImageLink,
          '/condominiums/C1/comfort/p1/image/h1');
      expect(page.data[1].partner.partnerIntro.partnerImageLink, isNull);
      expect(page.data[2].partner.partnerIntro.partnerImageLink, isNull);
      expect(http.requests.single.url.queryParameters['status'], 'all');
    });

    test('página vazia', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2',
          body: myRequestsPageJson([]));
      final result = await repository.getMyRequests(
          'C1', 1, 10, null, null, null, null);
      expect((result as Success).get().data, isEmpty);
    });

    test('falha', () async {
      http.failAll();
      expectUnknownFailure(
          await repository.getMyRequests('C1', 1, 10, null, null, null, null));
    });
  });

  group('createCouponRequest', () {
    test('sucesso e falha', () async {
      http.on('POST', '/condominiums/C1/comfort/couponResponse',
          body: couponRequestJson());
      final result = await repository.createCouponRequest('C1', 'P1', 'CP', 'U1');
      final entity = (result as Success).get();
      expect(entity.idRequest, 'req1');
      expect(entity.headers, {'x-api': 'k'});
      expect(entity.callBack, 'cb');

      http.failAll();
      expectUnknownFailure(
          await repository.createCouponRequest('C1', 'P1', null, 'U1'));
    });
  });

  group('sendReviewRequest', () {
    test('converte a entidade e devolve a resposta', () async {
      http.on('PUT', '/condominiums/C1/comfort/myRequests/reviewRequest',
          body: {'request_id': 'R1', 'rating': 4.5, 'comment': 'bom'});
      final result = await repository.sendReviewRequest(
          'C1', ComfortReviewRequest(requestId: 'R1', rating: 4.5, comment: 'bom'));
      final entity = (result as Success).get();
      expect(entity.requestId, 'R1');
      expect(entity.rating, 4.5);
      expect(http.requests.single.body, contains('"request_id":"R1"'));
    });

    test('falha', () async {
      http.failAll();
      expectUnknownFailure(await repository.sendReviewRequest(
          'C1', ComfortReviewRequest(requestId: 'R1', rating: 1, comment: null)));
    });
  });

  group('findRequestPurchase', () {
    test('sucesso e falha', () async {
      http.on('GET', '/condominiums/C1/comfort/findPurchase/R1',
          body: requestPurchaseJson(purchaseDone: false));
      final result = await repository.findRequestPurchase('C1', 'R1');
      expect((result as Success).get().purchaseDone, isFalse);
      http.failAll();
      expectUnknownFailure(await repository.findRequestPurchase('C1', 'R1'));
    });
  });

  group('getAllPartnerReviews', () {
    test('ordena da mais recente para a mais antiga', () async {
      http.on('GET', '/condominiums/C1/comfort/allReviews/partner/P1', body: [
        reviewJson(name: 'antiga', date: '2026-01-01T00:00:00.000'),
        reviewJson(name: 'recente', date: '2026-03-01T00:00:00.000'),
        reviewJson(name: 'meio', date: '2026-02-01T00:00:00.000'),
      ]);
      final result = await repository.getAllPartnerReviews('C1', 'P1');
      expect((result as Success).get().map((e) => e.name),
          ['recente', 'meio', 'antiga']);
    });

    test('avaliações sem data mantêm a posição relativa', () async {
      http.on('GET', '/condominiums/C1/comfort/allReviews/partner/P1', body: [
        reviewJson(name: 'sem data', date: null),
        reviewJson(name: 'com data', date: '2026-03-01T00:00:00.000'),
      ]);
      final result = await repository.getAllPartnerReviews('C1', 'P1');
      final names = (result as Success).get().map((e) => e.name).toList();
      expect(names, hasLength(2));
      expect(names, containsAll(['sem data', 'com data']));
    });

    test('falha', () async {
      http.failAll();
      expectUnknownFailure(await repository.getAllPartnerReviews('C1', 'P1'));
    });
  });

  group('requestPartners', () {
    test('sucesso devolve true', () async {
      http.on('POST', '/condominiums/C1/comfort/requestPartners', body: {});
      final result = await repository.requestPartners(
          'C1', RequestPartnersEntity(email: 'a@b.c', partners: ['p1']));
      expect((result as Success).get(), isTrue);
    });

    test('falha vira UnknownFailure', () async {
      http.failAll();
      expectUnknownFailure(
          await repository.requestPartners('C1', RequestPartnersEntity()));
    });
  });

  group('resendRequest / cancelRequest / updateRequest', () {
    test('sucessos', () async {
      http.on('PUT', '/condominiums/C1/comfort/myRequests/resend/R1',
          body: completedRequestJson(status: 'resent'));
      http.on('DELETE', '/condominiums/C1/comfort/myRequests/cancel/R1',
          body: completedRequestJson(status: 'canceled'));
      http.on('POST', '/condominiums/C1/comfort/myRequests/update/R1',
          body: completedRequestJson(id: 'R1'));

      final resend = await repository.resendRequest('C1', 'R1');
      expect((resend as Success).get().status, ComfortRequestStatus.resent);
      final cancel = await repository.cancelRequest('C1', 'R1');
      expect((cancel as Success).get().status, ComfortRequestStatus.canceled);
      final update = await repository.updateRequest(
          'C1', 'R1', buildCompletedRequest(id: 'R1'));
      expect((update as Success).get().idRequest, 'R1');
      expect((update as Success).get().partner.category, ComfortPartnerCategory.toYourCondo);
    });

    test('falhas', () async {
      http.failAll();
      expectUnknownFailure(await repository.resendRequest('C1', 'R1'));
      expectUnknownFailure(await repository.cancelRequest('C1', 'R1'));
      expectUnknownFailure(
          await repository.updateRequest('C1', 'R1', buildCompletedRequest()));
    });
  });

  group('getSubcategories', () {
    test('sucesso converte para enum', () async {
      http.on('GET', '/condominiums/C1/comfort/myRequestsV2/listComfortServiceType',
          body: ['gym', 'inexistente']);
      final result = await repository.getSubcategories('C1');
      expect((result as Success).get().map((e) => e.comfortType),
          [ComfortType.gym, ComfortType.others]);
    });

    test('falha', () async {
      http.failAll();
      expectUnknownFailure(await repository.getSubcategories('C1'));
    });
  });
}
