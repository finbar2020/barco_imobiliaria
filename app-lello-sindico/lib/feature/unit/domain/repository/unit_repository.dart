import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';

abstract class UnitRepository {
  Future<Try<List<Unit>>> list(
    DataOrigin origin,
    String condominiumId, {
    String? lastUnitId,
    String? query,
    bool? loadAll,
    String? blockName,
    String? unitName,
    bool? hasAppInstalled,
    bool? showOnlyUnitsWithBiometrics,
    String? vehicleIdentification,
    String? vehicleTypeSelected,
    bool? filterOnlyWithTenant,
  });

  Future<Try<List<UnitSimple>>> listSimple(
    String condominiumId,
  );
}
