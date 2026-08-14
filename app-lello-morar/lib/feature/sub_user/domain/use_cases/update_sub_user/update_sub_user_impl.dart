import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';

class UpdateSubUserImpl extends UpdateSubUser {
  final SubUserRepository repository;

  UpdateSubUserImpl({required this.repository});

  @override
  Future<Try<List<SubUser>>> call(UpdateSubUserParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.updateSubUser(params.subUser);
  }

  Failure? _validate(UpdateSubUserParams params) {
    if (params.subUser.name == null) return InvalidParamFailure();
    if (params.subUser.cpf == null) return InvalidParamFailure();
    return null;
  }
}
