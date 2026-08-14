import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';

abstract class GetVacation extends UseCase<Vacation, GetVacationParam> {}

class GetVacationParam {
  final String condominiumId;
  final String employeeId;

  GetVacationParam({required this.condominiumId, required this.employeeId});
}
