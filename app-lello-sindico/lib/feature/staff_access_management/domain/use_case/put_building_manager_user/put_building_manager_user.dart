import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

abstract class PutBuildingManagerUserCase
    extends UseCase<ApiResponse, PutBuildingManagerUserParam> {}

class PutBuildingManagerUserParam {
  BuildingManagerUser model;
  String condominiumId;
  PutBuildingManagerUserParam(
      {required this.model, required this.condominiumId});
}
