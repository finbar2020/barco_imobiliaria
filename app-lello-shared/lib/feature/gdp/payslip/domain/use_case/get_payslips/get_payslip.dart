import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';

abstract class GetPayslip extends UseCase<List<Payslip>, GetPayslipParam> {}

class GetPayslipParam {
  final String registrationNumber;

  GetPayslipParam({required this.registrationNumber});
}
