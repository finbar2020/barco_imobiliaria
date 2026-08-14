import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant.dart';

class EditVisitantImpl extends EditVisitant {
  final AccessControlRepository repository;

  EditVisitantImpl({required this.repository});

  @override
  Future<Try<String>> call(EditVisitantParam params) async {
    final result = await repository.editVisitant(params.visitant);

    return result;
  }
}
