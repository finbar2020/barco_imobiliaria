import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:lello/feature/access_management/domain/usecase/check_seventh_service/access_management_check_service.dart';

class AccessManagementCheckServiceCaseImpl
    extends AccessManagementCheckServiceCase {
  final AccessManagementRepository repository;

  AccessManagementCheckServiceCaseImpl({required this.repository});

  @override
  Future<Try<AccessManagementServiceSeventh>> call(
      AccessManagementCheckServiceParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.checkSeventhService(params.reference);
  }

  Failure? _validate(AccessManagementCheckServiceParams params) {
    if (params.reference.isEmpty) return InvalidParamFailure();
    return null;
  }
}
