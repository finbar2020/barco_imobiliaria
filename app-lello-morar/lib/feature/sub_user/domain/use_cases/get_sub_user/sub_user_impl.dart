import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';

class SubUserUseCaseImpl extends SubUserUseCase {
  final SubUserRepository repository;

  SubUserUseCaseImpl({required this.repository});

  @override
  Future<Try<List<SubUser>>> call(GetSubUserParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getSubUsers(params.unityId);
  }

  Failure? _validate(GetSubUserParams params) {
    if (params.unityId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
