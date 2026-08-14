import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeListState extends Equatable {
  final List<Employee> data;
  final String? condominiumId;
  final EmployeeListFilter filter;

  const EmployeeListState(this.data, this.condominiumId, this.filter);

  @override
  List<Object?> get props => [data, condominiumId, filter];
}

class EmployeeListLoadingState extends EmployeeListState {
  const EmployeeListLoadingState(
      List<Employee> data, String? condominiumId, EmployeeListFilter filter)
      : super(data, condominiumId, filter);
}

class EmployeeListLoadFailedState extends EmployeeListState {
  final Failure error;

  const EmployeeListLoadFailedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.error)
      : super(data, condominiumId, filter);

  @override
  List<Object?> get props => [...super.props, error];
}

class EmployeeListPagingState extends EmployeeListState {
  const EmployeeListPagingState(
      List<Employee> data, String condominiumId, EmployeeListFilter filter)
      : super(data, condominiumId, filter);
}

class EmployeeListPageFailedState extends EmployeeListState {
  final Failure error;

  const EmployeeListPageFailedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.error)
      : super(data, condominiumId, filter);

  @override
  List<Object?> get props => [...super.props, error];
}

class EmployeeListLoadedState extends EmployeeListState {
  final bool donePaging;

  const EmployeeListLoadedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.donePaging)
      : super(data, condominiumId, filter);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
