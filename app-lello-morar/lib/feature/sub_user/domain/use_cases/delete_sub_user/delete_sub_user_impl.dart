import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';

import 'delete_sub_user.dart';

class DeleteSubUserImpl extends DeleteSubUser {
  final SubUserRepository repository;

  DeleteSubUserImpl({required this.repository});

  @override
  Future<Try<bool>> call(DeleteSubUserParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.deleteSubUser(params.unitId, params.cpfCnpj);
  }

  Failure? _validate(DeleteSubUserParams params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();
    if (params.cpfCnpj.isEmpty) return InvalidParamFailure();
    return null;
  }
}
