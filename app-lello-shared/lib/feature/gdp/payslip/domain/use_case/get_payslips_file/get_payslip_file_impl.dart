import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:shared_features/feature/gdp/payslip/domain/repository/payslip_repository.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';

class GetPayslipFileImpl extends GetPayslipFile {
  final PayslipRepository repository;

  GetPayslipFileImpl({required this.repository});

  @override
  Future<Try<PayslipFile>> call(GetPayslipFileParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPayslipFile(
        params.nameFile, params.registrationNumber);
  }

  Failure? validate(GetPayslipFileParam param) {
    if (param.nameFile.isEmpty) return InvalidParamFailure();
    if (param.registrationNumber.isEmpty) return InvalidParamFailure();
    return null;
  }
}
