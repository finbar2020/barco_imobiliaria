import 'package:chopper/chopper.dart';
import 'package:lello/feature/staff_access_management/data/model/update_non_manager_user_model.dart';
import 'package:lello/feature/staff_access_management/data/model/building_manager_user_model.dart';

part 'staff_access_management_api.chopper.dart';

@ChopperApi()
abstract class StaffAccessManagementApi extends ChopperService {
  @GET(path: "/condominiums/{condo_id}/staff-access")
  Future<Response> getBuildingManagerUsers(
      @Path("condo_id") String? condominiumId,
      @Query("condo_user_manage_type") String? condoUserManageType);

  @POST(path: "/condominiums/{condominiumId}/staff-access")
  Future<Response> deactivateUser(
    @Path("condominiumId") String condominiumId,
    @Body() UpdateNonManagerUserModel model,
  );

  @POST(path: "/condominiums/{condominiumId}/staff-access/add-new-profile")
  Future<Response> postUser(
    @Body() BuildingManagerUserModel model,
    @Path("condominiumId") String condominiumId,
  );

  @PUT(path: "/condominiums/{condominiumId}/staff-access/edit-profile")
  Future<Response> putUser(
    @Body() BuildingManagerUserModel model,
    @Path("condominiumId") String condominiumId,
  );

  static StaffAccessManagementApi create(ChopperClient client) {
    return _$StaffAccessManagementApi(client);
  }
}
