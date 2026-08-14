import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_units.dart';
import 'package:essentials/essentials.dart';

class GetCitiesUsecaseImpl extends GetCitiesUsecase {
  final EmployeeReferralRepository repository;

  GetCitiesUsecaseImpl({required this.repository});
  @override
  Future<Try<List<CityEntity>>> call(GetCitiesParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getCities(params.condoId, params.employeeId);
  }

  Failure? validate(GetCitiesParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.employeeId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
