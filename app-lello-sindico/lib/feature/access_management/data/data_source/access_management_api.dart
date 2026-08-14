import 'package:chopper/chopper.dart';
import 'package:lello/feature/access_management/data/model/access_management_send_invite_model.dart';

part 'access_management_api.chopper.dart';

@ChopperApi()
abstract class AccessManagementApi extends ChopperService {
  @GET(path: "/concierge/accesscontrol/getServiceSeventh")
  Future<Response> checkSeventhService(
    @Query("reference") String reference,
  );
  @GET(path: "/concierge/accesscontrol/getUrlS3")
  Future<Response> getAwsUrl();

  @POST(path: "/concierge/accesscontrol/registerFacialBiometric")
  Future<Response> registerFacialBiometric(
    @Query("hash") String hash,
  );

  @POST(path: "/concierge/accesscontrol/sendInvite")
  Future<Response> sendInvite(
    @Body() AccessManagementSendInviteModel body,
  );

  static AccessManagementApi create(ChopperClient client) {
    return _$AccessManagementApi(client);
  }
}
