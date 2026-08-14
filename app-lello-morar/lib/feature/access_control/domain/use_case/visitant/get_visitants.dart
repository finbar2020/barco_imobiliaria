import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';

abstract class GetVisitants
    extends UseCase<List<AccessControl>, GetVisitantsParam> {}

class GetVisitantsParam {
  final String unitId;

  GetVisitantsParam({required this.unitId});
}
