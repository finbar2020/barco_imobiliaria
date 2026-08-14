import 'package:essentials/api/api_mapper.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_api.dart';
import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';

import '../../domain/entities/access_data_entity.dart';
import 'my_preferences_data_source.dart';

class MyPreferencesDataSourceImpl implements MyPreferencesDataSource {
  final MyPreferencesApi _api;

  MyPreferencesDataSourceImpl(this._api);

  @override
  Future<AccessData> getUnitPersonalData(int unitId) async {
    final response = await _api.getPreferencesZeroPaper(unitId);
    final result = ApiMapper.map(response, (json) => AccessData.fromJson(json));
    return result;
  }

  @override
  Future<AccessData> updateUnitPersonalData(AccessData accessData) async {
    final response = await _api.putPreferencesZeroPaper(accessData);
    final result = ApiMapper.map(response, (json) => AccessData.fromJson(json));
    return result;
  }

  @override
  Future<List<StreetTypeEntity>> getStreetTypesList() {
    return _api.getStreetTypesList().then((response) {
      return ApiMapper.mapList(
          response, (json) => StreetTypeEntity.fromMap(json));
    });
  }
}
