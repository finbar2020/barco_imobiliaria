import '../../domain/entities/access_data_entity.dart';
import '../../domain/entities/street_type_entity.dart';

abstract class MyPreferencesDataSource {
  Future<AccessData> getUnitPersonalData(int unitId);
  Future<AccessData> updateUnitPersonalData(AccessData accessData);
  Future<List<StreetTypeEntity>> getStreetTypesList();
}