import 'package:chopper/chopper.dart';
import 'package:lello/feature/payment/data/model/payment_approval_model.dart';
part 'payment_approval_api.chopper.dart';

@ChopperApi()
abstract class PaymentApprovalApi extends ChopperService {
  @POST(path: "/condominiums/{id}/payments/{paymentId}/approvals")
  Future<Response> post(@Path("id") String condominiumId,
      @Path("paymentId") String paymentId, @Body() PaymentApprovalModel body);

  static PaymentApprovalApi create(ChopperClient client) {
    return _$PaymentApprovalApi(client);
  }
}
