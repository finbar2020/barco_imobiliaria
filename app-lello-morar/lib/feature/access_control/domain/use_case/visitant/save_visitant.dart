import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';

abstract class SaveVisitant extends UseCase<AccessControl, SaveVisitantParam> {}

class SaveVisitantParam {
  AccessControlVisitant visitant;
  SaveVisitantParam({required this.visitant});
}
