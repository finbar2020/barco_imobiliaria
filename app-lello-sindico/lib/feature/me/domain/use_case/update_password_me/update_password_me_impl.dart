import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me.dart';

class UpdatePasswordMeImpl extends UpdatePasswordMe {
  final MeRepository repository;

  UpdatePasswordMeImpl({required this.repository});

  @override
  Future<Try<Me?>> call(UpdatePasswordMeParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    var result = await repository.updatePassword(
        params.cpf, params.originPassword, params.password);
    return result;
  }

  Failure? validate(UpdatePasswordMeParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.cpf.isEmpty) return InvalidParamFailure();
    if (params.originPassword.isEmpty) return InvalidParamFailure();
    if (params.password.isEmpty) return InvalidParamFailure();
    return null;
  }
}
