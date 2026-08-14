import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_review_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/request_partners_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
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

class ComfortRepositoryImpl extends ComfortRepository {
  final ComfortRemoteDataSource remoteDataSource;

  ComfortRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<List<ComfortPartnerCoupon>>> getPartnerCoupons(
      String condominiumId, String partnerId) async {
    try {
      final result =
          await remoteDataSource.getPartnerCoupons(condominiumId, partnerId);
      List<ComfortPartnerCoupon> entity =
          result.map((model) => model.toEntity()).toList();
      entity.forEach((coupon) {
        coupon.imageLink =
            "/condominiums/$condominiumId/comfort/coupon/${coupon.id}/image/${coupon.imageHash}";
      });
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<ComfortPartner>>> getAllPartners(String condominiumId) async {
    try {
      final result = await remoteDataSource.getAllPartners(condominiumId);
      List<ComfortPartner> entity =
          result.map((model) => model.toEntity()).toList();
      if (entity.length > 0) {
        entity.forEach((partner) {
          if (partner.imageHash.isNotEmpty && partner.id.isNotEmpty) {
            partner.partnerIntro.partnerImageLink =
                "/condominiums/$condominiumId/comfort/${partner.id}/image/${partner.imageHash}";
          }
          //TODO: Verify if it's necessary to sort the coupons (é para ordenar por highlight na frente?)
          // List<ComfortPartnerCoupon?> highlightCoupons = partner.partnerCoupons
          //     .where((element) => element?.highlight == true)
          //     .toList();
          // List<ComfortPartnerCoupon?> commomCoupons = partner.partnerCoupons
          //     .where((element) => element?.highlight == false)
          //     .toList();
          // List<ComfortPartnerCoupon?> coupons = [];
          // coupons.addAll(highlightCoupons);
          // coupons.addAll(commomCoupons);
          // partner.partnerCoupons = coupons;
          // partner.partnerCoupons.forEach(
          //   (coupon) {
          //     if (coupon != null) {
          //       coupon.partnerId = partner.id;
          //       coupon.comfortType = partner.partnerIntro.comfortType;
          //       coupon.imageLink =
          //           "/condominiums/$condominiumId/comfort/coupon/${coupon.id}/image/${coupon.imageHash}";
          //     }
          //   },
          // );
        });
      }
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortPartnerFavorite>> getPartnerIsFavorite(
      String condominiumId, String partnerId) async {
    try {
      final result =
          await remoteDataSource.getPartnerIsFavorite(condominiumId, partnerId);
      ComfortPartnerFavorite entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortCompletedRequestPaginated>> getMyRequests(
      String condominiumId, int page, int pageSize, DateTime? startDate, DateTime? endDate, ComfortFilterRequestStatus? status, ComfortType? requestType) async {
    try {
      final result =
          await remoteDataSource.getMyRequests(condominiumId, page, pageSize, startDate, endDate, status, requestType);
      ComfortCompletedRequestPaginated entity = result.toEntity();
      if (entity.data.length > 0) {
        entity.data.forEach((request) {
          if (request.imageHash.isNotEmpty && request.idPartner.isNotEmpty) {
            request.partner.partnerIntro.partnerImageLink =
                "/condominiums/$condominiumId/comfort/${request.idPartner}/image/${request.imageHash}";
          }
        });
      }
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortPartnerFavorite>> changePartnerFavoriteStatus(
      String condominiumId, String partnerId, bool isFavorite) async {
    try {
      final result = await remoteDataSource.changePartnerFavoriteStatus(
          condominiumId, partnerId, isFavorite);
      ComfortPartnerFavorite entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: write',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortCouponRequest>> createCouponRequest(String condominiumId,
      String partnerId, String? couponId, String unitId) async {
    try {
      final result = await remoteDataSource.createCouponRequest(
          condominiumId, partnerId, couponId, unitId);
      ComfortCouponRequest entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: write',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortReviewRequest>> sendReviewRequest(
      String condominiumId, ComfortReviewRequest review) async {
    try {
      ComfortReviewRequestModel reviewModel =
          ComfortReviewRequestModel.fromEntity(review);
      final result =
          await remoteDataSource.sendReviewRequest(condominiumId, reviewModel);
      ComfortReviewRequest entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: write',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortRequestPurchase>> findRequestPurchase(
      String condominiumId, String requestId) async {
    try {
      final result =
          await remoteDataSource.findRequestPurchase(condominiumId, requestId);
      ComfortRequestPurchase entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<ComfortPartnerReview>>> getAllPartnerReviews(
      String condominiumId, String partnerId) async {
    try {
      final result =
          await remoteDataSource.getAllPartnerReviews(condominiumId, partnerId);
      List<ComfortPartnerReview> entity =
          result.map((e) => e.toEntity()).toList();
      entity.sort(
        (a, b) {
          if (a.reviewDate == null || b.reviewDate == null) {
            return 0;
          }
          return b.reviewDate!.compareTo(a.reviewDate!);
        },
      );
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> requestPartners(
      String condominiumId, RequestPartnersEntity request) async {
    try {
      RequestPartnersModel model = RequestPartnersModel.fromEntity(request)!;
      final result =
          await remoteDataSource.requestPartners(condominiumId, model);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortCompletedRequest>> resendRequest(
      String condominiumId, String requestId) async {
    try {
      final result =
          await remoteDataSource.resendRequest(condominiumId, requestId);
      ComfortCompletedRequest entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortCompletedRequest>> cancelRequest(
      String condominiumId, String requestId) async {
    try {
      final result =
          await remoteDataSource.cancelRequest(condominiumId, requestId);
      ComfortCompletedRequest entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ComfortCompletedRequest>> updateRequest(String condominiumId,
      String requestId, ComfortCompletedRequest request) async {
    try {
      ComfortCompletedRequestModel model =
          ComfortCompletedRequestModel.fromEntity(request)!;
      final result =
          await remoteDataSource.updateRequest(condominiumId, requestId, model);
      return Success(result.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<ComfortSubcategories>>> getSubcategories(
      String condominiumId) async {
    try {
      final result = await remoteDataSource.getSubcategories(condominiumId);
      List<ComfortSubcategories> entity =
          result.map((model) => model.toEntity()).toList();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
