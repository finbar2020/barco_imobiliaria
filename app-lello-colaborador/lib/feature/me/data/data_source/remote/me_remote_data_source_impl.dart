import 'package:colaborador/feature/me/data/data_source/remote/me_api.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/me_password_model.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class MeRemoteDataSourceImpl extends MeRemoteDataSource {
  final MeApi api;
  final int? idEmpresa;

  MeRemoteDataSourceImpl({required this.api, this.idEmpresa});
  @override
  Future<MeModel> get() async {
    final response =
        await api.get(idEmpresa).timeout(const Duration(seconds: 30));
    final me = ApiMapper.map(response, (json) => MeModel.fromJson(json));
    me.cpf = me.cpf.formatCpfCnpj();
    _setGetMeLastUpdate();
    return me;
  }

  @override
  Future<MeModel> patch(MeModel model, String code) async {
    final response = await api.patch(model, code);
    final me = ApiMapper.map(response, (json) => MeModel.fromJson(json));
    me.cpf = me.cpf.formatCpfCnpj();
    return me;
  }

  @override
  Future updatePassword(MePasswordModel model) async {
    final response = await api.updatePassword(model);
    return ApiMapper.map(response, (json) => null);
  }

  Future<void> _setGetMeLastUpdate() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      preferences.setString(
          SharedPreferencesKeys.employeeLastGetMe, DateTime.now().toString());
    } catch (ex) {}
  }
}
