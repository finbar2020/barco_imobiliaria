import 'package:chopper/chopper.dart';
import 'package:lello/feature/space/registration/data/model/space_registration_request_model.dart';
part 'space_registration_request_api.chopper.dart';

@ChopperApi()
abstract class SpaceRegistrationRequestApi extends ChopperService {
  @POST(path: "/condominiums/{id}/space-requests")
  Future<Response> post(@Path("id") String condominiumId,
      @Body() SpaceRegistrationRequestModel model);

  static SpaceRegistrationRequestApi create(ChopperClient client) {
    return _$SpaceRegistrationRequestApi(client);
  }
}
