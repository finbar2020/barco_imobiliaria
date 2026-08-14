import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';

class GetVacationImpl extends GetVacation {
  final VacationRepository repository;

  GetVacationImpl({required this.repository});

  @override
  Future<Try<Vacation>> call(GetVacationParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getVacation(
        params.condominiumId, params.employeeId);
  }

  Failure? validate(GetVacationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
