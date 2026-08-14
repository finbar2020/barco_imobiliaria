import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/repository/payslip_repository.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';

class GetPayslipImpl extends GetPayslip {
  final PayslipRepository repository;

  GetPayslipImpl({required this.repository});

  @override
  Future<Try<List<Payslip>>> call(GetPayslipParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPayslip(params.registrationNumber);
  }

  Failure? validate(GetPayslipParam param) {
    if (param.registrationNumber.isEmpty) return InvalidParamFailure();
    return null;
  }
}
