import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeListEvent {}

class EmployeeListLoadEvent extends EmployeeListEvent {
  final String condominiumId;
  final EmployeeListFilter filter;
  EmployeeListLoadEvent({required this.condominiumId, required this.filter});
}

class EmployeeListNextPageEvent extends EmployeeListEvent {}
