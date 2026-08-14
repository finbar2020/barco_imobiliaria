import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit.dart';

class DeleteVisitImpl extends DeleteVisit {
  final AccessControlRepository repository;

  DeleteVisitImpl({required this.repository});

  @override
  Future<Try<String>> call(DeleteVisitParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.deleteVisit(params.recurrenceId);

    return result;
  }

  Failure? validate(DeleteVisitParam params) {
    if (params.recurrenceId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
