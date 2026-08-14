import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SessionBloc sessionBloc;
  final GetEmployee getEmployee;
  final SendInviteUsecase sendInviteCase;
  StreamSubscription? _subscription;
  Employee? employee;
  String condominiumId = "";

  EmployeeBloc({
    required this.sessionBloc,
    required this.getEmployee,
    required this.sendInviteCase,
  }) : super(EmployeeLoadingState(null, null)) {
    on<EmployeeLoadEvent>(_mapLoad);
    on<EmployeeSendInviteEvent>(_mapSendInvite);
  }

  Future<void> _mapLoad(
    EmployeeLoadEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    condominiumId = event.condominiumId;
    employee = state.data;

    emit(EmployeeLoadingState(employee, condominiumId));

    final result = await getEmployee.call(GetEmployeeParam(
        condominiumId: condominiumId, employeeId: event.employeeId));
    emit(result.fold(
        (err) => EmployeeLoadFailedState(employee!, condominiumId, err),
        (res) => EmployeeLoadedState(res, condominiumId)));
  }

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

  Future<void> _mapSendInvite(
    EmployeeSendInviteEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoadingState(employee, condominiumId));

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

    emit(result.fold(
        (err) =>
            EmployeeSendInviteFailedState(event.employee, condominiumId, err),
        (link) => event.type == AccessManagementInviteForwardType.sms
            ? EmployeeSendInviteSmsSuccessState(
                event.employee, condominiumId, link)
            : EmployeeSendInviteLinkSuccessState(
                event.employee, condominiumId, link)));
  }

  @override
  Future<void> close() {
    if (_subscription != null) _subscription?.cancel();
    return super.close();
  }

  void sendInvite(Employee employee, AccessManagementInviteForwardType type) {
    add(EmployeeSendInviteEvent(employee: employee, type: type));
  }
}
