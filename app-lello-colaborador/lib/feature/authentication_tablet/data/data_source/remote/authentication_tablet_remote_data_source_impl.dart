import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_api.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:essentials/essentials.dart';

class AuthenticationTabletRemoteDataSourceImpl
    extends AuthenticationTabletRemoteDataSource {
  final AuthenticationTabletApi api;

  AuthenticationTabletRemoteDataSourceImpl({required this.api});

  @override
  Future<CondominiumCodeInfoModel> getInfoByCondoCode(String condoCode) async {
    final code = int.parse(condoCode);
    final response = await api.getInfoByCondominiumCode(code);

    return ApiMapper.map(
        response, (json) => CondominiumCodeInfoModel.fromJson(json));
  }
}
