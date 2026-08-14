import 'package:essentials/essentials.dart';

import 'package:lello/feature/space/domain/entity/space_type.dart';

abstract class SpaceTypeRepository {
  Future<Try<List<SpaceType>>> list(String condominiumId);
}
