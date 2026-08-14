import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';

abstract class AddVisit extends UseCase<String, AddVisitParam> {}

class AddVisitParam {
  final String gestId;
  final String unitId;
  final AccessControlAuthorizations model;

  AddVisitParam({
    required this.gestId,
    required this.unitId,
    required this.model,
  });
}
