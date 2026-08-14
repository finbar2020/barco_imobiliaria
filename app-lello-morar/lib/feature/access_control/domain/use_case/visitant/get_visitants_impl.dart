import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants.dart';

class GetVisitantsImpl extends GetVisitants {
  final AccessControlRepository repository;

  GetVisitantsImpl({required this.repository});

  @override
  Future<Try<List<AccessControl>>> call(GetVisitantsParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.listVisitants(params.unitId);

    return result;
  }

  Failure? validate(GetVisitantsParam params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
