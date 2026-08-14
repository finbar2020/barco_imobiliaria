import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit.dart';

class AddVisitImpl extends AddVisit {
  final AccessControlRepository repository;

  AddVisitImpl({required this.repository});

  @override
  Future<Try<String>> call(AddVisitParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.addVisit(
      params.gestId,
      params.unitId,
      params.model,
    );

    return result;
  }

  Failure? validate(AddVisitParam params) {
    if (params.gestId.isEmpty) return InvalidParamFailure();
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
