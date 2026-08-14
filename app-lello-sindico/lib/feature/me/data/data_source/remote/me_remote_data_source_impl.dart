import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/data/data_source/remote/me_api.dart';
import 'package:lello/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/data/model/me_password_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeRemoteDataSourceImpl extends MeRemoteDataSource {
  final MeApi api;
  final int? idEmpresa;

  MeRemoteDataSourceImpl({required this.api, this.idEmpresa});
  @override
  Future<MeModel> get() async {
    final response = await api.get(idEmpresa).timeout(Duration(seconds: 30));
    final me = ApiMapper.map(response, (json) => MeModel.fromJson(json));

    _setGetMeLastUpdate();
    return me.copyWith(cpf: me.cpf?.formatCpfCnpj());
  }

  @override
  Future<MeModel> patch(MeModel model, String code) async {
    final response = await api.patch(model, code);
    final me = ApiMapper.map(response, (json) => MeModel.fromJson(json));

    return me.copyWith(cpf: me.cpf?.formatCpfCnpj());
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
          SharedPreferencesKeys.managerLastGetMe, DateTime.now().toString());
    } catch (ex) {}
  }
}
