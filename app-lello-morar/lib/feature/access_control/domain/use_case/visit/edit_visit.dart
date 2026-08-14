import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';

abstract class EditVisit extends UseCase<String, EditVisitParam> {}

class EditVisitParam {
  final String recurrenceId;
  final AccessControlAuthorizations model;

  EditVisitParam({
    required this.recurrenceId,
    required this.model,
  });
}
