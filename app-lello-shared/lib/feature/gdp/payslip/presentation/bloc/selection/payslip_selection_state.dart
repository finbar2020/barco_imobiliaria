import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';

abstract class PayslipSelectionState extends Equatable {
  final List<Payslip> data;
  final String? numeroCadastro;
  final PayslipFile payslipFile;

  const PayslipSelectionState(this.data, this.numeroCadastro, this.payslipFile);

  @override
  List<Object?> get props => [data, numeroCadastro, payslipFile];
}

class PayslipLoadingState extends PayslipSelectionState {
  PayslipLoadingState(
      List<Payslip>? data, String? numeroCadastro, PayslipFile payslipFile)
      : super(data ?? const [], numeroCadastro, payslipFile);
}

class PayslipLoadFailedState extends PayslipSelectionState {
  final Failure error;

  const PayslipLoadFailedState(List<Payslip> data, String numeroCadastro,
      PayslipFile payslipFile, this.error)
      : super(data, numeroCadastro, payslipFile);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayslipLoadedState extends PayslipSelectionState {
  const PayslipLoadedState(
      List<Payslip> data, String numeroCadastro, PayslipFile payslipFile)
      : super(data, numeroCadastro, payslipFile);
}

class PayslipFileDownloadedState extends PayslipSelectionState {
  const PayslipFileDownloadedState(
      List<Payslip> data, String numeroCadastro, PayslipFile payslipFile)
      : super(data, numeroCadastro, payslipFile);
}
