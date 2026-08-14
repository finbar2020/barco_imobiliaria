import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:essentials/essentials.dart';

abstract class GetCitiesUsecase
    extends UseCase<List<CityEntity>, GetCitiesParam> {}

class GetCitiesParam {
  final String condoId;
  final String employeeId;

  GetCitiesParam({required this.condoId, required this.employeeId});
}
