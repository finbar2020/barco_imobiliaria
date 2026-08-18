import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class EmployeeEvent {}

class EmployeeLoadEvent extends EmployeeEvent {
  final String condominiumId;
  final String employeeId;
  EmployeeLoadEvent({required this.condominiumId, required this.employeeId});
}

class EmployeeSendInviteEvent extends EmployeeEvent {
  final Employee employee;
  final AccessManagementInviteForwardType type;

  EmployeeSendInviteEvent({
    required this.employee,
    required this.type,
  });
}
