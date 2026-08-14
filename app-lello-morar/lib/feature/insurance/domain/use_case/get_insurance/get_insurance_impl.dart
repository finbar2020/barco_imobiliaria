import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';
import 'package:morar/feature/insurance/domain/repository/insurance_repository.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance.dart';

class GetInsurancempl extends GetInsurance {
  final InsuranceRepository repository;

  GetInsurancempl({required this.repository});

  @override
  Future<Try<Insurance>> call(GetInsuranceParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getInsurance(params.unitId);

    return result;
  }

  Failure? validate(GetInsuranceParam params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
