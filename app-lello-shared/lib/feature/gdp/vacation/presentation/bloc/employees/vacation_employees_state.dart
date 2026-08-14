import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

abstract class VacationEmployeesState extends Equatable {
  final List<Employee> data;
  final String condominiumId;
  final String query;

  const VacationEmployeesState(this.data, this.query, this.condominiumId);

  @override
  List<Object?> get props => [data, query, condominiumId];
}

class VacationEmployeesSearchingState extends VacationEmployeesState {
  const VacationEmployeesSearchingState(
      List<Employee> data, String query, String condominiumId)
      : super(data, query, condominiumId);
}

class VacationEmployeesLoadingState extends VacationEmployeesState {
  const VacationEmployeesLoadingState(
      List<Employee> data, String query, String condominiumId)
      : super(data, query, condominiumId);
}

class VacationEmployeesLoadFailedState extends VacationEmployeesState {
  final Failure error;

  const VacationEmployeesLoadFailedState(
      List<Employee> data, String query, String condominiumId, this.error)
      : super(data, query, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class VacationEmployeesPagingState extends VacationEmployeesState {
  const VacationEmployeesPagingState(
      List<Employee> data, String query, String condominiumId)
      : super(data, query, condominiumId);
}

class VacationEmployeesPageFailedState extends VacationEmployeesState {
  final Failure error;

  const VacationEmployeesPageFailedState(
      List<Employee> data, String query, String condominiumId, this.error)
      : super(data, query, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class VacationEmployeesLoadedState extends VacationEmployeesState {
  final bool donePaging;

  const VacationEmployeesLoadedState(
      List<Employee> data, String query, String condominiumId, this.donePaging)
      : super(data, query, condominiumId);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
