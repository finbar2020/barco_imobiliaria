import 'package:chopper/chopper.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_model.dart';

import '../model/update_access_request_status_model.dart';

part 'subuser_api.chopper.dart';

@ChopperApi()
abstract class SubUserApi extends ChopperService {
  @GET(path: "/concierge/subUser/{unity_id}")
  Future<Response> fetchSubUser(
    @Path("unity_id") String unityId,
  );

  @PUT(path: "/concierge/subUser")
  Future<Response> upateSubUser(@Body() SubUserModel resident);

  @POST(path: "/concierge/subUser")
  Future<Response> insertSubUser(@Body() SubUserModel resident);

  @GET(path: "/concierge/subUser/enabled_roles")
  Future<Response> fetchSubUserRoles();

  @GET(path: "/concierge/accesscontrol/getServiceSeventh")
  Future<Response> checkSeventhService(
    @Query("reference") String reference,
  );

  @GET(path: "/concierge/subUser/pending_requests/{unitId}")
  Future<Response> getPendingRequests(
    @Path("unitId") String unitId,
    @Query("status") String status,
  );

  @POST(path: "/concierge/subUser/renew_access/{unitId}")
  Future<Response> sendAccessRenewRequest(
    @Path("unitId") String unitId,
  );

  @POST(path: "/concierge/subUser/pending_requests/change-status")
  Future<Response> updateAccessRequestStatus(
      @Body() UpdateAccessRequestStatusModel body);

  @DELETE(path: "/concierge/subUser/{unitId}/{cpfCnpj}")
  Future<Response> deleteSubUser(
    @Path("unitId") String unitId,
    @Path("cpfCnpj") String cpfCnpj,
  );

  static SubUserApi create(ChopperClient client) {
    return _$SubUserApi(client);
  }

  static String insert_sub_user_conflict_failure =
      "insert_sub_user_conflict_failure";
}
