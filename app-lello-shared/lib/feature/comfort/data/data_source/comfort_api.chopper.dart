// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ComfortApi extends ComfortApi {
  _$ComfortApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ComfortApi;

  @override
  Future<Response<dynamic>> getPartnerCoupons(
    String condominiumId,
    String partnerId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/v2/Coupons/${partnerId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllPartners(String condominiumId) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/comfort/v2');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPartnerIsFavorite(
    String condominiumId,
    String partnerId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/favorite/${partnerId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMyRequests(
    String condominiumId,
    int page,
    int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? requestType,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/comfort/myRequestsV2');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'requestType': requestType,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> findRequestPurchase(
    String condominiumId,
    String requestId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/findPurchase/${requestId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllPartnerReviews(
    String condominiumId,
    String partnerId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/allReviews/partner/${partnerId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getSubcategories(String condominiumId) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/myRequestsV2/listComfortServiceType');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> changePartnerFavoriteStatus(
    String condominiumId,
    String partnerId,
    bool isFavorite,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/favorite/${partnerId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'is_favorite': isFavorite
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postCreateCouponRequest(
    String condominiumId,
    String partnerId,
    String? couponId,
    String? unitId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/comfort/couponResponse');
    final Map<String, dynamic> $params = <String, dynamic>{
      'partner_id': partnerId,
      'coupon_id': couponId,
      'unit_id': unitId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendReviewRequest(
    String condominiumId,
    ComfortReviewRequestModel review,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/myRequests/reviewRequest');
    final $body = review;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> requestPartners(
    String condominiumId,
    RequestPartnersModel request,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/comfort/requestPartners');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> resendRequest(
    String condominiumId,
    String requestId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/myRequests/resend/${requestId}');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> cancelRequest(
    String condominiumId,
    String requestId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/myRequests/cancel/${requestId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateRequest(
    String condominiumId,
    String requestId,
    ComfortCompletedRequestModel upddatedRequest,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/comfort/myRequests/update/${requestId}');
    final $body = upddatedRequest;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
