import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service.dart';

class SubUserCheckServiceImpl extends SubUserCheckServiceCase {
  final SubUserRepository repository;

  SubUserCheckServiceImpl({required this.repository});

  @override
  Future<Try<AccessControlServiceSeventh>> call(
      GetSubUserCheckServiceParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.checkSeventhService(params.reference);
  }

  Failure? _validate(GetSubUserCheckServiceParams params) {
    if (params.reference.isEmpty) return InvalidParamFailure();
    return null;
  }
}
