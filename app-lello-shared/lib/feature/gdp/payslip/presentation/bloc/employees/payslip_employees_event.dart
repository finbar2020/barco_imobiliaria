import 'package:essentials/essentials.dart';

abstract class PayslipEmployeesEvent extends Equatable {
  const PayslipEmployeesEvent();

  @override
  List<Object?> get props => [];
}

class PayslipEmployeesLoadEvent extends PayslipEmployeesEvent {
  final String condominiumId;

  const PayslipEmployeesLoadEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class PayslipEmployeesNextPageEvent extends PayslipEmployeesEvent {
  const PayslipEmployeesNextPageEvent();
}

class PayslipEmployeesSearchEvent extends PayslipEmployeesEvent {
  final String query;

  const PayslipEmployeesSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
