import 'package:essentials/base/api_response_model.dart';
import 'package:lello/feature/staff_access_management/data/model/building_manager_user_model.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';

abstract class StaffAccessManagementRemoteDataSource {
  Future<ApiResponseModel> getBuildingManagerUsers(
      String? condominiumId, CondoUserManageType? condoUserManageType);

  Future<ApiResponseModel> deactivateNonManagerUser(
      String condominiumId, String userId, bool isActive);

  Future<ApiResponseModel> postNonUser(
      BuildingManagerUserModel model, String condominiumId);
  Future<ApiResponseModel> putBuildingManagerUser(
      BuildingManagerUserModel model, String condominiumId);
}
