import 'package:morar/feature/easy_fix/data/model/easy_fix_unit_model.dart';

import '../../domain/entity/city_entity.dart';

abstract class EasyFixRemoteDataSource {
  Future<EasyFixUnitModel> selectEasyFixUnit({required String condominiumId});
  Future<void> updateAddress({
    required String condominiumId,
    required EasyFixUnitModel model,
  });

  Future<List<City>> selectCities({
    required String condominiumId,
    required String uf,
  });
}
