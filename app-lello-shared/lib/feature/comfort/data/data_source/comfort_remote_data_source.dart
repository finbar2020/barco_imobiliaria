import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_paginated_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_coupon_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_coupon_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_favorite_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_review_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_request_purchase_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_review_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_subcategories_model.dart';
import 'package:shared_features/feature/comfort/data/model/request_partners_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

abstract class ComfortRemoteDataSource {
  Future<List<ComfortPartnerCouponModel>> getPartnerCoupons(
      String condominiumId, String partnerId);
  Future<List<ComfortPartnerModel>> getAllPartners(String condominiumId);
  Future<List<ComfortSubcategoriesModel>> getSubcategories(
      String condominiumId);
  Future<ComfortPartnerFavoriteModel> getPartnerIsFavorite(
      String condominiumId, String partnerId);
  Future<ComfortCompletedRequestPaginatedModel> getMyRequests(
      String condominiumId, int page, int pageSize, DateTime? startDate, DateTime? endDate, ComfortFilterRequestStatus? status, ComfortType? requestType);
  Future<ComfortPartnerFavoriteModel> changePartnerFavoriteStatus(
      String condominiumId, String partnerId, bool isFavorite);
  Future<ComfortCouponRequestModel> createCouponRequest(
      String condominiumId, String partnerId, String? couponId, String unitId);

  Future<ComfortReviewRequestModel> sendReviewRequest(String condominiumId,
      ComfortReviewRequestModel comfortReviewRequestModel);

  Future<ComfortRequestPurchaseModel> findRequestPurchase(
      String condominiumId, String requestId);

  Future<List<ComfortPartnerReviewModel>> getAllPartnerReviews(
      String condominiumId, String partnerId);

  Future<bool> requestPartners(
      String condominiumId, RequestPartnersModel request);

  Future<ComfortCompletedRequestModel> resendRequest(
      String condominiumId, String requestId);

  Future<ComfortCompletedRequestModel> cancelRequest(
      String condominiumId, String requestId);

  Future<ComfortCompletedRequestModel> updateRequest(String condominiumId,
      String requestId, ComfortCompletedRequestModel request);
}
