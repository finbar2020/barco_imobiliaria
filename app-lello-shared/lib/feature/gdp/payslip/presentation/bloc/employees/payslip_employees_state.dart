import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

abstract class PayslipEmployeesState extends Equatable {
  final List<Employee> data;
  final String? condominiumId;
  final String? query;
  DateTime? selectedMonth;

  PayslipEmployeesState(
      this.data, this.query, this.condominiumId, this.selectedMonth);

  @override
  List<Object?> get props => [data, query, condominiumId, selectedMonth];
}

class PayslipEmployeesSearchingState extends PayslipEmployeesState {
  PayslipEmployeesSearchingState(List<Employee> data, String query,
      String condominiumId, DateTime selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesLoadingState extends PayslipEmployeesState {
  PayslipEmployeesLoadingState(List<Employee> data, String? query,
      String? condominiumId, DateTime? selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesLoadFailedState extends PayslipEmployeesState {
  final Failure error;

  PayslipEmployeesLoadFailedState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth, this.error)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayslipEmployeesPagingState extends PayslipEmployeesState {
  PayslipEmployeesPagingState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth)
      : super(data, query, condominiumId, selectedMonth);
}

class PayslipEmployeesPageFailedState extends PayslipEmployeesState {
  final Failure error;

  PayslipEmployeesPageFailedState(List<Employee> data, String? query,
      String condominiumId, DateTime selectedMonth, this.error)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class PayslipEmployeesLoadedState extends PayslipEmployeesState {
  final bool donePaging;

  PayslipEmployeesLoadedState(List<Employee> data, String? query,
      String condominiumId, DateTime? selectedMonth, this.donePaging)
      : super(data, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
