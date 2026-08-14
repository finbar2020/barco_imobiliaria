import 'package:essentials/essentials.dart';

import 'package:lello/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';

abstract class PayslipRepository {
  Future<Try<List<Payslip>>> getPayslip(String registrationNumber);
  Future<Try<PayslipFile>> getPayslipFile(
      String nameFile, String registrationNumber);
}
