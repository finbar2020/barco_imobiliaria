import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:lello/feature/unit/data/model/unit_simple_model.dart';

abstract class UnitRemoteDataSource {
  Future<List<UnitModel>> list(
    String condominiumId, {
    String? query,
    String? lastUnitId,
    bool? loadAll,
    String? blockName,
    String? unitName,
    bool? hasAppInstalled,
    bool? showOnlyUnitsWithBiometrics,
    String? vehicleIdentification,
    String? vehicleTypeSelected,
    bool? filterOnlyWithTenant,
  });

  Future<List<UnitSimpleModel>> listSimple(String condominiumId);
}
