import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user.dart';

class DeactivateNonManagerUserCaseImpl extends DeactivateNonManagerUserCase {
  final StaffAccessManagementRepository repository;

  DeactivateNonManagerUserCaseImpl({required this.repository});

  @override
  Future<Try<void>> call(DeactivateNonManagerUserParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.deactivateNonManagerUsers(
        params.condominiumId, params.userId, params.isActive);

    return result;
  }

  Failure? validate(DeactivateNonManagerUserParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.userId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
