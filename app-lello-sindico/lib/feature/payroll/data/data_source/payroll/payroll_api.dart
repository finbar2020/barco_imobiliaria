import 'package:chopper/chopper.dart';
part 'payroll_api.chopper.dart';

@ChopperApi()
abstract class PayrollApi extends ChopperService {
  @GET(path: "/condominiums/{id}/payrolls")
  Future<Response> list(@Path() String id);

  @GET(path: "/condominiums/{id}/payrolls/{period}")
  Future<Response> get(@Path() String id, @Path() String period);

  static PayrollApi create(ChopperClient client) {
    return _$PayrollApi(client);
  }
}
