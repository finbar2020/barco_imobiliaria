import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user.dart';

class PutBuildingManagerUserCaseImpl extends PutBuildingManagerUserCase {
  final StaffAccessManagementRepository repository;

  PutBuildingManagerUserCaseImpl({required this.repository});

  @override
  Future<Try<ApiResponse>> call(PutBuildingManagerUserParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.putBuildingManagerUser(
        params.model, params.condominiumId);

    return result;
  }

  Failure? validate(PutBuildingManagerUserParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.model.id?.isEmpty == true) return InvalidParamFailure();
    if (params.model.accessType == null) return InvalidParamFailure();
    return null;
  }
}
