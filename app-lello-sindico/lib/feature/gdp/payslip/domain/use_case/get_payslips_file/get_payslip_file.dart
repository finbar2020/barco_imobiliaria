import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';

abstract class GetPayslipFile
    extends UseCase<PayslipFile, GetPayslipFileParam> {}

class GetPayslipFileParam {
  final String nameFile;
  final String registrationNumber;

  GetPayslipFileParam(
      {required this.nameFile, required this.registrationNumber});
}
