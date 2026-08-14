import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:essentials/essentials.dart';

abstract class AuthenticationTabletRepository {
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCode(String condoCode);
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCodeFromCache();
}
