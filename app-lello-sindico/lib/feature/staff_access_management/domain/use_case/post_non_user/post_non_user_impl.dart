import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user.dart';

class PostNonUserCaseImpl extends PostNonUserCase {
  final StaffAccessManagementRepository repository;

  PostNonUserCaseImpl({required this.repository});

  @override
  Future<Try<ApiResponse>> call(PostNonUserParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result =
        await repository.postNonUser(params.model, params.condominiumId);

    return result;
  }

  Failure? validate(PostNonUserParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.model.cpf?.isNotEmpty == false) return InvalidParamFailure();
    if (params.model.gender?.isNotEmpty == false) return InvalidParamFailure();
    if (params.model.birthday?.isNotEmpty == false) {
      return InvalidParamFailure();
    }
    if (params.model.email?.isNotEmpty == false) return InvalidParamFailure();
    if (params.model.phone?.isNotEmpty == false) return InvalidParamFailure();
    if (params.model.accessType == null) return InvalidParamFailure();
    return null;
  }
}
