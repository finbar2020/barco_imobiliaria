import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class VacationEmployeesState {
  final List<Employee> data;
  final String condominiumId;
  final String query;

  VacationEmployeesState(this.data, this.query, this.condominiumId);
}

class VacationEmployeesSearchingState extends VacationEmployeesState {
  VacationEmployeesSearchingState(
      List<Employee> data, String query, String condominiumId)
      : super(data, query, condominiumId);
}

class VacationEmployeesLoadingState extends VacationEmployeesState {
  VacationEmployeesLoadingState(param0) : super([], '', '');
}

class VacationEmployeesLoadFailedState extends VacationEmployeesState {
  final Failure error;
  VacationEmployeesLoadFailedState(
      List<Employee> data, String query, String condominiumId, this.error)
      : super(data, query, condominiumId);
}

class VacationEmployeesPagingState extends VacationEmployeesState {
  VacationEmployeesPagingState(
      List<Employee> data, String query, String condominiumId)
      : super(data, query, condominiumId);
}

class VacationEmployeesPageFailedState extends VacationEmployeesState {
  final Failure error;
  VacationEmployeesPageFailedState(
      List<Employee> data, String query, String condominiumId, this.error)
      : super(data, query, condominiumId);
}

class VacationEmployeesLoadedState extends VacationEmployeesState {
  final bool donePaging;
  VacationEmployeesLoadedState(
      List<Employee> data, String query, String condominiumId, this.donePaging)
      : super(data, query, condominiumId);
}
