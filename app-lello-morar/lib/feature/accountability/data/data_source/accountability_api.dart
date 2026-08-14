import 'package:chopper/chopper.dart';

part 'accountability_api.chopper.dart';

@ChopperApi()
abstract class AccountabilityApi extends ChopperService {
  @Get(path: "/accountabilities/{id}/{period}/grouped")
  Future<Response> get(
      @Path("id") String condominiumId, @Path("period") String period);

  @Get(path: "/accountabilities/{id}")
  Future<Response> getPeriod(@Path("id") String condominiumId);

  static AccountabilityApi create(ChopperClient client) {
    return _$AccountabilityApi(client);
  }
}
