import 'package:chopper/chopper.dart';

part 'nonpayments_api.chopper.dart';

@ChopperApi()
abstract class NonPaymentsApi extends ChopperService {
  @GET(path: "/condominiums/{id}/nonpayments/{period}")
  Future<Response> get(@Path() String id, @Path() String period);

  static NonPaymentsApi create(ChopperClient client) {
    return _$NonPaymentsApi(client);
  }
}
