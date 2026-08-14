import 'package:essentials/essentials.dart';
import 'package:morar/feature/me/domain/entity/me.dart';

abstract class MeRepository {
  Future<Try<Me?>> select();
  Future<Try<Me?>> selectFromCache();
  Future<Try<Me?>> save(Me me, String code);
  Future<Try> updatePassword(
      String cpf, String originPassword, String password);

  Future<Try<Nothing>> clear();
}
