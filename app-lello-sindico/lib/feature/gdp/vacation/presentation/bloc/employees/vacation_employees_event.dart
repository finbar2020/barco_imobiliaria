import 'package:essentials/essentials.dart';

abstract class VacationEmployeesEvent extends Equatable {
  const VacationEmployeesEvent();

  @override
  List<Object?> get props => [];
}

class VacationEmployeesLoadEvent extends VacationEmployeesEvent {
  final String condominiumId;

  const VacationEmployeesLoadEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class VacationEmployeesNextPageEvent extends VacationEmployeesEvent {
  const VacationEmployeesNextPageEvent();
}

class VacationEmployeesSearchEvent extends VacationEmployeesEvent {
  final String query;

  const VacationEmployeesSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
