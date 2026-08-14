import 'package:chopper/chopper.dart';
part 'income_api.chopper.dart';

@ChopperApi()
abstract class IncomeApi extends ChopperService {
  @GET(path: "/condominiums/{id}/incomes/{period}")
  Future<Response> get(@Path() String id, @Path() String period);

  static IncomeApi create(ChopperClient client) {
    return _$IncomeApi(client);
  }
}
