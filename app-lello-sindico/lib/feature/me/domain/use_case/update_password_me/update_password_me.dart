import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

abstract class UpdatePasswordMe extends UseCase<Me?, UpdatePasswordMeParam> {}

class UpdatePasswordMeParam {
  final String cpf;
  final String originPassword;
  final String password;

  UpdatePasswordMeParam(
      {required this.cpf,
      required this.originPassword,
      required this.password});
}
