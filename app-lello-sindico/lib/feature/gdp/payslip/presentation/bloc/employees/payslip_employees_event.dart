abstract class PayslipEmployeesEvent {}

class PayslipEmployeesLoadEvent extends PayslipEmployeesEvent {
  final String condominiumId;
  PayslipEmployeesLoadEvent({required this.condominiumId});
}

class PayslipEmployeesNextPageEvent extends PayslipEmployeesEvent {}

class PayslipEmployeesSearchEvent extends PayslipEmployeesEvent {
  final String query;
  PayslipEmployeesSearchEvent({required this.query});
}
