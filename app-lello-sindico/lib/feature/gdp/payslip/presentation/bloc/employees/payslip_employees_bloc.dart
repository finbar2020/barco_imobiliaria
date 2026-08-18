import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';

abstract class PayslipEmployeesBloc
    extends Bloc<PayslipEmployeesEvent, PayslipEmployeesState> {
  PayslipEmployeesBloc(PayslipEmployeesState initialState)
      : super(initialState);

  void beginRefresh();
  void beginSearch(String query);
  void beginLoadNextPage();
}
