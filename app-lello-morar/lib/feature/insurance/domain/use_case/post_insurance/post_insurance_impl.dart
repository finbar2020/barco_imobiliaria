import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/domain/repository/insurance_repository.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance.dart';

class PostInsurancempl extends PostInsurance {
  final InsuranceRepository repository;

  PostInsurancempl({required this.repository});

  @override
  Future<Try<String>> call(PostInsuranceParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.postInsurance(params.unitId);

    return result;
  }

  Failure? validate(PostInsuranceParam params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
