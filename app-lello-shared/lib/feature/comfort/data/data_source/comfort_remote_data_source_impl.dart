import 'dart:convert';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source.dart';
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

class ComfortRemoteDataSourceImpl extends ComfortRemoteDataSource {
  final ComfortApi api;
  ComfortRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ComfortSubcategoriesModel>> getSubcategories(String condominiumId) async {
    final response = await api.getSubcategories(condominiumId);
    final List<dynamic> subcategories = jsonDecode(response.bodyString) as List<dynamic>;
    final List<ComfortSubcategoriesModel> result = subcategories.map((item) => 
        ComfortSubcategoriesModel(
          comfortType: item as String
        )).toList();

    return result;
  }

  @override
  Future<List<ComfortPartnerCouponModel>> getPartnerCoupons(
      String condominiumId, String partnerId) async {
    final response = await api.getPartnerCoupons(condominiumId, partnerId);
    final result = ApiMapper.mapList(
        response, (json) => ComfortPartnerCouponModel.fromJson(json));
    return result;
  }

  @override
  Future<List<ComfortPartnerModel>> getAllPartners(String condominiumId) async {
    final response = await api.getAllPartners(condominiumId);
    final result = ApiMapper.mapList(
        response, (json) => ComfortPartnerModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortPartnerFavoriteModel> getPartnerIsFavorite(
      String condominiumId, String partnerId) async {
    final response = await api.getPartnerIsFavorite(condominiumId, partnerId);
    final result = ApiMapper.map(
        response, (json) => ComfortPartnerFavoriteModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortCompletedRequestPaginatedModel> getMyRequests(
      String condominiumId, int page, int pageSize, DateTime? startDate, DateTime? endDate, ComfortFilterRequestStatus? status, ComfortType? requestType) async {
    final response = await api.getMyRequests(condominiumId, page, pageSize, startDate, endDate, enumToString(status), enumToString(requestType));
    final result = ApiMapper.map(response,
        (json) => ComfortCompletedRequestPaginatedModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortPartnerFavoriteModel> changePartnerFavoriteStatus(
      String condominiumId, String partnerId, bool isFavorite) async {
    final response = await api.changePartnerFavoriteStatus(
        condominiumId, partnerId, isFavorite);
    final result = ApiMapper.map(
        response, (json) => ComfortPartnerFavoriteModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortCouponRequestModel> createCouponRequest(String condominiumId,
      String partnerId, String? couponId, String unitId) async {
    final response = await api.postCreateCouponRequest(
        condominiumId, partnerId, couponId, unitId);
    final result = ApiMapper.map(
        response, (json) => ComfortCouponRequestModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortReviewRequestModel> sendReviewRequest(
      String condominiumId, ComfortReviewRequestModel review) async {
    final response = await api.sendReviewRequest(condominiumId, review);
    final result = ApiMapper.map(
        response, (json) => ComfortReviewRequestModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortRequestPurchaseModel> findRequestPurchase(
      String condominiumId, String requestId) async {
    final response = await api.findRequestPurchase(condominiumId, requestId);
    final result = ApiMapper.map(
        response, (json) => ComfortRequestPurchaseModel.fromJson(json));
    return result;
  }

  @override
  Future<List<ComfortPartnerReviewModel>> getAllPartnerReviews(
      String condominiumId, String partnerId) async {
    final response = await api.getAllPartnerReviews(condominiumId, partnerId);
    final result = ApiMapper.mapList(
        response, (json) => ComfortPartnerReviewModel.fromJson(json));
    return result;
  }

  @override
  Future<bool> requestPartners(
      String condominiumId, RequestPartnersModel request) async {
    final response = await api.requestPartners(condominiumId, request);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error ?? "";
    } else {
      return true;
    }
  }

  @override
  Future<ComfortCompletedRequestModel> resendRequest(
      String condominiumId, String requestId) async {
    final response = await api.resendRequest(condominiumId, requestId);
    final result = ApiMapper.map(
        response, (json) => ComfortCompletedRequestModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortCompletedRequestModel> cancelRequest(
      String condominiumId, String requestId) async {
    final response = await api.cancelRequest(condominiumId, requestId);
    final result = ApiMapper.map(
        response, (json) => ComfortCompletedRequestModel.fromJson(json));
    return result;
  }

  @override
  Future<ComfortCompletedRequestModel> updateRequest(String condominiumId,
      String requestId, ComfortCompletedRequestModel request) async {
    final response = await api.updateRequest(condominiumId, requestId, request);
    final result = ApiMapper.map(
        response, (json) => ComfortCompletedRequestModel.fromJson(json));
    return result;
  }
}
