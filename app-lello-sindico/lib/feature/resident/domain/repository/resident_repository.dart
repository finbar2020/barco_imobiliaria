import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class ResidentRepository {
  Future<Try<List<Resident>>> list(DataOrigin origin, String condominiumId,
      {String? lastResidentId, String? query, bool loadAll = false});
  Future<Try<List<Resident>>> listFromUnit(String condominiumId, String unitId);
}
