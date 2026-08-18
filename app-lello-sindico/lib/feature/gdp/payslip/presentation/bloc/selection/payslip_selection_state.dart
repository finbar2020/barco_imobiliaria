import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';

abstract class PayslipSelectionState {
  final List<Payslip> data;
  final String? numeroCadastro;
  PayslipFile payslipFile;

  PayslipSelectionState(this.data, this.numeroCadastro, this.payslipFile);
}

class PayslipLoadingState extends PayslipSelectionState {
  PayslipLoadingState(
      List<Payslip>? data, String? numeroCadastro, PayslipFile payslipFile)
      : super(data ?? [], numeroCadastro, payslipFile);
}

class PayslipLoadFailedState extends PayslipSelectionState {
  final Failure error;
  PayslipLoadFailedState(List<Payslip> data, String numeroCadastro,
      PayslipFile payslipFile, this.error)
      : super(data, numeroCadastro, payslipFile);
}

class PayslipLoadedState extends PayslipSelectionState {
  PayslipLoadedState(
      List<Payslip> data, String numeroCadastro, PayslipFile payslipFile)
      : super(data, numeroCadastro, payslipFile);
}

class PayslipFileDownloadedState extends PayslipSelectionState {
  PayslipFileDownloadedState(
      List<Payslip> data, String numeroCadastro, PayslipFile payslipFile)
      : super(data, numeroCadastro, payslipFile);
}
