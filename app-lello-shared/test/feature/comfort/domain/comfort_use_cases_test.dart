import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request_impl.dart';

import '../comfort_core_fixtures.dart';

/// Repositório falso que registra a última chamada (nome + argumentos) e
/// devolve sucesso ou, se [fail] for verdadeiro, rejeição.
class _FakeRepository extends Fake implements ComfortRepository {
  bool fail = false;
  String? lastCall;
  List<Object?> lastArgs = [];

  final failure = UnknownFailure('boom');

  Future<Try<T>> _answer<T>(String name, List<Object?> args, T value) async {
    lastCall = name;
    lastArgs = args;
    if (fail) return Rejection(failure);
    return Success(value);
  }

  @override
  Future<Try<List<ComfortSubcategories>>> getSubcategories(String condominiumId) =>
      _answer('getSubcategories', [condominiumId],
          [ComfortSubcategories(comfortType: ComfortType.gym)]);

  @override
  Future<Try<List<ComfortPartnerCoupon>>> getPartnerCoupons(
          String condominiumId, String partnerId) =>
      _answer('getPartnerCoupons', [condominiumId, partnerId], [buildCoupon()]);

  @override
  Future<Try<List<ComfortPartner>>> getAllPartners(String condominiumId) =>
      _answer('getAllPartners', [condominiumId], [buildPartner()]);

  @override
  Future<Try<ComfortCompletedRequestPaginated>> getMyRequests(
          String condominiumId,
          int page,
          int pageSize,
          DateTime? startDate,
          DateTime? endDate,
          ComfortFilterRequestStatus? status,
          ComfortType? requestType) =>
      _answer(
          'getMyRequests',
          [condominiumId, page, pageSize, startDate, endDate, status, requestType],
          ComfortCompletedRequestPaginated(
              meta: Meta(totalItems: 1), data: [buildCompletedRequest()]));

  @override
  Future<Try<ComfortPartnerFavorite>> getPartnerIsFavorite(
          String condominiumId, String partnerId) =>
      _answer('getPartnerIsFavorite', [condominiumId, partnerId],
          ComfortPartnerFavorite(comfortOwnerId: 'o', isFavorite: true));

  @override
  Future<Try<ComfortPartnerFavorite>> changePartnerFavoriteStatus(
          String condominiumId, String partnerId, bool isFavorite) =>
      _answer('changePartnerFavoriteStatus', [condominiumId, partnerId, isFavorite],
          ComfortPartnerFavorite(comfortOwnerId: 'o', isFavorite: isFavorite));

  @override
  Future<Try<ComfortCouponRequest>> createCouponRequest(String condominiumId,
          String partnerId, String? couponId, String unitId) =>
      _answer(
          'createCouponRequest',
          [condominiumId, partnerId, couponId, unitId],
          ComfortCouponRequest(
              idRequest: 'req',
              params: [],
              linkRedirectPartner: '',
              redirectExternal: false,
              cta: ComfortCTA.cupom));

  @override
  Future<Try<ComfortReviewRequest>> sendReviewRequest(
          String condominiumId, ComfortReviewRequest review) =>
      _answer('sendReviewRequest', [condominiumId, review], review);

  @override
  Future<Try<ComfortRequestPurchase>> findRequestPurchase(
          String condominiumId, String requestId) =>
      _answer(
          'findRequestPurchase',
          [condominiumId, requestId],
          ComfortRequestPurchase(
              requestId: requestId, userId: 'u', unitId: 'un', purchaseDone: true));

  @override
  Future<Try<List<ComfortPartnerReview>>> getAllPartnerReviews(
          String condominiumId, String partnerId) =>
      _answer('getAllPartnerReviews', [condominiumId, partnerId],
          [ComfortPartnerReview(review: 5)]);

  @override
  Future<Try<bool>> requestPartners(
          String condominiumId, RequestPartnersEntity request) =>
      _answer('requestPartners', [condominiumId, request], true);

  @override
  Future<Try<ComfortCompletedRequest>> resendRequest(
          String condominiumId, String requestId) =>
      _answer('resendRequest', [condominiumId, requestId],
          buildCompletedRequest(id: requestId));

  @override
  Future<Try<ComfortCompletedRequest>> cancelRequest(
          String condominiumId, String requestId) =>
      _answer('cancelRequest', [condominiumId, requestId],
          buildCompletedRequest(id: requestId));

