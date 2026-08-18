import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';

abstract class EmployeeListBloc
    extends Bloc<EmployeeListEvent, EmployeeListState> {
  EmployeeListBloc(EmployeeListState initialState) : super(initialState);

  void beginLoadNextPage();
  void beginRefresh();
  void beginFilter(EmployeeListFilter filter);
}
