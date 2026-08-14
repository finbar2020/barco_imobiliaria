import 'package:essentials/essentials.dart';

abstract class UpdatePasswordMe
    extends UseCase<dynamic, UpdatePasswordMeParam> {}

class UpdatePasswordMeParam {
  final String cpf;
  final String originPassword;
  final String password;

  UpdatePasswordMeParam({
    required this.cpf,
    required this.originPassword,
    required this.password,
  });
}
