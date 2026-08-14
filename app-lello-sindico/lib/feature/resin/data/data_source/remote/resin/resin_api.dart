import 'package:chopper/chopper.dart';
import 'package:lello/feature/resin/data/model/resin_refund_dto_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';

part 'resin_api.chopper.dart';

@ChopperApi()
abstract class ResinApi extends ChopperService {
  @GET(path: "/condominiums/{id}/refunds/parameters")
  Future<Response> getResinParams(
    @Path() String id,
  );

  @GET(path: "/condominiums/{id}/refunds/people")
  Future<Response> getResinPeople(
    @Path() String id,
  );

  @GET(path: "/condominiums/{id}/refunds")
  Future<Response> getResinRefunds(
    @Path() String id, {
    @Query() DateTime? startDate,
    @Query() DateTime? endDate,
    @Query() String? protocol,
    @Query() String? status,
    @Query() String? inconsistency,
    @Query() String? type,
  });

  @POST(path: "/condominiums/{id}/refunds")
  Future<Response> createNewRefund(
      @Path() String id, @Body() ResinRefundDTOModel refund);

  @PUT(path: "/condominiums/{id}/refunds")
  Future<Response> refundEdit(
      @Path() String id, @Body() ResinRefundDTOModel refund);

  @GET(path: "/condominiums/{id}/refunds/{refundId}")
  Future<Response> getResinRefundDetails(
    @Path() String id,
    @Path() String refundId,
  );

  @POST(path: "/condominiums/{id}/refunds/{refundId}/receipt")
  Future<Response> uploadNewReceipt(@Path() String id, @Path() String refundId,
      @Body() ResinRefundReceiptModel receiptModel);

  @DELETE(path: "/condominiums/{id}/refunds/{refundId}")
  Future<Response> refundCancel(@Path() String id, @Path() String refundId);

  @GET(path: "/condominiums/{id}/refunds/CheckMaxValue")
  Future<Response> checkMaxValue(
    @Path() String id,
    @Query() String type,
    @Query() double value,
  );

  static ResinApi create(ChopperClient client) {
    return _$ResinApi(client);
  }
}
