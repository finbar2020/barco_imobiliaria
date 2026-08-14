import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant.dart';

class SaveVisitantImpl extends SaveVisitant {
  final AccessControlRepository repository;

  SaveVisitantImpl({required this.repository});

  @override
  Future<Try<AccessControl>> call(SaveVisitantParam params) async {
    final result = await repository.saveVisitant(params.visitant);

    return result;
  }
}
