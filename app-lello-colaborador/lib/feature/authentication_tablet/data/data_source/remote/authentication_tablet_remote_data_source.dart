import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';

abstract class AuthenticationTabletRemoteDataSource {
  Future<CondominiumCodeInfoModel> getInfoByCondoCode(String condoCode);
}
