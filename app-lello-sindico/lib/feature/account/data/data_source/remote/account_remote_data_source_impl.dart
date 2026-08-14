import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/data/data_source/remote/account_api.dart';
import 'package:lello/feature/account/data/data_source/remote/account_remote_data_source.dart';
import 'package:lello/feature/account/data/model/account_model.dart';

class AccountRemoteDataSourceImpl extends AccountRemoteDataSource {
  final AccountApi api;

  AccountRemoteDataSourceImpl({required this.api});

  @override
  Future<List<AccountModel>> list(String condominiumId) async {
    final response = await api.get(condominiumId);
    return ApiMapper.mapList(response, (json) => AccountModel.fromJson(json));
  }
}
