import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class EmployeeState extends Equatable {
  final Employee? data;
  final String? condominiumId;

  const EmployeeState(this.data, this.condominiumId);

  @override
  List<Object?> get props => [data, condominiumId];
}

class EmployeeLoadingState extends EmployeeState {
  const EmployeeLoadingState(Employee? data, String? condominiumId)
      : super(data, condominiumId);
}

class EmployeeLoadFailedState extends EmployeeState {
  final Failure error;

  const EmployeeLoadFailedState(Employee data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class EmployeeLoadedState extends EmployeeState {
  const EmployeeLoadedState(Employee data, String condominiumId)
      : super(data, condominiumId);
}

class EmployeeSendInviteSmsSuccessState extends EmployeeState {
  final String link;

  const EmployeeSendInviteSmsSuccessState(
      Employee? data, String? condominiumId, this.link)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, link];
}

class EmployeeSendInviteLinkSuccessState extends EmployeeState {
  final String link;

  const EmployeeSendInviteLinkSuccessState(
      Employee data, String condominiumId, this.link)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, link];
}

class EmployeeSendInviteFailedState extends EmployeeState {
  final Failure error;

  const EmployeeSendInviteFailedState(
      Employee data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}
