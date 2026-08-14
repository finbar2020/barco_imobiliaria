import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

abstract class PostNonUserCase extends UseCase<ApiResponse, PostNonUserParam> {}

class PostNonUserParam {
  BuildingManagerUser model;
  String condominiumId;
  PostNonUserParam({required this.model, required this.condominiumId});
}
