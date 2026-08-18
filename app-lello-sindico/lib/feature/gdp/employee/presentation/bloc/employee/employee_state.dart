import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class EmployeeState {
  final Employee? data;
  final String? condominiumId;

  EmployeeState(this.data, this.condominiumId);
}

class EmployeeLoadingState extends EmployeeState {
  EmployeeLoadingState(Employee? data, String? condominiumId)
      : super(data, condominiumId);
}

class EmployeeLoadFailedState extends EmployeeState {
  final Failure error;
  EmployeeLoadFailedState(Employee data, String condominiumId, this.error)
      : super(data, condominiumId);
}

class EmployeeLoadedState extends EmployeeState {
  EmployeeLoadedState(Employee data, String condominiumId)
      : super(data, condominiumId);
}

class EmployeeSendInviteSmsSuccessState extends EmployeeState {
  final String link;
  EmployeeSendInviteSmsSuccessState(
      Employee? data, String? condominiumId, this.link)
      : super(data, condominiumId);
}

class EmployeeSendInviteLinkSuccessState extends EmployeeState {
  final String link;
  EmployeeSendInviteLinkSuccessState(
      Employee data, String condominiumId, this.link)
      : super(data, condominiumId);
}

class EmployeeSendInviteFailedState extends EmployeeState {
  final Failure error;
  EmployeeSendInviteFailedState(Employee data, String condominiumId, this.error)
      : super(data, condominiumId);
}
