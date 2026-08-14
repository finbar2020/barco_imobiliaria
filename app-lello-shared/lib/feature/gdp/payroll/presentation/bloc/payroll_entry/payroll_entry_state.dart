import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';

abstract class PayrollEntryState extends Equatable {
  final List<PayrollEntry> data;
  final String? condominiumId;
  final Payroll? payroll;

  const PayrollEntryState(this.data, this.condominiumId, this.payroll);

  @override
  List<Object?> get props => [data, condominiumId, payroll];
}

class PayrollEntryLoadingState extends PayrollEntryState {
  const PayrollEntryLoadingState(
      List<PayrollEntry> data, String? condominiumId, Payroll? payroll)
      : super(data, condominiumId, payroll);
}

class PayrollEntryLoadFailedState extends PayrollEntryState {
  final Failure error;

  const PayrollEntryLoadFailedState(List<PayrollEntry> data,
      String condominiumId, Payroll payroll, this.error)
      : super(data, condominiumId, payroll);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayrollEntryLoadedState extends PayrollEntryState {
  const PayrollEntryLoadedState(
      List<PayrollEntry> data, String condominiumId, Payroll payroll)
      : super(data, condominiumId, payroll);
}
