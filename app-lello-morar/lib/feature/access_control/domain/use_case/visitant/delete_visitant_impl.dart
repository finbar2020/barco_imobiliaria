import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant.dart';

class DeleteVisitantImpl extends DeleteVisitant {
  final AccessControlRepository repository;

  DeleteVisitantImpl({required this.repository});

  @override
  Future<Try<String>> call(DeleteVisitantParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.deleteVisitant(params.gestId);

    return result;
  }

  Failure? validate(DeleteVisitantParam params) {
    if (params.gestId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
