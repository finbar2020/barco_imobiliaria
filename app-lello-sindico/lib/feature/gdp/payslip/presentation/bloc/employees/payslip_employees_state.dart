import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class PayslipEmployeesState extends Equatable {
  final List<Employee> data;
  final String? condominiumId;
  final String? query;
  final DateTime? selectedMonth;

  const PayslipEmployeesState(
      this.data, this.query, this.condominiumId, this.selectedMonth);

  @override
  List<Object?> get props => [data, query, condominiumId, selectedMonth];
}

class PayslipEmployeesSearchingState extends PayslipEmployeesState {
  const PayslipEmployeesSearchingState(List<Employee> data, String query,
      String condominiumId, DateTime selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesLoadingState extends PayslipEmployeesState {
  const PayslipEmployeesLoadingState(List<Employee> data, String? query,
      String? condominiumId, DateTime? selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesLoadFailedState extends PayslipEmployeesState {
  final Failure? error;

  const PayslipEmployeesLoadFailedState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth, this.error)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayslipEmployeesPagingState extends PayslipEmployeesState {
  const PayslipEmployeesPagingState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesPageFailedState extends PayslipEmployeesState {
  final Failure error;

  const PayslipEmployeesPageFailedState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth, this.error)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayslipEmployeesLoadedState extends PayslipEmployeesState {
  final bool donePaging;

  const PayslipEmployeesLoadedState(List<Employee> data, String? query,
      String condominiumId, DateTime? selectedMonth, this.donePaging)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
