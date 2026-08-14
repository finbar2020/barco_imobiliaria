import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeLoadEvent extends EmployeeEvent {
  final String condominiumId;
  final String employeeId;

  const EmployeeLoadEvent({
    required this.condominiumId,
    required this.employeeId,
  });

  @override
  List<Object?> get props => [condominiumId, employeeId];
}

class EmployeeSendInviteEvent extends EmployeeEvent {
  final Employee employee;
  final AccessManagementInviteForwardType type;

  const EmployeeSendInviteEvent({
    required this.employee,
    required this.type,
  });

  @override
  List<Object?> get props => [employee, type];
}
