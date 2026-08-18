import 'dart:async';

import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class EmployeeBlocImpl extends EmployeeBloc {
  final SessionBloc sessionBloc;
  final GetEmployee getEmployee;
  final SendInviteUsecase sendInviteCase;
  StreamSubscription? _subscription;
  Employee? employee;
  String condominiumId = "";

  EmployeeBlocImpl({
    required this.sessionBloc,
    required this.getEmployee,
    required this.sendInviteCase,
  }) : super(EmployeeLoadingState(null, null));

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is EmployeeLoadEvent) yield* _mapLoad(event);
    if (event is EmployeeSendInviteEvent) yield* _mapSendInvite(event);
  }

  Stream<EmployeeState> _mapLoad(EmployeeLoadEvent event) async* {
    condominiumId = event.condominiumId;
    employee = state.data;

    yield EmployeeLoadingState(employee, condominiumId);

    final result = await getEmployee.call(GetEmployeeParam(
        condominiumId: condominiumId, employeeId: event.employeeId));
    yield result.fold(
        (err) => EmployeeLoadFailedState(employee!, condominiumId, err),
        (res) => EmployeeLoadedState(res, condominiumId));
  }

  @override
  void beginLoad(String employeeId) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      add(EmployeeLoadEvent(
          employeeId: employeeId,
          condominiumId: sessionState.session!.selectedCondominium!.id));
    } else {
      if (_subscription != null) _subscription?.cancel();
      _subscription = sessionBloc.stream.listen((state) {
        if (state is SessionLoadedState) {
          _subscription?.cancel();
          beginLoad(employeeId);
        }
      });
    }
  }

  Stream<EmployeeState> _mapSendInvite(EmployeeSendInviteEvent event) async* {
    yield EmployeeLoadingState(employee, condominiumId);

    final param = SendInviteParam(
        entity: AccessManagementSendInviteEntity(
      cpf: event.employee.cpf,
      name: event.employee.name,
      phone: event.employee.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
      email: "",
      userType: AccessManagementInviteUserType.employee,
      forwardType: event.type,
    ));
    final result = await sendInviteCase.call(param);

    yield result.fold(
        (err) =>
            EmployeeSendInviteFailedState(event.employee, condominiumId, err),
        (link) => event.type == AccessManagementInviteForwardType.sms
            ? EmployeeSendInviteSmsSuccessState(
                event.employee, condominiumId, link)
            : EmployeeSendInviteLinkSuccessState(
                event.employee, condominiumId, link));
  }

  @override
  Future<void> close() {
    if (_subscription != null) _subscription?.cancel();
    return super.close();
  }

  @override
  void sendInvite(Employee employee, AccessManagementInviteForwardType type) {
    add(EmployeeSendInviteEvent(employee: employee, type: type));
  }
}
