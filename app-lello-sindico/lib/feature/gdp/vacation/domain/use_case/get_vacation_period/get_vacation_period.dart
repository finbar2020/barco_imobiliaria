import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';

abstract class GetVacationPeriod
    extends UseCase<VacationParams, GetVacationPeriodParam> {}

class GetVacationPeriodParam {
  final String condominiumId;
  final String employeeId;

  GetVacationPeriodParam(
      {required this.condominiumId, required this.employeeId});
}
