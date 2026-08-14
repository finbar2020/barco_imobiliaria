import 'package:morar/feature/tdb/data/model/tdb_info_model.dart';

abstract class TDBRemoteDataSource {
  Future<TDBInfoModel> getTDBInfo(String condominiumId);
}
