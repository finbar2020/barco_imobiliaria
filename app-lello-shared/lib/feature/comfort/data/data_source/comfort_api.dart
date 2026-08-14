import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_review_request_model.dart';
import 'package:shared_features/feature/comfort/data/model/request_partners_model.dart';
part 'comfort_api.chopper.dart';

@ChopperApi()
abstract class ComfortApi extends ChopperService {
  @Get(path: "/condominiums/{condo_id}/comfort/v2/Coupons/{partner_id}")
  Future<Response> getPartnerCoupons(
    @Path("condo_id") String condominiumId,
    @Path("partner_id") String partnerId,
  );

  @Get(path: "/condominiums/{condo_id}/comfort/v2")
  Future<Response> getAllPartners(
    @Path("condo_id") String condominiumId,
  );

  @Get(path: "/condominiums/{condo_id}/comfort/favorite/{partner_id}")
  Future<Response> getPartnerIsFavorite(
    @Path("condo_id") String condominiumId,
    @Path("partner_id") String partnerId,
  );

  @Get(path: "/condominiums/{condo_id}/comfort/myRequestsV2")
  Future<Response> getMyRequests(
    @Path("condo_id") String condominiumId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("startDate") DateTime? startDate,
    @Query("endDate") DateTime? endDate,
    @Query("status") String? status,
    @Query("requestType") String? requestType
  );

  @Get(path: "/condominiums/{condo_id}/comfort/findPurchase/{request_id}")
  Future<Response> findRequestPurchase(
    @Path("condo_id") String condominiumId,
    @Path("request_id") String requestId,
  );

  @Get(path: "/condominiums/{condo_id}/comfort/allReviews/partner/{partner_id}")
  Future<Response> getAllPartnerReviews(
    @Path("condo_id") String condominiumId,
    @Path("partner_id") String partnerId,
  );

  @Get(
      path:
          "/condominiums/{condo_id}/comfort/myRequestsV2/listComfortServiceType")
  Future<Response> getSubcategories(@Path("condo_id") String condominiumId);

  @Put(path: "/condominiums/{condo_id}/comfort/favorite/{partner_id}")
  Future<Response> changePartnerFavoriteStatus(
    @Path("condo_id") String condominiumId,
    @Path("partner_id") String partnerId,
    @Query("is_favorite") bool isFavorite,
  );

  @Post(
      path: "/condominiums/{condo_id}/comfort/couponResponse",
      optionalBody: true)
  Future<Response> postCreateCouponRequest(
    @Path("condo_id") String condominiumId,
    @Query("partner_id") String partnerId,
    @Query("coupon_id") String? couponId,
    @Query("unit_id") String? unitId,
  );

  @Put(path: "/condominiums/{condo_id}/comfort/myRequests/reviewRequest")
  Future<Response> sendReviewRequest(
    @Path("condo_id") String condominiumId,
    @Body() ComfortReviewRequestModel review,
  );

  @Post(
      path: "/condominiums/{condo_id}/comfort/requestPartners",
      optionalBody: true)
  Future<Response> requestPartners(
    @Path("condo_id") String condominiumId,
    @Body() RequestPartnersModel request,
  );

  @Put(path: "/condominiums/{condo_id}/comfort/myRequests/resend/{request_id}")
  Future<Response> resendRequest(
    @Path("condo_id") String condominiumId,
    @Path("request_id") String requestId,
  );

  @Delete(
      path: "/condominiums/{condo_id}/comfort/myRequests/cancel/{request_id}")
  Future<Response> cancelRequest(
    @Path("condo_id") String condominiumId,
    @Path("request_id") String requestId,
  );

  @Post(path: "/condominiums/{condo_id}/comfort/myRequests/update/{request_id}")
  Future<Response> updateRequest(
    @Path("condo_id") String condominiumId,
    @Path("request_id") String requestId,
    @Body() ComfortCompletedRequestModel upddatedRequest,
  );

  static ComfortApi create(ChopperClient client) {
    return _$ComfortApi(client);
  }
}
