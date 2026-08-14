import 'package:chopper/chopper.dart';
import 'package:morar/feature/change_ownership/data/model/change_ownership_model.dart';

part 'change_ownership_api.chopper.dart';

@ChopperApi()
abstract class ChangeOwnershipApi extends ChopperService {
  @Post(path: "/condominiums/{id}/easyfix/change-ownership")
  //reference = reference do condominuim
  Future<Response> postChange(
    @Path("id") String condoId,
    @Body() ChangeOwnershipModel model,
  );

  @Get(path: "/condominiums/{id}/easyfix/aws-payload")
  Future<Response> getAwsPayload(
    @Path("id") String condoId,
  );

  @Get(path: "/condominiums/{id}/easyfix/can-change")
  Future<Response> getCanChange(
    @Path("id") String condoId,
  );

  static ChangeOwnershipApi create(ChopperClient client) {
    return _$ChangeOwnershipApi(client);
  }
}
