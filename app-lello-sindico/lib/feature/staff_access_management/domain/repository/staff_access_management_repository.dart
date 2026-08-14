import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';

abstract class StaffAccessManagementRepository {
  Future<Try<List<BuildingManagerUser>>> getBuildingManagerUsers(
      String? condominiumId, CondoUserManageType? condoUserManageType);

  Future<Try<ApiResponse>> deactivateNonManagerUsers(
    String condominiumId,
    String userId,
    bool isActive,
  );
  Future<Try<ApiResponse>> postNonUser(
      BuildingManagerUser nonUser, String condominiumId);
  Future<Try<ApiResponse>> putBuildingManagerUser(
      BuildingManagerUser buildingManagerUser, String condominiumId);
}
