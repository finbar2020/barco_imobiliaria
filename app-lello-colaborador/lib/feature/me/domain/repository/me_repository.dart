import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:essentials/essentials.dart';

abstract class MeRepository {
  Future<Try<Me?>> select();
  Future<Try<Me?>> selectFromCache();
  Future<Try<Me?>> save(Me? me, String code);
  Future<Try<Me?>> updatePassword(
      String cpf, String originPassword, String password);

  Future<Try<Nothing>> clear();
}
