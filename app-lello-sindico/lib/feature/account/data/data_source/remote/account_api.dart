import 'package:chopper/chopper.dart';
part 'account_api.chopper.dart';

@ChopperApi()
abstract class AccountApi extends ChopperService {
  @GET(path: "/condominiums/{id}/accounts")
  Future<Response> get(@Path() String id);

  static AccountApi create(ChopperClient client) {
    return _$AccountApi(client);
  }
}
