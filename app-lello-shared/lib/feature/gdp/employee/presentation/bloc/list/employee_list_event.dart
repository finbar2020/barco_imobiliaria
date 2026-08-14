import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeListEvent extends Equatable {
  const EmployeeListEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeListLoadEvent extends EmployeeListEvent {
  final String condominiumId;
  final EmployeeListFilter filter;

  const EmployeeListLoadEvent({
    required this.condominiumId,
    required this.filter,
  });

  @override
  List<Object?> get props => [condominiumId, filter];
}

class EmployeeListNextPageEvent extends EmployeeListEvent {
  const EmployeeListNextPageEvent();
}
