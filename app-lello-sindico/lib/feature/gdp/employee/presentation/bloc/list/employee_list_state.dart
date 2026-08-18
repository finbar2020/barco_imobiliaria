import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeListState {
  final List<Employee> data;
  final String? condominiumId;
  final EmployeeListFilter filter;

  EmployeeListState(this.data, this.condominiumId, this.filter);
}

class EmployeeListLoadingState extends EmployeeListState {
  EmployeeListLoadingState(
      List<Employee> data, String? condominiumId, EmployeeListFilter filter)
      : super(data, condominiumId, filter);
}

class EmployeeListLoadFailedState extends EmployeeListState {
  final Failure error;
  EmployeeListLoadFailedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.error)
      : super(data, condominiumId, filter);
}

class EmployeeListPagingState extends EmployeeListState {
  EmployeeListPagingState(
      List<Employee> data, String condominiumId, EmployeeListFilter filter)
      : super(data, condominiumId, filter);
}

class EmployeeListPageFailedState extends EmployeeListState {
  final Failure error;
  EmployeeListPageFailedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.error)
      : super(data, condominiumId, filter);
}

class EmployeeListLoadedState extends EmployeeListState {
  final bool donePaging;
  EmployeeListLoadedState(List<Employee> data, String condominiumId,
      EmployeeListFilter filter, this.donePaging)
      : super(data, condominiumId, filter);
}
