import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';

abstract class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc(EmployeeState initialState) : super(initialState);

  void beginLoad(String employeeId);
  void sendInvite(Employee employee, AccessManagementInviteForwardType type);
}
