import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit.dart';

class EditVisitImpl extends EditVisit {
  final AccessControlRepository repository;

  EditVisitImpl({required this.repository});

  @override
  Future<Try<String>> call(EditVisitParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.editVisit(
      params.model,
      params.recurrenceId,
    );

    return result;
  }

  Failure? validate(EditVisitParam params) {
    if (params.recurrenceId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