  @override
  Future<Try<ComfortCompletedRequest>> updateRequest(String condominiumId,
          String requestId, ComfortCompletedRequest request) =>
      _answer('updateRequest', [condominiumId, requestId, request], request);
}

void main() {
  late _FakeRepository repo;

  setUp(() {
    repo = _FakeRepository();
  });

  /// Garante que a rejeição é de parâmetro inválido e que o repositório
  /// não foi chamado.
  void expectInvalidParam(Try result) {
    expect(result, isA<Rejection>());
    expect((result as Rejection).get(), isA<InvalidParamFailure>());
    expect(repo.lastCall, isNull);
  }

  group('CancelRequestUseCase', () {
    late CancelRequestUseCaseImpl useCase;
    setUp(() => useCase = CancelRequestUseCaseImpl(repository: repo));

    test('delega ao repositório e devolve a solicitação', () async {
      final result = await useCase(
          CancelRequestParam(condominiumId: 'C1', requestId: 'R1'));
      expect(repo.lastCall, 'cancelRequest');
      expect(repo.lastArgs, ['C1', 'R1']);
      expect((result as Success).get().idRequest, 'R1');
    });

    test('rejeita condomínio ou solicitação vazios', () async {
      expectInvalidParam(await useCase(
          CancelRequestParam(condominiumId: '', requestId: 'R1')));
      expectInvalidParam(await useCase(
          CancelRequestParam(condominiumId: 'C1', requestId: '')));
    });

    test('propaga a rejeição do repositório', () async {
      repo.fail = true;
      final result = await useCase(
          CancelRequestParam(condominiumId: 'C1', requestId: 'R1'));
      expect((result as Rejection).get(), repo.failure);
    });
  });

  group('ChangePartnerFavoriteStatusUseCase', () {
    late ChangePartnerFavoriteStatusUseCaseImpl useCase;
    setUp(() =>
        useCase = ChangePartnerFavoriteStatusUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(ChangePartnerFavoriteStatusParam(
          condominiumId: 'C1', partnerId: 'P1', isFavorite: true));
      expect(repo.lastCall, 'changePartnerFavoriteStatus');
      expect(repo.lastArgs, ['C1', 'P1', true]);
      expect((result as Success).get().isFavorite, isTrue);
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(ChangePartnerFavoriteStatusParam(
          condominiumId: '', partnerId: 'P1', isFavorite: true)));
      expectInvalidParam(await useCase(ChangePartnerFavoriteStatusParam(
          condominiumId: 'C1', partnerId: '', isFavorite: false)));
    });
  });

  group('CreateCouponRequestUseCase', () {
    late CreateCouponRequestUseCaseImpl useCase;
    setUp(() => useCase = CreateCouponRequestUseCaseImpl(repository: repo));

    test('delega ao repositório (cupom e unidade opcionais)', () async {
      final result = await useCase(CreateCouponRequestUseCaseParam(
          condominiumId: 'C1', partnerId: 'P1', unitId: 'U1', couponId: 'CP'));
      expect(repo.lastCall, 'createCouponRequest');
      expect(repo.lastArgs, ['C1', 'P1', 'CP', 'U1']);
      expect((result as Success).get().idRequest, 'req');

      final semCupom = await useCase(CreateCouponRequestUseCaseParam(
          condominiumId: 'C1', partnerId: 'P1', unitId: ''));
      expect(repo.lastArgs, ['C1', 'P1', null, '']);
      expect(semCupom, isA<Success>());
    });

    test('valida condomínio e parceiro', () async {
      expectInvalidParam(await useCase(CreateCouponRequestUseCaseParam(
          condominiumId: '', partnerId: 'P1', unitId: 'U1')));
      expectInvalidParam(await useCase(CreateCouponRequestUseCaseParam(
          condominiumId: 'C1', partnerId: '', unitId: 'U1')));
    });
  });

  group('FindRequestPurchaseUseCase', () {
    late FindRequestPurchaseUseCaseImpl useCase;
    setUp(() => useCase = FindRequestPurchaseUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(
          FindRequestPurchaseParam(condominiumId: 'C1', requestId: 'R1'));
      expect(repo.lastArgs, ['C1', 'R1']);
      expect((result as Success).get().requestId, 'R1');
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(
          FindRequestPurchaseParam(condominiumId: '', requestId: 'R1')));
      expectInvalidParam(await useCase(
          FindRequestPurchaseParam(condominiumId: 'C1', requestId: '')));
    });
  });

  group('GetAllPartnerReviewsUseCase', () {
    late GetAllPartnerReviewsUseCaseImpl useCase;
    setUp(() => useCase = GetAllPartnerReviewsUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(
          GetAllPartnerReviewsParam(condominiumId: 'C1', partnerId: 'P1'));
      expect(repo.lastCall, 'getAllPartnerReviews');
      expect((result as Success).get(), hasLength(1));
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(
          GetAllPartnerReviewsParam(condominiumId: '', partnerId: 'P1')));
      expectInvalidParam(await useCase(
          GetAllPartnerReviewsParam(condominiumId: 'C1', partnerId: '')));
    });
  });

  group('GetAllPartnersUseCase', () {
    late GetAllPartnersUseCaseImpl useCase;
    setUp(() => useCase = GetAllPartnersUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(GetAllPartnersParam(condominiumId: 'C1'));
      expect(repo.lastArgs, ['C1']);
      expect((result as Success).get().single.id, 'p1');
    });

    test('valida o condomínio e propaga falha', () async {
      expectInvalidParam(await useCase(GetAllPartnersParam(condominiumId: '')));
      repo.fail = true;
      expect(await useCase(GetAllPartnersParam(condominiumId: 'C1')),
          isA<Rejection>());
    });
  });

  group('GetMyRequestsUseCase', () {
    late GetMyRequestsUseCaseImpl useCase;
    setUp(() => useCase = GetMyRequestsUseCaseImpl(repository: repo));

    test('repassa paginação e filtros', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 31);
      final result = await useCase(GetMyRequestsUseCaseParam(
          condominiumId: 'C1',
          page: 2,
          pageSize: 10,
          startDate: start,
          endDate: end,
          status: ComfortFilterRequestStatus.sended,
          requestType: ComfortType.cleaning));
      expect(repo.lastCall, 'getMyRequests');
      expect(repo.lastArgs, [
        'C1',
        2,
        10,
        start,
        end,
        ComfortFilterRequestStatus.sended,
        ComfortType.cleaning
      ]);
      expect((result as Success).get().data, hasLength(1));
    });

    test('filtros são opcionais', () async {
      await useCase(
          GetMyRequestsUseCaseParam(condominiumId: 'C1', page: 1, pageSize: 5));
      expect(repo.lastArgs, ['C1', 1, 5, null, null, null, null]);
    });

    test('rejeita condomínio vazio, página 0 e tamanho 0', () async {
      expectInvalidParam(await useCase(
          GetMyRequestsUseCaseParam(condominiumId: '', page: 1, pageSize: 5)));
      expectInvalidParam(await useCase(
          GetMyRequestsUseCaseParam(condominiumId: 'C1', page: 0, pageSize: 5)));
      expectInvalidParam(await useCase(
          GetMyRequestsUseCaseParam(condominiumId: 'C1', page: 1, pageSize: 0)));
    });
  });

  group('GetPartnerCouponsUseCase', () {
    late GetPartnerCouponsUseCaseImpl useCase;
    setUp(() => useCase = GetPartnerCouponsUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(
          GetPartnerCouponsParam(condominiumId: 'C1', partnerId: 'P1'));
      expect(repo.lastArgs, ['C1', 'P1']);
      expect((result as Success).get().single.id, 'c1');
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(
          GetPartnerCouponsParam(condominiumId: '', partnerId: 'P1')));
      expectInvalidParam(await useCase(
          GetPartnerCouponsParam(condominiumId: 'C1', partnerId: '')));
    });
  });

  group('GetPartnerIsFavoriteUseCase', () {
    late GetPartnerIsFavoriteUseCaseImpl useCase;
    setUp(() => useCase = GetPartnerIsFavoriteUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(
          GetPartnerIsFavoriteParam(condominiumId: 'C1', partnerId: 'P1'));
      expect(repo.lastCall, 'getPartnerIsFavorite');
      expect((result as Success).get().isFavorite, isTrue);
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(
          GetPartnerIsFavoriteParam(condominiumId: '', partnerId: 'P1')));
      expectInvalidParam(await useCase(
          GetPartnerIsFavoriteParam(condominiumId: 'C1', partnerId: '')));
    });
  });

  group('GetSubcategoriesUseCase', () {
    late GetSubcategoriesUseCaseImpl useCase;
    setUp(() => useCase = GetSubcategoriesUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result =
          await useCase(GetSubcategoriesUseCaseParam(condominiumId: 'C1'));
      expect(repo.lastArgs, ['C1']);
      expect((result as Success).get().single.comfortType, ComfortType.gym);
    });

    test('valida o condomínio', () async {
      expectInvalidParam(
          await useCase(GetSubcategoriesUseCaseParam(condominiumId: '')));
    });
  });

  group('RequestPartnersUseCase', () {
    late RequestPartnersUseCaseImpl useCase;
    setUp(() => useCase = RequestPartnersUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final request = RequestPartnersEntity(email: 'a@b.c', partners: ['p1']);
      final result = await useCase(
          RequestPartnersUseCaseParam(condominiumId: 'C1', request: request));
      expect(repo.lastArgs, ['C1', request]);
      expect((result as Success).get(), isTrue);
    });

    test('valida o condomínio', () async {
      expectInvalidParam(await useCase(RequestPartnersUseCaseParam(
          condominiumId: '', request: RequestPartnersEntity())));
    });
  });

  group('ResendRequestUseCase', () {
    late ResendRequestUseCaseImpl useCase;
    setUp(() => useCase = ResendRequestUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final result = await useCase(
          ResendRequestParam(condominiumId: 'C1', requestId: 'R9'));
      expect(repo.lastCall, 'resendRequest');
      expect((result as Success).get().idRequest, 'R9');
    });

    test('valida os parâmetros', () async {
      expectInvalidParam(await useCase(
          ResendRequestParam(condominiumId: '', requestId: 'R1')));
      expectInvalidParam(await useCase(
          ResendRequestParam(condominiumId: 'C1', requestId: '')));
    });
  });

  group('SendReviewRequestUseCase', () {
    late SendReviewRequestUseCaseImpl useCase;
    setUp(() => useCase = SendReviewRequestUseCaseImpl(repository: repo));

    ComfortReviewRequest review({String id = 'R1', double rating = 4}) =>
        ComfortReviewRequest(requestId: id, rating: rating, comment: 'ok');

    test('delega ao repositório', () async {
      final r = review();
      final result = await useCase(
          SendReviewRequestParam(condominiumId: 'C1', review: r));
      expect(repo.lastArgs, ['C1', r]);
      expect((result as Success).get(), r);
    });

    test('aceita as notas limite 0 e 5', () async {
      expect(
          await useCase(SendReviewRequestParam(
              condominiumId: 'C1', review: review(rating: 0))),
          isA<Success>());
      expect(
          await useCase(SendReviewRequestParam(
              condominiumId: 'C1', review: review(rating: 5))),
          isA<Success>());
    });

    test('rejeita condomínio vazio, solicitação vazia e nota fora de 0..5',
        () async {
      expectInvalidParam(await useCase(
          SendReviewRequestParam(condominiumId: '', review: review())));
      expectInvalidParam(await useCase(SendReviewRequestParam(
          condominiumId: 'C1', review: review(id: ''))));
      expectInvalidParam(await useCase(SendReviewRequestParam(
          condominiumId: 'C1', review: review(rating: -1))));
      expectInvalidParam(await useCase(SendReviewRequestParam(
          condominiumId: 'C1', review: review(rating: 5.5))));
    });
  });

  group('UpdateRequestUseCase', () {
    late UpdateRequestUseCaseImpl useCase;
    setUp(() => useCase = UpdateRequestUseCaseImpl(repository: repo));

    test('delega ao repositório', () async {
      final request = buildCompletedRequest(id: 'R1');
      final result = await useCase(UpdateRequestParam(
          condominiumId: 'C1', requestId: 'R1', request: request));
      expect(repo.lastArgs, ['C1', 'R1', request]);
      expect((result as Success).get(), request);
    });

    test('valida os parâmetros', () async {
      final request = buildCompletedRequest();
      expectInvalidParam(await useCase(UpdateRequestParam(
          condominiumId: '', requestId: 'R1', request: request)));
      expectInvalidParam(await useCase(UpdateRequestParam(
          condominiumId: 'C1', requestId: '', request: request)));
    });
  });
}
