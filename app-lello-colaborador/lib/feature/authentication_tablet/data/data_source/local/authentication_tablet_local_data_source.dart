import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';

abstract class AuthenticationTabletLocalDataSource {
  Future<CondominiumCodeInfoModel?> select(String condoCode);
  Future<CondominiumCodeInfoModel> save(
      String condoCode, CondominiumCodeInfoModel model);
  Future<bool> delete();
}
