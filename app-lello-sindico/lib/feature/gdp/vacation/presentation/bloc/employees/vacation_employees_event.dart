abstract class VacationEmployeesEvent {}

class VacationEmployeesLoadEvent extends VacationEmployeesEvent {
  final String condominiumId;
  VacationEmployeesLoadEvent({required this.condominiumId});
}

class VacationEmployeesNextPageEvent extends VacationEmployeesEvent {}

class VacationEmployeesSearchEvent extends VacationEmployeesEvent {
  final String query;
  VacationEmployeesSearchEvent({required this.query});
}
