import 'package:essentials/essentials.dart';

import 'package:lello/feature/space/domain/entity/space.dart';

abstract class SpaceRepository {
  Future<Try<List<Space>>> list(String condominiumId, DataOrigin origin);
  Future<Try<Space>> insert(String condominiumId, Space space);
  Future<Try<Space>> update(String condominiumId, Space space);
}
