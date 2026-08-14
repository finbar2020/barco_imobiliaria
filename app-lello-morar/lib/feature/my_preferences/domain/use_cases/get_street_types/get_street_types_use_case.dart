import 'package:essentials/base/use_case.dart';

import '../../entities/street_type_entity.dart';

abstract class GetStreetTypesUseCase
    extends UseCase<List<StreetTypeEntity>, void> {}
