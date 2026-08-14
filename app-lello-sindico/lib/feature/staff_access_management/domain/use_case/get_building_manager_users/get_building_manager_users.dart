import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';

abstract class BuildingManagerUsersCase
    extends UseCase<List<BuildingManagerUser>, BuildingManagerUsersParam> {}

class BuildingManagerUsersParam {
  String? condominiumId;
  CondoUserManageType? condoUserManageType;
  BuildingManagerUsersParam(
      {required this.condominiumId, required this.condoUserManageType});
}
