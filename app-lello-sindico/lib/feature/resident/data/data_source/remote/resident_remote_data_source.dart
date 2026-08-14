import 'package:lello/feature/resident/data/model/resident_model.dart';

abstract class ResidentRemoteDataSource {
  Future<List<ResidentModel>> list(String condominiumId,
      {String? query, String? lastResidentId, bool loadAll = false});
  Future<List<ResidentModel>> listFromUnit(String condominiumId, String unitId);
}
