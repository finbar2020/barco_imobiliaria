import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_api.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source.dart';
import 'package:morar/feature/tdb/data/model/tdb_info_model.dart';

class TDBRemoteDataSourceImpl extends TDBRemoteDataSource {
  final TDBApi api;
  TDBRemoteDataSourceImpl({required this.api});

  @override
  Future<TDBInfoModel> getTDBInfo(String condominiumId) async {
    final response = await api.getTDBInfo(condominiumId);
    final result =
        ApiMapper.map(response, (json) => TDBInfoModel.fromJson(json));
    return result;
  }
}
