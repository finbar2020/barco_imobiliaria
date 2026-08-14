import 'package:chopper/chopper.dart';

part 'insurance_api.chopper.dart';

@ChopperApi()
abstract class InsuranceApi extends ChopperService {
  @Get(path: "/{service_id}/file/{hash}")
  Future<Response> getImage(
    @Path("service_id") String serviceId,
    @Path("hash") String hash,
  );

  @Get(path: "/insurance/{unit_id}")
  Future<Response> getInsurance(
    @Path("unit_id") String unitId,
  );

  @Post(path: "/insurance/{unit_id}")
  Future<Response> postInsurance(
    @Path("unit_id") String unitId,
  );

  static InsuranceApi create(ChopperClient client) {
    return _$InsuranceApi(client);
  }
}
