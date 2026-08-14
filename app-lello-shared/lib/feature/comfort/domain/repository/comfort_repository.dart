import 'package:essentials/essentials.dart';
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

abstract class ComfortRepository {
  Future<Try<List<ComfortSubcategories>>> getSubcategories(
      String condominiumId);
  Future<Try<List<ComfortPartnerCoupon>>> getPartnerCoupons(
      String condominiumId, String partnerId);
  Future<Try<List<ComfortPartner>>> getAllPartners(String condominiumId);
  Future<Try<ComfortCompletedRequestPaginated>> getMyRequests(
      String condominiumId, int page, int pageSize, DateTime? startDate, DateTime? endDate, ComfortFilterRequestStatus? status, ComfortType? requestType);
  Future<Try<ComfortPartnerFavorite>> getPartnerIsFavorite(
      String condominiumId, String partnerId);
  Future<Try<ComfortPartnerFavorite>> changePartnerFavoriteStatus(
      String condominiumId, String partnerId, bool isFavorite);
  Future<Try<ComfortCouponRequest>> createCouponRequest(
      String condominiumId, String partnerId, String? couponId, String unitId);
  Future<Try<ComfortReviewRequest>> sendReviewRequest(
      String condominiumId, ComfortReviewRequest review);
  Future<Try<ComfortRequestPurchase>> findRequestPurchase(
      String condominiumId, String requestId);
  Future<Try<List<ComfortPartnerReview>>> getAllPartnerReviews(
      String condominiumId, String partnerId);
  Future<Try<bool>> requestPartners(
      String condominiumId, RequestPartnersEntity request);
  Future<Try<ComfortCompletedRequest>> resendRequest(
      String condominiumId, String requestId);
  Future<Try<ComfortCompletedRequest>> cancelRequest(
      String condominiumId, String requestId);
  Future<Try<ComfortCompletedRequest>> updateRequest(
      String condominiumId, String requestId, ComfortCompletedRequest request);
}
