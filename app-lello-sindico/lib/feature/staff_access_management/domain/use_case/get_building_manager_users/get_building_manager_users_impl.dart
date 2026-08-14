import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users.dart';

class BuildingManagerUsersCaseImpl extends BuildingManagerUsersCase {
  final StaffAccessManagementRepository repository;

  BuildingManagerUsersCaseImpl({required this.repository});

  @override
  Future<Try<List<BuildingManagerUser>>> call(
      BuildingManagerUsersParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getBuildingManagerUsers(
        params.condominiumId, params.condoUserManageType);

    return result;
  }

  Failure? validate(BuildingManagerUsersParam params) {
    return null;
  }
}
