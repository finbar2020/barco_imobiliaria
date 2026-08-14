import 'package:essentials/essentials.dart';

import '../entities/access_data_entity.dart';
import '../entities/street_type_entity.dart';

abstract class MyPreferencesRepository {
  Future<Try<AccessData>> getUnitPersonalData(
    int unitId,
  );

  Future<Try<AccessData>> updateUnitPersonalData(
    AccessData accessData,
  );

  Future<Try<List<StreetTypeEntity>>> getStreetTypesList();
}
