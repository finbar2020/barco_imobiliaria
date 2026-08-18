import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';

abstract class VacationEmployeesBloc
    extends Bloc<VacationEmployeesEvent, VacationEmployeesState> {
  VacationEmployeesBloc(VacationEmployeesState initialState)
      : super(initialState);

  void beginRefresh();
  void beginSearch(String query, {bool force = false});
  void beginLoadNextPage();
}
