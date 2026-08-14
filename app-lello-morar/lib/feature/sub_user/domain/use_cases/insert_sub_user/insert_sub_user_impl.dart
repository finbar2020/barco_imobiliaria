import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user.dart';

class InsertSubUserImpl extends InsertSubUser {
  final SubUserRepository repository;

  InsertSubUserImpl({required this.repository});

  @override
  Future<Try<List<SubUser>>> call(InsertSubUserParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    var result = await repository.insertSubUser(params.subUser);
    return result;
  }

  Failure? validate(InsertSubUserParam params) {
    if (params.subUser.name == null || params.subUser.name!.isEmpty)
      return InvalidParamFailure();
    return null;
  }
}
