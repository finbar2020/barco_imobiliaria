import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

abstract class MeRepository {
  Future<Try<Me?>> select();
  Future<Try<Me?>> selectFromCache();
  Future<Try<Me?>> save(Me? me, String code);
  Future<Try<Me?>> updatePassword(
      String cpf, String originPassword, String password);

  Future<Try<Nothing>> clear();
}
