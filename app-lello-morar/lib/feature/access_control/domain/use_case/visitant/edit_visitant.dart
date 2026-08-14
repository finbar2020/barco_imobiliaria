import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';

abstract class EditVisitant extends UseCase<String, EditVisitantParam> {}

class EditVisitantParam {
  final AccessControlVisitant visitant;

  EditVisitantParam({required this.visitant});
}
