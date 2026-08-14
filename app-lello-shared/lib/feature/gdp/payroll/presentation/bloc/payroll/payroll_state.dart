import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';

abstract class PayrollState extends Equatable {
  final Payroll? detail;
  final List<Payroll> data;
  final String? condominiumId;

  const PayrollState(this.data, this.detail, this.condominiumId);

  @override
  List<Object?> get props => [data, detail, condominiumId];
}

class PayrollInitialState extends PayrollState {
  const PayrollInitialState(List<Payroll> data, String? condominiumId)
      : super(data, null, condominiumId);
}

class PayrollLoadingState extends PayrollState {
  const PayrollLoadingState(
      List<Payroll> data, Payroll? detail, String? condominiumId)
      : super(data, detail, condominiumId);
}

class PayrollLoadFailedState extends PayrollState {
  final Failure error;

  const PayrollLoadFailedState(
      List<Payroll> data, Payroll detail, String condominiumId, this.error)
      : super(data, detail, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayrollListLoadedState extends PayrollState {
  const PayrollListLoadedState(List<Payroll> data, String condominiumId)
      : super(data, null, condominiumId);
}

class PayrollLoadedState extends PayrollState {
  const PayrollLoadedState(
      List<Payroll> data, Payroll detail, String condominiumId)
      : super(data, detail, condominiumId);
}
